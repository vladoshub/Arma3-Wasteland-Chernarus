if(isServer) then {

private _player = _this select 0;
private _flag = _this select 1;	

if(_flag getVariable ["flagsDenyActivate", 0] > serverTime ) exitWith {};

if(serverTime < _flag getVariable ["flag_security_time_activate", 0]) exitWith {};	


if((_flag getVariable ["is_base_flag_activate", false])) then {
	
	private _allObj = _flag nearObjects 350;
	private _filterObj = [];

	{ 
		if ( ((_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID _player) || (_x getVariable ["ownerUID", "0"] in ((units _player) apply {getPlayerUID _x})) || (group _x == group _player) || ((side _x == side _player) && (str(side _player) == "WEST" || str(side _player) == "EAST"))) && (_x getVariable ["secure_by_flag", false]) && (typeOf _x != "FlagChecked_F")) then 
			{
				_filterObj pushBack _x;
			};
	} forEach _allObj;

	{	_x setVariable ["secure_by_flag", nil, true];
		_x setVariable ["non_unlock_mode", nil, true];
		private _class = typeOf _x;
		_x EnableSimulationGlobal true;
		if (_class != "Land_Sacks_goods_F" && _class != "Land_BarrelWater_F" && !(_class isKindOf "ReammoBox_F")) then
		{ 
			_x setVariable ["allowDamage", true, true];
			_x allowDamage true;
			[_x, true] remoteExec ["allowDamage", -2];
		};
		//_x setVariable ["R3F_LOG_disabled", false, true];
		//_x setVariable ["objectLocked", false, true];
		//_x setVariable ["ownerUID", nil, true];
		//_x setVariable ["baseSaving_hoursAlive", nil, true];
		//_x setVariable ["baseSaving_spawningTime", nil, true];
		//detach _x;
		_x call fn_manualObjectSave;
	}
	forEach _filterObj;


	_flag setVariable ["is_base_flag_activate", nil, true];
	//_flag setVariable ["flag_disable_time", (diag_tickTime + (30 * 60)), true];
	_flag setVariable ["non_unlock_mode", nil, true];
	_flag setVariable ["allowDamage", true, true];
	_flag setVariable ["flag_respawn", nil, true];
	//_flag setVariable ["R3F_LOG_disabled", false, true];
	_flag setVariable ["objectLocked", false, true];
	_flag setVariable ["ownerUID", nil, true];
	_flag setVariable ["baseSaving_hoursAlive", nil, true];
	_flag setVariable ["baseSaving_spawningTime", nil, true];
	_flag EnableSimulationGlobal true;
	_flag allowDamage true;
	[_flag, true] remoteExec ["allowDamage", -2];
	//detach _flag;
	_flag call fn_manualObjectSave;

	deleteMarker ("BaseFlagAttack_" + netId _flag);
};
};