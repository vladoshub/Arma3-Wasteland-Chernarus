// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: playerSetupStart.sqf
//	@file Author: [GoT] JoSchaap, AgentRev

private _player = _this;

_player setSkill 0;
{_player disableAI _x} foreach ["move","anim","target","autotarget"];
_player setVariable ["BIS_noCoreConversations", true];
_player setVariable ["A3W_corpseEjected", nil, true];
_player allowDamage false;
[_player, true] call fn_hideObjectGlobal;
_player disableTIEquipment false;
//_player enableSimulation false;

if (["A3W_unlimitedStamina"] call isConfigOn) then
{
	_player enableFatigue true; //BY_VLADOS
	_player enableStamina false;
	_player allowSprint true;
	_player setCustomAimCoef 0.3; //BY_VLADOS
};

// V2 takes priority when both stamina options are enabled.
if (["A3W_unlimitedStaminaV2"] call isConfigOn) then
{
	_player enableFatigue false;
	_player enableStamina false;
	_player enableAimPrecision true;
	_player allowSprint true;
};

enableSentences false;

removeAllWeapons _player;
//removeUniform _player; BY VLADOS
//removeVest _player;
removeBackpack _player;
//removeGoggles _player;
//removeHeadgear _player;
