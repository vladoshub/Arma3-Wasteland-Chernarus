// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_AbandonedJet.sqf
//	@file Author: AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitWith {};
#include "mainMissionDefines.sqf";

private ["_vehicle", "_vehicleName", "_vehDeterminer", "_vehicleClass", "_veh1Object"];

_setupVars =
{
	_vehicleClass =
	selectRandom [
		"B_T_UAV_03_F", 
		"O_T_UAV_04_CAS_F",
		"B_UAV_05_F",
		"B_UAV_02_dynamicLoadout_F",
		"O_UAV_02_dynamicLoadout_F",
		"I_UAV_02_dynamicLoadout_F"
	];

	_missionType = "MIDDLE: UAV Wrecked";
	_locationsArray = MissionSpawnMarkers;
};

_setupObjects =
{

	private _vehChoices =
	[
		["I_LT_01_AA_F"]
	];

	if(["A3W_use_CUP", false] call getPublicVar) then {

		_vehChoices append [
			(CUP_Classes select {_x == "CUP_I_Datsun_AA_Random"}),
			(CUP_Classes select {_x == "CUP_B_UAZ_AA_CDF"})
		];


		if (random 1 < 0.45) then {
			_vehChoices append [(CUP_Classes select {_x == "CUP_O_2S6M_RU"})];
		};
	};

	private _ultraVehRandom = selectRandom _vehChoices;

	private _veh1 = _ultraVehRandom select 0;


	_createVehicle =
	{
		private ["_type", "_position", "_direction", "_variant", "_special", "_vehicle", "_soldier", "_soldierGun", "_soldierCommander", "_missionPos", "_vehicleClass"];
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


	_missionPos = markerPos _missionLocation;

	// Class, Position, Fuel, Ammo, Damage, Special
	_vehicle = [_vehicleClass, _missionPos] call createMissionVehicle;
	_vehicle setVariable ["MissionVehicleDrawIcon", true, true];

	_aiGroup = createGroup CIVILIAN;
	[_aiGroup,_missionPos,12,15] spawn createCustomGroup3;

	_missionPicture = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "picture");
	_vehicleName = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "displayName");

	_vehDeterminer = if ("AEIMO" find (_vehicleName select [0,1]) != -1) then { "An" } else { "A" };

	private _spawn1 = [(_missionPos select 0), ((_missionPos select 1) + 35), (_missionPos select 2)];

	_veh1Object = [_veh1, _spawn1] call _createVehicle;

	_missionHintText = format ["%1 <t color='%3'>%2</t> has been immobilized, go get it for your team!", _vehDeterminer, _vehicleName, mainMissionColor];	
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
//_waitUntilCondition = nil;
_waitUntilCondition = {!alive _vehicle};

_failedExec =
{

	if (alive _veh1Object) then {
		{ deleteVehicle _x; } forEach units _aiGroup;
		deleteVehicle _veh1Object;
	};

	// Mission failed
	deleteVehicle _vehicle;
};

_successExec =
{
	// Mission completed
	_vehicle lock 1;
	_vehicle setVariable ["R3F_LOG_disabled", false, true];
	_vehicle addItemCargoGlobal ["B_UavTerminal", 1];
	_vehicle addItemCargoGlobal ["O_UavTerminal", 1];
	_vehicle addItemCargoGlobal ["I_UavTerminal", 1];
	
	_successHintMessage = format ["The %1 has been captured, well done.", _vehicleName];
};

_this call mainMissionProcessor;