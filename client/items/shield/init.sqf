// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: init.sqf
//@file Author: MercyfulFate (script code), Nurdism (idea and some code), AryX
//@file Created: 04/01/2020
//@file Description: Initialisation of the shield (Create it)

MF_ITEMS_SHIELD = "shield";
MF_ITEMS_SHIELD_ICON = "client\icons\save.paa";

mf_shield_can_deploy	= [_this, "can_deploy.sqf"] call mf_compile;
mf_shield_deploy		= [_this, "deploy.sqf"] call mf_compile;

[MF_ITEMS_SHIELD, "Protective Shield", mf_shield_deploy, "", MF_ITEMS_SHIELD_ICON, 1, true] call mf_inventory_create;

mf_shield_can_pack		= [_this, "can_pack.sqf"] call mf_compile;
mf_shield_pack			= [_this, "pack.sqf"] call mf_compile;

[
  "shield-pack", 
  [
    format["<img image='%1'/> Pack shield", MF_ITEMS_SHIELD_ICON], mf_shield_pack, nil, 100, true, false, "", "([cursorObject] call mf_shield_can_pack == '')"
  ]
] call mf_player_actions_set;

