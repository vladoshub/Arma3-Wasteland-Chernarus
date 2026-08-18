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

private _soldierTypes = ["C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F"];
private _uniformTypes = ["U_B_HeliPilotCoveralls"];
private _vestTypes = ["V_PlateCarrier1_rgr","V_PlateCarrier2_rgr"];
private _backpackTypes = ["B_Parachute"];
private _weaponTypes = ["arifle_TRG20_F","LMG_Mk200_F","arifle_MXM_F","arifle_MX_GL_F"];

private _group = _this select 0;
private _position = _this select 1;

private _soldier = _group createUnit [selectRandom _soldierTypes, _position, [], 0, "NONE"];
_soldier addUniform (selectRandom _uniformTypes);
_soldier addVest (selectRandom _vestTypes);
_soldier addBackpack (selectRandom _backpackTypes);
_soldier addMagazine "HandGrenade";
[_soldier, selectRandom  _weaponTypes, 3] call BIS_fnc_addWeapon;

sleep 0.1; // Without this delay, headgear doesn't get removed properly

removeAllAssignedItems _soldier;
_soldier addHeadgear "H_PilotHelmetHeli_B";

_soldier spawn refillPrimaryAmmo;
_soldier call setMissionSkill;

_soldier addEventHandler ["Killed", server_playerDied];

_soldier
