// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: setupMissionArrays.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

// Mission filename, spawnrate

MainMissions = [
	["mission_APC", 1],
	["mission_HeavyVehicle", 0.75],
	["mission_wreckedUAV", 0.3],
	["mission_wreckedUGV", 0.75],
	["mission_ArmedHeli", 0.75],
	["mission_ArmedJet", 0.6],
	["mission_LightVehicle", 1],
	["mission_CivHeli", 0.3],
	["mission_AntiAir", 0.75]
]; 


UltraMissions = [
 	["mission_ArmedTvHeli", 0.8],
	["mission_MLRS", 0.15],
	["mission_NukeJet", 0.1],
	["mission_SuperJet", 0.7],
	["mission_CaptureBase", 0.35],
	["mission_BigTank", 1],
	["mission_Ammo", 0.55],
	["mission_BaseObjects", 0.4],
	["mission_CaptureBaseTwo", 0.8],
	["mission_CaptureBaseFlag", 0.2],
	["mission_DefendTerritory", 0.4],
	["mission_HQ", 0.7]
	//["mission_Mech", 0.6],
]; 


	if(["A3W_use_CUP", false] call getPublicVar) then {
		UltraMissions append [
		["mission_BigBoat", 0.25]
		];
	};


SideMissions = [
	["mission_SunkenSupplies", 0.2],
	["mission_ArmedDiversquad", 1],
	["mission_TownInvasion", 0.7],
	["mission_Outpost", 0.6],
	["mission_Truck", 1],
	["mission_diplomats", 0.7],
	["mission_GeoCache", 1],
	["mission_Convoy", 1],
	["mission_Sniper", 1],
	["mission_Roadblock", 0.6],
	["mission_FakePolice", 1],
	["mission_BountyHunter", 1],
	["mission_Smugglers", 1],
	["mission_Coastal_Convoy", 0.3],
	["mission_MiniConvoy", 1],
	["mission_SealTeams", 0.3],
	["mission_AirWreck", 1], //was 3
	["mission_WepCache", 1],
	["mission_AntiUAV", 0.5],
	["mission_Drone", 0.5] //BY_VLADOS
];


PatrolMissions = [
	["mission_Cobra", 0.5],
	["mission_HostileHelicopter", 1],
	["mission_HostileHeliFormation", 0.75],
	["mission_HostileJet", 0.1],
	["mission_HostileJetFormation", 0.5],
	["mission_SkySmuggler", 0.3]
];


MoneyMissions = [
	["mission_MoneyShipment", 0.7],
	["mission_SunkenTreasure", 0.3],
	["mission_NavySeals", 0.75],
	//["mission_militaryPatrol", 1], //BY_VLADOS
	["mission_armaPatrol", 0.5],
	["mission_BankRobbery", 1],
	["mission_CrimesofWar", 1]
];

ExtraMissions = [
	["mission_DeltaForce", 0.7],
	["mission_SpecOps", 0.7],
	["mission_Spetsnaz", 0.7],
	["mission_Assassin", 0.6],
	["mission_HnS", 1],
	["mission_HostageRescue", 1],
	["mission_HostilePlane", 0.2],
	["mission_TransportHeli", 0.5],
	["mission_WepDeal", 1],
	["mission_InfGroup", 1],
	["mission_Pawnee", 0.4],
	["mission_Fishie", 0.2],
	["mission_Thunder", 0.3],
	["mission_Falcon", 0.5],
	["mission_Graveyard", 1],
	["mission_BlackHawkDown", 1]
];

MissionSpawnMarkers = (allMapMarkers select {["Mission_", _x] call fn_startsWith}) apply {[_x, false]};
ForestMissionMarkers = (allMapMarkers select {["ForestMission_", _x] call fn_startsWith}) apply {[_x, false]};
SunkenMissionMarkers = (allMapMarkers select {["SunkenMission_", _x] call fn_startsWith}) apply {[_x, false]};
RoadblockMissionMarkers = (allMapMarkers select {["Roadblock_", _x] call fn_startsWith}) apply {[_x, false]};
SniperMissionMarkers = (allMapMarkers select {["Sniper_", _x] call fn_startsWith}) apply {[_x, false]};
PatrolMissionMarkers = (allMapMarkers select {["Patrol_", _x] call fn_startsWith}) apply {[_x, false]};
ClearMissionMarkers = (allMapMarkers select {["Clear_", _x] call fn_startsWith}) apply {[_x, false]};
AirstripMissionMarkers = (allMapMarkers select {["Airstrip_", _x] call fn_startsWith}) apply {[_x, false]};
IslandMissionMarkers = (allMapMarkers select {["Island_", _x] call fn_startsWith}) apply {[_x, false]};
WaterMissionMarkers = (allMapMarkers select {["Water_", _x] call fn_startsWith}) apply {[_x, false]};
FuelstationMissionMarkers = (allMapMarkers select {["Fuelstation_", _x] call fn_startsWith}) apply {[_x, false]};
TrainMissionMarkers = (allMapMarkers select {["Train_", _x] call fn_startsWith}) apply {[_x, false]};
BigBoatMissionMarkers = (allMapMarkers select {["BigBoat_", _x] call fn_startsWith}) apply {[_x, false]}; //BY VLADOS
UltraMissionSpawnMarkers = (allMapMarkers select {["UltraMission_", _x] call fn_startsWith}) apply {[_x, false]}; //BY VLADOS
BaseCaptureMissionSpawnMarkers = (allMapMarkers select {["BaseCapture_", _x] call fn_startsWith}) apply {[_x, false]}; //BY VLADOS

/*
if !(ForestMissionMarkers isEqualTo []) then {
	SideMissions append [
		["mission_AirWreck", 1], //was 3
		["mission_WepCache", 1],
		["mission_AntiUAV", 0.5],
		["mission_Drone", 0.5] //BY_VLADOS
	];
};
*/

LandConvoyPaths = (call compile preprocessFileLineNumbers "mapConfig\convoys\landConvoysList.sqf") apply {[_x, false]};
CoastalConvoyPaths = (call compile preprocessFileLineNumbers "mapConfig\convoys\coastalConvoysList.sqf") apply {[_x, false]};

//MainMissions = [MainMissions, [["A3W_heliPatrolMissions", ["mission_Coastal_Convoy", "mission_HostileHeliFormation", "mission_HostileJetFormation"]], ["A3W_underWaterMissions", ["mission_ArmedDiversquad"]]]] call removeDisabledMissions;
//SideMissions = [SideMissions, [["A3W_heliPatrolMissions", ["mission_HostileHelicopter"]], ["A3W_underWaterMissions", ["mission_SunkenSupplies"]]]] call removeDisabledMissions;
//MoneyMissions = [MoneyMissions, [["A3W_underWaterMissions", ["mission_SunkenTreasure"]]]] call removeDisabledMissions;

{ _x set [2, false] } forEach MainMissions;
{ _x set [2, false] } forEach SideMissions;
{ _x set [2, false] } forEach PatrolMissions;
{ _x set [2, false] } forEach MoneyMissions;
{ _x set [2, false] } forEach ExtraMissions;
{ _x set [2, false] } forEach UltraMissions;
/*
MissionSpawnMarkers = [];
SniperMissionMarkers = [];
RoadblockMissionMarkers = [];
PatrolMissionsMarkers = [];
{
	switch (true) do {
		case (["Mission_", _x] call fn_startsWith): {
			MissionSpawnMarkers pushBack [_x, false];
		};
		case (["Sniper_", _x] call fn_startsWith): {
			SniperMissionMarkers pushBack [_x, false];
		};
		case (["RoadBlock_", _x] call fn_startsWith): {
			RoadblockMissionMarkers pushBack [_x, false];
		};
		case (["Patrol_", _x] call fn_startsWith): {
			PatrolMissionsMarkers pushBack [_x, false];
		};
	};
} forEach allMapMarkers;*/