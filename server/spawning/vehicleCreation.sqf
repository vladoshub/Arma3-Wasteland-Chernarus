// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: vehicleCreation.sqf
//	@file Author: [404] Deadbeat, modded by AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args: markerPos [, vehicleType]

if (!isServer) exitWith {};

params ["_markerPos", ["_vehicleType","",[""]], ["_respawnSettings",nil,[[]]]];
private ["_pos", "_vehicle", "_hitPoint"];

private _isRespawn = !isNil "_respawnSettings";

// Town startup spawning already supplies a safe position. For respawns, the
// original point may now be obstructed by a player-built object or vehicle.
_pos = if (_isRespawn) then
{
	_markerPos findEmptyPosition [0, 5, _vehicleType]
}
else
{
	_markerPos
};

// Keep the respawn entry pending; the manager will retry on its next pass.
if (_pos isEqualTo []) exitWith {};

//Car Initialization
_vehicle = createVehicle [_vehicleType, _pos, [], 0, "None"];
if (isNull _vehicle) exitWith {};

_vehicle setPosATL [_pos select 0, _pos select 1, if (_isRespawn) then {(_pos select 2) + 0.1} else {1.5}];
_vehicle setDir random 360;
_vehicle setVelocity [0,0,0.01];

_vehicle setDamage (random 0.5); // setDamage must always be called before vehicleSetup

// Reset wheel damage
{
	if (toLower _x find "wheel" != -1) then
	{
		_vehicle setHitPointDamage [_x, 0];
	};
} forEach (getAllHitPointsDamage _vehicle param [0,[]]);

[_vehicle] call vehicleSetup;

_vehicle setVariable ["A3W_notForSale", true, true];

if (!isNil "_respawnSettings") then
{
	[_respawnSettings, "Vehicle", _vehicle] call fn_setToPairs;
	_vehicle setVariable ["vehicleRespawn_settingsArray", _respawnSettings];
};

//[_vehicle, _markerPos, 10, 20, 30] call addVehicleRespawn;
[_vehicle, _markerPos, 5*60, 10*60, 25*60] call addVehicleRespawn; // Keep the original respawn anchor.

//Set Vehicle Attributes
_vehicle setFuel (0.2 + random 0.1);

// Reset Offroad HMG to 1-2 mags
if (_vehicleType isKindOf "Offroad_01_armed_base_F") then
{
	_vehicle removeMagazinesTurret ["100Rnd_127x99_mag_Tracer_Yellow", [0]];
	_vehicle addMagazineTurret ["100Rnd_127x99_mag_Tracer_Yellow", [0]];
	reload _vehicle;
	_vehicle setVehicleAmmo ((1 + floor random 2) / 4);
};

// Reset Offroad AT to 0-4 rockets 
if (_vehicleType isKindOf "Offroad_01_AT_base_F") then
{
	{
		_x params ["_mag", "_path", "_ammo"];
		_vehicle setMagazineTurretAmmo [_mag, floor random 3, _path];
	} forEach magazinesAllTurrets _vehicle;
};

//if (_type > 1) then { _vehicle setVehicleAmmo (random 1.0) };

[_vehicle] call randomWeapons;
