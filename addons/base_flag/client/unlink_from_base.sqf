private _flags = player nearObjects  ["FlagChecked_F", 285];


private _friendlyFlags = ({(_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) || (_x getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _x == group player) || ((side _x == side player) && (str(side player) == "WEST" || str(side player) == "EAST"))} count _flags);  //flags friendly

if(_friendlyFlags > 0) then {
	[[player, _this select 0],"Base_flag_srv_disable_one",false,false,false] call BIS_fnc_MP;
} else {
	hint "Not found friendly base!";
	playSound "FD_CP_Not_Clear_F";
};