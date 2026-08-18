// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_LightArmVeh.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitWith {};
#include "mainMissionDefines.sqf";

private ["_vehicleClass", "_nbUnits", "_vars"];

_setupVars = {

	_vars = [
		"O_APC_Tracked_02_cannon_F",
		"I_APC_Wheeled_03_cannon_F",
		"O_T_LSV_02_AT_F",
		"B_T_LSV_01_AT_F",
		"B_AFV_Wheeled_01_cannon_F",
		"B_APC_Wheeled_01_cannon_F",
		"I_MRAP_03_gmg_F",
		"O_APC_Wheeled_02_rcws_v2_F"
	];

	if(["A3W_use_CUP", false] call getPublicVar) then {
		_vars append [
			(CUP_Classes select {_x == "CUP_B_ZSU23_CDF"}) select 0,
			(CUP_Classes select {_x == "CUP_B_BMP2_CDF"}) select 0,
			(CUP_Classes select {_x == "CUP_B_HMMWV_Avenger_USMC"}) select 0,
			(CUP_Classes select {_x == "CUP_B_M7Bradley_USA_D"}) select 0,
			(CUP_Classes select {_x == "CUP_O_BTR60_TK"}) select 0,
			(CUP_Classes select {_x == "CUP_O_GAZ_Vodnik_BPPU_RU"}) select 0,
			(CUP_Classes select {_x == "CUP_I_SUV_Armored_ION"}) select 0,
			(CUP_Classes select {_x == "CUP_I_BMP1_TK_GUE"}) select 0,
			(CUP_Classes select {_x == "CUP_B_BRDM2_ATGM_CDF"}) select 0,
			(CUP_Classes select {_x == "CUP_B_BRDM2_CDF"}) select 0,
			(CUP_Classes select {_x == "CUP_O_BTR90_RU"}) select 0,
			(CUP_Classes select {_x == "CUP_B_FV510_GB_D"}) select 0,
			(CUP_Classes select {_x == "CUP_B_MCV80_GB_D"}) select 0,
			(CUP_Classes select {_x == "CUP_O_BTR80_TK"}) select 0,
			(CUP_Classes select {_x == "CUP_B_M1128_MGS_Desert"}) select 0,
			(CUP_Classes select {_x == "CUP_B_M1167_USA"}) select 0,
			(CUP_Classes select {_x == "CUP_O_BMP1P_TKA"}) select 0,
			(CUP_Classes select {_x == "CUP_B_M2Bradley_USA_D"}) select 0,
			(CUP_Classes select {_x == "CUP_B_M1135_ATGMV_Desert"}) select 0,
			(CUP_Classes select {_x == "CUP_B_UAZ_METIS_CDF"}) select 0,
			(CUP_Classes select {_x == "CUP_B_HMMWV_TOW_USA"}) select 0,
			(CUP_Classes select {_x == "CUP_B_UAZ_AA_CDF"}) select 0,
			(CUP_Classes select {_x == "CUP_B_M6LineBacker_USA_W"}) select 0,
			(CUP_Classes select {_x == "CUP_B_HMMWV_Crows_M2_USA"}) select 0,
			(CUP_Classes select {_x == "CUP_B_HMMWV_Crows_MK19_USA"}) select 0
		];
	};


	_vehicleClass = selectRandom _vars;


	_missionType = "LIGHT: Light Vehicle";
	_locationsArray = MissionSpawnMarkers;

	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_this call mission_VehicleCaptureLight;
