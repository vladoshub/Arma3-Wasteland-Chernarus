// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: customGroup.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private "_uPos";
private "_unit";

private _expAITown = (serverTime + 1500 + random[0, 300, 600]);
private _group = createGroup CIVILIAN;
_group setVariable ["expAITown", _expAITown, true];
private _pos = _this select 0;

private _nbUnits = param [1, 7, [0]];
private _mSize = _this select 2;

private _minusX = 1;
private _minusY = 1;

_mSize = sqrt _mSize;

private _unitTypes = [
	"C_man_polo_1_F", "C_man_polo_1_F_euro", "C_man_polo_1_F_afro", "C_man_polo_1_F_asia",
	"C_man_polo_2_F", "C_man_polo_2_F_euro", "C_man_polo_2_F_afro", "C_man_polo_2_F_asia",
	"C_man_polo_3_F", "C_man_polo_3_F_euro", "C_man_polo_3_F_afro", "C_man_polo_3_F_asia",
	"C_man_polo_4_F", "C_man_polo_4_F_euro", "C_man_polo_4_F_afro", "C_man_polo_4_F_asia",
	"C_man_polo_5_F", "C_man_polo_5_F_euro", "C_man_polo_5_F_afro", "C_man_polo_5_F_asia",
	"C_man_polo_6_F", "C_man_polo_6_F_euro", "C_man_polo_6_F_afro", "C_man_polo_6_F_asia"
];

private _unitUniforms = [
	"U_BG_Guerilla3_1", "U_B_ParadeUniform_01_US_F", "U_B_CBRN_Suit_01_Wdl_F", "U_B_CombatUniform_mcam_tshirt",
	"U_B_FullGhillie_ard", "U_B_GEN_Soldier_F", "U_C_CBRN_Suit_01_Blue_F",
	"U_C_ConstructionCoverall_Blue_F", "U_C_FormalSuit_01_black_F", "U_NikosAgedBody", "U_O_R_Gorka_01_F",
	"U_O_SpecopsUniform_ocamo", "U_O_Wetsuit", "U_C_Poloshirt_redwhite", "U_C_Driver_3",
	"U_B_PilotCoveralls"
];


for "_i" from 1 to _nbUnits do {
	
	if((random 1) < 0.5) then {
		_minusX = -1;
	} else {
		_minusX = 1;
	};

	if((random 1) > 0.5) then {
		_minusY = -1;
	} else {
		_minusY = 1;
	};
	
	_uPos = [(_pos select 0) + ((random [30, _mSize/2, _mSize]) * _minusX), (_pos select 1) + ((random [30, _mSize/2, _mSize]) * _minusY), 0];


	//_uPos set [0 , (_uPos select 0) + ((random [30, _mSize/2, _mSize]) * _minusX)];
	//_uPos set [1, (_uPos select 1) + ((random [30, _mSize/2, _mSize]) * _minusY)];
	//_uPos set [2, 0];


	_uPos = [_uPos, 3, 10, 1 ,0 ,0 ,0] call findSafePos;

	
	_unit = _group createUnit [selectRandom _unitTypes, _uPos, [], 0, "Form"];
	_unit setVariable ["expAIIUnitFlag", true, true];
	//_unit setVariable ["expAITown", _expAITown, true];
	
	_unit setPosATL _uPos;

	removeAllWeapons _unit;
	removeAllAssignedItems _unit;
	removeUniform _unit;
	removeVest _unit;
	removeBackpack _unit;
	//removeHeadgear _unit;
	//removeGoggles _unit;

	_unit addVest "V_PlateCarrier1_rgr";

	private _localUniform = selectRandom _unitUniforms;


	private _typeAI = floor (random 6);


	switch (_typeAI) do{
		// Grenadier every 3 units, starting from #2
		case 0: {
			_unit addUniform _localUniform;
			_unit addMagazine "1Rnd_HE_Grenade_shell";
			_unit addWeapon "arifle_TRG21_GL_F";
			_unit addMagazine "1Rnd_HE_Grenade_shell";
			_unit addMagazine "1Rnd_HE_Grenade_shell";
			_unit addMagazine "30Rnd_556x45_Stanag";
			_unit addMagazine "30Rnd_556x45_Stanag";
			_unit addMagazine "30Rnd_556x45_Stanag";
		};
		// AA every 5 units, starting from #5
		case 1: {
			_unit addUniform _localUniform;
			_unit addBackpack "B_Kitbag_mcamo";
			_unit addWeapon "arifle_TRG20_F";
			if((random 1) < 0.1) then {
				_unit addMagazine "Titan_AA";
				_unit addWeapon "launch_Titan_F";
			};

			if((random 1) < 0.2) then {
				_unit addMagazine "Titan_AA";
			};

			_unit addMagazine "30Rnd_556x45_Stanag";
			_unit addMagazine "30Rnd_556x45_Stanag";
			_unit addMagazine "30Rnd_556x45_Stanag";
		};
		// PCML every 6 units, starting from #6
		case 2: {
			_unit addUniform _localUniform;
			_unit addBackpack "B_Kitbag_mcamo";
			_unit addWeapon "arifle_TRG20_F";
			if((random 1) < 0.15) then {
				_unit addMagazine "Titan_AT";
				_unit addWeapon "launch_Titan_short_F";
			};

			if((random 1) < 0.2) then {
				_unit addMagazine "Titan_AT";
			};
			_unit addMagazine "30Rnd_556x45_Stanag";
			_unit addMagazine "30Rnd_556x45_Stanag";
			_unit addMagazine "30Rnd_556x45_Stanag";
		};
		// RPG-42 every 6 units, starting from #3
		case 3: {
			_unit addUniform _localUniform;
			_unit addBackpack "B_Kitbag_mcamo";
			_unit addWeapon "arifle_TRG20_F";
			_unit addMagazine "RPG32_F";
			_unit addWeapon "launch_RPG32_F";
			_unit addMagazine "30Rnd_556x45_Stanag";
			_unit addMagazine "30Rnd_556x45_Stanag";
			_unit addMagazine "30Rnd_556x45_Stanag";
		};
		case 4: {
			_unit addUniform _localUniform;
			_unit addBackpack "B_Kitbag_mcamo";
			_unit addMagazine "10Rnd_93x64_DMR_05_Mag";
			_unit addWeapon "srifle_DMR_05_hex_F";
			_unit addPrimaryWeaponItem "optic_DMS_ghex_F";
			_unit addMagazine "10Rnd_93x64_DMR_05_Mag";
		};
		case 5: {
			_unit addUniform _localUniform;
			_unit addBackpack "B_Kitbag_mcamo";
			_unit addWeapon "LMG_Zafir_F";
			_unit addMagazine "RPG32_F";
			_unit addWeapon "launch_RPG32_F";
			_unit addMagazine "150Rnd_762x54_Box";
		};
		// Rifleman
		default {
			_unit addUniform _localUniform;

			if (_unit isEqualTo leader _group) then {
				_unit addWeapon "arifle_TRG21_F";
				_unit setRank "SERGEANT";
			} else {
				_unit addWeapon "arifle_TRG20_F";
			};
		};
	};

	_unit addPrimaryWeaponItem "acc_flashlight";
	//_unit enableGunLights "forceOn";

	_unit addRating 1e11;
	_unit spawn addMilCap;
	_unit spawn refillPrimaryAmmo;
	_unit call setMissionSkill;
	_unit addEventHandler ["Killed", serverAiDiedMoneyDrop];
};

[_group, _pos] call defendArea;