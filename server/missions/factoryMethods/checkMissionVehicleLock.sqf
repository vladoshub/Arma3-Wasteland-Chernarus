// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: checkMissionVehicleLock.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

params ["_vehicle", "_group"];
private _shepherd = -1;
private _crew = (crew _vehicle) select {alive _x && {!isPlayer _x} && {group _x isEqualTo _group}};

// Only the vehicle's own crew may board. Do not re-enable boarding for infantry.
_crew allowGetIn true;

if (_vehicle isKindOf "LandVehicle") then {
	_vehicle setUnloadInCombat [false, false];
	_vehicle setVariable ["A3W_missionVehicleCrew", _crew];
	_vehicle setVariable ["A3W_missionVehicleCrewGroup", _group];

	// Give seated drivers and turret operators explicit roles in this vehicle.
	{
		_x params ["_unit", "_role", "_cargoIndex", "_turretPath"];
		if (_unit in _crew) then {
			if (toLower _role == "driver") then {
				_unit assignAsDriver _vehicle;
			} else {
				if (count _turretPath > 0 && {!(toLower _role == "cargo")}) then {
					_unit assignAsTurret [_vehicle, _turretPath];
				};
			};
		};
	} forEach (fullCrew [_vehicle, "", false]);

	_shepherd = _vehicle addEventHandler ["GetOut",
	{
		params ["_vehicle", "_role", "_unit", "_turretPath"];
		if (_unit in (_vehicle getVariable ["A3W_missionVehicleCrew", []]) &&
			{(toLower _role) in ["driver", "gunner", "commander", "turret"]}) then {
			// Let the exit finish, then check the vehicle and the original seat again.
			_this spawn {
				params ["_vehicle", "_role", "_unit", "_turretPath"];
				sleep 0.2;
				if (!alive _unit || {!local _unit} || {isPlayer _unit} ||
					{!isNull objectParent _unit} || {!alive _vehicle} || {!canMove _vehicle} ||
					{damage _vehicle >= 0.9} || {((getPosASL _vehicle) select 2) < -0.5} ||
					{((vectorUp _vehicle) select 2) < 0.2} ||
					{!(_vehicle getVariable ["R3F_LOG_disabled", false])} ||
					{!(group _unit isEqualTo (_vehicle getVariable ["A3W_missionVehicleCrewGroup", grpNull]))} ||
					{({isPlayer _x} count crew _vehicle) > 0}) exitWith {};

				_role = toLower _role;
				private _seatFree = switch (_role) do {
					case "driver": {isNull driver _vehicle};
					case "gunner": {if (count _turretPath > 0) then {isNull (_vehicle turretUnit _turretPath)} else {isNull gunner _vehicle}};
					case "commander": {if (count _turretPath > 0) then {isNull (_vehicle turretUnit _turretPath)} else {isNull commander _vehicle}};
					default {count _turretPath > 0 && {isNull (_vehicle turretUnit _turretPath)}};
				};
				if (!_seatFree) exitWith {};

				[_unit] allowGetIn true;
				if (_role == "driver") then {
					_unit assignAsDriver _vehicle;
					[_unit] orderGetIn true;
					_unit moveInDriver _vehicle;
				} else {
					if (count _turretPath > 0) then {
						_unit assignAsTurret [_vehicle, _turretPath];
						[_unit] orderGetIn true;
						_unit moveInTurret [_vehicle, _turretPath];
					} else {
						if (_role == "gunner") then {
							_unit assignAsGunner _vehicle;
							[_unit] orderGetIn true;
							_unit moveInGunner _vehicle;
						} else {
							_unit assignAsCommander _vehicle;
							[_unit] orderGetIn true;
							_unit moveInCommander _vehicle;
						};
					};
				};
			};
		};
	}];
};

while {alive _vehicle && _vehicle getVariable ["R3F_LOG_disabled", false]} do {
	if ({alive _x && group _x isEqualTo _group} count crew _vehicle > 0) then {
		if (locked _vehicle < 3) then { _vehicle lock 3 };
	} else {
		if (locked _vehicle > 1) then { _vehicle lock 1 };
	};

	sleep 3;
};

_vehicle lock 1;

if (_shepherd >= 0) then {
	_vehicle removeEventHandler ["GetOut", _shepherd];
	_vehicle setVariable ["A3W_missionVehicleCrew", nil];
	_vehicle setVariable ["A3W_missionVehicleCrewGroup", nil];
};
