//	@file Name: use.sqf
//	@file Author: Leon

if (!alive player) exitWith {};
if !(player call A3W_fnc_isUnconscious) exitWith {};
if (((player getVariable "mf_inventory_list") select {(_x select 0) == "defibrillator"}) select 0 select 1 == 0) exitWith {
	playSound "FD_CP_Not_Clear_F";
	["You dont have defibrillator.", 5] call mf_notify_client;
};


if({ (_x getVariable ["objectLocked", false]) && ( !( (_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) || (_x getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _x == group player) || ((side _x == side player) && (str(side player) == "WEST" || str(side player) == "EAST")) || ((str(side player) == "WEST" || str(side player) == "EAST") && (str(side player)) == (_x getVariable ["LastSide", ""])) ) || ((str(side player)) != _x getVariable ["LastSide", (str(side player))]))  } count (player nearObjects 10) > 0) exitWith {

	playSound "FD_CP_Not_Clear_F";
	["You are not allowed to use near enemy objects!.", 5] call mf_notify_client;

};

_getPublicVar = if (!isNil "getPublicVar") then { getPublicVar } else { missionNamespace getVariable "getPublicVar" };

_abortDelay = ["A3W_combatAbortDelay", 0] call _getPublicVar;

_preventAbort =
{
	_timeStamp = ["combatTimestamp", -1] call _getPublicVar;
	(_timeStamp != -1 && (diag_tickTime - _timeStamp) < _abortDelay)
};

if (!(call _preventAbort)) then
{

	if (["Are you sure you want to use defibrillator?", "Confirm", true, true] call BIS_fnc_guiMessage) then
		{
			player setVariable ["FAR_isUnconscious", 0, true];
			player setVariable ["killOnBaseFlag", nil];
			//player setVariable ["mutex_net_obj", nil, true];
			["You bring back yourself from dead", 5] call mf_notify_client;
    		["defibrillator", 1] call mf_inventory_remove;
			player setDamage 0.5;
		};
} else {

	private _timeStampLocal = ["combatTimestamp", -1] call _getPublicVar;

	private _left = (_abortDelay - (diag_tickTime - _timeStampLocal));


	[format ["Cannot use in combat! Wait. LEFT %1 SEC", round (_left)], 5] call mf_notify_client;
	playSound "FD_CP_Not_Clear_F";
};
