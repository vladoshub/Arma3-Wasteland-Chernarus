// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_emergencyEject.sqf
//	@file Author: AgentRev

if (!alive player) exitWith {};



if({ (_x getVariable ["objectLocked", false]) && (_x getVariable ["is_base_flag_activate", false]) && ( !( (_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) || (_x getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _x == group player) || ((side _x == side player) && (str(side player) == "WEST" || str(side player) == "EAST")) || ((str(side player) == "WEST" || str(side player) == "EAST") && (str(side player)) == (_x getVariable ["LastSide", ""])) ) || ((str(side player)) != _x getVariable ["LastSide", (str(side player))])) } count (player nearObjects 320) > 0) exitWith {

	playSound "FD_CP_Not_Clear_F";
	["You are not allowed to OpenParachute near enemy objects!.", 5] call mf_notify_client;

};

private ["_veh", "_push", "_vecDir"];

_veh = vehicle player;
if (_veh == player) exitWith {};

moveOut player;

if (_veh isKindOf "Plane") then
{
	player setDir getDir _veh;
	_push = (vectorUp _veh) vectorMultiply 40; // Simulate rocket seat ejection
}
else
{
	if ((getPos _veh) select 2 > 4) then
	{
		_vecDir = (getPosASL player) vectorDiff (getPosASL _veh);
		_push = _vecDir vectorMultiply (5 / vectorMagnitude _vecDir); // Push 5m/s away from vehicle
	};
};

if (!isNil "_push") then
{
	player setVelocity ((velocity player) vectorAdd _push);
};
