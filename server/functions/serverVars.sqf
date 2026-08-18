// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: serverVars.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [404] Pulse, [GoT] JoSchaap, MercyfulFate, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args:

if (!isServer && hasInterface) exitWith {};

//no_log "WASTELAND SERVER - Initializing Server Vars";

if (isServer) then
{
	#include "setupServerPVars.sqf"
};

currentStaticHelis = []; // Storage for the heli marker numbers so that we don't spawn wrecks on top of live helis
currentStaticJets = []; // Storage for the jet marker numbers so that we don't spawn wrecks on top of live jets //BY_VLADOS
currentStaticTanks = []; // Storage for the jet marker numbers so that we don't spawn wrecks on top of live jets //BY_VLADOS

//Essential List - Random Spawns.
essentialsList =
[
	[0.1, "B_supplyCrate_F"],
	[0.1, "C_IDAP_supplyCrate_F"],
	[0.2, "Land_Sacks_goods_F"],
	[0.2, "Land_BarrelWater_F"]
];

//Object List - Random Spawns.
objectList =
[
	[0.8, "Land_BagBunker_Large_F"],
	[1, "Land_BagBunker_Small_F"],
	[0.3, "Land_BarGate_F"],
	[0.75, "Land_Canal_WallSmall_10m_F"],
	[0.9, "Land_CncBarrierMedium4_F"],
	[1, "Land_HBarrier_5_F"],
	[0.7, "Land_HBarrierTower_F"],
	[0.8, "Land_HBarrierWall4_F"],
	[0.65, "Land_HBarrierWall6_F"],
	[1, "Land_MetalBarrel_F"],
	[0.75, "Land_RampConcrete_F"],
	[0.5, "Land_RampConcreteHigh_F"],
	[0.75, "Land_Rampart_F"],
	[0.2, "Land_Scaffolding_F"],
	[0.07, "Land_Cargo_Tower_V4_F"],
	[0.3, "Land_Cargo_Patrol_V1_F"],
	[0.2, "Land_ConcreteBlock"],
	[0.2, "BlockConcrete_F"],
	[0.2, "Dirthump_3_F"],
	[0.75, "Land_CncBarrier_stripes_F"],
	[0.2, "Land_Dirthump03"],
	[0.01, "Land_ConcreteWall_01_l_gate_F"],
	[0.01, "land_bunker_garage"],
	[0.01, "B_Radar_System_02_F"],
	[0.01, "B_Radar_System_01_F"],
	[0.01, "B_SAM_System_03_F"],
	[0.01, "O_SAM_System_04_F"],
	[0.01, "Land_PierConcrete_01_16m_F"],
	[0.01, "Land_Pier_Box_F"],
	[0.3, "Land_GH_Stairs_F"],
	[0.01, "B_T_Static_AT_F"],
    [0.01, "B_T_Static_AA_F"],
	[0.05, "I_G_HMG_02_high_F"],
	[0.05, "I_G_HMG_02_F"],
	[0.03, "B_T_GMG_01_F"],
	[0.1, "Land_Bunker_01_big_F"],
	[0.55, "Land_BagFence_Round_F"],
	[0.55, "Land_BagFence_Corner_F"],
	[0.55, "Land_BagFence_End_F"],
	[0.55, "Land_BagFence_Short_F"],
	[0.55, "Land_BagFence_Long_F"],
	[0.65, "Land_BagBunker_Tower_F"],
	[0.3, "Land_PierLadder_F"],
	[0.2, "Land_A_Castle_Stairs_A"]

];


	if(["A3W_use_CUP", false] call getPublicVar) then {
		objectList append [
		[0.01, (CUP_Classes select {_x == "CUP_O_Metis_RU"}) select 0],
		[0.01, (CUP_Classes select {_x == "CUP_B_TOW_TriPod_USMC"}) select 0],
		[0.3, (CUP_Classes select {_x == "Fortress2"}) select 0],
		[0.01, (CUP_Classes select {_x == "CUP_O_Igla_AA_pod_ChDKZ"}) select 0],
		[0.23, (CUP_Classes select {_x == "WarfareBDepot"}) select 0],
		[0.5, (CUP_Classes select {_x == "WarfareBCamp"}) select 0],
		[0.2, (CUP_Classes select {_x == "CUP_O_ZU23_ChDKZ"}) select 0],
		[0.05, (CUP_Classes select {_x == "CUP_O_SPG9_ChDKZ"}) select 0],
		[0.1, (CUP_Classes select {_x == "CUP_O_DSHKM_ChDKZ"}) select 0],
		[0.03, (CUP_Classes select {_x == "CUP_O_AGS_ChDKZ"}) select 0],
		[1, (CUP_Classes select {_x == "TK_WarfareBBarrier10xTall_EP1"}) select 0],
		[1, (CUP_Classes select {_x == "Land_fort_rampart_EP1"}) select 0],
		[0.4, (CUP_Classes select {_x == "RampConcrete"}) select 0],
		[0.3, (CUP_Classes select {_x == "Land_ConcreteRamp"}) select 0]
		];
	};

call compile preprocessFileLineNumbers "modConfig\vehicleSpawnClasses.sqf";
