if(isServer) then {

private _player = _this select 0;
private _obj = _this select 1;	


_obj setVariable ["secure_by_flag", nil, true];
_obj setVariable ["non_unlock_mode", nil, true];
_obj setVariable ["is_base_flag_activate", nil, true];
_obj setVariable ["baseSaving_hoursAlive", nil, true];
_obj setVariable ["baseSaving_spawningTime", nil, true];
_obj setVariable ["flag_respawn", nil, true];
_obj EnableSimulationGlobal true;
private _class = typeOf _obj;
if (_class != "Land_Sacks_goods_F" && _class != "Land_BarrelWater_F" && !(_class isKindOf "ReammoBox_F")) then
{ 
	_obj setVariable ["allowDamage", true, true];
	_obj allowDamage true;
	[_obj, true] remoteExec ["allowDamage", -2];
};
_obj setVariable ["objectLocked", false, true];
_obj setVariable ["ownerUID", nil, true];
//detach _obj;
//_obj setVariable ["R3F_LOG_disabled", false, true];
_obj call fn_manualObjectSave;

};