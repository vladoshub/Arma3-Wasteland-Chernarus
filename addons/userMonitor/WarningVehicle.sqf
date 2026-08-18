
#define HINT_DELAY_NUKE 600
#define HINT_DELAY_ARTI 1200
#define HINT_DELAY_ARTI_GUN 60
#define DROP_USER_MARKER 120
if (!hasInterface || isServer) exitWith {};
waitUntil {sleep 0.1; alive player && !(player getVariable ["playerSpawning", true])};


private ["_lastHint", "_lastHintArti", "_lastHintArtiGun", "_lastHintUserMarker", "_vehicle", "_variant", "_nukeJet", "_isArtillery", "_message", "_clientOwner", "_simplMessage", "_currentIndex", "_index", "_indexStr"];

_lastHint = -HINT_DELAY_NUKE;
_lastHintArti = -HINT_DELAY_ARTI;
_lastHintArtiGun = -HINT_DELAY_ARTI_GUN;
_lastHintUserMarker = -DROP_USER_MARKER;

while {true} do {
	_vehicle = (vehicle player);
	_variant = _vehicle getVariable ["A3W_vehicleVariant", ""];
	_nukeJet = (_variant == "A164Nuke" && alive player && !(player getVariable ["playerSpawning", true]));
		
	_isArtillery = ((_vehicle isKindOf "CUP_I_Hilux_armored_podnos_IND_G_F" || _vehicle isKindOf "B_MBT_01_mlrs_F" || _vehicle isKindOf "CUP_B_2b14_82mm_ACR" || _vehicle isKindOf "CUP_B_L16A2_BAF_DDPM" || _vehicle isKindOf "CUP_B_M252_US" || _vehicle isKindOf "CUP_B_M119_US" ||  _vehicle isKindOf "B_T_MBT_01_mlrs_F" || _vehicle isKindOf "B_G_Mortar_01_F") && alive player && !(player getVariable ["playerSpawning", true]));

	if (_nukeJet && diag_tickTime - _lastHint >= HINT_DELAY_NUKE) then {
		_message = parseText ([
			"<t color='#FF0000' size='1.5' align='center'>WARNING</t>",
			//profileName,
			"<t color='#FFFFFF' shadow='1' shadowColor='#000000' align='center'>Someone is using jet with nuclear weapons!</t>"
		] joinString "<br/>");
		//_message remoteExec ["hint", -clientOwner];
		_simplMessage = "Someone is using jet with nuclear weapons!";
		_clientOwner = clientOwner;
		[_message, _simplMessage, _clientOwner] remoteExec ["hard_vehicle_message"];
		_lastHint = diag_tickTime;
	};


	if (_isArtillery && diag_tickTime - _lastHintArti >= HINT_DELAY_ARTI) then {
		_message = parseText ([
			"<t color='#FF0000' size='1.5' align='center'>WARNING</t>",
			//profileName,
			"<t color='#FFFFFF' shadow='1' shadowColor='#000000' align='center'>Someone is using artillery. Use radar to track!</t>"
		] joinString "<br/>");

		//_message remoteExec ["hint", -clientOwner];
		_simplMessage = "Someone is using artillery. Use radar to track!";
		_clientOwner = clientOwner;
		[_message, _simplMessage, _clientOwner] remoteExec ["hard_vehicle_message"];
		_lastHintArti = diag_tickTime;
	};



	if(_nukeJet) then {
		_currentIndex =  _vehicle getVariable ["nukeEventIndex", ""];
		if(_currentIndex == "") then {
		_vehicle removeAllEventHandlers "Fired";
		_index = _vehicle addEventHandler ["Fired", 
		{

		params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectileNuke", "_gunner"];
		if(!isServer && _unit == (vehicle player) && _ammo == "Bomb_04_F") then {	
			_projectileNuke addEventHandler ["Explode", 
				{
				params ["_projectileNuke", "_pos", "_velocity"];
				_projectileNuke removeAllEventHandlers "Explode";
				deleteVehicle _projectileNuke;
				[_pos] remoteExec ["freestylesNuclearBlastInvoke", 2];
				}];
		};
		
   		}];
		_indexStr = str(_index);
		_vehicle setVariable ["nukeEventIndex", _indexStr];	
	
		};
	
	};
	
	if (_isArtillery && ((_vehicle getVariable ["mortarEventIndex", ""]) == "") && (_vehicle emptyPositions "Gunner" == 0)) then {
		_vehicle removeAllEventHandlers "Fired";
		_index = _vehicle addEventHandler ["Fired", 
		{
			if((random 1) < 0.3) then {
			
			[(getPosWorld (vehicle player)), 1, (vehicle player isKindOf "B_T_MBT_01_mlrs_F")] remoteExec ["User_monitor", -2]; 
			
			};

   		}];
		_indexStr = str(_index);
		_vehicle setVariable ["mortarEventIndex", _indexStr];	
	
	};


	if (diag_tickTime - _lastHintUserMarker >= (DROP_USER_MARKER + random 20)) then {
			private _userMarkers = player getVariable ["mortarMarkers", []];

			if (count _userMarkers > 0) then {
					
				{
					deleteMarkerLocal _x;
				}
				forEach _userMarkers;
				player setVariable ["mortarMarkers", []];
			
			};

			_lastHintUserMarker = diag_tickTime;
	};

	if(_variant == "KajmanTV" && !(_vehicle getVariable ["TVSInit", false])) then {
		
		TVS = [_vehicle, "M_Scalpel_AT"] execvm "addons\TVS\scripts\init.sqf";
		_vehicle setVariable ["TVSInit", true];
	
	};

	if(_variant == "ka52TV" && !(_vehicle getVariable ["TVSInit", false])) then {
		
		TVS = [_vehicle, "CUP_M_9K121_Vikhr_AT16_Scallion_AT"] execvm "addons\TVS\scripts\init.sqf";
		_vehicle setVariable ["TVSInit", true];
	
	};


		/*if (_isArtillery && diag_tickTime - _lastHintArti >= HINT_DELAY_ARTI) then {
		_message = parseText ([
			"<t color='#FF0000' size='1.5' align='center'>WARNING</t>",
			//profileName,
			"<t color='#FFFFFF' shadow='1' shadowColor='#000000' align='center'>Someone is using artillery. Use radar to track!</t>"
		] joinString "<br/>");

		//_message remoteExec ["hint", -clientOwner];
		_simplMessage = "Someone is using artillery. Use radar to track!";
		_clientOwner = clientOwner;
		[_message, _simplMessage, _clientOwner] remoteExec ["hard_vehicle_message"];
		_lastHintArti = diag_tickTime;
	};*/



	//if (_isArtillery && diag_tickTime - _lastHintArtiGun >= (HINT_DELAY_ARTI_GUN + random 45) && (_vehicle emptyPositions "Gunner" == 0)) then {
			//_artMarkerPos = getPosWorld player;
			//
			//
			//_markerName = "Artillery_" + getPlayerUID player;
			//_artMarkerPosRandom = [((_artMarkerPos select 0) + (floor random [-250, 0, 250])), ((_artMarkerPos select 1) + (floor random [-250, 0, 250])), (_artMarkerPos select 2)];
			//createMarker [_markerName, _artMarkerPosRandom];
			//_markerName setMarkerText "Artillery";
			//_markerName setMarkerSize [0.75, 0.75];
			//_markerName setMarkerShape "ICON";
			//_markerName setMarkerType "b_art";
			//
			//[_artMarkerPos, 1] remoteExec ["User_monitor", -2]; 
			//_lastHintArtiGun = diag_tickTime; 
	//};
	

	sleep 0.5;
};