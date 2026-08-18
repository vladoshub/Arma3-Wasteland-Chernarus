if(R3F_LOG_mutex_local_verrou) exitWith {
	player globalChat STR_R3F_LOG_mutex_action_en_cours;
};

private["_locking", "_object", "_lockState", "_lockDuration", "_stringEscapePercent", "_iteration", "_unlockDuration", "_totalDuration", "_poiDist", "_poiMarkers", "_checks", "_success", "_isDoor"];

_object = _this select 0;
_lockState = _this select 3;
_isDoor = false;

_totalDuration = 0;
_stringEscapePercent = "%";

switch (_lockState) do
{
	player setVariable ["mutex_net_obj", (netId _object), true];
	case 0: // LOCK
	{
		R3F_LOG_mutex_local_verrou = true;
		_totalDuration = 5;
		private _poiDist = ["A3W_poiObjLockDistance", 100] call getPublicVar;
		private _poiMarkers = allMapMarkers select {markerType _x isEqualTo "Empty" && {[["GenStore","GunStore","VehStore","Mission_","ForestMission_","LandConvoy_","BigBoat_","UltraMission_","BaseCapture_", "UnlockBuildBase"], _x] call fn_startsWith}};

		if ( (({ (getPosASL _object) vectorDistance (ATLtoASL getMarkerPos _x) < _poiDist } count _poiMarkers > 0) || (count (nearestObjects [_object, ["Land_Atm_01_F", "Land_i_Shed_Ind_F", "Land_Pallet_MilBoxes_F", "Land_bags_EP1", "Land_ConcreteWell_02_F", "C_Truck_02_box_F", "Land_ToiletBox_F"], 100]) > 0) ) && ({ (([["UnlockBuildBase"], _x] call fn_startsWith) && ((getPosASL _object) vectorDistance (ATLtoASL getMarkerPos _x) < 400)) } count _poiMarkers == 0)) exitWith //BY VLADOS
		{
				playSound "FD_CP_Not_Clear_F";
				[format ["You are not allowed to lock objects within %1m of stores and mission spawn or other static objects (marked with dots on the map)", _poiDist], 5] call mf_notify_client;
				R3F_LOG_mutex_local_verrou = false;
				player setVariable ["mutex_net_obj", nil, true];
		};


		//private _poiDistTowns = 300;
		//private _poiMarkersTowns = allMapMarkers select {[["Spawn_"], _x] call fn_startsWith};

		if ({ (player inArea _X) } count (allMapMarkers select {[["Spawn_"], _x] call fn_startsWith}) > 0) exitWith //BY VLADOS
		{
			playSound "FD_CP_Not_Clear_F";
			["You are not allowed lock objects inside points", 5] call mf_notify_client;
		};

		/*
		if((count (nearestObjects [player, ["Land_ToiletBox_F"], 50]) > 0)) exitWith {
			playSound "FD_CP_Not_Clear_F";
			[format ["You are not allowed lock objects within %1m Portals points (marked with dots on the map)", 50], 5] call mf_notify_client;
		};
		*/


	if({ (_x getVariable ["objectLocked", false]) && ( (_object distance _x) <= ((sizeOf (typeOf _object)) + 4) ) && ( !( (_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) || (_x getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _x == group player) || ((side _x == side player) && (str(side player) == "WEST" || str(side player) == "EAST")) || ((str(side player) == "WEST" || str(side player) == "EAST") && (str(side player)) == (_x getVariable ["LastSide", ""])) ) || ((str(side player)) != _x getVariable ["LastSide", (str(side player))])) } count (player nearObjects (100)) > 0) exitWith {

			playSound "FD_CP_Not_Clear_F";
			["You are not allowed to lock objects near enemy objects", 5] call mf_notify_client;
			R3F_LOG_mutex_local_verrou = false;
			player setVariable ["mutex_net_obj", nil, true];

	};






		//base_flag addon

		private _nearFarFlagsPlayer = _object nearObjects ["FlagChecked_F", 320];
		private _nearFarFlagsPlayerFiltered = [];
		{ 
			if ((_x getVariable ["is_base_flag_activate", false]) && ( !((_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) || (_x getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _x == group player) || ((side _x == side player) && (str(side player) == "WEST" || str(side player) == "EAST")) || ((str(side player) == "WEST" || str(side player) == "EAST") && (str(side player)) == (_x getVariable ["LastSide", ""])) ) || ((str(side player)) != _x getVariable ["LastSide", (str(side player))])) ) then 
				{
					_nearFarFlagsPlayerFiltered pushBack _x;
				};
		} forEach _nearFarFlagsPlayer;

/*
		if(_object isKindOf "Land_Brana02") then {
			_isDoor = true;
			if ( { _x getVariable ["objectLocked", false] && _x isKindOf "Land_Brana02" } count (_object nearObjects ["Land_Brana02", 650]) > 0 ) exitWith {
				R3F_LOG_mutex_local_verrou = false;
				player setVariable ["mutex_net_obj", nil, true];
				playSound "FD_CP_Not_Clear_F";
				["It is not allowed to install more than 1 door within a radius of 650m", 5] call mf_notify_client;
			};
		};
*/

		if(count _nearFarFlagsPlayerFiltered > 0) exitWith {
			R3F_LOG_mutex_local_verrou = false;
			player setVariable ["mutex_net_obj", nil, true];
			playSound "FD_CP_Not_Clear_F";
			["Prohibited near the enemy base", 5] call mf_notify_client;
		};	

		private _friendlyCount = 0;
		private _enemyCount = 0;

		{
			if (isPlayer _x && alive _x && _x distance _object < 100) then //BY VLADOS
		{
			if ([_x, player] call A3W_fnc_isFriendly) then
			{
				_friendlyCount = _friendlyCount + 1;
			}
			else
			{
				_enemyCount = _enemyCount + 1;
			};
		};
		} forEach playableUnits;

		if (_enemyCount > 0) exitWith //BY VLADOS
		{
			R3F_LOG_mutex_local_verrou = false;
			player setVariable ["mutex_net_obj", nil, true];
			playSound "FD_CP_Not_Clear_F";
			["You are not allowed, the enemy is nearby.", 5] call mf_notify_client;
		};





		_checks =
		{
			private ["_progress", "_object", "_failed", "_text"];
			_progress = _this select 0;
			_object = _this select 1;
			_failed = true;

			switch (true) do
			{
				case (!alive player || player call A3W_fnc_isUnconscious): { _text = "" };
				case (abs((velocity _object) select 0) > 0.3 || abs((velocity _object) select 1) > 0.3 || abs((velocity _object) select 2) > 0.3 || abs(speed _object) > 0.2): { _text = "Don't move" };
				case ((player distance _object) > 30): { _text = "Object is far away" };
				case (doCancelAction): { doCancelAction = false; _text = "Locking cancelled" };
				case (vehicle player != player): { _text = "Action failed! You can't do this in a vehicle" };
				case (!isNull (_object getVariable ["R3F_LOG_est_transporte_par", objNull])): { _text = "Action failed! Somebody moved the object" };
				case (_object getVariable ["objectLocked", false]): { _text = "Somebody else locked it before you" };
				/*case (_isDoor && ( { _x getVariable ["objectLocked", false] && _x isKindOf "Land_Brana02" } count (_object nearObjects ["Land_Brana02", 650]) > 0 )): { _text = "It is not allowed to install more than 1 door within a radius of 650m" };*/
				default
				{
					_failed = false;
					_text = format ["Locking %1%2 complete", floor (_progress * 100), "%"];
				};
			};

			[_failed, _text];
		};

		_success = [_totalDuration, "AinvPknlMstpSlayWrflDnon_medic", _checks, [_object]] call a3w_actions_start;

		if (_success) then
		{

		_poiDist = ["A3W_poiObjLockDistance", 100] call getPublicVar;
		_poiMarkers = allMapMarkers select {markerType _x isEqualTo "Empty" && {[["GenStore","GunStore","VehStore","Mission_","ForestMission_","LandConvoy_","BigBoat_","UltraMission_","BaseCapture_", "UnlockBuildBase"], _x] call fn_startsWith}};

		if (({ (getPosASL _object) vectorDistance (ATLtoASL getMarkerPos _x) < _poiDist } count _poiMarkers > 0) && ({ (([["UnlockBuildBase"], _x] call fn_startsWith) && ((getPosASL _object) vectorDistance (ATLtoASL getMarkerPos _x) < 400)) } count _poiMarkers == 0)) exitWith //BY VLADOS
		{
				playSound "FD_CP_Not_Clear_F";
				[format ["You are not allowed to lock objects within %1m of stores and mission spawns", _poiDist], 5] call mf_notify_client;
				R3F_LOG_mutex_local_verrou = false;
				player setVariable ["mutex_net_obj", nil, true];
		};

		//base_flag addon
		_nearFarFlagsPlayer = _object nearObjects ["FlagChecked_F", 320];
		_nearFarFlagsPlayerFiltered = [];
		{ 
			if ((_x getVariable ["is_base_flag_activate", false]) && (!((_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) || (_x getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _x == group player) || ((side _x == side player) && (str(side player) == "WEST" || str(side player) == "EAST")) || ((str(side player) == "WEST" || str(side player) == "EAST") && (str(side player)) == (_x getVariable ["LastSide", ""])) ) || ((str(side player)) != _x getVariable ["LastSide", (str(side player))])) ) then 
				{
					_nearFarFlagsPlayerFiltered pushBack _x;
				};
		} forEach _nearFarFlagsPlayer;


		if(count _nearFarFlagsPlayerFiltered > 0) exitWith {
			R3F_LOG_mutex_local_verrou = false;
			player setVariable ["mutex_net_obj", nil, true];
			playSound "FD_CP_Not_Clear_F";
			["Prohibited near the enemy base", 5] call mf_notify_client;
		};	





		_friendlyCount = 0;
		_enemyCount = 0;

		{
			if (isPlayer _x && alive _x && _x distance _object < 100) then //BY VLADOS
		{
			if ([_x, player] call A3W_fnc_isFriendly) then
			{
				_friendlyCount = _friendlyCount + 1;
			}
			else
			{
				_enemyCount = _enemyCount + 1;
			};
		};
		} forEach playableUnits;

		if (_enemyCount > 0) exitWith //BY VLADOS
		{
			R3F_LOG_mutex_local_verrou = false;
			player setVariable ["mutex_net_obj", nil, true];
			playSound "FD_CP_Not_Clear_F";
			["You are not allowed, the enemy is nearby.", 5] call mf_notify_client;
		};













			//base_flag addon
			private _nearFlags = _object nearObjects  ["FlagChecked_F", 300];
			private _friendlyFlags = [];
			{ 
				if (((str(side player)) == (_object getVariable ["LastSide", (str(side player))])) && ((_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) || (_x getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _x == group player) || ((side _x == side player) && (str(side player) == "WEST" || str(side player) == "EAST")) || ((str(side player) == "WEST" || str(side player) == "EAST") && (str(side player)) == (_x getVariable ["LastSide", ""]))) ) then 
					{
						_friendlyFlags pushBack _x;
					};
			} forEach _nearFlags;

			private _nearFlagsCount = ({ _x getVariable ["is_base_flag_activate", false] } count _friendlyFlags); 
			private _nearFlagsCountNonUnlock = ({( _x getVariable ["is_base_flag_activate", false]) && (_x getVariable ["non_unlock_mode", false])} count _friendlyFlags); 

			private _useNonUnlock = true;
			/*
			if(_nearFlagsCountNonUnlock > 0) then {
				_useNonUnlock = true;
			};
			*/

			if(_nearFlagsCount == 0 && _isDoor) exitWith {
				R3F_LOG_mutex_local_verrou = false;
				player setVariable ["mutex_net_obj", nil, true];
				playSound "FD_CP_Not_Clear_F";
				["The door can only be placed with a friendly flag.", 5] call mf_notify_client;
			};


			if(_nearFlagsCount == 1 && ((typeOf _object) in Base_flag_obj) && ((typeOf _object) != "FlagChecked_F")) then {
				private _countNearObj = ({ (_x getVariable ["secure_by_flag", false]) } count ((_friendlyFlags select 0) nearObjects 350));
				if (_countNearObj < 2000) then {
					[[player, _object, _useNonUnlock, _friendlyFlags select 0],"Base_flag_srv_activate_one",false,false,false] call BIS_fnc_MP;
				} else {
					_object setVariable ["objectLocked", true, true];
					_object setVariable ["ownerUID", getPlayerUID player, true];

					pvar_manualObjectSave = netId _object;
					publicVariableServer "pvar_manualObjectSave";
				};
			} else {

				_object setVariable ["objectLocked", true, true];
				_object setVariable ["ownerUID", getPlayerUID player, true];

				pvar_manualObjectSave = netId _object;
				publicVariableServer "pvar_manualObjectSave";
			};

			["Object locked!", 5] call mf_notify_client;
		};

		R3F_LOG_mutex_local_verrou = false;

	};
	case 1: // UNLOCK
	{
		R3F_LOG_mutex_local_verrou = true;
		private _mags = magazines player;


		if(_object isKindOf "FlagChecked_F" && (serverTime < _object getVariable ["flag_security_time_activate", 0])) exitWith {
			R3F_LOG_mutex_local_verrou = false;
			player setVariable ["mutex_net_obj", nil, true];
			playSound "FD_CP_Not_Clear_F";
			["it's not available after activate flag (1h)", 5] call mf_notify_client;
		};	


		private _nearFlagsNonUnlock = _object nearObjects  ["FlagChecked_F", 310];
		private _flagsNonUnlock = [];
		{ 
			if  (_x getVariable ["non_unlock_mode", false]  ) then 
				{
					_flagsNonUnlock pushBack _x;
				};
		} forEach _nearFlagsNonUnlock;



			//Not unlock obj											//near flag			//not flag
		if(_object getVariable ["non_unlock_mode", false] && count _flagsNonUnlock > 0 && !(_object isKindOf "FlagChecked_F")) exitWith {
			R3F_LOG_mutex_local_verrou = false;
			player setVariable ["mutex_net_obj", nil, true];
			playSound "FD_CP_Not_Clear_F";
			["Cant unlock this object!", 5] call mf_notify_client;
		};

		private _objIsFriendlyNotYour = false;
		if ( !(_object getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) && ((_object getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _object == group player) || ((side _object == side player) && (str(side player) == "WEST" || str(side player) == "EAST")) || ((str(side player) == "WEST" || str(side player) == "EAST") && (str(side player)) == (_object getVariable ["LastSide", ""]))) && ((str(side player)) == (_object getVariable ["LastSide", (str(side player))])) ) then {
			_objIsFriendlyNotYour = true;
		};

			//Not unlock obj								       //in area flags				//friendly				//flag
		if(_object getVariable ["non_unlock_mode", false] && count _flagsNonUnlock > 0 && _objIsFriendlyNotYour  && (_object isKindOf "FlagChecked_F")) exitWith {
			R3F_LOG_mutex_local_verrou = false;
			player setVariable ["mutex_net_obj", nil, true];
			playSound "FD_CP_Not_Clear_F";
			["Cant unlock this friendly object!", 5] call mf_notify_client;
		};	

		
		private _currentOnline = count allPlayers;

		private _secPerPerson = 15;

		if(_currentOnline > 6) then {
			_secPerPerson = 15;
		};

		if(_currentOnline > 12) then {
			_secPerPerson = 15;
		};

		private _baseUnlockTime = 300;

		private _calculateSec = _baseUnlockTime - (_secPerPerson * _currentOnline) max 15;
		private _calculateSecKeys = floor (_calculateSec / 2) max 8;


		if ("Keys" in _mags) then {
			_totalDuration = if (_object getVariable ["ownerUID", ""] == getPlayerUID player) then { 2 } else { _calculateSecKeys }; // Allow owner to unlock quickly
		} else {
			_totalDuration = if (_object getVariable ["ownerUID", ""] == getPlayerUID player) then { 10 } else { _calculateSec }; // Allow owner to unlock quickly BY_VLADOS
		};



		if(_object isKindOf "FlagChecked_F") then {
			if ("Keys" in _mags) then {
				_totalDuration = 90;
			} else {
				_totalDuration = 180;
			};
		};

		_checks =
		{
			private ["_progress", "_object", "_failed", "_text"];
			_progress = _this select 0;
			_object = _this select 1;
			_failed = true;

			private _enemyCount = 0;
			private _friendlyCount = 0;

			{
				if (isPlayer _x && alive _x && _x distance _object < 100) then
				{
					if ([_x, player] call A3W_fnc_isFriendly) then
					{
						_friendlyCount = _friendlyCount + 1;
					}
					else
					{
						_enemyCount = _enemyCount + 1;
					};
				};
			} forEach playableUnits;

			switch (true) do
			{
				case (!alive player || player call A3W_fnc_isUnconscious): {};
				case (doCancelAction): { doCancelAction = false; _text = "Unlocking cancelled" };
				case (abs((velocity _object) select 0) > 0.3 || abs((velocity _object) select 1) > 0.3 || abs((velocity _object) select 2) > 0.3 || abs(speed _object) > 0.2): { _text = "Don't move" };
				case ((player distance _object) > 30): { _text = "Object is far away" };
				case (vehicle player != player): { _text = "Action failed! You can't do this in a vehicle" };
				case (!isNull (_object getVariable ["R3F_LOG_est_transporte_par", objNull])): { _text = "Action failed! Somebody moved the object" };
				case !(_object getVariable ["objectLocked", false]): { _text = "Somebody else unlocked it before you" };
				case (_enemyCount > 0 && (_object getVariable ["ownerUID", ""] != getPlayerUID player) ): { _text = "Cant unlock enemy object when somebody near" };
				default
				{
					_failed = false;
					_text = format ["Unlocking %1%2 complete, for fast unlock (2x) use 'Keys' item from the Gen Store. The speed depends on the current player online", floor (_progress * 100), "%"];
				};
			};

			[_failed, _text];
		};

		_success = [_totalDuration, "AinvPknlMstpSlayWrflDnon_medic", _checks, [_object]] call a3w_actions_start;

		if (_success) then
		{
			//base_flag addon
			if(_object getVariable ["secure_by_flag", false] || (_object isKindOf "FlagChecked_F" && _object getVariable ["is_base_flag_activate", false])) then {
				if(_object isKindOf "FlagChecked_F") then {
					[[player, _object],"Base_flag_srv_disable",false,false,false] call BIS_fnc_MP;
				} else {
					[[player, _object],"Base_flag_srv_disable_one",false,false,false] call BIS_fnc_MP;
				};
			} else {
				_object setVariable ["objectLocked", false, true];
				_object setVariable ["ownerUID", nil, true];
				_object setVariable ["baseSaving_hoursAlive", nil, true];
				_object setVariable ["baseSaving_spawningTime", nil, true];
				pvar_manualObjectSave = netId _object;
				publicVariableServer "pvar_manualObjectSave";
	
			};

			["Object unlocked!", 5] call mf_notify_client;
		};

		R3F_LOG_mutex_local_verrou = false;
		player setVariable ["mutex_net_obj", nil, true];

		
	};
	default
	{
		player setVariable ["mutex_net_obj", nil, true];
		diag_log format["WASTELAND DEBUG: An error has occured in LockStateMachine.sqf. _lockState was unknown. _lockState actual: %1", _lockState];
	};
};

if (R3F_LOG_mutex_local_verrou) then {
	R3F_LOG_mutex_local_verrou = false;
	player setVariable ["mutex_net_obj", nil, true];
	diag_log format["WASTELAND DEBUG: An error has occured in LockStateMachine.sqf. Mutex lock was not reset. Mutex lock state actual: %1", R3F_LOG_mutex_local_verrou];
};
