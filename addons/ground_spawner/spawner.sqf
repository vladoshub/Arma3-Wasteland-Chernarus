
private ["_weapon", "_mag", "_launchers", "_addition", "_lootholder", "_safePos"];

private _launchers = ["launch_Titan_F", "launch_Titan_short_F", "launch_RPG7_F", "CUP_launch_Metis", "CUP_launch_Javelin", "_newItem"];

while {true} do {




	{
		private _square = ((markerSize (_x select 0)) select 0) * ((markerSize (_x select 0)) select 1);
		_square = sqrt _square;
		private _pos = markerPos (_x select 0);

		{
			private _exp = _x getVariable ["expLootTime", -1];
			if(_exp != -1 && ((serverTime - _exp) > 0)) then {
				deleteVehicle _x;
			};
			
		} forEach (_pos nearObjects ["GroundWeaponHolder", (_square + 100)]);


		private _buildingsCount = ({ _x getVariable["R3F_LOG_disabled", true] && !(_x getVariable ["objectLocked", false]) } count ( (_pos nearObjects ["Building", _square])));

		private _randonWeapon = 0.2;


		if(_buildingsCount < 20) then {
			_randonWeapon = 0.3;
		};

		if(_buildingsCount < 4) then {
			_randonWeapon = 1;
		};


		private _spawnHolders = ( round ({ _x getVariable["R3F_LOG_disabled", true] && !(_x getVariable ["objectLocked", false]) && (_x getVariable ["ownerUID" , "NO"] == "NO") } count ( (_pos nearObjects ["Building", _square])) ) / (round ( 1/ _randonWeapon)) ) - ( ( {_x getVariable ["expLootFlag", false]} count (_pos nearObjects ["GroundWeaponHolder", (_square + 10)]))  );

		if(_spawnHolders > 200) then {
			_spawnHolders = 200;
		};

		{
			if( (_x getVariable["R3F_LOG_disabled", true]) && !(_x getVariable ["objectLocked", false]) && (_x getVariable ["ownerUID" , "NO"] == "NO") && _spawnHolders > 0 && ((random 1) <= _randonWeapon)) then {
				

				_safePos = [getPos _x , 1, ((sizeOf (typeOf _x)) / 2) + 1 , 1, 0 ,0 , 0] call findSafePos;
				_safePos set [2, 0];
				_lootholder = createVehicle ["GroundWeaponHolder", _safePos, [], 0, "NONE"];
				_lootholder setVariable ["expLootTime", serverTime + (2700 + random [0, 100, 300]), true];
				_lootholder setVariable ["expLootFlag", true, true];

				private _magCount = (1 + floor random 3);
				_weapon = vehicleWeapons call fn_selectRandomNested;
				if (_weapon in _launchers && (random 1 < 0.8)) then {
					_weapon = "launch_RPG7_F";
				};

				if (_weapon in _launchers) then {
					_magCount = (1 + floor random 2);
				};
				_mag = ((getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines")) select 0) call getBallMagazine;

				_lootholder addWeaponCargoGlobal [_weapon, 1];
			    _lootholder addMagazineCargoGlobal [_mag, _magCount];

				if((random 1) < 0.35) then {
					_addition = vehicleAddition call fn_selectRandomNested;	
					_lootholder addItemCargoGlobal [_addition, 1];
				};


				if (random 1 < 0.05) then { _lootholder addItemCargoGlobal ["HandGrenade", 1 + floor random 2]};

				if (random 1 < 0.03) then { _lootholder addItemCargoGlobal ["1Rnd_HE_Grenade_shell", 1 + floor random 2]};

				if (random 1 < 0.03) then { 
					_lootholder addItemCargoGlobal ["CUP_1Rnd_HE_M203", 1 + floor random 2];
					_lootholder addItemCargoGlobal ["CUP_1Rnd_HEDP_M203", 1 + floor random 2];
					_lootholder addItemCargoGlobal ["CUP_1Rnd_HE_GP25_M", 1 + floor random 2];
				};


				if (random 1 < 0.05) then { _lootholder addItemCargoGlobal ["NVGoggles", 1]};

				_spawnHolders = _spawnHolders - 1;

			};
			
		} forEach (_pos nearObjects ["Building", _square]);





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


		private _spawnItemsOne = ((round (_square / 30)) - ( ((count (_pos nearObjects ["Land_BakedBeans_F", (_square + 10)]))) )  -  (floor random 3));
		{
			if(_spawnItemsOne > 0 && (_x getVariable["R3F_LOG_disabled", true]) && !(_x getVariable ["objectLocked", false]) && (_x getVariable ["ownerUID" , "NO"] == "NO")) then {
			if(random 1 <= _randonAdditional) then {
			_safePos = [getPos _x , 1, ((sizeOf (typeOf _x)) / 2) + 1 , 1, 0 ,0 , 0] call findSafePos;
			_safePos set [2, 0];
			_newItem = createVehicle ["Land_BakedBeans_F", _safePos, [], 0, "NONE"];
			_newItem setVariable["mf_item_id", "cannedfood", true];

			_spawnItemsOne = _spawnItemsOne - 1;
			};
		};
		} forEach (_pos nearObjects ["Building", _square]);


		private _spawnItemsTwo = ((round (_square / 30)) - ( ((count (_pos nearObjects ["Land_BottlePlastic_V2_F", (_square + 10)]))) )   -  (floor random 3) );
		{
			if(_spawnItemsTwo > 0 && (_x getVariable["R3F_LOG_disabled", true]) && !(_x getVariable ["objectLocked", false]) && (_x getVariable ["ownerUID" , "NO"] == "NO")) then {
			if(random 1 <= _randonAdditional) then {
			_safePos = [getPos _x , 1, ((sizeOf (typeOf _x)) / 2) + 1 , 1, 0 ,0 , 0] call findSafePos;
			_safePos set [2, 0];
			_newItem = createVehicle ["Land_BottlePlastic_V2_F", _safePos, [], 0, "NONE"];
			_newItem setVariable["mf_item_id", "water", true];

			_spawnItemsTwo = _spawnItemsTwo - 1;
			};
		};
		} forEach (_pos nearObjects ["Building", _square]);


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

	
	} forEach (call cityListLimit);
	sleep (600 + random [0, 100, 300]);
};