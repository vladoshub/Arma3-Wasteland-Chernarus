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
		"B_APC_Tracked_01_AA_F",
		"O_APC_Tracked_02_AA_F"
	];

	if(["A3W_use_CUP", false] call getPublicVar) then {
		_vehicleClass append [
			(CUP_Classes select {_x == "CUP_B_UAZ_AA_CDF"}) select 0,
			(CUP_Classes select {_x == "CUP_B_HMMWV_Avenger_USMC"}) select 0,
			(CUP_Classes select {_x == "CUP_O_2S6M_RU"}) select 0
		];
	};

	while {_vehicleClass isEqualType []} do { _vehicleClass = selectRandom _vehicleClass };
	if (_vehicleClass find "/" != -1) then { _vehicleClass = _vehicleClass splitString "/" };

	_missionType = "MIDDLE: Anti Air vehicle";
	_locationsArray = MissionSpawnMarkers;

	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_this call mission_VehicleCapture;