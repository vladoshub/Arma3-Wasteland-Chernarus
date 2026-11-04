
private ["_weapon", "_mag", "_launchers", "_addition", "_lootholder", "_safePos", "_newItem"];

private _launchers = ["launch_Titan_F", "launch_Titan_short_F", "launch_RPG7_F", "CUP_launch_Metis", "CUP_launch_Javelin", "CUP_launch_RPG7V"];

// Recover this spawner's existing holders if the script is restarted.
private _spawnedWeaponHolders = (allMissionObjects "GroundWeaponHolder") select {
	_x getVariable ["expLootFlag", false]
};

// Recover this spawner's supplies and first-aid holders after a script restart.
private _spawnedGroundItems = [];
{
	_spawnedGroundItems append ((allMissionObjects _x) select {
		_x getVariable ["groundTownItemSpawn", false]
	});
} forEach ["Land_BakedBeans_F", "Land_BottlePlastic_V2_F", "Land_CanisterFuel_F", "Land_Suitcase_F", "GroundWeaponHolder"];

while {true} do {

	// Clear the previous cycle before spawning in any town, even if loot was moved.
	{
		if (!isNull _x) then {
			deleteVehicle _x;
		};
	} forEach (_spawnedWeaponHolders + _spawnedGroundItems);
	_spawnedWeaponHolders = [];
	_spawnedGroundItems = [];

	{
		private _square = ((markerSize (_x select 0)) select 0) * ((markerSize (_x select 0)) select 1);
		_square = sqrt _square;
		private _pos = markerPos (_x select 0);

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
				private _magCount = (1 + floor random 3);
				_weapon = vehicleWeapons call fn_selectVehicleWeapon;

				if (_weapon != "") then {
					_lootholder = createVehicle ["GroundWeaponHolder", _safePos, [], 0, "NONE"];
					_lootholder setVariable ["expLootFlag", true, true];
					_spawnedWeaponHolders pushBack _lootholder;

					if (_weapon in _launchers) then {
						_magCount = (1 + floor random 2);
					};
					_mag = ((getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines")) select 0) call getBallMagazine;

					_lootholder addWeaponCargoGlobal [_weapon, 1];
					_lootholder addMagazineCargoGlobal [_mag, _magCount];
					[_lootholder, _weapon] call A3W_fnc_addWeaponGrenadeAmmo;

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


		private _spawnItemsOne = ((floor random 3) - ( ((count (_pos nearObjects ["Land_BakedBeans_F", (_square + 10)]))) ));
		{
			if(_spawnItemsOne > 0 && (_x getVariable["R3F_LOG_disabled", true]) && !(_x getVariable ["objectLocked", false]) && (_x getVariable ["ownerUID" , "NO"] == "NO")) then {
			if(random 1 <= _randonAdditional) then {
			_safePos = [getPos _x , 1, ((sizeOf (typeOf _x)) / 2) + 1 , 1, 0 ,0 , 0] call findSafePos;
			_safePos set [2, 0];
			_newItem = createVehicle ["Land_BakedBeans_F", _safePos, [], 0, "NONE"];
			_newItem setVariable["mf_item_id", "cannedfood", true];
			_newItem setVariable ["groundTownItemSpawn", true, true];
			_spawnedGroundItems pushBack _newItem;

			_spawnItemsOne = _spawnItemsOne - 1;
			};
		};
		} forEach (_pos nearObjects ["Building", _square]);


		private _spawnItemsTwo = ((floor random 3) - ( ((count (_pos nearObjects ["Land_BottlePlastic_V2_F", (_square + 10)]))) ));
		{
			if(_spawnItemsTwo > 0 && (_x getVariable["R3F_LOG_disabled", true]) && !(_x getVariable ["objectLocked", false]) && (_x getVariable ["ownerUID" , "NO"] == "NO")) then {
			if(random 1 <= _randonAdditional) then {
			_safePos = [getPos _x , 1, ((sizeOf (typeOf _x)) / 2) + 1 , 1, 0 ,0 , 0] call findSafePos;
			_safePos set [2, 0];
			_newItem = createVehicle ["Land_BottlePlastic_V2_F", _safePos, [], 0, "NONE"];
			_newItem setVariable["mf_item_id", "water", true];
			_newItem setVariable ["groundTownItemSpawn", true, true];
			_spawnedGroundItems pushBack _newItem;

			_spawnItemsTwo = _spawnItemsTwo - 1;
			};
		};
		} forEach (_pos nearObjects ["Building", _square]);


		// One independent 10% roll per supply for the entire town, per cycle.
		// On success, spawn one item beside a randomly selected eligible building.
		private _supplyBuildings = (_pos nearObjects ["Building", _square]) select {
			(_x getVariable ["R3F_LOG_disabled", true]) && !(_x getVariable ["objectLocked", false]) && (_x getVariable ["ownerUID", "NO"] == "NO")
		};
		if (count _supplyBuildings > 0) then
		{
			{
				if (random 1 < 0.10) then
				{
					private _itemClass = _x;
					private _building = selectRandom _supplyBuildings;
					_safePos = [getPos _building, 1, ((sizeOf (typeOf _building)) / 2) + 1, 1, 0, 0, 0] call findSafePos;
					_safePos set [2, 0];
					if (_itemClass == "FirstAidKit") then
					{
						_newItem = createVehicle ["GroundWeaponHolder", _safePos, [], 0, "NONE"];
						_newItem addItemCargoGlobal ["FirstAidKit", 1];
					}
					else
					{
						_newItem = createVehicle [_itemClass, _safePos, [], 0, "NONE"];
						private _itemId = if (_itemClass == "Land_CanisterFuel_F") then {"jerrycanfull"} else {"repairkit"};
						_newItem setVariable ["mf_item_id", _itemId, true];
					};
					_newItem setVariable ["groundTownItemSpawn", true, true];
					_spawnedGroundItems pushBack _newItem;
				};
			} forEach ["FirstAidKit", "Land_CanisterFuel_F", "Land_Suitcase_F"];
		};

	
	} forEach (call cityListLimit);
	sleep (600 + random [0, 350, 600]);
};
