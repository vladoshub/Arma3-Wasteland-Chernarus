// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: can_pack.sqf
//@file Author: MercyfulFate (script code), Nurdism (idea and some code), AryX
//@file Created: 06/01/2020
//@file Description: Pack a Quad

#define ERR_ACT_NO_VEHICLE "Action Failed! No quad bike within the range."
#define ERR_ACT_PLAYER_IN_VEHICLE "Action Failed! Player is in quad bike."
#define ERR_ACT_IN_VEHICLE "Action Failed! You can't do this while being inside a vehicle."
#define ERR_ACT_TOO_MANY "Action Failed! You have too many quad bikes."
#define ERR_ACT_CANCELLED "Action Cancelled!"
#define ERR_ACT_NOT_FOR_PARCK "Cant pack this vehicle!"
#define ERR_ACT_NOT_FOR_PARCK_NOT_EMPTY "Quad not empty!"

params [["_target", objNull, [objNull]]];

private _error = "";

switch (true) do {
	case (isNull _target): { _error = ERR_ACT_NO_VEHICLE; };
	case ((count (crew _target) ) > 0):{ _error = ERR_ACT_NOT_FOR_PARCK_NOT_EMPTY; };
	case (vehicle player != player):{ _error = ERR_ACT_IN_VEHICLE; };
	case (!(_target isKindOf "I_G_Quadbike_01_F")):{ _error = "You cant pack this vehicle!"; };
	case (_target getVariable ["A3W_spawnedItemVehicleNotPack", true]):{ _error = ERR_ACT_NOT_FOR_PARCK; };
	case ((player distance _target) > 4): { _error = ERR_ACT_NO_VEHICLE; };
	case (!alive _target || !alive player): { _error = ERR_ACT_CANCELLED; };
	case (MF_ITEMS_QUAD call mf_inventory_count > 0): { _error = ERR_ACT_TOO_MANY; };
	case (!isNull (driver _target) || !isNull (gunner _target) || !isNull (commander _target)): { _error = ERR_ACT_PLAYER_IN_VEHICLE; };
};

_error;
