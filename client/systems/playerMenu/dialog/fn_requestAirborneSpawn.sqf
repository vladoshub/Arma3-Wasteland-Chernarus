#include "respawn_defines.hpp"

params ["_marker"];
disableSerialization;

private _display = uiNamespace getVariable ["RespawnSelectionDialog", displayNull];
if (!respawnDialogActive || {isNull _display} || {!(player getVariable ["airBornSpawn", true])} ||
	{!(ctrlEnabled (_display displayCtrl respawn_Random_Button))}) exitWith {};

([_marker] call fn_getAirborneSpawnState) params ["_blockedByOnline", "_remaining"];
if (_blockedByOnline || {_remaining > 0}) exitWith
{
	if (_blockedByOnline) then
	{
		hint "Blocked";
	}
	else
	{
		hint format ["This point has been blocked since you spawned there. Left: %1 SEC", round _remaining];
	};
	playSound "FD_CP_Not_Clear_F";
};

player setVariable ["airBornSpawn", false];
{
	(_display displayCtrl _x) ctrlEnable false;
} forEach [respawn_Random_Button, Halo_Spawn_Button, respawn_Spawn_Button, respawn_Locations_Type,
	respawn_Locations_List, respawn_Preload_Checkbox, respawn_GroupMgmt_Button, custom_Loadout_Button];

{
	(_x select 0) setMarkerColorLocal "ColorWhite";
} forEach (call spawnList);

[respawn_Spawn_Button, [6, _marker]] execVM "client\functions\spawnAction.sqf";
