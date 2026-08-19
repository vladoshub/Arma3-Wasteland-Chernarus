// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//  @file Name: dynamicMissionScheduler.sqf
//  Dynamic player-count/slot/weighted-type mission scheduler

if (!isServer) exitWith {};

private _controllerTypes = missionNamespace getVariable
[
    "A3W_dynamicMissionControllerTypes",
    ["mainMission", "patrolMission", "moneyMission", "extraMission", "sideMission", "ultraMission"]
];

private _hardCap = missionNamespace getVariable ["A3W_dynamicMissionHardCap", 6];
private _checkInterval = (["A3W_dynamicMissionCheckInterval", 60] call getPublicVar) max 1;

private _defaultLimits =
[
    [10, 1, [["mainMission", 15], ["patrolMission", 20], ["moneyMission", 25], ["extraMission", 20], ["sideMission", 18], ["ultraMission", 2]]],
    [20, 2, [["mainMission", 20], ["patrolMission", 20], ["moneyMission", 20], ["extraMission", 18], ["sideMission", 18], ["ultraMission", 4]]],
    [30, 3, [["mainMission", 24], ["patrolMission", 18], ["moneyMission", 18], ["extraMission", 17], ["sideMission", 18], ["ultraMission", 5]]],
    [40, 4, [["mainMission", 27], ["patrolMission", 18], ["moneyMission", 16], ["extraMission", 16], ["sideMission", 17], ["ultraMission", 6]]],
    [50, 5, [["mainMission", 30], ["patrolMission", 18], ["moneyMission", 15], ["extraMission", 15], ["sideMission", 15], ["ultraMission", 7]]],
    [60, 5, [["mainMission", 31], ["patrolMission", 18], ["moneyMission", 14], ["extraMission", 15], ["sideMission", 14], ["ultraMission", 8]]],
    [1000000, 6, [["mainMission", 32], ["patrolMission", 18], ["moneyMission", 14], ["extraMission", 14], ["sideMission", 13], ["ultraMission", 9]]]
];

A3W_dynamicMissionNextWorkerId = 0;
A3W_activeMissionCount = 0;
publicVariable "A3W_activeMissionCount";

// Session-long location history. Never reset this while the mission session is running.
// Records are [locationId, markerPosition]. Non-marker route IDs use [] as position.
if (isNil "A3W_usedMissionMarkers") then
{
    A3W_usedMissionMarkers = [];
};
A3W_usedMissionMarkerCount = count A3W_usedMissionMarkers;
publicVariable "A3W_usedMissionMarkerCount";

while {true} do
{
    // allPlayers also contains Headless Clients, so remove them explicitly.
    private _realPlayers = allPlayers - (entities "HeadlessClient_F");
    private _playerCount = count _realPlayers;

    private _limits = ["A3W_dynamicMissionPlayerLimits", _defaultLimits] call getPublicVar;
    private _selectedRange = [];

    {
        private _maxPlayers = _x param [0, 1000000, [0]];
        if (_playerCount <= _maxPlayers) exitWith
        {
            _selectedRange = _x;
        };
    } forEach _limits;

    if (_selectedRange isEqualTo [] && {count _limits > 0}) then
    {
        _selectedRange = _limits select ((count _limits) - 1);
    };

    private _targetSlots = (_selectedRange param [1, 0, [0]]) max 0 min _hardCap;
    private _typeWeights = _selectedRange param [2, [], [[]]];

    // Count the actual mission definitions currently marked active by setMissionState.
    // This also counts a mission started by some other server code if it uses one of these
    // six standard mission arrays.
    private _activeCount = 0;
    {
        private _missionArray = _x;
        _activeCount = _activeCount + ({ _x param [2, false, [false]] } count _missionArray);
    } forEach [MainMissions, PatrolMissions, MoneyMissions, ExtraMissions, SideMissions, UltraMissions];

    A3W_activeMissionCount = _activeCount;
    publicVariable "A3W_activeMissionCount";

    private _freeSlots = (_targetSlots - _activeCount) max 0;

    diag_log format
    [
        "[DynamicMissions] Tick: players=%1 target=%2 active=%3 free=%4 usedLocations=%5",
        _playerCount,
        _targetSlots,
        _activeCount,
        _freeSlots,
        missionNamespace getVariable ["A3W_usedMissionMarkerCount", 0]
    ];

    // Fill every slot that is free at the moment of this check. Workers are independent,
    // so the same mission TYPE can be selected for multiple slots in the same tick.
    for "_slotOffset" from 1 to _freeSlots do
    {
        A3W_dynamicMissionNextWorkerId = A3W_dynamicMissionNextWorkerId + 1;
        private _workerId = A3W_dynamicMissionNextWorkerId;

        [_workerId, +_typeWeights, +_controllerTypes] spawn
        {
            params ["_workerId", "_configuredWeights", "_controllerTypes"];

            // Only known controller names with positive weights are eligible.
            private _remaining = _configuredWeights select
            {
                count _x >= 2 &&
                {(_x select 0) in _controllerTypes} &&
                {(_x select 1) isEqualType 0} &&
                {(_x select 1) > 0}
            };

            private _missionRan = false;

            // If the weighted type has no free concrete mission, remove only that type
            // for this worker and reroll immediately. Therefore a free slot is not lost
            // merely because its first weighted choice was temporarily unavailable.
            while {!_missionRan && {count _remaining > 0}} do
            {
                private _types = _remaining apply { _x select 0 };
                private _weights = _remaining apply { _x select 1 };
                private _selectedType = [_types, _weights] call fn_selectRandomWeighted;

                if (isNil "_selectedType") exitWith {};

                private _selectedIndex = _remaining findIf { (_x select 0) isEqualTo _selectedType };
                if (_selectedIndex >= 0) then
                {
                    _remaining deleteAt _selectedIndex;
                };

                diag_log format ["[DynamicMissions] Worker %1 selected type %2", _workerId, _selectedType];

                // Third parameter enables immediate one-shot mode in missionController.sqf.
                // It atomically claims one concrete mission. If that type is exhausted,
                // false is returned immediately and this worker rerolls another type.
                private _controllerResult = [_workerId, true, true] call compile preprocessFileLineNumbers format
                [
                    "server\missions\%1Controller.sqf",
                    _selectedType
                ];

                _missionRan = (!isNil "_controllerResult" && {_controllerResult isEqualType true} && {_controllerResult});

                if (!_missionRan) then
                {
                    diag_log format ["[DynamicMissions] Worker %1: no free mission in type %2, rerolling type", _workerId, _selectedType];
                };
            };

            if (!_missionRan) then
            {
                diag_log format ["[DynamicMissions] Worker %1: no mission definition is currently available in any configured type", _workerId];
            };
        };
    };

    uiSleep _checkInterval;
};
