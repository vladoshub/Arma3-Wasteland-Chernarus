// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.1
//@file Name: init.sqf
//@file Author: [404] Deadbeat, [GoT] JoSchaap, AgentRev, [KoS] Bewilderbeest
//@file Created: 20/11/2012 05:19
//@file Description: The client init.

if (isDedicated) exitWith {};

if (!isServer) then
{
	waitUntil {!isNil "A3W_network_compileFuncs"};
};

waitUntil {!isNil "A3W_serverSetupComplete"};



#define respawn_Random_Button_init 3413
#define respawn_Halo_Spawn_Button 3415
#define respawn_Preload_Checkbox_init 3416
#define respawn_Locations_Type_init 3449
#define respawn_Locations_List_init 3450
#define respawn_Spawn_Button_init 3453
#define custom_Loadout_Button 3417

[] execVM "client\functions\bannedNames.sqf";
[] execVM "addons\CodeLock\doorConfig.sqf"; //codeLock
//[] execVM "R3F_LOG\client\checker.sqf"; //no players in tow vehicles

//kick afk
[] execVM "client\functions\idleKick\idleKick.sqf";

showPlayerIcons = true;
mutexScriptInProgress = false;
respawnDialogActive = false;
groupManagmentActive = false;
pvar_PlayerTeamKiller = [];
doCancelAction = false;

BeaconScanInProgress = false;
DisableSpawnFlagInProgress = false;
player setVariable ["mutex_net_obj", nil, true];
player setVariable ["killOnBaseFlag", nil, true];
R3F_LOG_mutex_local_verrou = false;


//Initialization Variables
playerCompiledScripts = false;
playerSetupComplete = false;

waitUntil {!isNull player && time > 0};

removeAllWeapons player;
player switchMove "";

// initialize actions and inventory
"client\actions" call mf_init;
"client\inventory" call mf_init;
"client\items" call mf_init;

//Call client compile list.
call compile preprocessFileLineNumbers "client\functions\clientCompile.sqf";

//Stop people being civ's.
if !(playerSide in [BLUFOR,OPFOR,INDEPENDENT]) exitWith
{
	endMission "LOSER";
};

//Setup player events.
if (!isNil "client_initEH") then { player removeEventHandler ["Respawn", client_initEH] };
//if (!isNil "client_initArtEH") then { player removeEventHandler ["Fired", client_initArtEH] };


player addEventHandler ["Respawn", { _this spawn onRespawn }];
player addEventHandler ["Killed", onKilled];
player addEventHandler ["Fired", onFired];



// Backpacks invisible 
//unitBackpack player setObjectTextureGlobal [0,""];
//player addEventHandler ["InventoryOpened", { unitBackpack player setObjectTextureGlobal [0,""]; }]; // Will be updated every now and again without having a loop running

call compile preprocessFileLineNumbers "addons\far_revive\FAR_revive_init.sqf";

A3W_scriptThreads pushBack execVM "client\functions\evalManagedActions.sqf";

[player, objNull] remoteExec ["A3W_fnc_playerRespawnServer", 2];

//Player setup
player call playerSetupStart;

// Deal with money here
_baseMoney = ["A3W_startingMoney", 100] call getPublicVar;
//player setVariable ["cmoney", _baseMoney, true];
[player, _baseMoney, true] call A3W_fnc_setCMoney;

// Player saving - load data
if (["A3W_playerSaving"] call isConfigOn) then
{
	call compile preprocessFileLineNumbers "persistence\client\players\setupPlayerDB.sqf";
	call fn_requestPlayerData;

	waitUntil {!isNil "playerData_loaded"};

	A3W_scriptThreads pushBack ([] spawn
	{
		scriptName "savePlayerLoop";

		// Save player every 60s
		for "_i" from 0 to 1 step 0 do
		{
			sleep 60;
			call fn_savePlayerData;
		};
	});
};

// Teambalancer
call compile preprocessFileLineNumbers "client\functions\teamBalance.sqf";

if (isNil "playerData_alive") then
{
	player call playerGearFirst;
};

player call playerSetupEnd;

diag_log format ["Player starting with $%1", (player getVariable ["cmoney", 0]) call fn_numToStr];

[] execVM "territory\client\hideDisabledTerritories.sqf";

// Territory system enabled?
if (count (["config_territory_markers", []] call getPublicVar) > 0) then
{
	A3W_fnc_territoryActivityHandler = "territory\client\territoryActivityHandler.sqf" call mf_compile;
	[] execVM "territory\client\CaptureTriggers.sqf";
};

//Setup player menu scroll action.
//[] execVM "client\clientEvents\onMouseWheel.sqf";

// Load custom keys from profile
call compile preprocessFileLineNumbers "client\clientEvents\customKeys.sqf";

//Setup Key Handler
waitUntil {!isNull findDisplay 46};
(findDisplay 46) displayAddEventHandler ["KeyDown", onKeyPress];
(findDisplay 46) displayAddEventHandler ["KeyUp", onKeyRelease];

_mouseButtonToKey = "params ['_disp','_btn']; ([_disp, _btn + 65536 + ([0,128] select (_btn isEqualTo 1))] + (_this select [4,999])) call "; // actionKeys mouse bitflag + RMB fix

(findDisplay 46) displayAddEventHandler ["MouseButtonDown", _mouseButtonToKey + "onKeyPress"];
(findDisplay 46) displayAddEventHandler ["MouseButtonUp", _mouseButtonToKey + "onKeyRelease"];

call compile preprocessFileLineNumbers "client\functions\setupClientPVars.sqf";

//client Executes
A3W_scriptThreads pushBack execVM "client\systems\hud\playerHud.sqf";
A3W_scriptThreads pushBack execVM "client\systems\killFeed\killFeed.sqf";

if (["A3W_survivalSystem"] call isConfigOn) then
{
	[] execVM "client\functions\initSurvival.sqf";
};

[] spawn
{
	[] execVM "client\functions\createGunStoreMarkers.sqf";

	if (["A3W_privateParking"] call isConfigOn) then
	{
		waitUntil {!isNil "parking_functions_defined"};
	};

	if (["A3W_privateStorage"] call isConfigOn) then
	{
		waitUntil {!isNil "storage_functions_defined"};
	};

	[] execVM "client\functions\createResupplyTruckMarkers.sqf";
	[] execVM "client\functions\createGeneralStoreMarkers.sqf";
	[] execVM "client\functions\createVehicleStoreMarkers.sqf";
	[] execVM "client\functions\createPortalMarkers.sqf";
	[] execVM "client\functions\createFoodMarkers.sqf";
	[] execVM "client\functions\createLegendMarkers.sqf";
};

	addMissionEventHandler ["Map", {
    params ["_mapIsOpened", "_mapIsForced"];
    
    if (_mapIsOpened) then {
        [] spawn {
            waitUntil {!isNull (findDisplay 12)};
            sleep 0.05;
            
            _mapControl = (findDisplay 12) displayCtrl 51;
            ctrlMapAnimClear _mapControl;
            _mapControl ctrlMapAnimAdd [
                0.5, // время анимации
                0.5, 
                getPos player
            ];
            ctrlMapAnimCommit _mapControl;
        };
    	};
	}];



addMissionEventHandler ["MapSingleClick", {

	params ["_units", "_pos", "_alt", "_shift"];

	private _localMarkerArray = ((call spawnList) select {_pos inArea (_x select 0)} );

	if(respawnDialogActive && (count (_localMarkerArray)) == 1 && player getVariable ["airBornSpawn", true]) then {
		private _canSpawn = true;
		private _pointSpawnTime =  player getVariable (((_localMarkerArray select 0) select 0) + "_lastSpawn");
		if (!isNil "_pointSpawnTime") then
		{
				private _spawnCooldown = 60;
				private _remaining = _spawnCooldown - (diag_tickTime - _pointSpawnTime);
				if (_remaining > 0) then {
					_canSpawn = false;
					hint format ["This point has been blocked since you spawned there. Left: %1 SEC", round (_remaining)];
					playSound "FD_CP_Not_Clear_F";
				};
		};
		
		if(_canSpawn) then {
			player setVariable ["airBornSpawn", false];
				{ 
					ctrlEnable [_x, false]
				}		
				forEach  [respawn_Random_Button_init, respawn_Halo_Spawn_Button, respawn_Preload_Checkbox_init, respawn_Locations_Type_init, respawn_Locations_List_init, respawn_Spawn_Button_init, custom_Loadout_Button];

				/////
				{
					(_x select 0) setMarkerColorLocal "ColorWhite";
		
				} forEach (call spawnList);

				[nil, [6, (_localMarkerArray select 0) select 0]] execVM "client\functions\spawnAction.sqf";
		};
	};
}];


A3W_clientSetupComplete = compileFinal "true";

[] spawn playerSpawn;

A3W_scriptThreads pushBack execVM "addons\fpsFix\vehicleManager.sqf";
A3W_scriptThreads pushBack execVM "addons\Lootspawner\LSclientScan.sqf";

// StatusBar
if(hasInterface) then{[] execVM "addons\statusBar\statusbar.sqf"}; 


[] execVM "client\functions\drawPlayerIcons.sqf";
[] execVM "addons\UAV_Control\functions.sqf";
[] execVM "addons\tailhook\init.sqf";
[] execVM "addons\drop_ladder\init.sqf";
//[] execVM "addons\noaim\K_noAim_flightRestriction.sqf"; //BY_VLADOS
// [] execVM "addons\noaim\deathzone.sqf";
//[] execVM "addons\compass\voyagerCompass.sqf";
[] execVM "client\items\stash\pack.sqf";
// [] execVM "addons\noaim\emptyfuel.sqf";

call compile preprocessFileLineNumbers "client\functions\generateAtmArray.sqf";
[] execVM "client\functions\drawPlayerMarkers.sqf";

inGameUISetEventHandler ["Action", "_this call A3W_fnc_inGameUIActionEvent"];

{ [_x] call fn_remotePlayerSetup } forEach allPlayers;

// update player's spawn beaoon
{
	if (_x getVariable ["ownerUID",""] == getPlayerUID player) then
	{
		_x setVariable ["ownerName", name player, true];
		_x setVariable ["side", playerSide, true];
	};
} forEach pvar_spawn_beacons;

/*[] spawn {
	for "_i" from 0 to 1 step 0 do {
		// Check if the player has an AV terminal
		{
			if (_x isKindOf "B_SAM_System_02_F" || _x isKindOf "B_AAA_System_01_F") then
			{
				player disableUAVConnectability [_x, true];
			};
		} forEach allUnitsUAV;
		sleep 0.01;
	};
};*/ //BY VLADOS B_AAA

/*
[] spawn {
	for "_i" from 0 to 1 step 0 do {
		if ((vehicle player) isKindOf "Air") then {
			vehicle enableVehicleSensor ["ActiveRadarSensorComponent", true]; //BY_VLADOS
			{(vehicle player) enableInfoPanelComponent [_x,"SensorsDisplayComponent",false]} forEach ["left","right"];
		};
		sleep 0.01;
	};
};
*/