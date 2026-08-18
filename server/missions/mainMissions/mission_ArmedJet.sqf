// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_ArmedHeli.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitWith {};
#include "mainMissionDefines.sqf";

private "_vehicleClass";
private "_nbUnits";
private "_vars";

_setupVars =
{	
	_vars = [
		"B_T_VTOL_01_armed_F",
		"B_Plane_CAS_01_dynamicLoadout_F",
		["O_T_VTOL_02_infantry_dynamicLoadout_F", "xianAntiInf"],
		"O_Plane_CAS_02_dynamicLoadout_F",
		["I_Plane_Fighter_03_dynamicLoadout_F", "variant_buzzardCAS"]
	];

	if(["A3W_use_CUP", false] call getPublicVar) then {
		_vars append [
			(CUP_Classes select {_x == "CUP_B_SU34_CDF"}) select 0,
			(CUP_Classes select {_x == "CUP_B_Su25_Dyn_CDF"}) select 0,
			(CUP_Classes select {_x == "CUP_B_F35B_BAF"}) select 0,
			(CUP_Classes select {_x == "CUP_B_L39_CZ"}) select 0,
			(CUP_Classes select {_x == "CUP_B_A10_DYN_USA"}) select 0,
			(CUP_Classes select {_x == "CUP_B_AV8B_DYN_USMC"}) select 0
		];
	};




	_vehicleClass = selectRandom _vars;
	_missionType = "MIDDLE: Armed Jet";
	_locationsArray = MissionSpawnMarkers;

	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_this call mission_VehicleCapture;
