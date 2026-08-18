// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: init.sqf
//@file Author: MercyfulFate (script code), Nurdism (idea and some code), AryX
//@file Created: 04/01/2020
//@file Description: Initialisation of the Car (Create it)

MF_ITEMS_CAR = "carSpawns";
MF_ITEMS_CAR_ICON = "client\icons\car.paa";

mf_car_can_deploy	= [_this, "can_deploy.sqf"] call mf_compile;
mf_car_deploy		= [_this, "deploy.sqf"] call mf_compile;

[MF_ITEMS_CAR, "Car", mf_car_deploy, "", MF_ITEMS_CAR_ICON, 1, true] call mf_inventory_create;

mf_car_can_pack		= [_this, "can_pack.sqf"] call mf_compile;
mf_car_pack			= [_this, "pack.sqf"] call mf_compile;

[
  "car-pack", 
  [
    format["<img image='%1'/> Pack Car", MF_ITEMS_CAR_ICON], mf_car_pack, nil, 100, true, false, "", "([cursorObject] call mf_car_can_pack == '')"
  ]
] call mf_player_actions_set;
