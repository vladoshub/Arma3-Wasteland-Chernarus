// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: deploy.sqf
//@file Author: MercyfulFate (script code), Nurdism (idea and some code), AryX
//@file Created: 05/01/2020
//@file Description: Deploy a Heli

#define DURATION 45
#define ANIMATION "AinvPknlMstpSlayWrflDnon_medic"
#define ERR_CANCELLED "Action Cancelled"

_check = {
	_this params ["_progress"];
	_text = [] call mf_heli_can_deploy;
	_failed = true;

	if (doCancelAction) then  { _text = ERR_CANCELLED; };
	if (_text == "") then {
		_text = format["Deploying Heli is at %1%2", round(100 * _progress), "%"];
		_failed = false;
	};

	[_failed, _text];
};

_done = [DURATION, ANIMATION, _check, []] call a3w_actions_start;

if (_done) then {
	_class = "C_Heli_Light_01_civil_F";
	_uid = getPlayerUID player;
	_heliSpawns = createVehicle [_class, [player, [0,3,0]] call relativePos, [], 0, "CAN_COLLIDE"];
	clearItemCargo _heliSpawns;
	_heliSpawns setDir (getDir player);
	_heliSpawns setVariable ["ownerUID", _uid, true];
	_heliSpawns setVariable ["ownerName", name player, true];
	_heliSpawns setVariable ["A3W_notForSale", true, true];
	_heliSpawns setVariable ["A3W_spawnedItemVehicleNotPack", false, true];
	_heliSpawns setVariable ["A3W_notForParking", true, true];
	// player moveInDriver _quad;
};

_done;