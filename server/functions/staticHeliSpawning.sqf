// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: staticHeliSpawning.sqf
//	@file Author: [404] Costlyy, AgentRev
//	@file Created: 20/12/2012 21:00
//	@file Description: Random static helis
//	@file Args:

if (!isServer) exitWith {};

private ["_count", "_position", "_marker", "_vehicle"];
_count = 0;

{
	_marker = _x;

	if (["heliSpawn_", _marker] call fn_startsWith) then
	{
		_position = markerPos _marker;

		// Match the 50 m placement radius and include parked vehicles and wrecks.
		if (nearestObjects [_position, ["LandVehicle", "Air", "Ship"], 10] isEqualTo [] && {random 1 < 0.35}) then // 20% chance per attempt
		{
			_vehicle = [0, _position] call staticHeliCreation;
			if (!isNull _vehicle) then { _count = _count + 1 };
		};
	};
} forEach allMapMarkers;

_count
