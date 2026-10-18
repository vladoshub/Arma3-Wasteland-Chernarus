// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	Lootspawner junction lists for classes to spawn-/lootable items
//	Author: Na_Palm (BIS forums)
//-------------------------------------------------------------------------------------
// All item lists use ["classname", spawnChance] entries, with 1.0 as the default.
// Select one entry, then roll its 0..1 chance; failure leaves the slot empty (no reroll).
// Plain classname strings are still accepted with chance 1.0.
//here place Weapons an usable items (ex.: Binocular, ...)
//used with addWeaponCargoGlobal
//"lootWeapon_list" array of [class, [weaponlist]]
//                              class       : 0-civil, 1-military, ... (add more as you wish)
//                              weaponlist  : list of weapon class names
lootWeapon_list =
[
	[ // CIVIL
		0,
		[
			["arifle_MX_F", 1.0],
			["arifle_MXC_Black_F", 1.0],
			["arifle_MX_SW_F", 1.0],
			["arifle_MXM_Black_F", 1.0],
			["arifle_AK12_F", 1.0],
			["arifle_AKM_F", 1.0],
			["arifle_ARX_blk_F", 1.0],
			["arifle_SPAR_01_blk_F", 1.0],
			["arifle_SPAR_02_blk_F", 1.0],
			["arifle_Katiba_F", 1.0],
			["sgun_HunterShotgun_01_F", 1.0],
			["arifle_AKS_F", 1.0],
			["arifle_CTAR_blk_F", 1.0],
			["arifle_TRG20_F", 1.0],
			["arifle_Mk20C_F", 1.0],
			["arifle_Katiba_C_F", 1.0],
			["arifle_MSBS65_black_F", 1.0],
			["arifle_AK12U_F", 1.0],
			["arifle_MSBS65_Mark_black_F", 1.0],
			["SMG_03_TR_black", 1.0],
			["SMG_05_F", 1.0]
		]
	],
	[ // MILITARY
		1,
		[
			["arifle_MX_F", 1.0],
			["arifle_MXC_Black_F", 1.0],
			["arifle_MX_SW_F", 1.0],
			["arifle_MXM_Black_F", 1.0],
			["arifle_AK12_F", 1.0],
			["arifle_AKM_F", 1.0],
			["arifle_ARX_blk_F", 1.0],
			["arifle_SPAR_01_blk_F", 1.0],
			["arifle_SPAR_02_blk_F", 1.0],
			["arifle_Katiba_F", 1.0],
			["arifle_MX_GL_Black_F", 1.0],
			["arifle_AK12_GL_F", 1.0],
			["arifle_SPAR_01_GL_khk_F", 1.0],
			["arifle_CTAR_GL_ghex_F", 1.0],
			["arifle_TRG21_GL_F", 1.0],
			["arifle_Mk20_GL_F", 1.0],
			["arifle_Katiba_GL_F", 1.0],
			["arifle_MSBS65_GL_black_F", 1.0],
			["sgun_HunterShotgun_01_F", 1.0],
			["arifle_AKS_F", 1.0],
			["arifle_CTAR_blk_F", 1.0],
			["arifle_TRG20_F", 1.0],
			["arifle_Mk20C_F", 1.0],
			["arifle_Katiba_C_F", 1.0],
			["arifle_MSBS65_black_F", 1.0],
			["arifle_AK12U_F", 1.0],
			["arifle_MSBS65_Mark_black_F", 1.0],
			["arifle_MSBS65_UBS_black_F", 1.0],
			["LMG_Zafir_F", 1.0],
			["LMG_03_F", 1.0],
			["srifle_DMR_01_F", 1.0],					//rahim
			["srifle_EBR_F", 1.0],						//mk18
			["srifle_DMR_06_camo_F", 1.0],				//mk14
			["srifle_DMR_07_hex_F", 1.0],				//cmr
			["srifle_DMR_02_camo_F", 1.0],				//mar10
			["srifle_DMR_03_multicam_F", 1.0],			//mk-l
			["srifle_DMR_05_hex_F", 1.0],				//cyrus
			["launch_Titan_F", 1.0],
			["launch_Titan_short_F", 1.0],
			["launch_RPG7_F", 1.0]
		]
	],
	[ // INDUSTRIAL
		2,
		[
			["arifle_MX_F", 1.0],
			["arifle_MXC_Black_F", 1.0],
			["arifle_MX_SW_F", 1.0],
			["arifle_MXM_Black_F", 1.0],
			["arifle_AK12_F", 1.0],
			["arifle_AKM_F", 1.0],
			["arifle_ARX_blk_F", 1.0],
			["arifle_SPAR_01_blk_F", 1.0],
			["arifle_SPAR_02_blk_F", 1.0],
			["arifle_Katiba_F", 1.0],
			["sgun_HunterShotgun_01_F", 1.0],
			["arifle_AKS_F", 1.0],
			["arifle_CTAR_blk_F", 1.0],
			["arifle_TRG20_F", 1.0],
			["arifle_Mk20C_F", 1.0],
			["arifle_Katiba_C_F", 1.0],
			["arifle_MSBS65_black_F", 1.0],
			["arifle_AK12U_F", 1.0],
			["arifle_MSBS65_Mark_black_F", 1.0],
			["SMG_03_TR_black", 1.0],
			["SMG_05_F", 1.0]
		]
	],
	[ // RESEARCH
		3,
		[
			["arifle_MX_GL_Black_F", 1.0],
			["arifle_AK12_GL_F", 1.0],
			["arifle_SPAR_01_GL_khk_F", 1.0],
			["arifle_CTAR_GL_ghex_F", 1.0],
			["arifle_TRG21_GL_F", 1.0],
			["arifle_Mk20_GL_F", 1.0],
			["arifle_Katiba_GL_F", 1.0],
			["arifle_MSBS65_GL_black_F", 1.0]
		]
	]
];

//here place magazines, weaponattachments and bodyitems(ex.: ItemGPS, ItemMap, Medikit, FirstAidKit, Binoculars, ...)
//used with addMagazineCargoGlobal
//"lootMagazine_list" array of [class, [magazinelist]]
//                              class       : 0-civil, 1-military, ... (add more as you wish)
//                              magazinelist: list of magazine class names
lootMagazine_list =
[
	[ // CIVIL
		0,
		[
			//["16Rnd_9x21_Mag", 1.0],
			["9Rnd_45ACP_Mag", 1.0],
			["30Rnd_9x21_Mag", 1.0],
			["30Rnd_45ACP_Mag_SMG_01_tracer_green", 1.0],
			["30Rnd_556x45_Stanag_Tracer_Yellow", 1.0],
			["30Rnd_65x39_caseless_mag_Tracer", 1.0],
			["2Rnd_12Gauge_Pellets", 1.0],
			["30Rnd_65x39_caseless_green_mag_Tracer", 1.0]/*,
			["Chemlight_blue", 1.0],
			["Chemlight_green", 1.0],
			["Chemlight_red", 1.0],
			["Chemlight_yellow", 1.0]*/
		]
	],
	[ // MILITARY
		1,
		[
			["100Rnd_65x39_caseless_mag", 1.0],
			["100Rnd_65x39_caseless_mag_Tracer", 1.0],
			["150Rnd_762x51_Box", 1.0],
			["150Rnd_762x51_Box_Tracer", 1.0],
			//["16Rnd_9x21_Mag", 1.0],
			["1Rnd_HE_Grenade_shell", 1.0],
			["1Rnd_Smoke_Grenade_shell", 1.0],
			["SmokeShell", 1.0],
			["SmokeShellPurple", 1.0],
			["SmokeShellBlue", 1.0],
			["SmokeShellGreen", 1.0],
			["SmokeShellYellow", 1.0],
			["SmokeShellOrange", 1.0],
			["SmokeShellRed", 1.0],
			["200Rnd_65x39_cased_Box", 1.0],
			["200Rnd_65x39_cased_Box_Tracer", 1.0],
			["20Rnd_556x45_UW_mag", 1.0],
			["20Rnd_762x51_Mag", 1.0],
			["30Rnd_65x39_caseless_msbs_mag", 1.0],
			["6Rnd_12Gauge_Slug", 1.0],
			["20Rnd_762x51_Mag", 1.0],
			["30Rnd_45ACP_Mag_SMG_01", 1.0],
			["30Rnd_45ACP_Mag_SMG_01", 1.0],
			["30Rnd_556x45_Stanag", 1.0],
			["30Rnd_556x45_Stanag_Tracer_Yellow", 1.0],
			["30Rnd_65x39_caseless_green", 1.0],
			["30Rnd_65x39_caseless_green_mag_Tracer", 1.0],
			["30Rnd_65x39_caseless_mag", 1.0],
			["30Rnd_65x39_caseless_mag_Tracer", 1.0],
			["30Rnd_9x21_Mag", 1.0],
			["30Rnd_9x21_Mag", 1.0],
			/*"3Rnd_HE_Grenade_shell",
			["3Rnd_SmokeBlue_Grenade_shell", 1.0],
			["3Rnd_SmokeGreen_Grenade_shell", 1.0],
			["3Rnd_SmokeOrange_Grenade_shell", 1.0],
			["3Rnd_SmokePurple_Grenade_shell", 1.0],
			["3Rnd_SmokeRed_Grenade_shell", 1.0],
			["3Rnd_SmokeYellow_Grenade_shell", 1.0],
			["3Rnd_Smoke_Grenade_shell", 1.0],*/
			["5Rnd_127x108_Mag", 1.0],
			["7Rnd_408_Mag", 1.0],
			["9Rnd_45ACP_Mag", 1.0],
			["9Rnd_45ACP_Mag", 1.0],
			["APERSBoundingMine_Range_Mag", 1.0],
			["APERSMine_Range_Mag", 1.0],
			["APERSTripMine_Wire_Mag", 1.0],
			["ATMine_Range_Mag", 1.0],
			/*"Chemlight_blue",
			["Chemlight_green", 1.0],
			["Chemlight_red", 1.0],
			["Chemlight_yellow", 1.0],*/
			["ClaymoreDirectionalMine_Remote_Mag", 1.0],
			["HandGrenade", 1.0],
			["MiniGrenade", 1.0],
			["SatchelCharge_Remote_Mag", 1.0],
			["SLAMDirectionalMine_Wire_Mag", 1.0]
		]
	],
	[ // INDUSTRIAL
		2,
		[
			["30Rnd_9x21_Mag", 1.0],
			["30Rnd_45ACP_Mag_SMG_01", 1.0],
			["30Rnd_556x45_Stanag", 1.0],
			["30Rnd_556x45_Stanag_Tracer_Yellow", 1.0],
			["30Rnd_65x39_caseless_green", 1.0],
			["30Rnd_65x39_caseless_msbs_mag", 1.0],
			["6Rnd_12Gauge_Pellets", 1.0],
			["30Rnd_65x39_caseless_green_mag_Tracer", 1.0],
			["30Rnd_65x39_caseless_mag", 1.0],
			["30Rnd_65x39_caseless_mag_Tracer", 1.0]/*,
			["Chemlight_blue", 1.0],
			["Chemlight_green", 1.0],
			["Chemlight_red", 1.0],
			["Chemlight_yellow", 1.0]*/
		]
	],
	[ // RESEARCH
		3,
		[
			["20Rnd_556x45_UW_mag", 1.0],
			["30Rnd_556x45_Stanag", 1.0],
			["30Rnd_556x45_Stanag", 1.0],
			["30Rnd_65x39_caseless_mag", 1.0],
			["2Rnd_12Gauge_Slug", 1.0],
			["30Rnd_65x39_caseless_mag", 1.0],
			["30Rnd_65x39_caseless_green", 1.0],
			["30Rnd_65x39_caseless_green", 1.0],
			["5Rnd_127x108_Mag", 1.0],
			["7Rnd_408_Mag", 1.0]
		]
	]
];

//here place hats, glasses, clothes, uniforms, vests
//used with addItemCargoGlobal
//"lootItem_list" array of [class, [itemlist]]
//                              class       : 0-civil, 1-military, ... (add more as you wish)
//                              itemlist    : list of item class names
lootItem_list =
[
	[ // CIVIL
		0,
		[
			["acc_flashlight", 1.0],
			["FirstAidKit", 1.0],
			["FirstAidKit", 1.0],
			["FirstAidKit", 1.0],
			["muzzle_snds_acp", 1.0],                  // .45 ACP
			["muzzle_snds_L", 1.0],                    // 9mm
			["optic_Aco", 1.0],
			["optic_ACO_grn", 1.0],
			["optic_aco_smg", 1.0],
			["optic_Holosight", 1.0],
			["optic_Holosight_smg", 1.0]
		]
	],
	[ // MILITARY
		1,
		[
			["acc_flashlight", 1.0],
			["acc_pointer_IR", 1.0],
			["FirstAidKit", 1.0],
			["ItemGPS", 1.0],
			["Medikit", 1.0],
			["muzzle_snds_acp", 1.0],                  // .45 ACP
			["muzzle_snds_B", 1.0],                    // 7.62mm
			["muzzle_snds_H", 1.0],                    // 6.5mm
			["muzzle_snds_H_MG", 1.0],                 // 6.5mm LMG
			["muzzle_snds_L", 1.0],                    // 9mm
			["muzzle_snds_M", 1.0],                    // 5.56mm
			["NVGoggles", 1.0],
			//["NVGoggles_INDEP", 1.0],
			//["NVGoggles_OPFOR", 1.0],
			["optic_Aco", 1.0],
			["optic_ACO_grn", 1.0],
			["optic_aco_smg", 1.0],
			["optic_Arco", 1.0],
			["optic_Hamr", 1.0],
			["optic_Holosight", 1.0],
			["optic_Holosight_smg", 1.0],
			["optic_SOS", 1.0],
			["ToolKit", 1.0],
			["H_HelmetB", 1.0],
			["H_CrewHelmetHeli_B", 1.0], //BY VLADOS
			["H_HelmetIA", 1.0],
			["H_HelmetO_ocamo", 1.0],
			["V_PlateCarrier1_rgr", 1.0],
			["V_PlateCarrierIA1_dgtl", 1.0],
			["V_HarnessO_brn", 1.0]
		]
	],
	[ // INDUSTRIAL
		2,
		[
			["FirstAidKit", 1.0],
			["FirstAidKit", 1.0],
			["Medikit", 1.0],
			["ToolKit", 1.0],
			["ToolKit", 1.0]
		]
	],
	[ // RESEARCH
		3,
		[
			["FirstAidKit", 1.0],
			["FirstAidKit", 1.0],
			["FirstAidKit", 1.0],
			["ItemGPS", 1.0],
			["Medikit", 1.0],
			["NVGoggles", 1.0],
			//["NVGoggles_INDEP", 1.0],
			//["NVGoggles_OPFOR", 1.0],
			//["optic_Nightstalker", 1.0],
			["optic_NVS", 1.0],
			["optic_SOS", 1.0],
			["V_RebreatherB", 1.0]
		]
	]
];

//here place backpacks, parachutes and packed drones/stationary
//used with addBackpackCargoGlobal
//"lootBackpack_list" array of [class, [backpacklist]]
//                              class       : 0-civil, 1-military, ... (add more as you wish)
//                              backpacklist: list of backpack class names
lootBackpack_list =
[
	[ // CIVIL
		0,
		[
			["B_FieldPack_blk", 1.0],
			["B_FieldPack_cbr", 1.0],
			["B_FieldPack_khk", 1.0],
			["B_FieldPack_oucamo", 1.0]
		]
	],
	[ // MILITARY
		1,
		[
			["B_FieldPack_blk", 1.0],
			["B_FieldPack_cbr", 1.0],
			["B_FieldPack_khk", 1.0],
			["B_FieldPack_oucamo", 1.0],
			["B_Kitbag_cbr", 1.0],
			["B_Kitbag_rgr", 1.0],
			["B_Kitbag_mcamo", 1.0],
			["B_Kitbag_sgg", 1.0],
			["B_Bergen_blk", 1.0],
			["B_Bergen_rgr", 1.0],
			["B_Bergen_mcamo", 1.0],
			["B_Bergen_sgg", 1.0],
			["B_Carryall_khk", 1.0],
			["B_Carryall_mcamo", 1.0],
			["B_Carryall_oli", 1.0],
			["B_Carryall_oucamo", 1.0]
		]
	],
	[ // INDUSTRIAL
		2,
		[
			["B_FieldPack_blk", 1.0],
			["B_FieldPack_cbr", 1.0],
			["B_FieldPack_khk", 1.0],
			["B_FieldPack_oucamo", 1.0],
			["B_Kitbag_cbr", 1.0],
			["B_Kitbag_rgr", 1.0],
			["B_Kitbag_mcamo", 1.0],
			["B_Kitbag_sgg", 1.0]
		]
	],
	[ // RESEARCH
		3,
		[
			["B_FieldPack_blk", 1.0],
			["B_FieldPack_cbr", 1.0],
			["B_FieldPack_khk", 1.0],
			["B_FieldPack_oucamo", 1.0],
			["B_Kitbag_cbr", 1.0],
			["B_Kitbag_rgr", 1.0],
			["B_Kitbag_mcamo", 1.0],
			["B_Kitbag_sgg", 1.0],
			["B_Bergen_blk", 1.0],
			["B_Bergen_rgr", 1.0],
			["B_Bergen_mcamo", 1.0],
			["B_Bergen_sgg", 1.0],
			["B_Carryall_khk", 1.0],
			["B_Carryall_mcamo", 1.0],
			["B_Carryall_oli", 1.0],
			["B_Carryall_oucamo", 1.0]
		]
	]
];

//here place any other objects(ex.: Land_Basket_F, Box_East_Wps_F, Land_Can_V3_F, ...)
//used with createVehicle directly
//"lootworldObject_list" array of [class, [objectlist]]
//                              class       : 0-civil, 1-military, ... (add more as you wish)
//                              objectlist  : list of worldobject class names
lootworldObject_list =
[
	[ // CIVIL
		0,
		[
			["Land_BakedBeans_F", 1.0],                // food
			["Land_BakedBeans_F", 1.0],                // food
			["Land_BottlePlastic_V2_F", 1.0],          // water
			["Land_BottlePlastic_V2_F", 1.0],          // water
			//["Land_Can_V3_F", 1.0],                    // energydrink
			["Land_Suitcase_F", 1.0],                  // repairkit
			["Land_CanisterOil_F", 1.0],               // syphon hose
			["Land_CanisterFuel_F", 1.0]               // jerrycan
		]
	],
	[ // MILITARY
		1,
		[
			["Land_BakedBeans_F", 1.0],                // food
			["Land_BottlePlastic_V2_F", 1.0],          // water
			//["Land_Can_V3_F", 1.0],                    // energydrink
			["Land_Suitcase_F", 1.0],                  // repairkit
			["Land_CanisterOil_F", 1.0],               // syphon hose
			["Land_CanisterFuel_F", 1.0]               // jerrycan
		]
	],
	[ // INDUSTRIAL
		2,
		[
			["Land_BakedBeans_F", 1.0],                // food
			["Land_BottlePlastic_V2_F", 1.0],          // water
			//["Land_Can_V3_F", 1.0],                    // energydrink
			["Land_Suitcase_F", 1.0],                  // repairkit
			["Land_Suitcase_F", 1.0],                  // repairkit
			["Land_CanisterOil_F", 1.0],               // syphon hose
			["Land_CanisterOil_F", 1.0],               // syphon hose
			["Land_CanisterFuel_F", 1.0],              // jerrycan
			["Land_CanisterFuel_F", 1.0]               // jerrycan
		]
	],
	[ // RESEARCH
		3,
		[
			["Land_BakedBeans_F", 1.0],                // food
			["Land_BottlePlastic_V2_F", 1.0],          // water
			//["Land_Can_V3_F", 1.0],                    // energydrink
			["Land_Suitcase_F", 1.0],                  // repairkit
			["Land_CanisterOil_F", 1.0],               // syphon hose
			["Land_CanisterFuel_F", 1.0]               // jerrycan
		]
	]
];
