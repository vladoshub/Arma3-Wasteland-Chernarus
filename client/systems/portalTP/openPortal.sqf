private ["_portalNum", "_portals", "_town", "_playerMoney", "_price", "_towns", "_isCurrentSafe", "_territories", "_territoryText", "_territoryMarker", "_enemyPlayers", "_isSameSide", "_side", "_spawns"];


private _payCard = ["Select a Payment Method", "Payment", "Card", "Cash"] call BIS_fnc_guiMessage;
if(_payCard) then {
	player setVariable ["playerPayType", "bmoney", true];
} else {
	player setVariable ["playerPayType", "cmoney", true];
};

_portalNum = _this select 3 select 0;
_portals = call compile preprocessFileLineNumbers format ["mapConfig\%1\portals.sqf", (["A3W_map", "chernarus"] call getPublicVar)];
_town = "";
{
	if (_x select 0 == _portalNum) exitWith
	{
		_town = _x select 1;
	};
} forEach _portals;
_playerMoney = player getVariable [(player getVariable ["playerPayType", "bmoney"]), 0];
_price = ["A3W_portalAmount", 1000] call getPublicVar;
if (_price > _playerMoney) exitWith
{
	hint format["You need $%1 money for using teleport", _price];
	playSound "FD_CP_Not_Clear_F";
	_price = -1;
};
_towns = call compile preprocessFileLineNumbers format ["mapConfig\%1\towns.sqf", (["A3W_map", "chernarus"] call getPublicVar)];
{
	if (_x select 2 == _town) exitWith
	{
		_town = _x;
	};
} forEach _towns;
_isCurrentSafe = true;
{
	if (alive _x && {_x isKindOf "CAManBase" && {!(_x call A3W_fnc_isUnconscious)}}) then
	{
		if (!([_x, player] call A3W_fnc_isFriendly) && isPlayer _x && (position _x) inArea [markerPos (_town select 0), _town select 1, _town select 1, 0, false]) exitWith
		{
			_isCurrentSafe = false;
		};
	};
} forEach allUnits;
if (!_isCurrentSafe) exitWith
{
	hint "Enemy nearby town, portal has been closed!";
};
["A3W_Portal", "onMapSingleClick",
{
	_territories = call compile preprocessFileLineNumbers format ["mapConfig\%1\territories.sqf", (["A3W_map", "chernarus"] call getPublicVar)];
	{
		if (_pos inArea (_x select 0)) exitWith
		{
			_territoryText = _x select 1;
			_territoryMarker = _x select 0;
			_enemyPlayers = 0;
			_isSameSide = false;
			_side = str (missionNamespace getVariable [format['%1_team',_x select 0], sideUnknown]);
			{
				if (isPlayer _x && alive _x && _x isKindOf "CAManBase" && !(_x call A3W_fnc_isUnconscious) && (position _x) inArea _territoryMarker) then
				{
					if (_side == "WEST" || _side == "EAST") then
					{
						if (str (side _x) != _side) then
						{
							_enemyPlayers = _enemyPlayers + 1;
						};
					} else
					{
						if (str (group _x) != _side) then
						{
							_enemyPlayers = _enemyPlayers + 1;
						};
					};
				};
			} forEach allUnits;
			if (str playerSide == "GUER") then
			{
				if (str (group player) == _side) then
				{
					_isSameSide = true;
				};
			} else
			{
				if (str playerSide == _side) then
				{
					_isSameSide = true;
				};
			};
			cutText [format["Teleporting from %1 to %2...", _this select 4 select 2 ,_territoryText], "BLACK", -0.25];
			if (_enemyPlayers == 0 && _isSameSide) then
			{
				private _price = _this select 5;
				[_pos, _price] spawn {
					params ["_pos", "_price"];
					private ["_top", "_buildings"];

					if(player getVariable ["playerPayType", "bmoney"] == "bmoney") then {
						_playerMoney = player getVariable ["bmoney", 0];
						private _newBalance = _playerMoney - _price;
						player setVariable ["bmoney", _newBalance, true];
					} else {
						[player, -_price] call A3W_fnc_setCMoney;
					};
					[] call fn_savePlayerData;
					uiSleep 3;
					openMap false;
					_pos set [2, 500];
					player setPos _pos;
					["A3W_Portal", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
					cutText ["Teleported finish.", "BLACK IN", 2.5];
				};
			} else
			{
				[] spawn {
					uiSleep 1;
					openMap false;
					cutText ["Teleport failed, try other territory", "BLACK IN", 2.5];
				};
			};
		};
	} forEach _territories;

	_spawns = (call spawnList);

	{
		if (_pos inArea (_x select 0)) exitWith
		{
			[_x select 0] spawn {
				params ["_marker"];

				[] call fn_savePlayerData;
				//uiSleep 3;
				openMap false;			
				private _playerPos = _marker call BIS_fnc_randomPosTrigger;
				private _height = (["A3W_spawnBeaconSpawnHeight", 0] call getPublicVar) max 0;
				_playerPos set [2, if (_height < 25) then { 0 } else { _height }];
				if ((primaryWeapon player) != "") then {
					player action ["SwitchWeapon", player, player, 100];
				};
				player setPos _playerPos;
				["A3W_Portal", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
				//cutText ["Teleported finish.", "BLACK IN", 2.5];
			};
		};

	} forEach _spawns;

	true
}, [_town, _price]] call BIS_fnc_addStackedEventHandler;
if (!visibleMap) then {openMap true};
hint "Click on any territory your side captured to teleport.";

[] spawn {
	addMissionEventHandler ["Map",
	{
		params ["_isOpened","_isForced"];
		_isOpened = _this select 0;
		if (!_isOpened) then
		{
			["A3W_Portal", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
		};
	}];
};