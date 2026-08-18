// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: spawnInTown.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args:

private ["_pos", "_rad", "_townName", "_playerPos"];
private _marker = _this select 0;
private _preload = param [1, false, [false]];
_rad = 5;
{
	if (_x select 0 == _marker) exitWith
	{
		_pos = getMarkerPos _marker;
		_rad = _x select 1;
		_townName = _x select 2;

		_playerPos = [_pos,5,_rad,1,0,0,0] call findSafePos;
		if (_preload) then { waitUntil {sleep 0.1; preloadCamera _playerPos} };

		waitUntil {!isNil "bis_fnc_init" && {bis_fnc_init}};

		player setPos _playerPos;

		/*
		private _squareM = (markerSize (_marker) select 0) * (markerSize (_marker) select 1);
		private _aiCount = round (_squareM / 2000);
		private _aiSpawn = _aiCount - count (allUnits select { !([_x, player] call A3W_fnc_isFriendly) && !(isPlayer _x) && side _x != sideLogic && _x inArea (_marker)});

		_aiSpawn = floor (random _aiSpawn);

		if (_aiSpawn >= 1 && (serverTime - (missionNamespace getVariable [(_marker) + "_last_spawn_ai",  0])) > 0) then {
			[_playerPos, _aiSpawn, (_marker), _squareM] remoteExecCall ["A3W_fnc_spawn_ai", 2];
		};
		*/
	

	};
} forEach (call cityList);

player setVariable [_marker + "_lastSpawn", diag_tickTime];
[player, _marker] remoteExecCall ["A3W_fnc_updateSpawnTimestamp", 2];

respawnDialogActive = false;
closeDialog 0;

_townName spawn
{
	_townName = _this;
	sleep 1;

	_hour = date select 3;
	_mins = date select 4;
	["Wasteland", _townName, format ["%1:%3%2", _hour, _mins, if (_mins < 10) then {"0"} else {""}]] spawn BIS_fnc_infoText;
};
