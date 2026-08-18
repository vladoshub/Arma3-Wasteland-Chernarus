// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_VehicleCapture.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, JoSchaap, AgentRev
//	@file Created: 08/12/2012 15:19

//COPY FROM

if (!isServer) exitWith {};
#include "ultraMissionDefines.sqf";

private ["_vehicle", "_vehicleName", "_vehDeterminer", "_variant", "_veh1Object", "_veh2Object", "_veh3Object", "_vehicleClass", "_createVehicle"];

// setupVars must be defined in the top mission file

_setupObjects =
{
	_missionPos = markerPos _missionLocation;

	// Class, Position, Fuel, Ammo, Damage, Special
	_vehicle = [_vehicleClass, _missionPos] call createMissionVehicle;
	_vehicle setVariable ["MissionVehicleDrawIcon", true, true];

	if (_vehicleClass isEqualType []) then
	{
		_variant = _vehicleClass param [1,"",[""]];
		_vehicleClass = _vehicleClass select 0;
	};

	if (!isNil "_customVehicleSetup") then { call _customVehicleSetup };



	private _vehChoices =
	[
		["O_MBT_02_cannon_F", "O_APC_Tracked_02_AA_F", "O_APC_Tracked_02_cannon_F"],
		["I_APC_Wheeled_03_cannon_F", "O_APC_Tracked_02_AA_F", "B_MBT_01_TUSK_F"],
		["O_MBT_04_command_F", "B_APC_Tracked_01_AA_F", "I_APC_Wheeled_03_cannon_F"]
	];

	if(["A3W_use_CUP", false] call getPublicVar) then {
		_vehChoices append [
		[(CUP_Classes select {_x == "CUP_B_M1A1_DES_US_Army"}) select 0, (CUP_Classes select {_x == "O_APC_Tracked_02_AA_F"}) select 0,  (CUP_Classes select {_x == "CUP_O_BMP3_RU"}) select 0],
		[(CUP_Classes select {_x == "CUP_O_BMP3_RU"}) select 0, (CUP_Classes select {_x == "CUP_O_2S6M_RU"}) select 0,  (CUP_Classes select {_x == "CUP_O_T90_RU"}) select 0],
		[(CUP_Classes select {_x == "CUP_O_T90_RU"}) select 0, (CUP_Classes select {_x == "O_APC_Tracked_02_AA_F"}) select 0,  (CUP_Classes select {_x == "CUP_B_M1A1_DES_US_Army"}) select 0]
		];
	};

	private _nukeJetVeh = selectRandom _vehChoices;

	private _veh1 = _nukeJetVeh select 0;
	private _veh2 = _nukeJetVeh select 1;
	private _veh3 = _nukeJetVeh select 2;


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

		if (_vehicle emptyPositions "driver" > 0) then
		{
			_soldier = [_aiGroup, _position] call createRandomSoldierC;
			_soldier moveInDriver _vehicle;
		};

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

	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos, _nbUnits] call createCustomGroup;

    //_chair setPosATL [_missionPos select 0, _missionPos select 1, _missionPos select 2];


	private _spawn1 = [((_missionPos select 0) + 42), ((_missionPos select 1) + 42), (_missionPos select 2)];
	private _spawn2 = [(_missionPos select 0), ((_missionPos select 1) + 30), (_missionPos select 2)];
	private _spawn3 = [((_missionPos select 0) + 30), ((_missionPos select 1) + 30), (_missionPos select 2)];

	//_vehicles =
	//[
	_veh1Object = [_veh1, _spawn1] call _createVehicle;
	_veh2Object = [_veh2, _spawn2] call _createVehicle;
	_veh3Object = [_veh3, _spawn3] call _createVehicle;

	_veh2Object setVariable ["allowDamage", true];
	_veh3Object setVariable ["allowDamage", true];

	//];

	_missionPicture = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "picture");
	_vehicleName = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "displayName");

	_vehDeterminer = if ("AEIMO" find (_vehicleName select [0,1]) != -1) then { "An" } else { "A" };

	_missionHintText = format ["%1 <t color='%3'>%2</t> has been immobilized, go get it for your team!", _vehDeterminer, _vehicleName, ultraMissionColor];
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = {!alive _vehicle};

_failedExec =
{
	// Mission failed
	deleteVehicle _vehicle;
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
};

_successExec =
{
	// Mission completed
	_vehicle allowDamage true;
	[_vehicle, 1] call A3W_fnc_setLockState; // Unlock

	_successHintMessage = format ["The %1 has been captured, well done.", _vehicleName];
};

_this call ultraMissionProcessor;
