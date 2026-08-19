// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: missionProcessor.sqf
//	@file Author: AgentRev, AryX
if (!isServer) exitWith { false };

#define MISSION_TIMER_EXTENSION (15*60)

private ["_availableLocations", "_missionLocation", "_lastPos", "_missionType", "_locationsArray", "_missionPos", "_missionPicture", "_missionHintText", "_successHintMessage", "_failedHintMessage"];

private _controllerSuffix = param [0, "", [""]];
private _aiGroup = grpNull;

if (!isNil "_setupVars") then { call _setupVars };

private _missionTimeout = MISSION_PROC_TIMEOUT + (floor random [100, 200, 300]);

private _locationClaimed = true;

if (!isNil "_locationsArray") then
{
    _locationClaimed = false;

    // Reserve a location atomically. A location is permanently recorded for this server
    // session as soon as it is claimed, before any mission objects or AI are created.
    // This prevents two concurrently-starting mission workers from selecting the same place.
    isNil
    {
        private _usedLocations = missionNamespace getVariable ["A3W_usedMissionMarkers", []];
        private _mapMarkers = allMapMarkers;

        _availableLocations = [_locationsArray,
        {
            private _locationId = _x param [0, "", [""]];
            private _locationBusy = _x param [1, false, [false]];

            if (_locationBusy || {_locationId == ""}) exitWith { false };

            // Convoy route IDs are also location IDs, but are not actual map markers.
            // For actual markers, additionally compare coordinates so differently-named
            // markers placed at the same spot cannot both be used during one session.
            private _locationPos = if (_locationId in _mapMarkers) then { markerPos _locationId } else { [] };
            private _alreadyUsed = _usedLocations findIf
            {
                private _usedId = _x param [0, "", [""]];
                private _usedPos = _x param [1, [], [[]]];

                (_usedId isEqualTo _locationId) ||
                {
                    count _locationPos >= 2 &&
                    {count _usedPos >= 2} &&
                    {_locationPos distance2D _usedPos < 5}
                }
            } >= 0;

            !_alreadyUsed
        }] call BIS_fnc_conditionalSelect;

        if (count _availableLocations > 0) then
        {
            _missionLocation = (selectRandom _availableLocations) select 0;
            [_locationsArray, _missionLocation, true] call setLocationState;

            private _missionLocationPos = if (_missionLocation in _mapMarkers) then { markerPos _missionLocation } else { [] };
            _usedLocations pushBack [_missionLocation, _missionLocationPos];
            missionNamespace setVariable ["A3W_usedMissionMarkers", _usedLocations];

            A3W_usedMissionMarkerCount = count _usedLocations;
            publicVariable "A3W_usedMissionMarkerCount";

            _locationClaimed = true;

            diag_log format
            [
                "[DynamicMissions] Reserved session-unique location %1 at %2; used locations=%3",
                _missionLocation,
                _missionLocationPos,
                count _usedLocations
            ];
        };
    };
};

// No unused location remains for this concrete mission. Return to missionController before
// _setupObjects, so it can try another concrete mission/type without leaving partial objects.
if (!_locationClaimed) exitWith
{
    diag_log format
    [
        "[DynamicMissions] No unused location remains for %1 / %2",
        MISSION_PROC_TYPE_NAME,
        if (!isNil "_missionType") then { _missionType } else { "unknown mission" }
    ];
    false
};

if (!isNil "_locationsArray") then
{
    [_locationsArray, _missionLocation, markerPos _missionLocation] call cleanLocationObjects;
};

if (!isNil "_setupObjects") then { call _setupObjects };

private _leader = leader _aiGroup;
private _marker = [_missionType, _missionPos] call createMissionMarker;
_aiGroup setVariable ["A3W_missionMarkerName", _marker, true];

if (isNil "_missionPicture") then { _missionPicture = "" };

[
	format ["%1 Objective", MISSION_PROC_TYPE_NAME],
	_missionType,
	_missionPicture,
	_missionHintText,
	MISSION_PROC_COLOR_DEFINE,
	"hint"
]
call missionHint;

//no_log format ["WASTELAND SERVER - %1 Mission%2 waiting to be finished: %3", MISSION_PROC_TYPE_NAME, _controllerSuffix, _missionType];

private _failed = false;
private _complete = false;
private _startTime = diag_tickTime;
private _oldAiCount = 0;

if (isNil "_ignoreAiDeaths") then { _ignoreAiDeaths = false };

waitUntil {
	uiSleep 1;

	private _leaderTemp = leader _aiGroup;

	// Force immediate leader change if current one is dead
	if (!alive _leaderTemp) then {
		{
			if (alive _x) exitWith {
				_aiGroup selectLeader _x;
				_leaderTemp = _x;
			};
		} forEach units _aiGroup;
	};

	private _newAiCount = count units _aiGroup;

	if (_newAiCount < _oldAiCount) then {
		// some units were killed, mission expiry will be reset to 15 mins if it's currently lower than that
		private _adjustTime = if (_missionTimeout < MISSION_TIMER_EXTENSION) then { MISSION_TIMER_EXTENSION - _missionTimeout } else { 0 };
		_startTime = _startTime max (diag_tickTime - ((MISSION_TIMER_EXTENSION - _adjustTime) max 0));
	};

	_oldAiCount = _newAiCount;

	if (!isNull _leaderTemp) then { _leader = _leaderTemp }; // Update current leader

	if (!isNil "_waitUntilMarkerPos") then { _marker setMarkerPos (call _waitUntilMarkerPos) };
	if (!isNil "_waitUntilExec") then { call _waitUntilExec };

	_failed = ((!isNil "_waitUntilCondition" && {call _waitUntilCondition}) || diag_tickTime - _startTime >= _missionTimeout);

	if (!isNil "_waitUntilSuccessCondition" && {call _waitUntilSuccessCondition}) then {
		_failed = false;
		_complete = true;
	};

	(_failed || _complete || (!_ignoreAiDeaths && {alive _x} count units _aiGroup == 0))
};

if (_failed) then {
	// Mission failed
	{ moveOut _x; deleteVehicle _x } forEach units _aiGroup;

	if (!isNil "_failedExec") then { call _failedExec };

	if (!isNil "_vehicle" && {typeName _vehicle == "OBJECT"}) then {
		deleteVehicle _vehicle;
	};

	if (!isNil "_vehicles" && {typeName _vehicles == "ARRAY"}) then {
		{
			if (!isNil "_x" && {typeName _x == "OBJECT"}) then {
				deleteVehicle _x;
			};
		} forEach _vehicles;
	};

	[
		"Objective Failed",
		_missionType,
		_missionPicture,
		if (!isNil "_failedHintMessage") then { _failedHintMessage } else { "Better luck next time!" },
		failMissionColor,
		"FD_Timer_F"
	]
	call missionHint;

	//no_log format ["WASTELAND SERVER - %1 Mission%2 failed: %3", MISSION_PROC_TYPE_NAME, _controllerSuffix, _missionType];
} else {
	// Mission completed
	if (isNull _leader) then {
		_lastPos = markerPos _marker;
	} else {
		_lastPos = _leader call fn_getPos3D;
		private _floorHeight = (getPos _leader) select 2;
		_lastPos set [2, (_lastPos select 2) - _floorHeight];
	};

	if (!isNil "_successExec") then { call _successExec };

	if (!isNil "_vehicle" && {typeName _vehicle == "OBJECT"}) then {
		_vehicle setVariable ["R3F_LOG_disabled", false, true];
		_vehicle setVariable ["A3W_missionVehicle", true, true];
		_vehicle setVariable ["A3W_lockpickDisabled", nil, true];

		_vehicle setVariable ["MissionVehicleDrawIcon", false, true];

		if (!isNil "fn_manualVehicleSave" && !(_vehicle getVariable ["A3W_skipAutoSave", false])) then {
			_vehicle call fn_manualVehicleSave;
		};
	};
	
	private _convoyAutoSave = ["A3W_missionVehicleSaving"] call isConfigOn;

	if (!isNil "_vehicles" && {typeName _vehicles == "ARRAY"}) then {
		{
			if (!isNil "_x" && {typeName _x == "OBJECT"}) then {
			
				if (!_convoyAutoSave) then
				{
					_x setVariable ["A3W_skipAutoSave", true, true];
				};
				
				_x setVariable ["R3F_LOG_disabled", false, true];
				_x setVariable ["A3W_missionVehicle", true, true];
				_x setVariable ["A3W_lockpickDisabled", nil, true];
				_x setVariable ["MissionVehicleDrawIcon", false, true];

				if (!isNil "fn_manualVehicleSave" && !(_x getVariable ["A3W_skipAutoSave", false])) then
				{
					_x call fn_manualVehicleSave;
				};
			};
		} forEach _vehicles;
	};

	[
		"Objective Complete",
		_missionType,
		_missionPicture,
		_successHintMessage,
		successMissionColor,
		"hintExpand"
	]
	call missionHint;
	
	_lastPos = markerPos _marker;
	[_missionType, _lastPos] spawn {
		_missionType1 = (_this select 0) + " - Complete"; 
		_marker1 = [_missionType1, (_this select 1)] call createMissionCompleteMarker;
		uiSleep 60; //BY VLADOS //30
		deleteMarker _marker1;
	};
};

if (!isNil "_defMines") then { { deleteVehicle _x; } forEach _defMines };

deleteGroup _aiGroup;


private _deleteGroupAfterSuccess = true;
if(_deleteGroupAfterSuccess) then {
	{ 
		if(((_x distance (markerPos _marker)) < 300) && (_x getVariable ["forCleanMission", true])) then {
			deleteVehicle _x;
		};
	} forEach (allDeadMen)
};

deleteMarker _marker;

if (!isNil "_locationsArray") then {
	[_locationsArray, _missionLocation, false] call setLocationState;
};

// The concrete mission successfully acquired its location (or does not use a static
// location array) and ran to completion/failure. The dynamic controller treats this slot
// as successfully used and does not reroll another mission.
true
