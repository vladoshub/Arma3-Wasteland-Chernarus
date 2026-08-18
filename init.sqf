// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.2
//	@file Name: init.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap, AgentRev
//	@file Description: The main init.
// Ich bin der beste by AryX
if (isServer) then
{
"12345abz!" serverCommand "#lock";
};

#include "debugFlag.hpp"

#ifdef A3W_DEBUG
#define DEBUG true
#else
#define DEBUG false
#endif

enableSaving [false, false];

// block script injection exploit
A3W_sessionTimeStart = diag_tickTime;

_descExtPath = str missionConfigFile;
currMissionDir = compileFinal str (_descExtPath select [0, count _descExtPath - 15]);
CUP_Classes = [];

X_Server = false;
X_Client = false;
X_JIP = false;

CHVD_allowNoGrass = false;
CHVD_allowTerrain = true; // terrain option has been disabled out from the menu due to terrible code, this variable has currently no effect
CHVD_maxView = 4500; // Set maximum view distance (default: 12000) //BY_VLADOS
CHVD_maxObj = 4500; // Set maximimum object view distance (default: 12000) //BY_VLADOS
externalConfigFolderAdditional = "\A3Wasteland_settings";

private _need = "12345abz!";

// versionName = ""; // Set in STR_WL_WelcomeToWasteland in stringtable.xml

if (isServer) then {
	//_need serverCommand "#lock";
	BlockFlagKillEnemy = false;
	X_Server = true 
};
if (!isDedicated) then { X_Client = true };
if (isNull player) then { X_JIP = true };

A3W_scriptThreads = [];

[DEBUG] call compile preprocessFileLineNumbers "globalCompile.sqf";

if (isServer) then
{
	//load default config
	call compile preprocessFileLineNumbers "server\default_config_additional.sqf";

	// load external config

/*
	if (loadFile (externalConfigFolderAdditional + "\main_config_additional.sqf") != "") then
	{
		call compile preprocessFileLineNumbers (externalConfigFolderAdditional + "\main_config_additional.sqf");
	}
	else
	{
		diag_log format["[WARNING] A3W configuration file '%1\main_config_additional.sqf' was not found. Using default settings!", externalConfigFolderAdditional];
		//no_log "[WARNING] For more information go to http://forums.a3wasteland.com/";
	};
*/

	// compileFinal & broadcast client config variables
	{
		missionNamespace setVariable [_x, compileFinal str (missionNamespace getVariable _x)];
		publicVariable _x;
	}
	forEach
	[
		"A3W_use_CUP",
		"A3W_map",
		"A3W_store_variant"
	];

	if(["A3W_use_CUP", false] call getPublicVar) then {
		[] execVM "cup_classes.sqf";
	};

};

if (hasInterface && (["A3W_use_CUP", false] call getPublicVar)) then {
	[] execVM "cup_classes.sqf";
};

call compile preprocessFileLineNumbers "addons\cram\Trophy.sqf"; //CRAM2

//init Wasteland Core
[] execVM "config.sqf";
[] execVM format ["storeConfig_%1.sqf", (["A3W_store_variant", "stock"] call getPublicVar)]; // Separated as its now v large for
[] execVM "briefing.sqf";
[] execVM "addons\sw\spectrum_device.sqf"; //https://steamcommunity.com/sharedfiles/filedetails/?id=2214415193
[] execVM "addons\sw\sa_ewar.sqf";
[] execVM "addons\base_flag\server\config.sqf";

if (!isDedicated) then {
	[] spawn {
		if (hasInterface) then {
			9999 cutText ["Welcome to A3Wasteland, please wait for your client to initialize", "BLACK", 0.01];

			waitUntil {!isNull player};
			player setVariable ["playerSpawning", true, true];
			playerSpawning = true;

			removeAllWeapons player;
			client_initEH = player addEventHandler ["Respawn", { removeAllWeapons (_this select 0) }];
			/*client_initArtEH = player addEventHandler ["Fired",{ if ((vehicle player) isKindOf "CUP_I_Hilux_armored_podnos_IND_G_F" || (vehicle player) isKindOf "B_MBT_01_mlrs_F" || (vehicle player) isKindOf "CUP_B_2b14_82mm_ACR" || (vehicle player) isKindOf "CUP_B_L16A2_BAF_DDPM" || (vehicle player) isKindOf "CUP_B_M252_US" || (vehicle player) isKindOf "CUP_B_M119_US") then
				{ 
					_markerName = "Artillery_" + getPlayerUID player;
					_artMarkerPos = getPosWorld player;
					_artMarkerPosRandom = [((_artMarkerPos select 0) + (floor random [-50, 0, 50])), ((_artMarkerPos select 1) + (floor random [-50, 0, 50])), (_artMarkerPos select 2)];
					createMarker [_markerName, _artMarkerPosRandom];
					_markerName setMarkerText "Artillery";
					_markerName setMarkerSize [0.75, 0.75];
					_markerName setMarkerShape "ICON";
					_markerName setMarkerType "b_art";
	
				};
			}];
			*/

			// Reset group & side
			[player] joinSilent createGroup playerSide;

			execVM "client\init.sqf";

			if ((vehicleVarName player) select [0,17] == "BIS_fnc_objectVar") then { player setVehicleVarName "" }; // undo useless crap added by BIS
		} else {
			waitUntil {!isNull player};
			if (getText (configFile >> "CfgVehicles" >> typeOf player >> "simulation") == "headlessclient") then
			{
				execVM "client\headless\init.sqf";
			};
		};
	};
};

if (isServer) then {
	//[] execVM "\waste_server\init.sqf";
	diag_log "WASTE SERVER - Init Loaded";
	//no_log format ["############################# %1 #############################", missionName];
	//no_log "WASTELAND SERVER - Initializing Server";
	[] execVM "server\init.sqf";
	diag_log "WASTELAND SERVER - Init Loaded";
	[] execVM "addons\offroad\EP_SlowOffroadVehicles.sqf";
	[] execVM "addons\uavAttitude\init.sqf";
};

if (hasInterface || isServer) then {
	
	//messages
	[] execVM "addons\serverRestartMessage\init.sqf";
	[] execVM "addons\serverCheckFps\init.sqf";
	[] execVM "addons\serverMessageInfo\init.sqf";


	//init 3rd Party Scripts
	[] execVM "addons\parking\functions.sqf";
	[] execVM "addons\storage\functions.sqf";
	[] execVM "addons\vactions\functions.sqf";
	[] execVM "R3F_LOG\init.sqf";
	//https://github.com/expung3d/A3-EnhancementPack
	//[] execVM "addons\offroad\EP_SlowOffroadVehicles.sqf";
	
	//UNLOCK ALL MAP //BY_VLADOS
	//[] execVM "addons\outOfBounds\outOfBoundsPlayer.sqf";
  	//[] execVM "addons\outOfBounds\outOfBoundsHeli.sqf";
  	//[] execVM "addons\outOfBounds\outOfBoundsPlane.sqf";
  	//[] execVM "addons\outOfBounds\outOfBoundsShip.sqf";
  	//[] execVM "addons\outOfBounds\outOfBoundsLandVehicle.sqf";
  	//[] execVM "addons\outOfBounds\outOfBoundsRemote.sqf";
	//[] execVM "addons\proving_ground\init.sqf";
	
	[] execVM "addons\proving_ground\init.sqf";
	[] execVM "addons\JumpMF\init.sqf";
	[] execVM "addons\melee\init.sqf";
	//[] execVM "addons\outlw_magrepack\MagRepack_init.sqf";
	[] execVM "addons\stickyCharges\init.sqf";
	
	// noAim Stuff
	[] execVM "addons\APOC_Airdrop_Assistance\init.sqf";  // Airdrop
	[] execVM "addons\base_flag\server\init.sqf";  // base_flag addon
	[] execVM "addons\JTS_PM\Functions.sqf";			  // messages
	[] execVM "addons\scripts\HvT.sqf";                   // High Value Target
	[] execVM "addons\userMonitor\WarningVehicle.sqf";
	[] execVM "addons\sounds\pain.sqf"; //Play near Sounds Player
	//[] execVM "addons\sounds\rofl.sqf"; //Play near Sounds Player


	[] execVM "addons\CHVD\autoView.sqf"; //Smart Mode FPS
	[] execVM "addons\scripts\initGrenades.sqf"; 		  // Toxic Gas Grenades
	//[] execVM "addons\zlt_fastrope\zlt_fastrope.sqf";     // Fastrope
	//if (isNil "drn_DynamicWeather_MainThread") then { drn_DynamicWeather_MainThread = [] execVM "addons\scripts\DynamicWeatherEffects.sqf" }; BY_VLADOS
	[] execVM "addons\laptop\init.sqf";
	[] execVM "addons\noaim\intro.sqf";
	[] execVM "addons\bounty\init.sqf";
	[] execVM "addons\noaim\repetitive_cleanup.sqf";

};

// Remove line drawings from map
(createTrigger ["EmptyDetector", [0,0,0], false]) setTriggerStatements
[
	"!triggerActivated thisTrigger", 
	"thisTrigger setTriggerTimeout [30,30,30,false]",
	"{if (markerShape _x == 'POLYLINE') then {deleteMarker _x}} forEach allMapMarkers"
];

/*
[] spawn {
	for "_i" from 0 to 1 step 0 do {
		sleep 10;
		0 setFog 0;
		0 setRain 0;
		0 setOvercast 0;
		forceWeatherChange;
		200 setFog 0;
		200 setRain 0;
		200 setOvercast 0;
		sleep 590;
	};
};
*/
// Clean Up
[
	7*60 //Suitcases Cleanup
] execVM "addons\noaim\clean.sqf";
[] execVM "addons\scripts\ir_to_incendiary.sqf";