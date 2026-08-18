// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: spawnAction.sqf
//	@file Author: [404] Deadbeat, [KoS] Bewilderbeest, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args: [int(type of spawn)]

#define respawn_Content_Text 3401
#define respawn_Random_Button 3413
#define respawn_Preload_Checkbox 3416
#define respawn_Locations_Type 3449
#define respawn_Locations_List 3450
#define respawn_Spawn_Button 3453
#define btn_custom_loadout 3417

disableSerialization;

private _player = _this;

if (!isNil "spawnActionHandle" && {typeName spawnActionHandle == "SCRIPT"} && {!scriptDone spawnActionHandle}) exitWith {};

spawnActionHandle = (_this select 1) spawn
{
	disableSerialization;

	private _switch = _this select 0;
	private _data = [_this select 1, false];

	//base_flag addon
	player setVariable ["mutex_net_obj", nil, true];
	player setVariable ["killOnBaseFlag", nil, true];
	R3F_LOG_mutex_local_verrou = false;

	if (isNil "playerData_resetPos") then
	{




		
private _playerGlobalNotFirstInit = "playerGlobalNotFirstInit_" + getPlayerUID player;
if(missionNamespace getVariable [_playerGlobalNotFirstInit, true]) then {


	player setVariable ["notFirstSpawnTown", false, true];

	if (((call mf_inventory_list) select {(_x select 0) == "defibrillator"}) select 0 select 1 == 0) then {
		["defibrillator", 1] call mf_inventory_add;
	};

	//if (((call mf_inventory_list) select {(_x select 0) == "carSpawns"}) select 0 select 1 == 0) then {
	//	["carSpawns", 1] call mf_inventory_add;
	//};

	if (((call mf_inventory_list) select {(_x select 0) == "heliSpawns"}) select 0 select 1 == 0) then {
		["heliSpawns", 1] call mf_inventory_add;
	};

	if (((call mf_inventory_list) select {(_x select 0) == "shield"}) select 0 select 1 == 0) then {
		["shield", 1] call mf_inventory_add;
	};

	if (((call mf_inventory_list) select {(_x select 0) == "repairkit"}) select 0 select 1 == 0) then {
		["repairkit", 1] call mf_inventory_add;
	};

	/*
	if (hmd player == "") then { 
		player linkItem "NVGoggles"; 
		player setVariable ["firstNVGogglesNeedRemove", false, true]; 
	};
	*/

	if (primaryWeapon player == "") then {
			player addMagazine "100Rnd_65x39_caseless_mag";
			player addWeapon "arifle_MX_SW_F";
			player addPrimaryWeaponItem "optic_DMS";
			player addMagazine "100Rnd_65x39_caseless_mag";
			player addMagazine "100Rnd_65x39_caseless_mag";
	};
	
	if (SecondaryWeapon  player == "") then {
			player addMagazine "RPG7_F";
			player addWeapon "launch_RPG7_F";
			player addMagazine "RPG7_F";
	};
	

	[player, 25000, true] call A3W_fnc_setCMoney;
	missionNamespace setVariable [_playerGlobalNotFirstInit, false, true];
} else {
	_baseMoney = ["A3W_startingMoney", 100] call getPublicVar;
	[player, _baseMoney, true] call A3W_fnc_setCMoney;


	if (primaryWeapon player == "") then {
		player addMagazine "100Rnd_65x39_caseless_mag";
		player addWeapon "arifle_MX_SW_F";
		player addPrimaryWeaponItem "optic_Arco";
		player addMagazine "30Rnd_65x39_caseless_mag";
		player addMagazine "30Rnd_65x39_caseless_mag";
	};

	if (SecondaryWeapon  player == "") then {
			player addMagazine "RPG7_F";
			player addWeapon "launch_RPG7_F";
			if ((random 1) < 0.25 && SecondaryWeapon  player == "") then {
				player addMagazine "RPG7_F";
			};
	};

};




		if (["A3W_survivalSystem"] call isConfigOn) then
		{
			[MF_ITEMS_CANNED_FOOD, 1] call mf_inventory_add;
			[MF_ITEMS_WATER, 1] call mf_inventory_add;

			[MF_ITEMS_SACK_FOOD, 1] call mf_inventory_add;
			[MF_ITEMS_TEAPOT_WATER, 1] call mf_inventory_add;
		};
		
		//[MF_ITEMS_REPAIR_KIT, 1] call mf_inventory_add;
		[MF_ITEMS_QUAD, 1] call mf_inventory_add;
		["carSpawns", 1] call mf_inventory_add;
	};

	if (cbChecked ((uiNamespace getVariable "RespawnSelectionDialog") displayCtrl respawn_Preload_Checkbox)) then
	{
		_data set [1, true];
	}
	else
	{
		profileNamespace setVariable ["A3W_preloadSpawn", false];
	};

	switch (_switch) do
	{
		case 1: { _data call spawnInTown };
		case 2: { _data call spawnOnBeacon };
		case 3: { _data call HalospawnRandom };
		case 4: { _data call spawnOnTerritory };
		case 5: { _data call spawnOnFlag }; //base_flag addon
		case 6: { _data call spawnOnPoint }; //base_flag addon
		case 7: { _data call spawnOnHQ }; //base_flag addon
		default { _data call spawnRandom };
	};

	if (isNil "client_firstSpawn") then
	{
		execVM "client\functions\firstSpawn.sqf";
	};

	{
		(_x select 0) setMarkerColorLocal "ColorWhite";
		
	} forEach (call spawnList);

};

private _dialog = uiNamespace getVariable ["RespawnSelectionDialog", displayNull];
private _header = _dialog displayCtrl respawn_Content_Text;

if (cbChecked (_dialog displayCtrl respawn_Preload_Checkbox)) then
{
	_header ctrlSetStructuredText parseText "<t size='0.5'> <br/></t><t size='1.33'>Preloading spawn...</t>";
};


player call playerSetupGear;

/*
if (weapons player isEqualTo [] && itemsWithMagazines player isEqualTo []) then 
{
	player call playerSetupGear;
} else
{

switch (true) do {
	case (["medic", typeOf _player] call fn_findString != -1 || ["_Doctor_", typeOf _player] call fn_findString != -1 || ["Medic", typeOf _player] call fn_findString != -1): {
		if (backpack _player == "") then {
			_player addBackpack "B_Kitbag_Base";
		};
		_player addItemToBackpack  "Medikit";
	};
	case (["engineer", typeOf _player] call fn_findString != -1 || ["_Worker_", typeOf _player] call fn_findString != -1 || ["_Mechanic_", typeOf _player] call fn_findString != -1 || ["Engineer", typeOf _player] call fn_findString != -1): {
		if (backpack _player == "") then {
			_player addBackpack "B_Kitbag_Base";
		};
		_player addItemToBackpack "Toolkit";
	};
	case (["_sniper_", typeOf _player] call fn_findString != -1 || ["Scout", typeOf _player] call fn_findString != -1 || ["Sniper", typeOf _player] call fn_findString != -1  || ["sniper", typeOf _player] call fn_findString != -1): {
		_player addWeapon "Rangefinder";
	};
};


};
*/

if (typeName spawnActionHandle == "SCRIPT") then
{
	private _spawnActionHandle = spawnActionHandle;
	waitUntil {scriptDone _spawnActionHandle};
	spawnActionHandle = nil;
};

_header ctrlSetStructuredText parseText "It appears there was an error,<br/>please try again.";
{
	(_dialog displayCtrl _x) ctrlEnable true;
} forEach [respawn_Random_Button, respawn_Spawn_Button, respawn_Locations_Type, respawn_Locations_List, respawn_Preload_Checkbox, btn_custom_loadout];
