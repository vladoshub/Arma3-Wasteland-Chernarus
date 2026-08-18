// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_ArmedHeli.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitWith {};

#include "ultraMissionDefines.sqf";

private ["_nbUnits", "_drop_item", "_block", "_objects", "_veh1Object", "_veh2Object", "_veh3Object", "_vehicleClass", "_createVehicle"];

_setupVars =
{
	_missionType = "ULTIMATE: Base Capture";	
	_locationsArray = BaseCaptureMissionSpawnMarkers;
};


_setupObjects =
{
	//_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };


	_createVehicle =
	{
		private ["_type", "_position", "_direction", "_variant", "_special", "_vehicle", "_soldier", "_soldierGun", "_soldierCommander"];
		_type = _this select 0;
		_position = _this select 1;
		_variant = _type param [1,"",[""]];
		if (_type isEqualType []) then
		{
			_type = _type select 0;
		};
		_vehicle = createVehicle [_type, _position, [], 0, "NONE"];
		_vehicle setVariable ["R3F_LOG_disabled", true, true];
		if (_variant != "") then
		{
			_vehicle setVariable ["A3W_vehicleVariant", _variant, true];
		};
		[_vehicle] call vehicleSetup;
		//_vehicle setDir _direction;
		_aiGroup addVehicle _vehicle;
		// add a driver/pilot/captain to the vehicle
		// the little bird, orca, and hellcat do not require gunners and should not have any passengers
		_soldier = [_aiGroup, _position] call createRandomSoldierC;
		_soldier moveInDriver _vehicle;
		_soldierGun = [_aiGroup, _position] call createRandomSoldierC;
		_soldierGun moveInGunner _vehicle;
	
		if (_vehicle emptyPositions "commander" > 0) then
		{
			_soldierCommander = [_aiGroup, _position] call createRandomSoldierC;
	    	_soldierCommander moveInCommander _vehicle;
		};
		[_vehicle, _aiGroup] spawn checkMissionVehicleLock;
		_vehicle
	};


	private _vehChoices =
	[
		["O_MBT_02_cannon_F", "O_APC_Tracked_02_AA_F"],
		["O_APC_Tracked_02_cannon_F", "I_LT_01_AA_F"],
		["B_MBT_01_TUSK_F", "B_APC_Tracked_01_AA_F"]
	];

	if(["A3W_use_CUP", false] call getPublicVar) then {
		_vehChoices append [
		[(CUP_Classes select {_x == "CUP_B_M1A1_DES_US_Army"}) select 0, (CUP_Classes select {_x == "O_APC_Tracked_02_AA_F"}) select 0],
		[(CUP_Classes select {_x == "CUP_O_BMP3_RU"}) select 0, (CUP_Classes select {_x == "CUP_O_2S6M_RU"}) select 0],
		[(CUP_Classes select {_x == "CUP_O_T90_RU"}) select 0, (CUP_Classes select {_x == "O_APC_Tracked_02_AA_F"}) select 0]
		];
	};

	private _nukeJetVeh = selectRandom _vehChoices;

	private _veh1 = _nukeJetVeh select 0;
	private _veh2 = _nukeJetVeh select 1;


	_nbUnits = 16;
	_missionPos = markerPos _missionLocation;
	private _missionDir = markerDir _missionLocation;
	_block = selectRandom (call compile preprocessFileLineNumbers "server\missions\ultraMissions\baseBlocks\baseBlockList.sqf");
	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos, _nbUnits, 30] call createCustomGroup;
	_objects = [_block, _missionPos, _missionDir] call createBlock; 
	{ 	
		_x setVariable ["R3F_LOG_disabled", true, true];
		_objClass = typeOf _x;
		
		_x setVariable ["allowDamage", true];
		
		if (_objClass == "Land_BarrelWater_F") then
		{
			_x setVariable ["water", 50, true];
		};
		if (_objClass == "Land_Sacks_goods_F") then
		{
			_x setVariable ["food", 40, true];
		};

				
		if (_x emptyPositions "gunner" > 0) then
		{
			_soldierCommander = [_aiGroup, _missionPos] call createRandomSoldierC;
		    _soldierCommander moveInGunner _x;
		};

		_x allowDamage true;

	} forEach _objects;


	private _spawn1 = [((_missionPos select 0) + 60), (_missionPos select 1), (_missionPos select 2)];
	private _spawn2 = [(_missionPos select 0), ((_missionPos select 1) + 60), (_missionPos select 2)];
	private _spawn3 = [((_missionPos select 0) + 60), ((_missionPos select 1) + 60), (_missionPos select 2)];

	//_vehicles =
	//[
	_veh1Object = [_veh1, _spawn1] call _createVehicle;
	_veh2Object = [_veh2, _spawn2] call _createVehicle;

	_vehicleClass = "B_Truck_01_box_F";
	(units _aiGroup) allowGetIn false; //BLOCK AI
	_veh3Object = [_vehicleClass, _spawn3] call createMissionVehicle;

	/*
	if (_vehicleClass isEqualType []) then
	{
		_variant = _vehicleClass param [1,"",[""]];
		_vehicleClass = _vehicleClass select 0;
	};
	*/

	_aiGroup leaveVehicle _veh3Object; //BLOCK AI



	_missionHintText = format ["The enemies created a base and hid money there! Take them!", ultraMissionColor];
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_drop_item = 
{
	private _item = _this select 0;
	private _pos = _this select 1;

	if (isNil "_item" || {typeName _item != typeName [] || {count(_item) != 2}}) exitWith {};
	if (isNil "_pos" || {typeName _pos != typeName [] || {count(_pos) != 3}}) exitWith {};

	private _id = _item select 0;
	private _class = _item select 1;

	private _obj = createVehicle [_class, _pos, [], 5, "None"];
	_obj setPos ([_pos, [[2 + random 3,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
	_obj setVariable ["mf_item_id", _id, true];
};




_failedExec =
{

	if (alive _veh1Object) then {
		{ deleteVehicle _x; } forEach units _aiGroup;
		deleteVehicle _veh1Object;
	};
	if (alive _veh2Object) then {
		{ deleteVehicle _x; } forEach units _aiGroup;
		deleteVehicle _veh2Object;
	};
	if (alive _veh3Object) then {
		{ deleteVehicle _x; } forEach units _aiGroup;
		deleteVehicle _veh3Object;
	};

	{ deleteVehicle _x } forEach _objects;
};

_successExec =
{
	{
		//if(!(_x isKindOf "Land_BagBunker_Tower_F")) then {
			_x setVariable ["R3F_LOG_disabled", false, true];
			[_x, 1] call A3W_fnc_setLockState;
		//};
	} forEach _objects;
	
	[_veh3Object, 1] call A3W_fnc_setLockState;

	//[_locationsArray, _missionLocation, _objects] call setLocationObjects;
	
	//{ deleteVehicle _x } forEach _objects;
	uiSleep 1;

	for "_i" from 1 to 5 do {
		private _cash = createVehicle ["Land_Money_F", _missionPos, [], 5, "None"];
		_cash setPos ([_missionPos, [[2 + random 3,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
		_cash setDir random 360;
		_cash setVariable ["cmoney", 150000, true];
		_cash setVariable ["owner", "world", true];
	};


	if (random 1 < 0.2) then // 20% chance of key spawning //BY VLADOS
	{
		private _tmpPos = ([_missionPos, [[2 + random 3,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
		private _lootholder = createVehicle ["GroundWeaponHolder", _tmpPos, [], 0, "CAN_COLLIDE"];
		_lootholder setPosATL _tmpPos;
		_lootholder addMagazineCargoGlobal ["Keys", 1];
	};
	
	_successHintMessage = "The Base has been capture!";
	
};

_this call ultraMissionProcessor;
