// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: can_pack.sqf
//@file Author: MercyfulFate (script code), Nurdism (idea and some code), AryX
//@file Created: 06/01/2020
//@file Description: Pack a Heli

#define ERR_ACT_NO_VEHICLE_HELI "Action Failed! No heli within the range."
#define ERR_ACT_PLAYER_IN_VEHICLE_HELI "Action Failed! Player is in heli."
#define ERR_ACT_IN_VEHICLE_HELI "Action Failed! You can't do this while being inside a vehicle."
#define ERR_ACT_TOO_MANY_HELI "Action Failed! You have too many heli bikes."
#define ERR_ACT_CANCELLED_HELI "Action Cancelled!"
#define ERR_ACT_NOT_FOR_PARCK_HELI "Cant pack this vehicle!"
#define ERR_ACT_NOT_FOR_PARCK_HELI_NOT_EMPTY "Heli not empty!"

params [["_target", objNull, [objNull]]];

private _error = "";

switch (true) do {
	case (isNull _target): { _error = ERR_ACT_NO_VEHICLE_HELI; };
	case ((count (crew _target) ) > 0):{ _error = ERR_ACT_NOT_FOR_PARCK_HELI_NOT_EMPTY; };
	case (vehicle player != player):{ _error = ERR_ACT_IN_VEHICLE_HELI; };
	case (!(_target isKindOf "C_Heli_Light_01_civil_F")):{ _error = "You cant pack this vehicle!"; };
	case (_target getVariable ["A3W_spawnedItemVehicleNotPack", true]):{ _error = ERR_ACT_NOT_FOR_PARCK_HELI; };
	case ((player distance _target) > 4): { _error = ERR_ACT_NO_VEHICLE_HELI; };
	case (!alive _target || !alive player): { _error = ERR_ACT_CANCELLED_HELI; };
	case (MF_ITEMS_HELI call mf_inventory_count > 0): { _error = ERR_ACT_TOO_MANY_HELI; };
	case (!isNull (driver _target) || !isNull (gunner _target) || !isNull (commander _target)): { _error = ERR_ACT_PLAYER_IN_VEHICLE_HELI; };
};

_error;
