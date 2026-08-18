// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: pack.sqf
//@file Author: MercyfulFate (script code), Nurdism (idea and some code), AryX
//@file Created: 06/01/2020
//@file Description: Pack a Car

#define ERR_CANCELLED "Action Cancelled"

#define SPEED 12
#define ANIMATION "AinvPknlMstpSlayWrflDnon_medic"

_target = cursorObject;

_checks = {
	_this params ["_progress", "_target"];
	_text = [_target] call mf_car_can_pack;
	_failed = true;

	if (doCancelAction) then { _text = ERR_CANCELLED; };
	if (_text == "") then {
		_text = format["Packing Car %1%2 Complete", round(100 * _progress), "%"];
		_failed = false;
	};

	[_failed, _text];
};

_done = [SPEED, ANIMATION, _checks, [_target]] call a3w_actions_start;

if (_done) then {
	deleteVehicle _target;
	[MF_ITEMS_CAR, 1] call mf_inventory_add;
};

_done;