// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_inGameUIActionEvent.sqf
//	@file Author: AgentRev

params ["_target", "_unit", "", "_action", "","", "_showWindow", "","", "_menuOpen"];
private _handled = false;

if (_unit == player && (_showWindow || _menuOpen)) then
{
	switch (true) do
	{
		case (_handled): {};

		case (_action == "UseMagazine" || _action == "UseContainerMagazine"): // placed explosive
		{
			_minDist = ["A3W_remoteBombStoreRadius", 100] call getPublicVar;
			if (_minDist <= 0) exitWith {};

			_nearbyStores = entities "CAManBase" select {_x getVariable ["storeNPC_setupComplete", false] && {player distance _x < _minDist}};

			if !(_nearbyStores isEqualTo []) exitWith
			{
				playSound "FD_CP_Not_Clear_F";
				[format ["You are not allowed to place explosives within %1m of a store.", _minDist], 5] call mf_notify_client;
				_handled = true;
			};
			
			{
				if ((typeof _x) in ["Land_Carrier_01_base_F", "Land_Destroyer_01_base_F"]) exitWith {
					playSound "FD_CP_Not_Clear_F";
					[format ["You are not allowed to place explosives on a carrier.", _minDist], 5] call mf_notify_client;
					_handled = true;
				}
			} forEach (lineIntersectsWith [getPosWorld player, getPosWorld player vectorAdd [0, 0, 50], player, objNull]);

			_nearbyMissions = allMapMarkers select {markerType _x == "Empty" && {[["Mission_","ForestMission_","LandConvoy_"], _x] call fn_startsWith && {player distance markerPos _x < _minDist}}};

			if !(_nearbyMissions isEqualTo []) exitWith
			{
				playSound "FD_CP_Not_Clear_F";
				[format ["You are not allowed to place explosives within %1m of a mission spawn.", _minDist], 5] call mf_notify_client;
				_handled = true;
			};

			_nearbyParking = allMapMarkers select {markerType _x == "Empty" && {["Parking", _x] call fn_startsWith && {player distance markerPos _x < _minDist}}};

			if !(_nearbyParking isEqualTo []) exitWith
			{
				playSound "FD_CP_Not_Clear_F";
				[format ["You are not allowed to place explosives within %1m of a parking location.", _minDist], 5] call mf_notify_client;
				_handled = true;
			};

			_nearbyStorage = nearestObjects [player, ["Land_PaperBox_open_full_F", "Land_Pallet_MilBoxes_F", "Land_PaperBox_open_empty_F", "Land_PaperBox_closed_F"], _minDist] select {_x getVariable ["is_storage", false]};

			if !(_nearbyStorage isEqualTo []) exitWith
			{
				playSound "FD_CP_Not_Clear_F";
				[format ["You are not allowed to place explosives within %1m of a storage location.", _minDist], 5] call mf_notify_client;
				_handled = true;
			};
		};

		// now done via enableWeaponDisassembly in vehicleSetup.sqf
		case (_action == "DisAssemble" && {unitIsUAV _target && !((_target getVariable ["ownerUID",""]) in ["", getPlayerUID player])} ):
		{
			playSound "FD_CP_Not_Clear_F";
			//["You are not allowed to disassemble other players' drones.", 5] call mf_notify_client;
			["You are not allowed to disassemble.", 5] call mf_notify_client;
			_handled = true;
		};

		case (_action == "DisAssemble" && _target isKindOf "StaticWeapon"):
		{
			playSound "FD_CP_Not_Clear_F";
			//["You are not allowed to disassemble other players' drones.", 5] call mf_notify_client;
			["You are not allowed to disassemble.", 5] call mf_notify_client;
			_handled = true;
		};

	
		case (["Getin", _action] call fn_startsWith && (!(canMove _target) || _target isKindOf "StaticWeapon" || (fuel _target == 0)) && ({ (_x getVariable ["objectLocked", false] && _x getVariable ["is_base_flag_activate", false] && ((player distance _x) <= (((sizeOf (typeOf _x)) /2) + 1) ) ) && ( !( (_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) || (_x getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _x == group player) || ((side _x == side player) && (str(side player) == "WEST" || str(side player) == "EAST")) || ((str(side player) == "WEST" || str(side player) == "EAST") && (str(side player)) == (_x getVariable ["LastSide", ""])) ) || ((str(side player)) != _x getVariable ["LastSide", (str(side player))]) )} count (player nearObjects (320 + sizeOf (typeOf _target))) > 0)):
		{
			playSound "FD_CP_Not_Clear_F";
			["You are not allowed to GetIn near enemy objects when vehicle is not movable!.", 5] call mf_notify_client;
			_handled = true;
		}; 
		

		case (_action == "GetOut" && { (_x getVariable ["objectLocked", false] && _x getVariable ["is_base_flag_activate", false] && ((player distance _x) <= (((sizeOf (typeOf _x)) /2) + 1) ) ) && ( !( (_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) || (_x getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _x == group player) || ((side _x == side player) && (str(side player) == "WEST" || str(side player) == "EAST")) || ((str(side player) == "WEST" || str(side player) == "EAST") && (str(side player)) == (_x getVariable ["LastSide", ""])) ) || ((str(side player)) != _x getVariable ["LastSide", (str(side player))])) } count (player nearObjects (320 + sizeOf (typeOf _target))) > 0):
		{
			playSound "FD_CP_Not_Clear_F";
			["You are not allowed to GetOut near enemy objects!.", 5] call mf_notify_client;
			_handled = true;
		};

		case (_action == "Eject" && { (_x getVariable ["objectLocked", false] && _x getVariable ["is_base_flag_activate", false] && ((player distance _x) <= (((sizeOf (typeOf _x)) /2) + 1) ) ) && ( !( (_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) || (_x getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _x == group player) || ((side _x == side player) && (str(side player) == "WEST" || str(side player) == "EAST")) || ((str(side player) == "WEST" || str(side player) == "EAST") && (str(side player)) == (_x getVariable ["LastSide", ""])) ) || ((str(side player)) != _x getVariable ["LastSide", (str(side player))])) } count (player nearObjects (320 + sizeOf (typeOf _target))) > 0):
		{
			playSound "FD_CP_Not_Clear_F";
			["You are not allowed to Eject near enemy objects!.", 5] call mf_notify_client;
			_handled = true;
		};


		case (_action == "ManualFire"): // use UAV AI to re-align attack heli turret with pilot crosshair when manual fire is enabled with no gunner (thx KK xoxoxo)
		{
			private _veh = vehicle player;

			if ({_veh isKindOf _x} count ["Heli_Attack_01_base_F","Heli_Attack_02_base_F","VTOL_02_base_F"] > 0 && isNull gunner _veh) then
			{
				private _class = format ["%1_UAV_AI", ["B","O","I"] select (([BLUFOR,OPFOR,INDEPENDENT] find playerSide) max 0)];
				private _bob = createAgent [_class, _veh, [], 0, "NONE"];

				_bob allowDamage false;
				_bob setVariable ["A3W_driverAssistOwner", player, true];
				_bob setName ["","",""];
				[_bob, ["","",""]] remoteExec ["A3W_fnc_setName"];
				_bob moveInGunner _veh;

				private _turretCfg = ([_veh, configNull] call BIS_fnc_getTurrets) param [1, configNull];
				private _rotH = getText (_turretCfg >> "animationSourceBody");
				private _rotV = getText (_turretCfg >> "animationSourceGun");

				[_veh, _bob, _rotH, _rotV] spawn
				{
					params ["_veh", "_bob", "_rotH", "_rotV"];
					_time = time;
					waitUntil {_bob doWatch objNull; (abs (_veh animationSourcePhase _rotH) < 0.001 && abs (_veh animationSourcePhase _rotV) < 0.001) || time - _time > 10};
					deleteVehicle _bob;
				};
			};
		};
		
		case (_target isKindOf "UGV_02_Base_F" && _action == "MoveToTurret"): // Block glitched "To Gunner's seat" action on Demining UGV
		{
			_handled = true;
		};

		case (_action == "HealSoldierSelf" && [player, "FirstAidKit", true] call BIS_fnc_hasItem):
		{
			[] execVM "addons\scripts\healSelf.sqf";
			_handled = true;
		};

		case (_action select [0,5] == "GetIn"): // Speed up get in vehicle animation since player unit appears idle for other players
		{
			0 spawn
			{
				scopeName "getInCheck";
				_time = time;

				waitUntil
				{
					if ((toLower animationState player) find "getin" != -1) exitWith
					{
						player setAnimSpeedCoef 2;
						true
					};

					if (time - _time >= 3) then
					{
						breakOut "getInCheck";
					};

					false
				};

				_time = diag_tickTime;

				waitUntil {(toLower animationState player) find "getin" == -1 || diag_tickTime - _time >= 1};

				player setAnimSpeedCoef 1;
			};
		};

		/*
		case ((_action == "MoveToGunner" || _action == "MoveToCommander")):
		{
			sleep 2;
			private _localVeh = objectParent player;
			if (alive _localVeh && !alive driver _localVeh && {effectiveCommander _localVeh == player && player in [gunner _localVeh, commander _localVeh] && {_localVeh isKindOf _x} count ['LandVehicle','Ship'] > 0 && !(_localVeh isKindOf 'StaticWeapon')}) then {
				
				if (!alive _localVeh || alive driver _localVeh || effectiveCommander _localVeh != player) exitWith {};

				private _localClass = format ["%1_UAV_AI", ["B","O","I"] select (([BLUFOR,OPFOR,INDEPENDENT] find playerSide) max 0)];
				private _ai = createAgent [_localClass, _localVeh, [], 0, "NONE"];

				_ai allowDamage false;
				_ai setVariable ["A3W_driverAssistOwner", player, true];
				[_ai, ["Autodrive","",""]] remoteExec ["A3W_fnc_setName", 0, _ai];
				_ai moveInDriver _localVeh;

				[_localVeh, _ai] spawn
				{
					params ["_localVeh", "_ai"];

					_localTime = time;
					waitUntil {local _localVeh || time - _localTime > 3};

					if (driver _localVeh != _ai) exitWith {};

					["lockDriver", netId _localVeh] call A3W_fnc_towingHelper;
				};

			};
		};
		*/
		


	};
};

if (!_handled && !isNil "A3W_fnc_stickyCharges_actionEvent") then
{
	_handled = _this call A3W_fnc_stickyCharges_actionEvent;
};

_handled
