// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: ultraMissionController.sqf

#define MISSION_CTRL_PVAR_LIST UltraMissions
#define MISSION_CTRL_TYPE_NAME "Ultra"
#define MISSION_CTRL_FOLDER "ultraMissions"
#define MISSION_CTRL_DELAY (["A3W_ultraMissionDelay", 45*60] call getPublicVar)
#define MISSION_CTRL_COLOR_DEFINE ultraMissionColor

#include "ultraMissions\ultraMissionDefines.sqf"
#include "missionController.sqf";
