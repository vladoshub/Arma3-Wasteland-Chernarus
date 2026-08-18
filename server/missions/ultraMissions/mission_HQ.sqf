
if (!isServer) exitWith {};
#include "ultraMissionDefines.sqf";

private ["_vehicleClass", "_nbUnits"];

_setupVars = {

	_MissionHQs = [
		"B_T_VTOL_01_armed_olive_F",
		"B_T_APC_Tracked_01_rcws_F",
		"B_T_APC_Wheeled_01_cannon_F"
	];

	if(["A3W_use_CUP", false] call getPublicVar) then {
		_MissionHQs append [
			(CUP_Classes select {_x == "CUP_O_BTR90_HQ_RU"}),
			(CUP_Classes select {_x == "CUP_B_BRDM2_HQ_CDF"}),
			(CUP_Classes select {_x == "CUP_B_BMP_HQ_CDF"})
		];
	};

	_vehicleClass = selectRandom _MissionHQs;

	_missionType = "HARD: Spawn vehicle (HQ)";
	_locationsArray = UltraMissionSpawnMarkers;

	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_this call mission_UltraVehicleCapture;
