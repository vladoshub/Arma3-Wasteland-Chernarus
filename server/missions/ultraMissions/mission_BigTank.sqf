
if (!isServer) exitWith {};
#include "ultraMissionDefines.sqf";

private ["_vehicleClass", "_nbUnits"];

_setupVars = {

	_vehicleClass = selectRandom
	[
		"O_MBT_02_railgun_F"
	];

	_missionType = "HARD: Super Tank";
	_locationsArray = UltraMissionSpawnMarkers;

	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_this call mission_UltraVehicleCapture;
