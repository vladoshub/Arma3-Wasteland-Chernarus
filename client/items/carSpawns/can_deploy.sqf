// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: can_deplay.sqf
//@file Author: MercyfulFate (script code), Nurdism (idea and some code), AryX
//@file Created: 05/01/2020
//@file Description: Deploy Car

#define ERR_CANCELLED_CAR "Action Cancelled!"
#define ERR_IN_VEHICLE_CAR "Action Failed! You can't do this in a vehicle."
#define ERR_IN_ROCK_CAR "Action Failed! You cannot deploy a car in a Object or rock."
#define ERR_IN_BUILDING_CAR "Action Failed! You cannot deploy a car here."

#define ERR_NO_CAR "You don't have a car to deploy."

private _error = "";

private _nearFlagsCount = ({ _x getVariable ["is_base_flag_activate", false] } count (player nearObjects  ["FlagChecked_F", 320])); 

switch (true) do {
	case (vehicle player != player): { _error = ERR_IN_VEHICLE_CAR; };
	case (_nearFlagsCount > 0): { _error = ERR_IN_BUILDING_CAR; };
	case (!alive player): { _error = ERR_CANCELLED_CAR; };
	case (MF_ITEMS_CAR call mf_inventory_count < 1): { _error = ERR_NO_CAR; };
};

if ( _error == "") then {
	{
	switch (true) do {         
		case (((str _x) find "rock") != -1): { _error = ERR_IN_ROCK_CAR; };
		case (((str _x) find "stone") != -1): { _error = ERR_IN_ROCK_CAR; };
		case ((typeof _x) in ["Land_Carrier_01_base_F", "Land_Destroyer_01_base_F"]): { _error = ERR_IN_BUILDING_CAR; };
		case (_x isKindOf "HOUSE"): { _error = ERR_IN_BUILDING_CAR; };
	};
	if (_error != "") exitWith {};
	} forEach (lineIntersectsWith [getPosWorld player, getPosWorld player vectorAdd [0, 0, 50], player, objNull]);
};

_error;
