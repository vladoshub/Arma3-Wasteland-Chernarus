// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: deploy.sqf
//@file Author: MercyfulFate (script code), Nurdism (idea and some code), AryX
//@file Created: 05/01/2020
//@file Description: Deploy a Car

#define DURATION 45
#define ANIMATION "AinvPknlMstpSlayWrflDnon_medic"
#define ERR_CANCELLED "Action Cancelled"

_check = {
	_this params ["_progress"];
	_text = [] call mf_car_can_deploy;
	_failed = true;

	if (doCancelAction) then  { _text = ERR_CANCELLED; };
	if (_text == "") then {
		_text = format["Deploying Car is at %1%2", round(100 * _progress), "%"];
		_failed = false;
	};

	[_failed, _text];
};

_done = [DURATION, ANIMATION, _check, []] call a3w_actions_start;

if (_done) then {
	_class = "C_Hatchback_01_sport_F";
	_uid = getPlayerUID player;
	_carSpawn = createVehicle [_class, [player, [0,3,0]] call relativePos, [], 0, "CAN_COLLIDE"];
	clearItemCargo _carSpawn;
	_carSpawn setDir (getDir player);
	_carSpawn setVariable ["ownerUID", _uid, true];
	_carSpawn setVariable ["ownerName", name player, true];
	_carSpawn setVariable ["A3W_notForSale", true, true];
	_carSpawn setVariable ["A3W_spawnedItemVehicleNotPack", false, true];
	_carSpawn setVariable ["A3W_notForParking", true, true];
	// player moveInDriver _quad;
};

_done;