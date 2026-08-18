// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: spawnOnHQ.sqf
//	@file Author: [404] Costlyy, [GoT] JoSchaap, MercyfulFate, AgentRev
//	@file Created: 08/12/2012 18:30
//	@file Args:

private ["_data", "_hq"];
_data = _this select 0;
_hq = objectFromNetId (_data select 0);
_preload = false;

missionNamespace setVariable ["spawnHQ_lastUse_" + getPlayerUID player, serverTime];
[player, _hq] remoteExecCall ["A3W_fnc_updateSpawnTimestamp", 2];


if (_preload) then { waitUntil {preloadCamera _playerPos} };

waitUntil {!isNil "bis_fnc_init" && {bis_fnc_init}};

if ((primaryWeapon player) != "") then {
	player action ["SwitchWeapon", player, player, 100];
};


if((_hq emptyPositions "") > 0) then {
	player moveInAny _hq;
	respawnDialogActive = false;
	closeDialog 0;

	[] spawn
	{
		sleep 1;

		_hour = date select 3;
		_mins = date select 4;
		["Wasteland", "HQ", format ["%1:%3%2", _hour, _mins, if (_mins < 10) then {"0"} else {""}]] spawn BIS_fnc_infoText;
	};

} else {
	
	private _randomLoc = selectRandom (call cityListLimit);
	private _pos = getMarkerPos (_randomLoc select 0);
	private _rad = _randomLoc select 1;
	private _townName = _randomLoc select 2;
	private _playerPos = [_pos,5,_rad,1,0,0,0] call findSafePos;
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

};
