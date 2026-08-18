// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************

// Parameters passed by the action
params ["_target", "", "", "_params"];
_params params ["_action"];

////////////////////////////////////////////////
// Handle actions
////////////////////////////////////////////////

switch (toLower _action) do
{

	case "action_revive":
	{
		if({ (_x getVariable ["objectLocked", false]) && ( !( (_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) || (_x getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _x == group player) || ((side _x == side player) && (str(side player) == "WEST" || str(side player) == "EAST")) || ((str(side player) == "WEST" || str(side player) == "EAST") && (str(side player)) == (_x getVariable ["LastSide", ""])) ) || ((str(side player)) != _x getVariable ["LastSide", (str(side player))])) } count (player nearObjects 15) > 0) exitWith {
			playSound "FD_CP_Not_Clear_F";
			["You are not allowed to revive near enemy objects!.", 5] call mf_notify_client;
		};

		[call FAR_FindTarget, _target] spawn FAR_HandleRevive;
	};

	case "action_stabilize":
	{
		[call FAR_FindTarget, _target] spawn FAR_HandleStabilize;
	};

	case "action_suicide":
	{
		player setDamage 1;
	};

	case "action_drag":
	{
		[call FAR_FindTarget] spawn FAR_Drag;
	};

	case "action_release":
	{
		[] spawn FAR_Release;
	};

	case "action_slay":
	{
		call FAR_Slay_Target;
	};

	case "action_load":
	{
		[] call FAR_Drag_Load_Vehicle;
	};

	case "action_eject":
	{
		[] call FAR_Eject_Injured;
	};
};
