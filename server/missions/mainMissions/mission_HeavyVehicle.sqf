// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_MBT.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitWith {};
#include "mainMissionDefines.sqf";

private ["_vehicleClass", "_nbUnits"];

_setupVars =
{
	_vehicleClass = // to specify a vehicleLoadouts variant, simply write "class/variant", e.g. "O_Heli_Light_02_dynamicLoadout_F/orcaDAR"
	[
		"B_MBT_01_cannon_F",
		"O_MBT_02_cannon_F",
		"I_MBT_03_cannon_F",
		"O_APC_Tracked_02_AA_F",
		//["O_MBT_04_cannon_F", "O_MBT_04_command_F"], // Tanks DLC
		"B_APC_Tracked_01_rcws_F",
		"B_MBT_01_TUSK_F",
		"I_E_APC_tracked_03_cannon_F",
		"B_APC_Tracked_01_AA_F"
	];

	if(["A3W_use_CUP", false] call getPublicVar) then {
		_vehicleClass append [
			(CUP_Classes select {_x == "CUP_O_T90_RU"}) select 0,
			(CUP_Classes select {_x == "CUP_I_T34_TK_GUE"}) select 0,
			(CUP_Classes select {_x == "CUP_B_M1A1_DES_US_Army"}) select 0,
			(CUP_Classes select {_x == "CUP_O_T55_CHDKZ"}) select 0,
			(CUP_Classes select {_x == "CUP_B_T72_CDF"}) select 0,
			(CUP_Classes select {_x == "CUP_O_2S6M_RU"}) select 0,
			(CUP_Classes select {_x == "CUP_O_BMP3_RU"}) select 0,
			(CUP_Classes select {_x == "CUP_B_M60A3_USMC"}) select 0,
			(CUP_Classes select {_x == "CUP_B_M60A3_TTS_USMC"}) select 0,
			(CUP_Classes select {_x == "CUP_B_M163_USA"}) select 0,
			(CUP_Classes select {_x == "CUP_B_Leopard2A6_GER"}) select 0,
			(CUP_Classes select {_x == "CUP_B_Challenger2_Desert_BAF"}) select 0
		];
	};

	while {_vehicleClass isEqualType []} do { _vehicleClass = selectRandom _vehicleClass };
	if (_vehicleClass find "/" != -1) then { _vehicleClass = _vehicleClass splitString "/" };

	_missionType = "MIDDLE: Heavy vehicle";
	_locationsArray = MissionSpawnMarkers;

	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_this call mission_VehicleCapture;