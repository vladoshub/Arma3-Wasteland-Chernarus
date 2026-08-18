// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: config.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:13
//	@file Description: Main config.

// For SERVER CONFIG, values are in server\init.sqf

// Towns and cities array
cityList = compileFinal preprocessFileLineNumbers format ["mapConfig\%1\towns.sqf", (["A3W_map", "chernarus"] call getPublicVar)];
spawnList = compileFinal preprocessFileLineNumbers format ["mapConfig\%1\spawns.sqf", (["A3W_map", "chernarus"] call getPublicVar)];
cityListLimit = compileFinal preprocessFileLineNumbers format ["mapConfig\%1\townsLimit.sqf", (["A3W_map", "chernarus"] call getPublicVar)]; // Town limitation for Spawns such as Assasins, Spetznas, SpecOps, Delta Force, etc..
citylistNoRanObj = compileFinal preprocessFileLineNumbers format ["mapConfig\%1\townsNoRanObj.sqf", (["A3W_map", "chernarus"] call getPublicVar)]; //no Random Objects in Towns
cityListMISCITY = compileFinal preprocessFileLineNumbers format ["mapConfig\%1\missioncity.sqf", (["A3W_map", "chernarus"] call getPublicVar)];


config_items_jerrycans_max = compileFinal "1";
config_items_syphon_hose_max = compileFinal "1";

config_refuel_amount_default = compileFinal "0.25";
config_refuel_amounts = compileFinal str
[
	["Kart_01_Base_F", 1],
	["Quadbike_01_base_F", 0.5],
	["Tank", 0.1],
	["Air", 0.1]
];

// NOTE: Player saving and money settings moved to external config (A3Wasteland_settings\main_config.sqf), default values are set in server\default_config.sqf

// Is player saving enabled?
// config_player_saving_enabled = compileFinal "0";

// How much do players spawn with?
// config_initial_spawn_money = compileFinal "100";

if (isServer) then
{
	config_territory_markers = compileFinal preprocessFileLineNumbers format ["mapConfig\%1\territories.sqf", (["A3W_map", "chernarus"] call getPublicVar)];
	publicVariable "config_territory_markers";
};
