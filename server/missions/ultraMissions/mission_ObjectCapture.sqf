// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_VehicleCapture.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, JoSchaap, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitWith {};
#include "ultraMissionDefines.sqf";

private ["_vehicle", "_vehicleName", "_vehDeterminer", "_variant", "_veh1Object", "_createVehicle", "_vehicleClass"];

// setupVars must be defined in the top mission file

_setupObjects =
{

	private _vehChoices =
	[
		["I_LT_01_AA_F"],
		["O_APC_Tracked_02_cannon_F"],
		["O_MBT_04_command_F"]
	];


	if(["A3W_use_CUP", false] call getPublicVar) then {
		_vehChoices append [
			(CUP_Classes select {_x == "CUP_O_T90_RU"}),
			(CUP_Classes select {_x == "CUP_O_BMP3_RU"})
		];
	};

	private _objectVehRandom = selectRandom _vehChoices;

	private _veh1 = _objectVehRandom select 0;


	_missionPos = markerPos _missionLocation;

	_createVehicle =
	{
		private ["_type", "_position", "_direction", "_variant", "_special", "_vehicle", "_soldier", "_soldierGun", "_soldierCommander", "_vehicleClass"];
		_type = _this select 0;
		_position = _this select 1;
		_variant = _type param [1,"",[""]];
		if (_type isEqualType []) then
		{
			_type = _type select 0;
		};

		if(_type == "land_nav_pier_C_R") then {
			private _zPos = (_position select 2);
			_position set [2, _zPos + 2];
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

	// Class, Position, Fuel, Ammo, Damage, Special
	_vehicle = [_vehicleClass, _missionPos] call createMissionVehicle;
	_vehicle setVariable ["MissionVehicleDrawIcon", true, true];

	_vehicle setVariable ["allowDamage", true];

	_vehicleName = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "displayName");


	if (_vehicleClass isEqualType []) then
	{
		_variant = _vehicleClass param [1,"",[""]];
		_vehicleClass = _vehicleClass select 0;
	};

	if (!isNil "_customVehicleSetup") then { call _customVehicleSetup };

	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos, _nbUnits] call createCustomGroup;

	private _spawn1 = [(_missionPos select 0), ((_missionPos select 1) + 35), (_missionPos select 2)];

	(units _aiGroup) allowGetIn false; //BLOCK AI

	_veh1Object = [_veh1, _spawn1] call _createVehicle;

	//_missionPicture = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "picture");
	_missionPicture = "";


	_vehDeterminer = if ("AEIMO" find (_vehicleName select [0,1]) != -1) then { "An" } else { "A" };

	_aiGroup leaveVehicle _vehicle; //BLOCK AI

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
};

_successExec =
{
	// Mission completed
	_vehicle allowDamage true;
	[_vehicle, 1] call A3W_fnc_setLockState; // Unlock

	_successHintMessage = format ["The %1 has been captured, well done.", _vehicleName];
};

/*_loadObject =
{
	_transporteur = select 0;
	_objet = select 1;


	_objets_charges = _transporteur getVariable "R3F_LOG_objets_charges";

	_objets_charges = _objets_charges + [_objet];
	_transporteur setVariable ["R3F_LOG_objets_charges", _objets_charges, true];
	_objet setVariable ["R3F_LOG_est_transporte_par", _transporteur, true];
	_objet disableCollisionWith _transporteur;
	//R3F_LOG_joueur_deplace_objet = objNull;
	private ["_nb_tirage_pos", "_position_attache"];
	_position_attache = [random 3000, random 3000, (10000 + (random 3000))];
	_nb_tirage_pos = 1;
	while {(!isNull (nearestObject _position_attache)) && (_nb_tirage_pos < 25)} do
		{
			_position_attache = [random 3000, random 3000, (10000 + (random 3000))];
			_nb_tirage_pos = _nb_tirage_pos + 1;
		};

	[R3F_LOG_PUBVAR_point_attache, true] call fn_enableSimulationGlobal;
	[_objet, true] call fn_enableSimulationGlobal;
	
	_objet attachTo [R3F_LOG_PUBVAR_point_attache, _position_attache];
	_objet enableCollisionWith _transporteur;
};*/

_this call ultraMissionProcessor;

