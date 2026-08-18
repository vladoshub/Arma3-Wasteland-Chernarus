// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_ArmedHeli.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitWith {};
#include "ultraMissionDefines.sqf";

private ["_vehicleClass", "_nbUnits", "_vars"];

_setupVars =
{
	_vars =
	[
		["O_Heli_Attack_02_dynamicLoadout_F", "KajmanTV"]
	];

	
	if(["A3W_use_CUP", false] call getPublicVar) then {
		_vars append [
			[(CUP_Classes select {_x == "CUP_O_Ka52_RU"}) select 0, "ka52TV"]
		];
	};

	_vehicleClass = selectRandom _vars;


	_missionType = "HARD: Armed TV Missile Helicopter";
	_locationsArray = UltraMissionSpawnMarkers;

	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_this call mission_UltraVehicleCapture;
