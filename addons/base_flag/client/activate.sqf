private _poiDistMarket = 500;
private _poiMarkersStores = allMapMarkers select {markerType _x isEqualTo "Empty" && {[["GenStore","GunStore","VehStore","Parking"], _x] call fn_startsWith}};

if ({ (getPosASL player) distance2D (ATLtoASL getMarkerPos _x) < _poiDistMarket } count _poiMarkersStores > 0) exitWith //BY VLADOS
{
	playSound "FD_CP_Not_Clear_F";
	[format ["You are not allowed place a flag within %1m of stores", _poiDistMarket], 5] call mf_notify_client;
};



if((count (nearestObjects [player, ["Land_Atm_01_F", "Land_i_Shed_Ind_F", "Land_Pallet_MilBoxes_F", "Land_bags_EP1", "Land_ConcreteWell_02_F", "Land_ToiletBox_F", "C_Truck_02_box_F"], 400]) > 0)) exitWith {
	playSound "FD_CP_Not_Clear_F";
	[format ["You are not allowed place a flag within %1m of ATMs or Parkings or other static objects placed on the map (marked with dots on the map)", 400], 5] call mf_notify_client;
};


private _poiDistMissions = 500;
private _poiMarkersMissions = allMapMarkers select {markerType _x isEqualTo "Empty" && {[["Mission_","ForestMission_","LandConvoy_","BigBoat_","UltraMission_","BaseCapture_"], _x] call fn_startsWith}};

if ({ (getPosASL player) distance2D (ATLtoASL getMarkerPos _x) < _poiDistMissions } count _poiMarkersMissions > 0) exitWith //BY VLADOS
{
	playSound "FD_CP_Not_Clear_F";
	[format ["You are not allowed place a flag within %1m of missions", _poiDistMissions], 5] call mf_notify_client;
};

private _poiDistTowns = 300;
private _poiMarkersTowns = allMapMarkers select {([["Town_"], _x] call fn_startsWith) || ([["Spawn_"], _x] call fn_startsWith) || ([["TERRITORY_"], _x] call fn_startsWith)};

if ({ (((getPosASL player) distance2D (ATLtoASL getMarkerPos _x))) < (_poiDistTowns + ((getMarkerSize _x) select 1))} count _poiMarkersTowns > 0) exitWith //BY VLADOS
{
	playSound "FD_CP_Not_Clear_F";
	[format ["You are not allowed place a flag within %1m of towns or spawn points or territories", _poiDistTowns], 5] call mf_notify_client;
};

private _friendlyCount = 0;
private _enemyCount = 0;

{
	if (isPlayer _x && alive _x && _x distance player < 30) then //BY VLADOS
		{
			if ([_x, player] call A3W_fnc_isFriendly) then
			{
				_friendlyCount = _friendlyCount + 1;
			}
			else
			{
				_enemyCount = _enemyCount + 1;
			};
		};
} forEach playableUnits;

if (_enemyCount > 0) exitWith //BY VLADOS
{
	playSound "FD_CP_Not_Clear_F";
	["You are not allowed place a flag, the enemy is nearby.", 5] call mf_notify_client;
};

/*
private _timer = (_this select 0) getVariable ["flag_disable_time", 0];
if(diag_tickTime < _timer) exitWith {
	hint format["You can't yet. Wait: %1 Seconds", diag_tickTime - _timer];
	playSound "FD_CP_Not_Clear_F";
};
*/

private _nearFlags = player nearObjects  ["FlagChecked_F", 4600];
private _nearFlagsCount = ({ _x getVariable ["is_base_flag_activate", false] } count _nearFlags);

private _allFlags = allMissionObjects "FlagChecked_F";
private _allFlagsCount = ({(_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) && (_x getVariable ["is_base_flag_activate", false])} count _allFlags);

if(_allFlagsCount > 1) exitWith {
	hint "You have too many activated flags";
	playSound "FD_CP_Not_Clear_F";
};


/*
private _allFlags = allMissionObjects "FlagChecked_F";
private _filteredFlags = [];
	{ 
		if ( (_x getVariable ["is_base_flag_activate", false]) ) then 
			{
				_filteredFlags pushBack _x
			};
	} forEach _allFlags;
*/

if(_nearFlagsCount > 0) exitWith {
	hint "You cannot place a flag within a 4600m radius of others flags";
	playSound "FD_CP_Not_Clear_F";
};

private _inCrater = false;
if(count(allMapMarkers)>0) then {
	{
		if(( ["Crater", _x] call fn_startsWith) && ((getmarkerpos _x) distance player < 400)) exitWith
		{
			_inCrater = true;
		};
	} forEach allMapMarkers;
};

if(_inCrater) exitWith {
	hint "You cannot place a flag near the crater";
	playSound "FD_CP_Not_Clear_F";
};




/*
if(count _filteredFlags > 30) exitWith {
	hint "The maximum number of flags on the map has been exceeded (30)";
	playSound "FD_CP_Not_Clear_F";
};
*/

/*
private _playerPosATL = getPosATL player;
_playerPosATL set [1, (_playerPosATL select 1) + 1];
private _playerPosATLOffset = _playerPosATL;

_this select 0 setVehiclePosition  [player , [ ] , 0 , "CAN_COLLIDE"];

player setPosATL _playerPosATLOffset;
*/

if((_this select 0) getVariable ["flagsDenyActivate", 0] > serverTime ) exitWith {
	hint "You cannot activate a flag when flag is attacked";
	playSound "FD_CP_Not_Clear_F";
};


[[player, _this select 0],"Base_flag_srv_activate",false,false,false] call BIS_fnc_MP;
