
if (!isServer) exitWith {};
#include "ultraMissionDefines.sqf";

private ["_vehicleClass", "_nbUnits"];

_setupVars = {
	_vehicleClass = selectRandom [
		"B_Radar_System_01_F",
		"B_Radar_System_02_F",
		"B_AAA_System_01_F",
		"B_SAM_System_03_F",
		"O_SAM_System_04_F",
		"Land_i_Garage_V1_F",
		"Land_SCF_01_shredder_F",
		"Land_Atm_01_malden_F",
		"FlagChecked_F",
		"Land_ConcreteWall_01_l_gate_F",
		"Land_PierConcrete_01_16m_F",
		"Land_Pier_Box_F",
		"Land_Bunker_01_big_F",
		"land_bunker_garage"
		//"B_Truck_01_box_F"
	];

	_missionType = "HARD: Protective systems and Base Parts";
	_locationsArray = UltraMissionSpawnMarkers;

	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_this call mission_ObjectCapture;

