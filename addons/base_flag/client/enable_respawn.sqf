private _timer = (_this select 0) getVariable ["flag_security_time_activate", 0];
if(diag_tickTime >= _timer) then {
	[[player, _this select 0],"Base_flag_srv_enable_respawn",false,false,false] call BIS_fnc_MP;
} else {
	hint format["You can't yet. Wait: %1 Seconds", diag_tickTime - _timer];
	playSound "FD_CP_Not_Clear_F";
};