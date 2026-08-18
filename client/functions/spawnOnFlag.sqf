// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: spawnOnFlag.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args:
//BY VLADOS
//base_flag addon

private ["_pos", "_rad", "_flag", "_playerPos", "_data", "_flagName"];

_flag = objectFromNetId (_this select 0);
private _preload = param [1, false, [false]];

private _flagCode = str netId _flag;
_flagName = "Next to the flag";

_pos = getPosASL _flag;
_rad = 4;



_playerPos = [_pos,2,_rad,1,0,0,0] call findSafePos;
if (_preload) then { waitUntil {sleep 0.1; preloadCamera _playerPos} };

waitUntil {!isNil "bis_fnc_init" && {bis_fnc_init}};




private _lastSpawn = _flag getVariable "flag_lastSpawn_UID_" + getPlayerUID player;

if (!isNil "_lastSpawn") then
{
	if(_lastSpawn > 0) then {
	private _spawnCooldownLong = 600;
	private _remainingLong = _spawnCooldownLong - (serverTime - _lastSpawn);
	if(_remainingLong > 0) then {
		private _playerMoneyBank = player getVariable ["bmoney", 0];
		private _newBalance = _playerMoneyBank - 200000;
		player setVariable ["bmoney", _newBalance, true];
		[] call fn_savePlayerData;
	};
	};
};
player setPosASL _playerPos;


_flag setVariable ["flag_lastSpawn_UID_" + getPlayerUID player, serverTime, true];
[player, _flagCode] remoteExecCall ["A3W_fnc_updateSpawnTimestamp", 2];

pvar_manualObjectSave = netId _flag;
publicVariableServer "pvar_manualObjectSave";

respawnDialogActive = false;
closeDialog 0;

_flagName spawn
{
	_flagName = _this;
	sleep 1;

	_hour = date select 3;
	_mins = date select 4;
	["Wasteland", _flagName, format ["%1:%3%2", _hour, _mins, if (_mins < 10) then {"0"} else {""}]] spawn BIS_fnc_infoText;
};
