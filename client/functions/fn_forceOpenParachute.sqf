// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_forceOpenParachute.sqf
//	@file Author: AgentRev

if (!alive player || vehicle player != player) exitWith {};

A3W_openParachuteTimestamp = diag_tickTime;

private _wait = false;
private _pos = getPosATL player;
private "_para";


if({ (_x getVariable ["objectLocked", false]) && ( !( (_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) || (_x getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _x == group player) || ((side _x == side player) && (str(side player) == "WEST" || str(side player) == "EAST")) || ((str(side player) == "WEST" || str(side player) == "EAST") && (str(side player)) == (_x getVariable ["LastSide", ""])) ) || ((str(side player)) != _x getVariable ["LastSide", (str(side player))]))} count (player nearObjects 10) > 0) exitWith {

	playSound "FD_CP_Not_Clear_F";
	["You are not allowed to OpenParachute near enemy objects!.", 5] call mf_notify_client;

};

// Under 10m, use non-steerable parachute
if (_pos select 2 < 10) then
{
	_para = createVehicle ["NonSteerable_Parachute_F", _pos, [], 0, "FLY"]; //FLY //CAN_COLLIDE
	_para setPosATL _pos;
	_para setDir 0; // non-steerable parachutes always orient toward North due to engine bug
}
else
{
	_wait = true;
	_para = createVehicle ["Steerable_Parachute_F", _pos, [], 0, "CAN_COLLIDE"];
	_para setDir getDir player;
};

_para disableCollisionWith player;
player moveInDriver _para;
_para setVelocity [0,0,0];

[_para, _wait, diag_tickTime] spawn
{
	params ["_para", "_wait", "_startTime"];

	if (vehicle player == _para && animationState player != "para_pilot") then
	{
		[player, "para_pilot"] call switchMoveGlobal;
	};

	sleep (([0.5, 4.25] select _wait) - (diag_tickTime - _startTime)); // 4.25 = parachute deployment time
	waitUntil {isTouchingGround _para || !alive _para};

	if (!isNull _para) then
	{
		_para setVelocity [0,0,0];
		sleep 0.5;
		if (vehicle player == _para) then { moveOut player };
		sleep 1.5;
		deleteVehicle _para;
	};
};
