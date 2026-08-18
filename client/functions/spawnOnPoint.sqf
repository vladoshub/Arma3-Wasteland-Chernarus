private ["_marker", "_height", "_index", "_spawns", "_preload", "_pos", "_sizes", "_fullSizes", "_radian", "_spawnName", "_playerPos", "_maxLoop", "_loop"];
_marker = _this select 0;
_closeDialog = _this select 1;
_preload = false;

_height = (["A3W_spawnBeaconSpawnHeight", 0] call getPublicVar) max 0;
_spawns = (call spawnList);
_index = _spawns findIf { _x select 0 == _marker };
_sizes = markerSize _marker;
_fullSizes = _sizes apply {_x * 2};
_radian = (markerDir _marker) * pi / 180;
_spawnName = _spawns select _index select 1;

_playerPos = _marker call BIS_fnc_randomPosTrigger;

_playerPos set [2, if (_height < 25) then { 0 } else { _height }];

if (_preload) then { waitUntil {sleep 0.1; preloadCamera _playerPos} };
waitUntil {!isNil "bis_fnc_init" && {bis_fnc_init}};

if ((primaryWeapon player) != "") then {
	player action ["SwitchWeapon", player, player, 100];
};

player setPos _playerPos;

player setVariable [_marker + "_lastSpawn", diag_tickTime]; //????

[player, _marker] remoteExecCall ["A3W_fnc_updateSpawnTimestamp", 2];


respawnDialogActive = false;
closeDialog 0;
player setVariable ["airBornSpawn", true];


_spawnName spawn
{
	_spawnName = _this;
	sleep 1;

	_hour = date select 3;
	_mins = date select 4;
	["Wasteland", _spawnName, format ["%1:%3%2", _hour, _mins, if (_mins < 10) then {"0"} else {""}]] spawn BIS_fnc_infoText;
};
