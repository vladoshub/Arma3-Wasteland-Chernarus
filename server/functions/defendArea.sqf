// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/*
 =======================================================================================================================
Script: BIN_taskDefend.sqf v1.3a (defendArea.sqf)
Author(s): Binesi, AgentRev
Partly based on original code by BIS

Description:
Group will guard/patrol the position and surrounding area.

Parameter(s):
_this select 0: group (Group)
_this select 1: defense position (Array)
_this select 2: Vehicle class to move in as gunner (String, optional)

Returns:
Boolean - success flag

Example(s):
[group this, getPos this] call defendArea;
=======================================================================================================================
*/

if (!isServer) exitWith {};

private ["_grp", "_pos", "_vehicleType"];

_grp = _this select 0;
_pos = _this select 1;
_vehicleType = if (count _this > 2) then { _this select 2 } else { "StaticWeapon" };

_grp allowFleeing 0;

// Static weapons
private ["_units", "_staticWeapons", "_unit"];
_units = (units _grp) - [leader _grp]; // The leader should not man defenses
_staticWeapons = [];

// Find all nearby static defenses or vehicles without a gunner
{
	if (_x emptyPositions "gunner" > 0 && {!(_x getVariable ["A3W_missionVehicleCandidate", false])}) then
	{
		_staticWeapons pushBack _x;
	};
} forEach (nearestObjects [_pos, [_vehicleType], 75]);

// Have the group man empty static defenses and vehicle turrets
{
	// Are there still units available?
	if (count _units > 0) then
	{
		_unit = selectRandom _units;
		_unit assignAsGunner _x;
		_unit moveInGunner _x;
		_units = _units - [_unit];
	};
} forEach _staticWeapons;

// Search the area while alert. DISMISS makes small teams wander off and sit down.
private ["_wp1", "_wp2"];

_wp1 = _grp addWaypoint [_pos, 0];
_wp1 setWaypointType "SAD"; // Seek And Destroy
_wp1 setWaypointBehaviour "AWARE";
_wp1 setWaypointCombatMode "RED";
_wp1 setWaypointCompletionRadius 75;

_wp2 = _grp addWaypoint [_pos, 0];
_wp2 setWaypointType "CYCLE";
_wp2 setWaypointBehaviour "AWARE";
_wp2 setWaypointCombatMode "RED";
_wp2 setWaypointCompletionRadius 75;

{
	// Prevent units from wandering too far and from going prone
	[_x, _pos] spawn
	{
		private ["_unit", "_unitPos", "_targetPos", "_doMove"];
		_unit = _this select 0;
		_targetPos = +(_this select 1);
		_targetPos set [2, 0]; // Movement commands need a ground-level ATL destination.

		while {alive _unit} do
		{
			if ((toUpper behaviour _unit) in ["COMBAT","STEALTH"]) then
			{
				if (stance _unit == "PRONE") then
				{
					_unit setUnitPos "MIDDLE";
				};
			}
			else
			{
				if (unitPos _unit == "MIDDLE") then
				{
					_unit setUnitPos "AUTO";
				};
			};

			sleep 1;

			if (alive _unit && {local _unit} && {!isPlayer _unit}) then
			{
				_unitPos = getPosATL _unit;

				if (_unitPos distance2D _targetPos > 75 &&
					{!((vehicle _unit) getVariable ["A3W_missionVehicleAvoiding", false])}) then
				{
					_doMove = [[0, 5 + random 65, 0], -(([_targetPos, _unitPos] call BIS_fnc_dirTo) + (45 - random 90))] call BIS_fnc_rotateVector2D;
					_unit doMove (_targetPos vectorAdd _doMove);
					sleep 3;
				};
			};
		};
	};
	
	_x disableAI "COVER";
} forEach units _grp;

_grp spawn
{
	while {{alive _x} count units _this > 0} do
	{
		if (combatMode _this != "RED") then
		{
			_this setCombatMode "RED"; // FIRE AT WILL MOTHERFUCKERS!
		};

		sleep 3;
	};
};

true
