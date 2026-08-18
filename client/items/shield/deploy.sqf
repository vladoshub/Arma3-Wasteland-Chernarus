// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: deploy.sqf
//@file Author: MercyfulFate (script code), Nurdism (idea and some code), AryX
//@file Created: 05/01/2020
//@file Description: Deploy a Shield

#define DURATION 3
#define ANIMATION "AinvPknlMstpSlayWrflDnon_medic"
#define ERR_CANCELLED "Action Cancelled"

_check = {
	_this params ["_progress"];
	_text = [] call mf_shield_can_deploy;
	_failed = true;

	if (doCancelAction) then  { _text = ERR_CANCELLED; };
	if (_text == "") then {
		_text = format["Deploying Shield is at %1%2", round(100 * _progress), "%"];
		_failed = false;
	};

	[_failed, _text];
};

_done = [DURATION, ANIMATION, _check, []] call a3w_actions_start;

//Land_HBarrier1

//Land_Mil_WallBig_Corner_F
//Land_Mil_WallBig_corner_battered_F

if (_done) then {
	_class = "Land_Mil_WallBig_corner_battered_F";
	_uid = getPlayerUID player;
	_shield = createVehicle [_class, [player, [0,2,-2]] call relativePos, [], 0, "CAN_COLLIDE"];
	clearItemCargo _shield;
	_shield setDir (getDir player);
	_shield setVariable ["ownerUID", _uid, true];
	_shield setVariable ["ownerName", name player, true];
	_shield setVariable ["A3W_notForSale", true, true];
	_shield setVariable ["A3W_spawnedItemVehicleNotPack", false, true];
	_shield setVariable ["R3F_LOG_disabled", true, true];
	_shield setVariable ["A3W_notForParking", true, true];
	_shield allowDamage true;
	_shield setVariable ["allowDamage", true, true];
	// player moveInDriver _quad;
};

_done;