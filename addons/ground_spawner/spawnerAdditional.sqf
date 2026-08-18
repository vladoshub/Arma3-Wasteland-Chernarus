
private ["_weapon", "_mag", "_launchers", "_addition", "_lootholder", "_safePos"];


while {true} do {




	{
		private _square = ((markerSize (_x select 0)) select 0) * ((markerSize (_x select 0)) select 1);
		_square = sqrt _square;
		private _pos = markerPos (_x select 0);
		private _buildingsCount = ({ _x getVariable["R3F_LOG_disabled", true] && !(_x getVariable ["objectLocked", false]) } count ( (_pos nearObjects ["Building", _square])));
		private _randonAdditional = 0.1;

		if(_buildingsCount < 30) then {
			_randonAdditional = 0.15;
		};

		if(_buildingsCount < 20) then {
			_randonAdditional = 0.2;
		};

		if(_buildingsCount < 10) then {
			_randonAdditional = 0.5;
		};


		if(_buildingsCount < 7) then {
			_randonAdditional = 1;
		};



		if(random 1 <= 0.15) then {
		private _spawnItemsThree = floor random 2 - ( ((count (_pos nearObjects ["Land_CanisterFuel_F", (_square + 10)]))) );
		{
			if(_spawnItemsThree > 0 && (_x getVariable["R3F_LOG_disabled", true]) && !(_x getVariable ["objectLocked", false]) && (_x getVariable ["ownerUID" , "NO"] == "NO")) then {
			if(random 1 <= _randonAdditional) then {
			_safePos = [getPos _x , 1, ((sizeOf (typeOf _x)) / 2) + 1 , 1, 0 ,0 , 0] call findSafePos;
			_safePos set [2, 0];
			_newItem = createVehicle ["Land_CanisterFuel_F", _safePos, [], 0, "NONE"];
			_newItem setVariable["mf_item_id", "jerrycanfull", true];

			_spawnItemsThree = _spawnItemsThree - 1;
			};
		};
		} forEach (_pos nearObjects ["Building", _square]);
		};


		if(random 1 <= 0.15) then {
		private _spawnItemsFour = floor random 2 - ( ((count (_pos nearObjects ["Land_Suitcase_F", (_square + 10)]))) );
		{
			if(_spawnItemsFour > 0 && (_x getVariable["R3F_LOG_disabled", true]) && !(_x getVariable ["objectLocked", false]) && (_x getVariable ["ownerUID" , "NO"] == "NO")) then {
			if(random 1 <= _randonAdditional) then {
			_safePos = [getPos _x , 1, ((sizeOf (typeOf _x)) / 2) + 1 , 1, 0 ,0 , 0] call findSafePos;
			_safePos set [2, 0];
			_newItem = createVehicle ["Land_Suitcase_F", _safePos, [], 0, "NONE"];
			_newItem setVariable["mf_item_id", "repairkit", true];

			_spawnItemsFour = _spawnItemsFour - 1;
			};
		};
		} forEach (_pos nearObjects ["Building", _square]);
		};

	
	} forEach (call cityListLimit);
	sleep (1800 + random [0, 100, 300]);
};