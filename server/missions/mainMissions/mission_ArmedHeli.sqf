// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_ArmedHeli.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitWith {};
#include "mainMissionDefines.sqf";

private ["_vehicleClass", "_nbUnits", "_vars"];

_setupVars =
{


	_vars = [
		["O_Heli_Attack_02_dynamicLoadout_F", "KajmanAG"],
		["O_Heli_Attack_02_dynamicLoadout_F", "KajmanDelta"],
		"B_Heli_Attack_01_dynamicLoadout_F",
		["O_Heli_Light_02_dynamicLoadout_F", "orcaDAGR"],
		"O_Heli_Attack_02_dynamicLoadout_F",
		"I_Heli_light_03_dynamicLoadout_F"
	];

	
	if(["A3W_use_CUP", false] call getPublicVar) then {
		_vars append [
			(CUP_Classes select {_x == "CUP_O_Mi24_D_Dynamic_SLA"}) select 0,
			(CUP_Classes select {_x == "CUP_O_Ka52_RU"}) select 0,
			(CUP_Classes select {_x == "CUP_I_Ka60_Blk_ION"}) select 0,
			(CUP_Classes select {_x == "CUP_B_AH64_DL_USA"}) select 0,
			(CUP_Classes select {_x == "CUP_O_Ka50_DL_SLA"}) select 0,
			(CUP_Classes select {_x == "CUP_B_Mi35_Dynamic_CZ"}) select 0,
			(CUP_Classes select {_x == "CUP_B_AH1Z_Dynamic_USMC"}) select 0,
			(CUP_Classes select {_x == "CUP_B_AH1_DL_BAF"}) select 0,
			(CUP_Classes select {_x == "CUP_B_Mi171Sh_ACR"}) select 0,
			(CUP_Classes select {_x == "CUP_B_AH6J_USA"}) select 0,
			(CUP_Classes select {_x == "CUP_O_UH1H_armed_SLA"}) select 0
		];
	};


	_vehicleClass = selectRandom _vars;

	_missionType = "MIDDLE: Armed Helicopter";
	_locationsArray = MissionSpawnMarkers;

	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_this call mission_VehicleCapture;
