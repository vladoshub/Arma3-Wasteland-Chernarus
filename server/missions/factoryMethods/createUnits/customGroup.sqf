// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: customGroup.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private "_uPos";
private "_unit";

private _group = _this select 0;
private _pos = _this select 1;
private _nbUnits = param [2, 7, [0]];
private _radius = param [3, 10, [0]];

private _unitTypes = [
	"C_man_polo_1_F", "C_man_polo_1_F_euro", "C_man_polo_1_F_afro", "C_man_polo_1_F_asia",
	"C_man_polo_2_F", "C_man_polo_2_F_euro", "C_man_polo_2_F_afro", "C_man_polo_2_F_asia",
	"C_man_polo_3_F", "C_man_polo_3_F_euro", "C_man_polo_3_F_afro", "C_man_polo_3_F_asia",
	"C_man_polo_4_F", "C_man_polo_4_F_euro", "C_man_polo_4_F_afro", "C_man_polo_4_F_asia",
	"C_man_polo_5_F", "C_man_polo_5_F_euro", "C_man_polo_5_F_afro", "C_man_polo_5_F_asia",
	"C_man_polo_6_F", "C_man_polo_6_F_euro", "C_man_polo_6_F_afro", "C_man_polo_6_F_asia"
];

for "_i" from 1 to _nbUnits do {
	_uPos = _pos vectorAdd ([[random _radius, 0, 0], random 360] call BIS_fnc_rotateVector2D);
	_unit = _group createUnit [selectRandom _unitTypes, _uPos, [], 0, "Form"];
	_unit setPosATL _uPos;

	removeAllWeapons _unit;
	removeAllAssignedItems _unit;
	removeUniform _unit;
	removeVest _unit;
	removeBackpack _unit;
	removeHeadgear _unit;
	removeGoggles _unit;
	_unit addVest "V_PlateCarrier1_rgr";

	switch (true) do {
		// Grenadier every 3 units, starting from #2
		case ((_i + 4) % 3 isEqualTo 0): {
			_unit addUniform "U_B_CombatUniform_mcam_vest";
			_unit addMagazine "1Rnd_HE_Grenade_shell";
			_unit addMagazines ["30Rnd_556x45_Stanag", 3];
			_unit addWeapon "arifle_TRG21_GL_F";
			_unit addMagazine "1Rnd_HE_Grenade_shell";
			_unit addMagazine "1Rnd_HE_Grenade_shell";
		};
		// Titan AT every 6 units, starting from #6
		case (_i % 6 isEqualTo 0): {
			_unit addUniform "U_B_CombatUniform_mcam_tshirt";
			_unit addBackpack "B_Kitbag_mcamo";
			_unit addMagazines ["30Rnd_556x45_Stanag", 3];
			_unit addWeapon "arifle_TRG20_F";
			_unit addMagazine "Titan_AT";
			_unit addWeapon "launch_Titan_short_F";
			_unit addMagazine "Titan_AT";
			_unit addMagazine "Titan_AT";
		};
		// RPG-42 every 6 units, starting from #3
		case ((_i + 3) % 6 isEqualTo 0): {
			_unit addUniform "U_B_CombatUniform_mcam_tshirt";
			_unit addBackpack "B_Kitbag_mcamo";
			[_unit, "LMG_Zafir_F", 3, "150Rnd_762x54_Box"] call BIS_fnc_addWeapon;
			_unit addPrimaryWeaponItem "optic_SOS";
			_unit addMagazine "RPG32_F";
			_unit addWeapon "launch_RPG32_F";
			_unit addMagazine "RPG32_F";
			_unit addMagazine "RPG32_F";
		};
		// Rifleman
		default {
			_unit addUniform "U_B_CombatUniform_mcam";
			private _isLeader = _unit isEqualTo leader _group;
			[_unit, "srifle_DMR_02_F", 7, "10Rnd_338_Mag"] call BIS_fnc_addWeapon;
			_unit addPrimaryWeaponItem "optic_AMS";
			if (_isLeader) then {
				_unit setRank "SERGEANT";
			};
		};
	};

	_unit addPrimaryWeaponItem "acc_flashlight";
	_unit enableGunLights "forceOn";

	_unit addRating 1e11;
	_unit spawn addMilCap;
	_unit spawn refillPrimaryAmmo;
	_unit call setMissionSkill;
	_unit addEventHandler ["Killed", server_playerDied];
	_unit addEventHandler ["Killed", serverAiMissionDiedMoneyDrop];
};

[_group, _pos] call defendArea;