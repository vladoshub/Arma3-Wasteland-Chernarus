private _object = _this select 0;
private _objIsFriendlyNotYour = false;
if ( !(_object getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) && ((_object getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _object == group player) || ((side _object == side player) && (str(side player) == "WEST" || str(side player) == "EAST")) || ((str(side player) == "WEST" || str(side player) == "EAST") && (str(side player)) == (_object getVariable ["LastSide", ""]))) && ((str(side player)) == _object getVariable ["LastSide", (str(side player))]) ) then {
	_objIsFriendlyNotYour = true;
};

if(!_objIsFriendlyNotYour) then {
	_object setVariable ["flag_respawn", false, true];
	//_object setVariable ["diable_flag_wait", serverTime + (60 * 60), true];
	pvar_manualObjectSave = netId _object;
	publicVariableServer "pvar_manualObjectSave";
	
} else {
	hint "You are not the owner or this flag's spawn was recently disabled!";
	playSound "FD_CP_Not_Clear_F";
};