
if(isServer) then {
	private _flag = _this select 0;	
	private _sysTime = systemTime;
	private _date = [_sysTime select 0, _sysTime select 1, _sysTime select 2, _sysTime select 3, _sysTime select 4];
	_flag setVariable ["payBuild", [_date, 9, "d"] call BIS_fnc_calculateDateTime, true];
	_flag setVariable ["isUpdatePayBuild", true, true];
	_flag call fn_manualObjectSave;

	private _allObj = _flag nearObjects 300;
	private _filterObj = [];

	{ 
		if ((_x getVariable ["secure_by_flag", false])) then 
			{
				_filterObj pushBack _x;
			};
	} forEach _allObj;

	{	
		if(!(_x isKindOf "StaticWeapon") && !(unitIsUAV _x) && alive _x) then {
			_x setVariable ["allowDamage", false, true];
			_x allowDamage false;
			[_x, false] remoteExec ["allowDamage", -2];
		};

		_x setVariable ["non_unlock_mode", true, true];

		_x call fn_manualObjectSave;
	}
	forEach _filterObj;

};