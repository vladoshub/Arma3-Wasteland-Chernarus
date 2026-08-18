sleep 60;
while {true} do
{
	{ deleteVehicle _x; } forEach (allMissionObjects "Land_R_rock_general2");
	{ deleteVehicle _x; } forEach (allMissionObjects "Land_ShellCrater_02_debris_F");
	{ deleteVehicle _x; } forEach (allMissionObjects "Land_BluntStones_erosion");
	{ deleteVehicle _x; } forEach (allMissionObjects "Land_SharpStones_erosion");
	{ deleteVehicle _x; } forEach (allMissionObjects "Land_W_sharpStones_erosion");

	{ deleteVehicle _x; } forEach (allMissionObjects "Land_SharpStone_02");
	{ deleteVehicle _x; } forEach (allMissionObjects "Land_W_sharpStone_02");
	{ deleteVehicle _x; } forEach (allMissionObjects "Land_SharpStone_01");
	{ deleteVehicle _x; } forEach (allMissionObjects "Land_W_sharpStone_01");
	{ deleteVehicle _x; } forEach (allMissionObjects "Land_LavaStone_big_F");
	{ deleteVehicle _x; } forEach (allMissionObjects "Land_LavaStone_small_F");

	//{ deleteVehicle _x; } forEach (allMissionObjects "Land_ShellCrater_02_decal_F");

	sleep 1200;
};
