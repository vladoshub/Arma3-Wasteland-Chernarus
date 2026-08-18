// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//  @file Name: fn_resupplyTruck.sqf
//  @file Author: Wiking, AgentRev, micovery

#define RESUPPLY_TRUCK_DISTANCE_REAMMO (10 max (sizeOf typeOf _vehicle * 0.75)) // this must match the addAction condition in fn_setupResupplyTruck.sqf
#define REARM_TIME_SLICE_REAMMO 15
#define REPAIR_TIME_SLICE_REAMMO 1
#define REFUEL_TIME_SLICE_REAMMO 1
#define PRICE_RELATIONSHIP_REAMMO 4 // resupply price = brand-new store price divided by PRICE_RELATIONSHIP
#define RESUPPLY_TIMEOUT_REAMMO 30

// Check if mutex lock is active.
if (mutexScriptInProgress) exitWith {
	titleText ["You are already performing another action.", "PLAIN DOWN", 0.5];
};

mutexScriptInProgress = true;
doCancelAction = false;

params ["", ["_unit",objNull,[objNull]]];

_vehicle = vehicle _unit;

//check if caller is in vehicle
if (_vehicle == _unit) exitWith {};

_resupplyThreadAmmo = [_vehicle, _unit] spawn
{
	params ["_vehicle", "_unit"];

	_vehClass = typeOf _vehicle;
	_vehCfg = configFile >> "CfgVehicles" >> _vehClass;
	_vehName = getText (_vehCfg >> "displayName");
	_isUAV = (round getNumber (_vehCfg >> "isUav") >= 1);
	_isStaticWep = _vehClass isKindOf "StaticWeapon";

	scopeName "resupplyTruckThread";
	
	if (_vehicle isKindOf "B_SAM_System_02_F") then {
		_vehicle setVehicleAmmo 0.5;
		_vehicle setVehicleAmmoDef 0.5;
		hint format["You payed %1 for new Turret Ammo please re-enter the Turret to use Ammo.",_price];
	};
	
	if (_vehicle isKindOf "B_AAA_System_01_F") then {
		_vehicle setVehicleAmmo 1;
		hint format["You payed %1 for new Turret Ammo",_price];
	};

	_variant = _vehicle getVariable ["A3W_vehicleVariant", ""];
	if (_variant != "") then { _variant = "variant_" + _variant };


	_titleText =
	{
		params ["_text", ["_time",((REARM_TIME_SLICE_REAMMO max 1) / 10) max 0.3,[0]]];
		titleText [_text, "PLAIN DOWN", _time];
	};

	_checkAbortConditions =
	{
		private _abortText = "";
		private _pauseText = "";
		private "_checkCondition";

		call
		{
			if (doCancelAction) exitWith
			{
				doCancelAction = false;
				_abortText = "Cancelled by player.";
			};

			if (!alive player) exitWith
			{
				_abortText = "You have been killed.";
			};

			// Abort if vehicle is no longer local, otherwise commands won't do anything
			_checkCondition = {!local _vehicle};
			if (call _checkCondition) exitWith
			{
				_pauseText = "Take back control of the vehicle.";
				_abortText = "Another player took control of the vehicle.";
			};

			// Abort if vehicle is destroyed
			_checkCondition = {!alive _vehicle};
			if (call _checkCondition) exitWith
			{
				_abortText = "The vehicle has been destroyed.";
			};

			// Abort if no resupply vehicle in proximity
			_checkCondition = {{alive _x && {_x getVariable ["A3W_resupplyTruck", false]}} count (_vehicle nearEntities ["AllVehicles", RESUPPLY_TRUCK_DISTANCE_REAMMO]) == 0};
			if (call _checkCondition) exitWith
			{
				_pauseText = "Move closer to a resupply vehicle.";
				_abortText = "Too far from resupply vehicle.";
			};

			// Abort if player gets out of vehicle
			_checkCondition = {vehicle _unit != _vehicle};
			if (!_isUAV && !_isStaticWep && _checkCondition) exitWith
			{
				_pauseText = "Get back in the vehicle.";
				_abortText = "You are not in the vehicle.";
			};

			// Abort if someone gets in the gunner seat
			/*_checkCondition = {alive gunner _vehicle};
			if (!_isUAV && _checkCondition) exitWith
			{
				_pauseText = "The gunner seat must be empty.";
				_abortText = "Someone is in the gunner seat.";
			};*/

			private _vehVel = velocity _vehicle;
			_checkCondition = {abs(_vehVel select 0) > 3 || abs(_vehVel select 1) > 3 || abs(_vehVel select 2) > 3 || abs(speed _vehicle) > 10}; 
			if (call _checkCondition) exitWith
			{
				_abortText = "Don't move while it's reloading";
			};


			_curPos = getPosATL _vehicle;
				if((["A3W_map", "chernarus"] call getPublicVar) == "chernarus") then {
					_checkCondition = { (_curPos select 0) > 18000 || (_curPos select 0) < -3000 || (_curPos select 1) < 0 || (_curPos select 1) > 16000 || (_curPos select 2) > 3000};
				} else {
					_checkCondition = { (_curPos select 0) > 30000 || (_curPos select 0) < 0 || (_curPos select 1) < 0 || (_curPos select 1) > 30000 || (_curPos select 2) > 3000};
				};
			if (call _checkCondition) exitWith
			{
				_abortText = "Not available this";
			};
		};

		if (_pauseText != "") then
		{
			private "_i";

			for [{_i = RESUPPLY_TIMEOUT_REAMMO}, {_i > 0 && _checkCondition && !doCancelAction}, {_i = _i - 1}] do
			{
				_vehicle setVariable ["A3W_resupplyTruckTimeout", true];
				titleText [format ["%1\n%2", _pauseText, format ["Resupply sequence timeout in %1", _i]], "PLAIN DOWN", 0.5];
				sleep 1;
			};

			_vehicle setVariable ["A3W_resupplyTruckTimeout", nil];

			if !(call _checkCondition) then
			{
				_abortText = "";
				titleText ["", "PLAIN DOWN", 0.5];
			};

			if (doCancelAction) then
			{
				_abortText = "Cancelled by player.";
			};
		};

		if (_abortText != "") then
		{
			titleText [format ["%1\n%2", _abortText, "Resupply sequence aborted"], "PLAIN DOWN", 0.5];
			breakTo "resupplyTruckThread";
		};
	};


	call
	{
		call _checkAbortConditions;


		private _pathArrs = [];
		private _notFull = false;

		// Collect turret mag data
		{
			_x params ["_mag", "_path", "_ammo"];

			if (_mag != "FakeWeapon" && !isText (configFile >> "CfgMagazines" >> _mag >> "pylonWeapon")) then
			{
				_pathArr = [_pathArrs, _path] call fn_getFromPairs;
				_new = isNil "_pathArr";

				if (_new) then { _pathArr = [] };

				_index = [_pathArr, _mag, 1] call fn_addToPairs;

				if (_ammo < getNumber (configFile >> "CfgMagazines" >> _mag >> "count")) then
				{
					(_pathArr select _index) set [2, true]; // mark mag for reload
					_notFull = true;
				};

				if (_new) then { _pathArrs pushBack [_path, _pathArr] };
			};
		} forEach magazinesAllTurrets _vehicle;

		_checkDone = true;

		{
			if (_x != "") then
			{
				_magCfg = configFile >> "CfgMagazines" >> _x;

				if (_vehicle ammoOnPylon (_forEachIndex + 1) < getNumber (_magCfg >> "count")) then
				{
					_notFull = true;
				};
			};
		} forEach getPylonMagazines _vehicle;

		if (_notFull) then
		{
			call _checkAbortConditions;
			playSound3D ["A3\Sounds_F\arsenal\weapons_static\Static_HMG\reload_static_HMG.wss", _vehicle, false, getPosASL _vehicle, 10, 1, 20 max sizeOf _vehClass];

			private "_i";
			for "_i" from 1 to REARM_TIME_SLICE_REAMMO do
			{
				"Reloading..." call _titleText;
				sleep 1;
				call _checkAbortConditions;
			};
		};

		_vehicle setVehicleAmmo 1;
		[_vehicle, false, true, true] call A3W_fnc_setVehicleLoadout;

		_checkDone = true;


		// reset ejection seat crap
		if (_vehicle isKindOf "Plane") then
		{
			_vehicle setVariable ["bis_ejected", nil, true];
			{ _vehicle animate [_x, 0, true] } forEach ["canopy_hide", "ejection_seat_motion", "ejection_seat_hide"];
		};

		_checkDone = true;
		titleText ["Your vehicle is ready.", "PLAIN DOWN", 0.5];
	};
};

_vehicle setVariable ["A3W_truckResupplyThreadAmmo", _resupplyThreadAmmo];

// Secondary thread for cleanup in case of error in resupply thread
[_vehicle, _resupplyThreadAmmo] spawn
{
	params ["_vehicle", "_resupplyThreadAmmo"];

	waitUntil {scriptDone _resupplyThreadAmmo};

	/*_ehID = _vehicle getVariable ["A3W_truckResupplyEngineEH", -1];

	if (_ehID isEqualType 0) then
	{
		_vehicle removeEventHandler ["Engine", _ehID];
	};

	_vehicle setVariable ["A3W_truckResupplyEngineEH", nil];
	*/
	mutexScriptInProgress = false;
};
