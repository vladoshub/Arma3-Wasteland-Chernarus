
private  ["_safePos"];

// Recover only this spawner's money if the script is restarted.
private _spawnedMoney = (allMissionObjects "Land_Money_F") select {
	_x getVariable ["moneyTownSpawn", false]
};

while {true} do {

	// Clear the previous cycle before spawning in any town, even if money was moved.
	{
		if (!isNull _x) then {
			deleteVehicle _x;
		};
	} forEach _spawnedMoney;
	_spawnedMoney = [];

	{
		private _square = ((markerSize (_x select 0)) select 0) * ((markerSize (_x select 0)) select 1);
		_square = sqrt _square;
		private _pos = markerPos (_x select 0);

		// One 5% roll per town and cycle. A successful roll requests 1-2 piles.
		private _spawnMoney = 0;
		if (random 1 < 0.05) then {
			_spawnMoney = 1 + floor random 2;
		};
		{
		if(_spawnMoney > 0 && (_x getVariable["R3F_LOG_disabled", true]) && !(_x getVariable ["objectLocked", false]) && (_x getVariable ["ownerUID" , "NO"] == "NO") ) then {
			_safePos = [getPos _x , 1, ((sizeOf (typeOf _x)) / 2) + 1 , 1, 0 ,0 , 0] call findSafePos;
			_safePos set [2, 0];
			private _cash = createVehicle ["Land_Money_F", _safePos, [], 5, "None"];
			private _moneyAmount = random [200000, 750000, 2000000];
			_cash setDir random 360;
			_cash setVariable ["cmoney", _moneyAmount, true];
			_cash setVariable ["owner", "world", true];
			_cash setVariable ["moneyTownSpawn", true, true];
			_spawnedMoney pushBack _cash;
			_spawnMoney = _spawnMoney - 1;
		};
		} forEach (_pos nearObjects ["Building", _square]);
	
	} forEach (call cityListLimit);
	sleep (9000 + random [0, 500, 1000]);
};
