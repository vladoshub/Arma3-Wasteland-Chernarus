//Configuration for Airdrop Assistance
//Author: Apoc

// APOC_AA_coolDownTime = 180; //Expressed in sec

APOC_AA_VehOptions = [
	["Ifrit", "O_MRAP_02_F", 45000, "vehicle"],
	["Hunter", "B_MRAP_01_F", 65000, "vehicle"],
	["Assault Boat", "I_C_Boat_Transport_01_F", 264000, "vehicle"],
	["MB 4WD LMG", "I_C_Offroad_02_LMG_F", 180000, "vehicle"],
	["Qilin Minigun", "O_T_LSV_02_armed_F", 600000, "vehicle"],
	["MB 4WD AT", "I_C_Offroad_02_AT_F", 1000000, "vehicle"],
	["Ifrit HMG", "O_MRAP_02_hmg_F", 1360000, "vehicle"],
	["HEMTT Ammo", "B_Truck_01_ammo_F", 6000000, "vehicle"]
];

APOC_AA_Veh2Options = [
	["Hunter HMG", "B_MRAP_01_hmg_F", 600000, "vehicle2"],
	["Hunter GMG", "B_MRAP_01_gmg_F", 160000, "vehicle2"],
	["AFV-4 Gorgon", "I_APC_Wheeled_03_cannon_F", 2700000, "vehicle2"],
	["ZSU-39 Tigris AA", "O_APC_Tracked_02_AA_F", 4200000, "vehicle2"],
	["T-100 Varsuk", "O_MBT_02_cannon_F", 4200000, "vehicle2"],
	["AMV-7 Marshall (HQ)", "B_T_APC_Wheeled_01_cannon_F", 5800000, 'vehicle']
	// ["Rhino MGS UP", "B_AFV_Wheeled_01_up_cannon_F", 95000, "vehicle2"]
	// ["MBT-52 Kuma", "I_MBT_03_cannon_F", 170000, "vehicle2"]
];

APOC_AA_Veh3Options = [
	["Offroad", "C_Offroad_01_F", 60000, "vehicle3"],
	["HEMTT Flatbed", "B_T_Truck_01_flatbed_F", 135000, "vehicle3"]
];

APOC_AA_Veh4Options = [
	["M-900 LittleBird", "C_Heli_Light_01_civil_F", 300000, "vehicle4"],
	["PO-30 Orca (DAGR)", "O_Heli_Light_02_dynamicLoadout_F", 1775000, "vehicle4"],
	["Mi-48 Kajman Delta", "O_Heli_Attack_02_dynamicLoadout_F", 3000000, "vehicle4"],
	["A-143 Buzzard", "I_Plane_Fighter_03_dynamicLoadout_F", 3500000, "vehicle4"],
	["F/A-181 Black Wasp", "B_Plane_Fighter_01_F", 5000000, "vehicle4"],
	["V-44 X Blackfish Armed (HQ)", "B_T_VTOL_01_armed_olive_F", 7300000, "vehicle4"]
];


APOC_AA_SupOptions = [
	["Contact DLC Box", "mission_DLC_contact", 680000, "supply"],
	["Assault Rifles", "mission_Assault1", 600000, "supply"],
	["Dive Gear", "mission_Gear_Diving", 600000, "supply"],
	["Machine Guns", "mission_LMGs1", 772500, "supply"],
	["Marksmen DLC Box", "mission_DLC_marks", 772500, "supply"],
	["Sniper Rifles", "mission_Snipers2", 872500, "supply"],
	["Sniper Rifles #2", "mission_Snipers3", 872500, "supply"],
	["Apex DLC Box", "mission_DLC_apex", 872500, "supply"],
	["Launchers", "mission_Launchers1", 1862500, "supply"]
];


APOC_AA_Base_one = [
	["Base blocks (walls)", [[["Land_HBarrier_3_F", 4], ["Land_HBarrierWall6_F", 2]], "Land_Cargo40_white_F"], 200000, "base"],
	["Base blocks (bunkers)", [[["Land_BagBunker_Small_F", 1], ["Land_BagBunker_Large_F", 1], ["Land_HBarrier_3_F", 1], ["Land_HBarrierTower_F", 1]], "Land_Cargo40_white_F"], 300000, "base"],
	["Base blocks (humps)", [[["Dirthump_3_F", 2]], "Land_Cargo40_white_F"], 350000, "base"], 
	["Food and Water", [[["Land_Sacks_goods_F", 2], ["Land_BarrelWater_F", 3]], "Land_CargoBox_V1_F"], 500000, "base"],
	["Mobile ATM", [[["Land_Atm_01_malden_F", 1]], "Land_Cargo40_white_F"], 3825000, "base"],
	["Object Factory", [[["Land_SCF_01_shredder_F", 1]], "Land_Cargo40_white_F"], 6225000, "base"],
	["Mobile parking", [[["Land_i_Garage_V1_F", 1]], "Land_Cargo40_white_F"], 6500000, "base"],
	["Base flag", [[["FlagChecked_F", 1]], "Land_Cargo40_white_F"], 8500000, "base"]
	//["Base blocks (walls)", "block", 150000, "base"],
	//["Base blocks (bunkers)", "block", 200000, "baseBunker"],
//	["Base blocks 2", "block", 200000, "base1"],
//	["Base blocks 3", "block", 200000, "base2"]
];



/*
	["Launchers #1","mission_Launchers1",1,"supply"], 
	["Launchers #2","mission_Launchers2",1,"supply"],
	["Launchers #3","mission_Launchers3",1,"supply"],
	["LMGs Box","mission_LMGs1",1,"supply"],
	["Weapons Box #1","mission_Weapon1",1,"supply"],
	["Weapons Box #2","mission_Weapon2",1,"supply"],
	["Weapons Box #3","mission_Weapon3",1,"supply"],
	["Weapon_camo *New Box","mission_Weapon_camo",1,"supply"],
	["Weapon_green *New Box","mission_Weapon_green",1,"supply"],
	["Weapon_tropic *New Box","mission_Weapon_tropic",1,"supply"],
	["Weapon_sand *New Box","mission_Weapon_sand",1,"supply"],
	["Sniper Box #1","mission_Snipers1",1,"supply"],
	["Sniper Box #2","mission_Snipers2",1,"supply"],
	["Sniper Box #3","mission_Snipers3",1,"supply"],
	["Sniper Box #4","mission_Snipers4",1,"supply"],
	["DLC Marksmen Box","mission_DLC_marks",1,"supply"],
	["DLC Apex Box","mission_DLC_apex",1,"supply"],
	["DLC Contact Box","mission_DLC_contact",1,"supply"],
	["Cop Box","mission_Gear_Cop",1,"supply"],
	["Ammo Box","mission_Gear_Ammo",1,"supply"],
	["Diving Box","mission_Gear_Diving",1,"supply"],
	["Black Box","mission_Gear_BlackBox",1,"supply"],
	["Hunter *New Box","mission_Gear_Hunter",1,"supply"],
	["Biohazard *New Box","mission_Gear_Biohazard",1,"supply"],
	["Night *New Box","mission_Gear_Night",1,"supply"]
	["Random XL *New Box","mission_Gear_RandomXL",1,"supply"],
	["Random XS *New Box","mission_Gear_RandomXS",1,"supply"]
*/