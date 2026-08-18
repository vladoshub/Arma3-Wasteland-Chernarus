// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_ArmedHeli.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitWith {};
#include "ultraMissionDefines.sqf";

private "_vehicleClass";
private "_nbUnits";

_setupVars =
{
	_vehicleClass = selectRandom
	[
		["B_Plane_CAS_01_dynamicLoadout_F", "A164Nuke"]
	];

	_missionType = "ULTIMATE: Nuke Jet";
	_locationsArray = UltraMissionSpawnMarkers;

	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_this call mission_JetNukeCapture;
