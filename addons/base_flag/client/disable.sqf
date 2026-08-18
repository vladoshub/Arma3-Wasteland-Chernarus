private _flag = _this select 0;


if((_this select 0) getVariable ["flagsDenyActivate", 0] > serverTime ) exitWith {
	hint "You cannot disable a flag when flag is attacked";
	playSound "FD_CP_Not_Clear_F";
};

if((_flag getVariable ["ownerUID", 0]) == getPlayerUID player) then {
	[[player, _this select 0],"Base_flag_srv_disable",false,false,false] call BIS_fnc_MP;
} else {
	hint "You are not the owner!";
	playSound "FD_CP_Not_Clear_F";
};