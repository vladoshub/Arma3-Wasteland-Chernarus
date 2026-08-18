// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: init.sqf
//@file Author: MercyfulFate (script code), Nurdism (idea and some code), AryX
//@file Created: 04/01/2020
//@file Description: Initialisation of the Heli (Create it)

MF_ITEMS_HELI = "heliSpawns";
MF_ITEMS_HELI_ICON = "client\icons\heli.paa";

mf_heli_can_deploy	= [_this, "can_deploy.sqf"] call mf_compile;
mf_heli_deploy		= [_this, "deploy.sqf"] call mf_compile;

[MF_ITEMS_HELI, "Heli", mf_heli_deploy, "", MF_ITEMS_HELI_ICON, 1, true] call mf_inventory_create;

mf_heli_can_pack		= [_this, "can_pack.sqf"] call mf_compile;
mf_heli_pack			= [_this, "pack.sqf"] call mf_compile;

[
  "heli-pack", 
  [
    format["<img image='%1'/> Pack Heli ", MF_ITEMS_HELI_ICON], mf_heli_pack, nil, 100, true, false, "", "([cursorObject] call mf_heli_can_pack == '')"
  ]
] call mf_player_actions_set;
