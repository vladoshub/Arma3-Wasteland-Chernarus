
if (!isServer) exitWith {};
#include "ultraMissionDefines.sqf";

private ["_vehicleClass", "_nbUnits", "_vars"];

_setupVars = {

	_vars = [
		"B_T_MBT_01_mlrs_F"
	];

	if(["A3W_use_CUP", false] call getPublicVar) then {
		_vars append [(CUP_Classes select {_x == "CUP_I_Hilux_armored_podnos_IND_G_F"})];
	};


	_vehicleClass = selectRandom _vars;


	_missionType = "HARD: Artillery and MLRS";
	_locationsArray = UltraMissionSpawnMarkers;

	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_this call mission_UltraVehicleCapture;
