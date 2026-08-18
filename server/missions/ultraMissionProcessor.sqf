// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: ultraMissionProcessor.sqf

#define MISSION_PROC_TYPE_NAME "Ultra"
#define MISSION_PROC_TIMEOUT (["A3W_ultraMissionTimeout", 45*60] call getPublicVar)
#define MISSION_PROC_COLOR_DEFINE ultraMissionColor

#include "ultraMissions\ultraMissionDefines.sqf"
#include "missionProcessor.sqf";
