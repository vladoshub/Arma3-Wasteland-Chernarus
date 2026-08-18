
private  ["_safePos"];


while {true} do {

	{
		private _square = ((markerSize (_x select 0)) select 0) * ((markerSize (_x select 0)) select 1);
		_square = sqrt _square;
		private _pos = markerPos (_x select 0);

		//money
		private _spawnMoney = floor random 3 - (({(_x getVariable ["moneyTownSpawn" , false])}  count (_pos nearObjects ["Land_Money_F", (_square + 100)])));
		{
		if(_spawnMoney > 0 && (_x getVariable["R3F_LOG_disabled", true]) && !(_x getVariable ["objectLocked", false]) && (_x getVariable ["ownerUID" , "NO"] == "NO") ) then {
			if(random 1 < 0.05) then {
			_safePos = [getPos _x , 1, ((sizeOf (typeOf _x)) / 2) + 1 , 1, 0 ,0 , 0] call findSafePos;
			_safePos set [2, 0];
			private _cash = createVehicle ["Land_Money_F", _safePos, [], 5, "None"];
			private _moneyAmount = random [25000, 50000, 200000];
			_cash setDir random 360;
			_cash setVariable ["cmoney", _moneyAmount, true];
			_cash setVariable ["owner", "world", true];
			};
			_spawnMoney = _spawnMoney - 1;
		};
		} forEach (_pos nearObjects ["Building", _square]);
	
	} forEach (call cityListLimit);
	sleep (3000 +random [0, 300, 600]);
};