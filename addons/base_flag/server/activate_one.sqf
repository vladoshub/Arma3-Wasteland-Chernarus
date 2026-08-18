if(isServer) then {

private _player = _this select 0;
private _obj = _this select 1;	
private _nonUnlock = _this select 2;
private _friendlyFlag = _this select 3;		

private _isOK = true;

private _countNearObj = ({ (_x getVariable ["secure_by_flag", false]) } count (_friendlyFlag nearObjects 350));

private _isNewer = false;

private _arrDate = _friendlyFlag getVariable "payBuild";

if(!(isNil "_arrDate")) then {
private _sysTime = systemTime;
private _date = [_sysTime select 0, _sysTime select 1, _sysTime select 2, _sysTime select 3, _sysTime select 4];

_isNewer = [_arrDate, _date] call BIS_fnc_isDateTimeNewer;
};

	private	_nearFarFlagsPlayer = _obj nearObjects ["FlagChecked_F", 300];
	private	_nearFarFlagsPlayerFiltered = [];
		{ 
			if ((_x getVariable ["is_base_flag_activate", false]) && ( !((_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID _player) || (_x getVariable ["ownerUID", "0"] in ((units _player) apply {getPlayerUID _x})) || (group _x == group _player) || ((side _x == side _player) && (str(side _player) == "WEST" || str(side _player) == "EAST")) || ((str(side _player) == "WEST" || str(side _player) == "EAST") && (str(side _player)) == (_x getVariable ["LastSide", ""])) ) || ((str(side _player)) != _x getVariable ["LastSide", (str(side _player))])) ) then 
				{
					_nearFarFlagsPlayerFiltered pushBack _x;
				};
		} forEach _nearFarFlagsPlayer;


	if(count _nearFarFlagsPlayerFiltered > 0) then {
		_isOK = false;
	};	

if(_isOK && _countNearObj < 2000) then {
_obj setVariable ["objectLocked", true, true];
_obj setVariable ["ownerUID", getPlayerUID _player, true];
//_obj setVariable ["R3F_LOG_disabled", true, true];
_obj setVariable ["secure_by_flag", true, true];
if(!(_obj isKindOf "land_bunker_garage") && !(_obj isKindOf "Land_i_Garage_V1_F") && (!(_obj isKindOf "StaticWeapon") && !(unitIsUAV _obj)) && (!(_obj isKindOf "Land_ConcreteWall_01_l_gate_F")) && (!(_obj isKindOf "Land_Cargo_Tower_V4_F"))) then {
	_obj EnableSimulationGlobal false;
};
if(!(_obj isKindOf "StaticWeapon") && !(unitIsUAV _obj) && alive _obj && _isNewer) then {
	_obj setVariable ["allowDamage", false, true];
	_obj allowDamage false;
	[_obj, false] remoteExec ["allowDamage", -2];
};
if(_nonUnlock && _isNewer) then {
	_obj setVariable ["non_unlock_mode", true, true];
};

//private _hp = createVehicle ["Land_HelipadEmpty_F", (getPosATL _obj), [], 0, "CAN_COLLIDE"];
//_hp setDir (getDir _obj);
//_obj AttachTo [_hp];
_obj call fn_manualObjectSave;
};

};