// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: storeOwners.sqf
//	@file Author: AgentRev, JoSchaap, His_Shadow

// Notes: Gun and general stores have position of spawned crate, vehicle stores have an extra air spawn direction
//
// Array contents are as follows:
// Name, Building Position, Desk Direction (or [Desk Direction, Front Offset]), Excluded Buttons
storeOwnerConfig = compileFinal str
[
	["GenStore1", -1, [], []],
	["GenStore3", -1, [], []],
	["GenStore4", -1, [], []],
	["GenStore5", -1, [], []],
	["GenStore8", -1, [], []],
	["GenStore10", -1, [], []],
	["GenStore11", -1, [], []],
	["GenStore12", -1, [], ["Objects"]],
	["GenStore13", -1, [], []],
	["GenStore14", -1, [], []],
	["GenStore15", -1, [], []],

	["GunStore3", -1, [], []],
	["GunStore4", -1, [], []],
	["GunStore6", -1, [], []],
	["GunStore9", -1, [], []],
	["GunStore10", -1, [], ["Armament"]],
	["GunStore11", -1, [], []],
	["GunStore12", -1, [], []],
	["GunStore13", -1, [], []],

	// Buttons you can disable: "Land", "Armored", "Tanks", "Helicopters", "Boats", "Planes"
	["VehStore1", -1, [], ["Boats"]],
	["VehStore2", -1, [], ["Boats"]],
	["VehStore3", -1, [], ["Boats"]],
	["VehStore5", -1, [], ["Land", "Armored", "Tanks", "Planes", "Helicopters"]],
	["VehStore7", -1, [], ["Planes", "Boats"]],
	["VehStore9", -1, [], ["Planes", "Boats"]],
	["VehStore10", -1, [], []],
	["VehStore12", -1, [], ["Boats"]],
	["VehStore13", -1, [], ["Boats"]],
	["VehStore14", -1, [], ["Boats", "Planes", "Helicopters"]],
	["VehStore15", -1, [], ["Boats"]],
	["VehStore16", -1, [], ["Land", "Armored", "Tanks"]],
	["VehStore17", -1, [], ["Planes", "Boats"]],
	["VehStore18", -1, [], ["Land", "Armored", "Tanks", "Planes", "Helicopters"]],
	["VehStore19", -1, [], ["Planes"]]
	// ["VehStore7", -1, [], ["Planes","Boats","Helicopters"]]
];
// Auf neue Skins warten
// Outfits for store owners
storeOwnerConfigAppearance = compileFinal str
[
	["GenStore1", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_01_formal_F"]]],
	["GenStore3", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_01_formal_F"]]],
	["GenStore4", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_01_formal_F"]]],
	["GenStore5", [["weapon", ""], ["uniform", "U_I_E_CBRN_Suit_01_EAF_F"]]],
	["GenStore8", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_01_formal_F"]]],
	["GenStore10", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_01_formal_F"]]],
	["GenStore11", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_01_formal_F"]]],
	["GenStore12", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_01_formal_F"]]],
	["GenStore13", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_01_formal_F"]]],
	["GenStore14", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_01_formal_F"]]],
	["GenStore15", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_01_formal_F"]]],

	["GunStore3", [["weapon", ""], ["uniform", "U_I_E_Uniform_01_F"]]],
	["GunStore4", [["weapon", ""], ["uniform", "U_I_E_Uniform_01_officer_F"]]],
	["GunStore6", [["weapon", ""], ["uniform", "U_I_E_Uniform_01_F"]]],
	["GunStore9", [["weapon", ""], ["uniform", "U_I_E_Uniform_01_officer_F"]]],
	["GunStore10", [["weapon", ""], ["uniform", "U_I_E_Uniform_01_officer_F"]]],
	["GunStore11", [["weapon", ""], ["uniform", "U_I_E_Uniform_01_officer_F"]]],
	["GunStore12", [["weapon", ""], ["uniform", "U_I_E_Uniform_01_officer_F"]]],
	["GunStore13", [["weapon", ""], ["uniform", "U_I_E_Uniform_01_officer_F"]]],

	["VehStore1", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_02_formal_F"]]],
	["VehStore2", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_02_formal_F"]]],
	["VehStore3", [["weapon", ""], ["uniform", "U_C_CBRN_Suit_01_Blue_F"]]],
	["VehStore5", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_02_formal_F"]]],
	["VehStore7", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_02_formal_F"]]],
	["VehStore9", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_02_formal_F"]]],
	["VehStore10", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_02_formal_F"]]],
	["VehStore12", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_02_formal_F"]]],
	["VehStore13", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_02_formal_F"]]],
	["VehStore14", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_02_formal_F"]]],
	["VehStore15", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_02_formal_F"]]],
	["VehStore16", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_02_formal_F"]]],
	["VehStore17", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_02_formal_F"]]],
	["VehStore18", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_02_formal_F"]]],
	["VehStore19", [["weapon", ""], ["uniform", "U_C_Uniform_Scientist_02_formal_F"]]]
];
