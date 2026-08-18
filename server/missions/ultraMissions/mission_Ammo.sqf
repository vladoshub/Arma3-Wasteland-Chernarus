
if (!isServer) exitWith {};
#include "ultraMissionDefines.sqf";

private ["_vehicleClass", "_nbUnits"];

_setupVars = {
	_vehicleClass = selectRandom [
		"I_Truck_02_ammo_F"
	];

	_missionType = "HARD: Ammo";
	_locationsArray = UltraMissionSpawnMarkers;

	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_this call mission_UltraVehicleCapture;
