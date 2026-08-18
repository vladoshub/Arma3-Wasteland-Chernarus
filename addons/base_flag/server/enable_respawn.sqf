if(isServer) then {
private _player = _this select 0;
private _flag = _this select 1;	

if(_flag getVariable ["is_base_flag_activate", false]) then {
	_flag setVariable ["flag_respawn", true, true];
	_flag setVariable ["non_unlock_mode", false, true];
	_flag setVariable ["flag_security_time_activate", diag_tickTime, true];
	//_flag setVariable ["R3F_LOG_disabled", false, true];
	_flag call fn_manualObjectSave;

	private _allObj = _flag nearObjects 305;
	private _filterObj = [];

	{ 
		if ( ((_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID _player) || (_x getVariable ["ownerUID", "0"] in ((units _player) apply {getPlayerUID _x})) || (group _x == group _player) || ((side _x == side _player) && (str(side _player) == "WEST" || str(side _player) == "EAST"))) && (_x getVariable ["secure_by_flag", false]) ) then 
		{
			_filterObj pushBack _x;
		};
	} forEach _allObj;

	{
		_x setVariable ["non_unlock_mode", false, true];
		//_x setVariable ["R3F_LOG_disabled", false, true];
		_x call fn_manualObjectSave;
	}
	forEach _filterObj;
};

};