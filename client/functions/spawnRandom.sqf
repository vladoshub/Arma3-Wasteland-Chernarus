// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: spawnRandom.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, AgentRev
private _preload = param [1, false, [false]];

private _randomLoc = selectRandom (call cityListLimit);

private _enemyPlayers = (allPlayers - entities "HeadlessClient_F") select { isPlayer _x && alive _x && !([_x, player] call A3W_fnc_isFriendly) };

if((random 1) < 0.3 && count _enemyPlayers < 10 && count _enemyPlayers > 0 && player getVariable ["notFirstSpawnTown", true]) then {

private _enemyTowns = [];

	{
		private _currentEnemy = _x;
		private _currentPos = selectRandom ((call cityListLimit) select {_currentEnemy inArea (_x select 0) && (serverTime - (missionNamespace getVariable [(_x select 0) + "_last_spawn_town_UID_" + getPlayerUID player,  0])) > 0 });
		if(!(isNil "_currentPos")) then {
			_enemyTowns append [_currentPos];
		}
	} forEach _enemyPlayers;

	if(count _enemyTowns > 0) then {
		_randomLoc = selectRandom (_enemyTowns);
		missionNamespace setVariable [((_randomLoc select 0) + "_last_spawn_town_UID_" + getPlayerUID player), (serverTime + 600 + (random [0, 150, 300])), true];
	};


};

//spawnAI
private _pos = getMarkerPos (_randomLoc select 0);
private _rad = _randomLoc select 1;
private _townName = _randomLoc select 2;
private _playerPos = [_pos,5,_rad,1,0,0,0] call findSafePos;

/*
private _squareM = (markerSize (_randomLoc select 0) select 0) * (markerSize (_randomLoc select 0) select 1);
private _aiCount = round (_squareM / 1500);
private _aiSpawn = _aiCount - count (allUnits select { !([_x, player] call A3W_fnc_isFriendly) && !(isPlayer _x) && side _x != sideLogic && _x inArea (_randomLoc select 0)});

_aiSpawn = random [0, _aiSpawn/2, _aiSpawn];

if (_aiSpawn >= 2 && (serverTime - (missionNamespace getVariable [(_randomLoc select 0) + "_last_spawn_ai",  0])) > 0) then {
	[_playerPos, _aiSpawn, (_randomLoc select 0), _squareM] remoteExecCall ["A3W_fnc_spawn_ai", 2];
};
*/


if (_preload) then { waitUntil {sleep 0.1; preloadCamera _playerPos} };

waitUntil {!isNil "bis_fnc_init" && {bis_fnc_init}};

player setPos _playerPos;

respawnDialogActive = false;
closeDialog 0;

player setVariable ["notFirstSpawnTown", true, true];

_townName spawn
{
	_townName = _this;
	sleep 1;

	_hour = date select 3;
	_mins = date select 4;
	["Wasteland", _townName, format ["%1:%3%2", _hour, _mins, if (_mins < 10) then {"0"} else {""}]] spawn BIS_fnc_infoText;
};
