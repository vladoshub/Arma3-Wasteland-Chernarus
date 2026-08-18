// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: can_pack.sqf
//@file Author: MercyfulFate (script code), Nurdism (idea and some code), AryX
//@file Created: 06/01/2020
//@file Description: Pack a Shield

#define ERR_ACT_NO_VEHICLE "Action Failed! No shield within the range."
#define ERR_ACT_PLAYER_IN_VEHICLE "Action Failed! Player is in shield bike."
#define ERR_ACT_TOO_MANY "Action Failed! You have too many shields."
#define ERR_ACT_CANCELLED "Action Cancelled!"
#define ERR_ACT_NOT_FOR_PARCK "Cant pack this shield!"
#define ERR_ACT_NOT_FOR_PARCK_NOT_EMPTY "Shield not empty!"

params [["_target", objNull, [objNull]]];

private _error = "";

switch (true) do {
	case (isNull _target): { _error = ERR_ACT_NO_VEHICLE; };
	case (!(_target isKindOf "Land_Mil_WallBig_corner_battered_F")):{ _error = "You cant pack this vehicle!"; };
	case (_target getVariable ["A3W_spawnedItemVehicleNotPack", true]):{ _error = ERR_ACT_NOT_FOR_PARCK; };
	case ((player distance _target) > 4): { _error = ERR_ACT_NO_VEHICLE; };
	case (!alive _target || !alive player): { _error = ERR_ACT_CANCELLED; };
	case (MF_ITEMS_SHIELD call mf_inventory_count > 0): { _error = ERR_ACT_TOO_MANY; };
};

_error;
