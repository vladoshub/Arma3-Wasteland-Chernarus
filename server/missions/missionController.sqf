// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//  @file Name: missionController.sqf
//  @file Author: AgentRev
//  Dynamic one-shot mode: Vlados / OpenAI

if (!isServer) exitWith { false };

private ["_availableMissions", "_missionsList", "_nextMission"];

private _controllerNum = param [0, 1, [0]];
private _tempController = param [1, false, [false]];
private _dynamicOneShot = param [2, false, [false]];
private _controllerSuffix = "";

if (_controllerNum > 1) then
{
    _controllerSuffix = format [" %1", _controllerNum];
};

// Dynamic scheduler mode:
// - do not wait for the old per-type delay;
// - atomically claim concrete missions one at a time;
// - if a concrete mission has no unused location marker/route left, immediately try
//   another concrete mission from the same type;
// - return false only when this whole mission type cannot start anything right now;
// - run exactly one successfully started mission and return true after it ends.
if (_dynamicOneShot) exitWith
{
    private _missionRan = false;
    private _attemptedMissions = [];
    private _typeExhausted = false;

    while {!_missionRan && {!_typeExhausted}} do
    {
        private _claimed = false;
        private _claimedMission = "";

        // isNil { code } executes unscheduled, making select + setMissionState one atomic
        // claim against other dynamic workers trying to start the same concrete mission.
        isNil
        {
            private _available = [MISSION_CTRL_PVAR_LIST,
            {
                !(_x select 2) && {!((_x select 0) in _attemptedMissions)}
            }] call BIS_fnc_conditionalSelect;

            if (count _available > 0) then
            {
                private _weighted = _available call generateMissionWeights;
                private _candidate = _weighted call fn_selectRandomWeighted;

                if (!isNil "_candidate" && {_candidate != ""}) then
                {
                    [MISSION_CTRL_PVAR_LIST, _candidate, true] call setMissionState;
                    _claimedMission = _candidate;
                    _claimed = true;
                };
            };
        };

        if (!_claimed) then
        {
            _typeExhausted = true;
        }
        else
        {
            // These variables are intentionally private because mission scripts populate them
            // before calling their type-specific mission processor. Re-declare on every retry
            // so a rejected concrete mission cannot leak setup callbacks into the next one.
            private ["_setupVars", "_setupObjects", "_waitUntilMarkerPos", "_waitUntilExec", "_waitUntilCondition", "_waitUntilSuccessCondition", "_ignoreAiDeaths", "_failedExec", "_successExec"];

            diag_log format ["[DynamicMissions] Mission claimed: type=%1 mission=%2 slot=%3", MISSION_CTRL_TYPE_NAME, _claimedMission, _controllerNum];

            private _missionResult = [_controllerSuffix] call compile preprocessFileLineNumbers format
            [
                "server\missions\%1\%2.sqf",
                MISSION_CTRL_FOLDER,
                _claimedMission
            ];

            [MISSION_CTRL_PVAR_LIST, _claimedMission, false] call setMissionState;

            _missionRan = (!isNil "_missionResult" && {_missionResult isEqualType true} && {_missionResult});

            if (_missionRan) then
            {
                diag_log format ["[DynamicMissions] Mission released: type=%1 mission=%2 slot=%3", MISSION_CTRL_TYPE_NAME, _claimedMission, _controllerNum];
            }
            else
            {
                _attemptedMissions pushBackUnique _claimedMission;
                diag_log format
                [
                    "[DynamicMissions] Mission rejected before spawn (no unused location): type=%1 mission=%2; trying another mission in same type",
                    MISSION_CTRL_TYPE_NAME,
                    _claimedMission
                ];
            };
        };
    };

    _missionRan
};

// Legacy mode retained for compatibility with any code that directly launches a
// mission type controller without the dynamic scheduler's third parameter.
private _missionsFolder = MISSION_CTRL_FOLDER;
[MISSION_CTRL_PVAR_LIST, MISSION_CTRL_FOLDER] call attemptCompileMissions;

private _randMinutes = floor random [0, 2, 4];
private _missionDelay = MISSION_CTRL_DELAY + (_randMinutes * 60);

for "_i" from 0 to 1 step 0 do
{
    _nextMission = nil;

    while {isNil "_nextMission"} do
    {
        _availableMissions = [MISSION_CTRL_PVAR_LIST, { !(_x select 2) }] call BIS_fnc_conditionalSelect;

        if (count _availableMissions > 0) then
        {
            _missionsList = _availableMissions call generateMissionWeights;
            _nextMission = _missionsList call fn_selectRandomWeighted;
        }
        else
        {
            uiSleep 60;
        };
    };

    [MISSION_CTRL_PVAR_LIST, _nextMission, true] call setMissionState;

    [
        format
        [
            "<t color='%1' shadow='2' size='1.75'>%2 Objective%3</t><br/>" +
            "<t color='%1'>------------------------------</t><br/>" +
            "<t color='%4' size='1.0'>Starting in %5 minutes</t>",
            MISSION_CTRL_COLOR_DEFINE,
            MISSION_CTRL_TYPE_NAME,
            _controllerSuffix,
            subTextColor,
            _missionDelay / 60
        ], ""
    ] call hintBroadcast;

    uiSleep _missionDelay;

    private ["_setupVars", "_setupObjects", "_waitUntilMarkerPos", "_waitUntilExec", "_waitUntilCondition", "_waitUntilSuccessCondition", "_ignoreAiDeaths", "_failedExec", "_successExec"];

    [_controllerSuffix] call compile preprocessFileLineNumbers format ["server\missions\%1\%2.sqf", MISSION_CTRL_FOLDER, _nextMission];

    [MISSION_CTRL_PVAR_LIST, _nextMission, false] call setMissionState;

    if (_tempController) exitWith {};
    uiSleep 5;
};

true
