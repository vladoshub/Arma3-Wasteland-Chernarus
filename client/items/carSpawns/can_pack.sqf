// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: can_pack.sqf
//@file Author: MercyfulFate (script code), Nurdism (idea and some code), AryX
//@file Created: 06/01/2020
//@file Description: Pack a Car

#define ERR_ACT_NO_VEHICLE_CAR "Action Failed! No car within the range."
#define ERR_ACT_PLAYER_IN_VEHICLE_CAR "Action Failed! Player is in car."
#define ERR_ACT_IN_VEHICLE_CAR "Action Failed! You can't do this while being inside a vehicle."
#define ERR_ACT_TOO_MANY_CAR "Action Failed! You have too many car bikes."
#define ERR_ACT_CANCELLED_CAR "Action Cancelled!"
#define ERR_ACT_NOT_FOR_PARCK_CAR "Cant pack this vehicle!"
#define ERR_ACT_NOT_FOR_PARCK_CAR_NOT_EMPTY "Car not empty!"

params [["_target", objNull, [objNull]]];

private _error = "";

switch (true) do {
	case (isNull _target): { _error = ERR_ACT_NO_VEHICLE_CAR; };
	case ((count (crew _target) ) > 0):{ _error = ERR_ACT_NOT_FOR_PARCK_CAR_NOT_EMPTY; };
	case (vehicle player != player):{ _error = ERR_ACT_IN_VEHICLE_CAR; };
	case (!(_target isKindOf "C_Hatchback_01_sport_F")):{ _error = "You cant pack this vehicle!"; };
	case (_target getVariable ["A3W_spawnedItemVehicleNotPack", true]):{ _error = ERR_ACT_NOT_FOR_PARCK_CAR; };
	case ((player distance _target) > 4): { _error = ERR_ACT_NO_VEHICLE_CAR; };
	case (!alive _target || !alive player): { _error = ERR_ACT_CANCELLED_CAR; };
	case (MF_ITEMS_CAR call mf_inventory_count > 0): { _error = ERR_ACT_TOO_MANY_CAR; };
	case (!isNull (driver _target) || !isNull (gunner _target) || !isNull (commander _target)): { _error = ERR_ACT_PLAYER_IN_VEHICLE_CAR; };
};

_error;
