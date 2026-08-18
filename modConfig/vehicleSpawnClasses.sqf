// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: vehicleSpawnClasses.sqf
//	@file Author: AgentRev

A3W_smallVehicles =
[
	"C_Quadbike_01_F",
	"C_Hatchback_01_sport_F",
	"C_SUV_01_F",
	"B_MRAP_01_F",
	["B_Quadbike_01_F", "O_Quadbike_01_F", "I_Quadbike_01_F", "I_G_Quadbike_01_F"],
	["C_Offroad_01_F", "I_G_Offroad_01_F"],
	["C_Offroad_02_unarmed_F", "I_C_Offroad_02_unarmed_F"]
];

	if(["A3W_use_CUP", false] call getPublicVar) then {
		A3W_smallVehicles append [
		(CUP_Classes select {_x == "CUP_I_SUV_UNO"}) select 0,
		(CUP_Classes select {_x == "CUP_I_TT650_NAPA"}) select 0,
		(CUP_Classes select {_x == "CUP_C_Ural_Civ_02"}) select 0,
		(CUP_Classes select {_x == "CUP_HMMWV_Unarmed_Base"}) select 0,
		(CUP_Classes select {_x == "CUP_I_V3S_Covered_TKG"}) select 0
		];
	};

//Civilian Vehicle List - Random Spawns
civilianVehicles =
[
	["C_Van_01_box_F", "C_Van_01_transport_F"],
	"C_Hatchback_01_F"
];


	if(["A3W_use_CUP", false] call getPublicVar) then {
		civilianVehicles append [
		(CUP_Classes select {_x == "CUP_C_Ikarus_TKC"}) select 0,
    	(CUP_Classes select {_x == "CUP_C_Skoda_White_CIV"}) select 0,
		(CUP_Classes select {_x == "CUP_C_Volha_CR_CIV"}) select 0,
		(CUP_Classes select {_x == "CUP_C_Octavia_CIV"}) select 0,
    	(CUP_Classes select {_x == "CUP_C_Lada_White_CIV"}) select 0,
		(CUP_Classes select {_x == "CUP_C_Bus_City_CRCIV"}) select 0,
		(CUP_Classes select {_x == "CUP_C_S1203_CIV_CR"}) select 0,
		(CUP_Classes select {_x == "CUP_I_V3S_Open_TKG"}) select 0,
    	(CUP_Classes select {_x == "CUP_C_Golf4_black_Civ"}) select 0,
    	(CUP_Classes select {_x == "CUP_O_LR_Transport_TKA"}) select 0,
		(CUP_Classes select {_x == "CUP_C_UAZ_Unarmed_TK_CIV"}) select 0,
		(CUP_Classes select {_x == "CUP_B_S1203_Ambulance_CR"}) select 0
		];
	};

//Light Military Vehicle List - Random Spawns
lightMilitaryVehicles =
[
	["I_G_Offroad_01_armed_F", "I_C_Offroad_02_LMG_F"],
	["I_G_Offroad_01_AT_F",    "I_C_Offroad_02_AT_F"]

];


	if(["A3W_use_CUP", false] call getPublicVar) then {
		lightMilitaryVehicles append [
		(CUP_Classes select {_x == "CUP_O_BTR40_TKA"}) select 0,
    	(CUP_Classes select {_x == "CUP_B_Ural_CDF"}) select 0,
    	(CUP_Classes select {_x == "CUP_I_Datsun_PK"}) select 0,

		(CUP_Classes select {_x == "CUP_O_GAZ_Vodnik_PK_RU"}) select 0,
		(CUP_Classes select {_x == "CUP_B_UAZ_SPG9_CDF"}) select 0,
		(CUP_Classes select {_x == "CUP_O_BTR40_MG_TKA"}) select 0,
		(CUP_Classes select {_x == "CUP_B_Jackal2_L2A1_GB_W"}) select 0,
		(CUP_Classes select {_x == "CUP_B_HMMWV_SOV_M2_USA"}) select 0,
		(CUP_Classes select {_x == "CUP_I_Datsun_PK_Random"}) select 0,
		(CUP_Classes select {_x == "CUP_B_UAZ_MG_CDF"}) select 0,
		(CUP_Classes select {_x == "CUP_B_HMMWV_DSHKM_GPK_ACR"}) select 0,
		(CUP_Classes select {_x == "CUP_B_HMMWV_M2_USA"}) select 0
		];

	};

//Medium Military Vehicle List - Random Spawns
mediumMilitaryVehicles =
[
    "O_APC_Wheeled_02_rcws_v2_F",
    "I_MRAP_03_gmg_F",
   // "I_LT_01_AT_F",
   // "I_APC_Wheeled_03_cannon_F",
	"I_Truck_02_medical_F",
	"I_Truck_02_ammo_F",
	"I_Truck_02_box_F",
	"I_Truck_02_fuel_F",
	"B_Heli_Light_01_dynamicLoadout_F",
	"O_Heli_Light_02_dynamicLoadout_F"
];


	if(["A3W_use_CUP", false] call getPublicVar) then {
		mediumMilitaryVehicles append [
		(CUP_Classes select {_x == "CUP_O_BTR90_RU"}) select 0,
    	//(CUP_Classes select {_x == "CUP_B_M7Bradley_USA_D"}) select 0,
		//(CUP_Classes select {_x == "CUP_O_T55_CHDKZ"}) select 0,
    	(CUP_Classes select {_x == "CUP_I_BMP1_TK_GUE"}) select 0,
    	(CUP_Classes select {_x == "CUP_B_BRDM2_ATGM_CDF"}) select 0,
    	//(CUP_Classes select {_x == "CUP_B_M6LineBacker_USA_W"}) select 0,
		(CUP_Classes select {_x == "CUP_B_FV510_GB_D"}) select 0,
    	(CUP_Classes select {_x == "CUP_B_HMMWV_Avenger_USMC"}) select 0,
    	//(CUP_Classes select {_x == "CUP_B_M1135_ATGMV_Desert"}) select 0,
		//(CUP_Classes select {_x == "CUP_I_Ka60_Blk_ION"}) select 0,
    	(CUP_Classes select {_x == "CUP_B_AH6J_USA"}) select 0,
		(CUP_Classes select {_x == "CUP_B_Ural_Repair_CDF"}) select 0,
    	(CUP_Classes select {_x == "CUP_B_UAZ_METIS_CDF"}) select 0,
    	(CUP_Classes select {_x == "CUP_I_T34_TK_GUE"}) select 0,
    	//(CUP_Classes select {_x == "CUP_B_LAV25_USMC"}) select 0,
    	//(CUP_Classes select {_x == "CUP_B_Ural_Reammo_CDF"}) select 0,
    	//(CUP_Classes select {_x == "CUP_O_Mi24_D_Dynamic_SLA"}) select 0,
		(CUP_Classes select {_x == "CUP_B_BMP2_CDF"}) select 0,
    	(CUP_Classes select {_x == "CUP_I_Datsun_AA_Random"}) select 0,
    	//(CUP_Classes select {_x == "CUP_O_BMP3_RU"}) select 0,
		(CUP_Classes select {_x == "CUP_B_Ural_Refuel_CDF"}) select 0,
    	(CUP_Classes select {_x == "CUP_I_SUV_Armored_ION"}) select 0,
    	(CUP_Classes select {_x == "CUP_I_Hilux_BMP1_NAPA"}) select 0,
		(CUP_Classes select {_x == "CUP_B_ZSU23_CDF"}) select 0,
		(CUP_Classes select {_x == "CUP_O_BTR60_TK"}) select 0,
		(CUP_Classes select {_x == "CUP_B_BRDM2_CDF"}) select 0,
		(CUP_Classes select {_x == "CUP_O_GAZ_Vodnik_BPPU_RU"}) select 0
		];
	};

//Water Vehicles - Random Spawns
waterVehicles =
[
	"C_Scooter_Transport_01_F",
	"C_Boat_Civil_01_F",
	//"C_Boat_Civil_01_F",
	["C_Boat_Civil_01_police_F", "C_Boat_Civil_01_rescue_F"],
	["C_Boat_Transport_02_F", "I_C_Boat_Transport_02_F"]
];

//Object List - Random Spawns.
staticWeaponsList =
[
	"B_Mortar_01_F",
	"O_Mortar_01_F",
	"I_Mortar_01_F",
	"I_G_Mortar_01_F"
];

//Object List - Random Helis.
staticHeliList =
[
	"C_Heli_Light_01_civil_F",
	"B_Heli_Light_01_F",
	"O_Heli_Light_02_unarmed_F",
	"I_Heli_light_03_unarmed_F"
	// don't put cargo helicopters here, it doesn't make sense to find them in towns; they spawn in the CivHeli mission
]; //heliSpawn_


staticJetList =
[
	"B_UAV_02_dynamicLoadout_F",
	"I_Plane_Fighter_03_dynamicLoadout_F",
	"O_Plane_CAS_02_dynamicLoadout_F",
	"C_Plane_Civil_01_racing_F",
	"C_Plane_Civil_01_F"
]; //jetSpawn_


	if(["A3W_use_CUP", false] call getPublicVar) then {
		staticJetList append [
		(CUP_Classes select {_x == "CUP_B_SU34_CDF"}) select 0,
    	(CUP_Classes select {_x == "CUP_I_T34_TK_GUE"}) select 0,
    	(CUP_Classes select {_x == "CUP_B_Su25_Dyn_CDF"}) select 0,
		(CUP_Classes select {_x == "CUP_B_L39_CZ"}) select 0,
    	(CUP_Classes select {_x == "CUP_O_AN2_TK"}) select 0,
    	(CUP_Classes select {_x == "CUP_C_AN2_CIV"}) select 0
		];
	};

staticTankList =
[
	"O_APC_Tracked_02_AA_F",
	"I_MBT_03_cannon_F",
	"B_APC_Tracked_01_AA_F",
	"B_MBT_01_TUSK_F",
	"B_APC_Tracked_01_rcws_F"
]; //tankSpawn_


	if(["A3W_use_CUP", false] call getPublicVar) then {
		staticTankList append [
		(CUP_Classes select {_x == "CUP_O_T90_RU"}) select 0,
    	(CUP_Classes select {_x == "CUP_I_T34_TK_GUE"}) select 0,
    	(CUP_Classes select {_x == "CUP_B_M1A1_DES_US_Army"}) select 0,
		(CUP_Classes select {_x == "CUP_B_Challenger2_Desert_BAF"}) select 0,
    	(CUP_Classes select {_x == "CUP_B_ZSU23_CDF"}) select 0,
    	(CUP_Classes select {_x == "CUP_O_2S6M_RU"}) select 0
		];
	};

//Object List - Random Planes.
staticPlaneList =
[
	"C_Plane_Civil_01_F",
	"C_Plane_Civil_01_racing_F",
	"I_Plane_Fighter_03_dynamicLoadout_F"
];

	if(["A3W_use_CUP", false] call getPublicVar) then {
		staticPlaneList append [
		(CUP_Classes select {_x == "CUP_B_L39_CZ"}) select 0
		];
	};


A3W_planeSpawnOdds = 0.25; // 0.0 to 1.0

//Random Weapon List - Change this to what you want to spawn in cars.
vehicleWeapons =
[
	"arifle_ARX_ghex_F",
	"hgun_PDW2000_F",
    "SMG_05_F",
    "SMG_03C_black",
    "SMG_02_F",
	["SMG_03_TR_black", "SMG_03C_TR_black"],
	["arifle_TRG20_F", "arifle_TRG21_F", "arifle_TRG21_GL_F"],
	["arifle_Mk20C_F", "arifle_Mk20_F", "arifle_Mk20_GL_F"],
	"launch_Titan_F",
	"launch_Titan_short_F",
	"launch_RPG7_F",
    "arifle_MXC_F",
    "arifle_AKS_F",
    "arifle_Mk20_F",
    "arifle_TRG21_F",
    "arifle_Katiba_F",
    "arifle_MX_F",
    "arifle_CTAR_blk_F", 
    "arifle_AKM_F",
    "arifle_AK12U_F",
    "arifle_AK12_arid_F",
    "arifle_MSBS65_F", 
    "arifle_Mk20_GL_plain_F",
    "arifle_TRG21_GL_F",
    "arifle_MX_GL_F",
    "arifle_CTAR_GL_blk_F",
    "arifle_MSBS65_GL_F", 
    "arifle_AK12_GL_F",
    "arifle_MXM_Black_F"
];

	if(["A3W_use_CUP", false] call getPublicVar) then {
		vehicleWeapons append [
    	(CUP_Classes select {_x == "CUP_launch_Metis"}) select 0,
    	(CUP_Classes select {_x == "CUP_launch_Javelin"}) select 0,
		(CUP_Classes select {_x == "CUP_lmg_M240"}) select 0,
		(CUP_Classes select {_x == "CUP_srifle_CZ550_rail"}) select 0,
    	(CUP_Classes select {_x == "CUP_srifle_M40A3"}) select 0,
    	(CUP_Classes select {_x == "CUP_arifle_AS_VAL"}) select 0,
		(CUP_Classes select {_x == "CUP_srifle_AS50"}) select 0,
    	(CUP_Classes select {_x == "CUP_arifle_RPK74_45"}) select 0,
    	(CUP_Classes select {_x == "CUP_lmg_M60E4"}) select 0,
    	(CUP_Classes select {_x == "CUP_lmg_PKM"}) select 0,
    	(CUP_Classes select {_x == "CUP_lmg_Pecheneg_woodland"}) select 0,
		(CUP_Classes select {_x == "CUP_glaunch_M79"}) select 0,
		(CUP_Classes select {_x == "CUP_glaunch_M32"}) select 0,
		(CUP_Classes select {_x == "CUP_arifle_G36A"}) select 0,
		(CUP_Classes select {_x == "CUP_arifle_AK109_GL_railed"}) select 0,
		(CUP_Classes select {_x == "CUP_arifle_AK108_GL_railed"}) select 0,
		(CUP_Classes select {_x == "CUP_arifle_AK107_GL_railed"}) select 0,
		(CUP_Classes select {_x == "CUP_sgun_AA12"}) select 0,
		(CUP_Classes select {_x == "CUP_arifle_XM8_Carbine_GL"}) select 0,
		(CUP_Classes select {_x == "CUP_arifle_Mk17_CQC"}) select 0,
		(CUP_Classes select {_x == "CUP_arifle_M16A4_Base"}) select 0,
		(CUP_Classes select {_x == "CUP_arifle_M4A3_black"}) select 0,
		(CUP_Classes select {_x == "CUP_arifle_Mk17_CQC_SFG"}) select 0,
		(CUP_Classes select {_x == "CUP_arifle_Sa58RIS2_gl"}) select 0,
		(CUP_Classes select {_x == "CUP_arifle_M16A2_GL"}) select 0,
		(CUP_Classes select {_x == "CUP_srifle_M14_DMR"}) select 0,
		(CUP_Classes select {_x == "CUP_srifle_ksvk"}) select 0,
		(CUP_Classes select {_x == "CUP_launch_Mk153Mod0"}) select 0,
		(CUP_Classes select {_x == "CUP_arifle_AK107_GL_pso"}) select 0,
		(CUP_Classes select {_x == "CUP_srifle_SVD"}) select 0,
		(CUP_Classes select {_x == "CUP_srifle_VSSVintorez_pso"}) select 0

		];
	};

vehicleAddition =
[
	"muzzle_snds_M", // 5.56mm
	"muzzle_snds_58_blk_F", // 5.8mm
	"muzzle_snds_H", // 6.5mm
	"muzzle_snds_H_MG", // 6.5mm LMG
	"muzzle_snds_B", // 7.62mm
	"optic_Arco",
	"optic_ERCO_blk_F",
	"optic_DMS",
	"optic_ico_01_black_f",
	"muzzle_snds_B_khk_F", 
	"muzzle_snds_58_wdm_F",
	"muzzle_snds_65_TI_hex_F",
	"optic_MRD",
	"CUP_optic_PSO_1",
    "optic_MRD_black",
    "muzzle_snds_L",
    "optic_aco_smg",
    "optic_ACO_grn_smg",
    "optic_Holosight_smg",
    "muzzle_snds_acp",
    "optic_Aco",
    "optic_Aco_grn",
    "optic_Holosight",
    "optic_Holosight_khk_F",
    "optic_Holosight_smg_khk_F", 
    "optic_Holosight_blk_F", 
    "optic_Holosight_blk_khk_F",
    "optic_Holosight_arid_F",
    "optic_Holosight_lush_F",
	"Chemlight_blue",
	"Chemlight_green",
	"Chemlight_yellow",
	"Chemlight_red",
	"FirstAidKit"
];

vehicleAddition2 =
[
	// "Chemlight_blue",
	// "Chemlight_green",
	// "Chemlight_yellow",
	// "Chemlight_red"
];