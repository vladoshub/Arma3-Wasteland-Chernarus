// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: createRandomSoldier.sqf
/*
 * Creates a random civilian soldier.
 *
 * Arguments: [ position, group, init, skill, rank]: Array
 *    position: Position - Location unit is created at.
 *    group: Group - Existing group new unit will join.
 *    init: String - (optional, default "") Command to be executed upon creation of unit. Parameter this is set to the created unit and passed to the code.
 *    skill: Number - (optional, default 0.5)
 *    rank: String - (optional, default "PRIVATE")
 */

if (!isServer) exitWith {};

private _soldierTypes = ["C_man_polo_1_F", "C_man_polo_2_F", "C_man_polo_3_F", "C_man_polo_4_F", "C_man_polo_5_F", "C_man_polo_6_F"];
private _uniformTypes = ["U_IG_Guerilla1_1","U_IG_Guerilla2_3","U_IG_Guerilla2_1"];
private _vestTypes = ["V_BandollierB_oli","V_HarnessOGL_brn"];
private _weaponTypes = ["arifle_MXM_khk_F","arifle_MXM_F","arifle_MXM_Black_F"];

private _group = _this select 0;
private _position = _this select 1;
private _rank = param [2, "", [""]];

private _soldier = _group createUnit [selectRandom _soldierTypes, _position, [], 0, "NONE"];
_soldier addUniform (selectRandom _uniformTypes);
_soldier addVest (selectRandom _vestTypes);
[_soldier, selectRandom _weaponTypes, 3] call BIS_fnc_addWeapon;
_soldier addPrimaryWeaponItem "optic_Arco";

if (_rank != "") then {
	_soldier setRank _rank;
};

_soldier spawn refillPrimaryAmmo;
_soldier spawn addMilCap;
_soldier call setMissionSkillConvoy;

_soldier addEventHandler ["Killed", server_playerDied];

_soldier
