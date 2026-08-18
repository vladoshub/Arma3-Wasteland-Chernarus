// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: init.sqf
//@file Author: MercyfulFate (script code), Nurdism (idea and some code), AryX
//@file Created: 04/01/2020
//@file Description: Initialisation of the Quad (Create it)

MF_ITEMS_QUAD = "quad";
MF_ITEMS_QUAD_ICON = "client\icons\quad.paa";

mf_quad_can_deploy	= [_this, "can_deploy.sqf"] call mf_compile;
mf_quad_deploy		= [_this, "deploy.sqf"] call mf_compile;

[MF_ITEMS_QUAD, "Offroad Quad Bike", mf_quad_deploy, "", MF_ITEMS_QUAD_ICON, 1, true] call mf_inventory_create;

mf_quad_can_pack		= [_this, "can_pack.sqf"] call mf_compile;
mf_quad_pack			= [_this, "pack.sqf"] call mf_compile;

[
  "quad-pack", 
  [
    format["<img image='%1'/> Pack Quad bike", MF_ITEMS_QUAD_ICON], mf_quad_pack, nil, 100, true, false, "", "([cursorObject] call mf_quad_can_pack == '')"
  ]
] call mf_player_actions_set;


//player addAction[format["<img image='%1'/> Spawn Quad bike", MF_ITEMS_QUAD_ICON], "'quad' call mf_inventory_use", [], -5, false, false, '','( (MF_ITEMS_QUAD call mf_inventory_count > 0) && player == vehicle player)'];