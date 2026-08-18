if(isServer) then {

private _player = _this select 0;
private _flag = _this select 1;	

if(_flag getVariable ["flagsDenyActivate", 0] > serverTime ) exitWith {};


private _inCrater = false;
if(count(allMapMarkers)>0) then {
	{
		if(( ["Crater", _x] call fn_startsWith) && ((getmarkerpos _x) distance _flag < 400)) exitWith
		{
			_inCrater = true;
		};
	} forEach allMapMarkers;
};

private _countNearObj = ({ (_x getVariable ["secure_by_flag", false]) } count (_flag nearObjects 350));




private _nearFlags = player nearObjects  ["FlagChecked_F", 4600];
private _nearFlagsCount = ({ _x getVariable ["is_base_flag_activate", false] } count _nearFlags);


if(!(_flag getVariable ["is_base_flag_activate", false]) && !_inCrater && _countNearObj < 200 && _nearFlagsCount == 0 && alive _flag) then {


/*
	private _playerPosATL = getPosATL _player;
	_playerPosATL set [1, (_playerPosATL select 1) + 1];
	private _playerPosATLOffset = _playerPosATL;

	//_flag setVehiclePosition  [_player , [ ] , 0 , "CAN_COLLIDE"];
	_flag setPosASL (getPosASL _player);

	_player setPosATL _playerPosATLOffset;
	*/


	_flag setVariable ["is_base_flag_activate", true, true];
	//_flag setVariable ["R3F_LOG_disabled", true, true];
	_flag setVariable ["allowDamage", false, true];
	//_flag setVariable ["flag_respawn", true, true];
	_flag allowDamage false;
	[_flag, false] remoteExec ["allowDamage", -2];
	_flag setVariable ["objectLocked", true, true];
	_flag setVariable ["ownerUID", getPlayerUID _player, true];

	private _payBuild = _flag getVariable "payBuild";
	
	if(isNil "_payBuild") then {
		private _sysTime = systemTime;
		private _date = [_sysTime select 0, _sysTime select 1, _sysTime select 2, _sysTime select 3, _sysTime select 4];
		_flag setVariable ["payBuild", [_date, 9, "d"] call BIS_fnc_calculateDateTime, true];
	};
	
	_flag setVariable ["non_unlock_mode", true, true];
	_flag setVariable ["flag_security_time_activate", (serverTime + (60 * 60)), true];
	_flag setVariable ["isUpdatePayBuild", true, true];
	//_flag EnableSimulationGlobal  false;

	//private _hp = createVehicle ["Land_HelipadEmpty_F", (getPosATL _flag), [], 0, "CAN_COLLIDE"];
	//_hp setDir (getDir _flag);
	//_flag AttachTo [_hp];

	_flag call fn_manualObjectSave;

	deleteMarker ("BaseFlagAttack_" + netId _flag);

	
	private _arrDate = _flag getVariable "payBuild";

	private _sysTime = systemTime;
	private _date = [_sysTime select 0, _sysTime select 1, _sysTime select 2, _sysTime select 3, _sysTime select 4];

	private _isNewer = [_arrDate, _date] call BIS_fnc_isDateTimeNewer;

	private _allObj = _flag nearObjects 300;
	private _filterObj = [];


	{ 
		if ( ((_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID _player) || (_x getVariable ["ownerUID", "0"] in ((units _player) apply {getPlayerUID _x})) || (group _x == group _player) || ((side _x == side _player) && (str(side _player) == "WEST" || str(side _player) == "EAST"))) && (typeOf _x in Base_flag_obj) && (_x getVariable ["objectLocked", false]) && (typeOf _x != "FlagChecked_F")) then 
			{
				_filterObj pushBack _x;
			};
	} forEach _allObj;

	{	//_x setVariable ["R3F_LOG_disabled", true, true];
		if(_countNearObj >= 2000) exitWith {};
		_x setVariable ["secure_by_flag", true, true];
		if(!(_x isKindOf "land_bunker_garage") && !(_x isKindOf "Land_i_Garage_V1_F") && (!(_x isKindOf "StaticWeapon") && !(unitIsUAV _x)) && (!(_x isKindOf "Land_ConcreteWall_01_l_gate_F")) && (!(_x isKindOf "Land_Cargo_Tower_V4_F"))) then {
			_x EnableSimulationGlobal false;
		};
		if(!(_x isKindOf "StaticWeapon") && !(unitIsUAV _x) && alive _x && _isNewer) then {
			_x setVariable ["allowDamage", false, true];
			_x allowDamage false;
			[_x, false] remoteExec ["allowDamage", -2];
		};
		_x setVariable ["objectLocked", true, true];
		_x setVariable ["ownerUID", getPlayerUID _player, true];
		if(_isNewer) then {
		_x setVariable ["non_unlock_mode", true, true];
		};

		//private _hp = createVehicle ["Land_HelipadEmpty_F", (getPosATL _x), [], 0, "CAN_COLLIDE"];
		//_hp setDir (getDir _x);
		//_x AttachTo [_hp];

		//sleep 0.01;
		_x call fn_manualObjectSave;
		_countNearObj = _countNearObj + 1;
	}
	forEach _filterObj;

};
};