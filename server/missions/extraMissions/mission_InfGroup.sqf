// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2019 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_InfGroup.sqf
//	@file Author: AryX
//	@file Version: 0.2
//	@file Description: InfGroup Extra-Mission

if (!isServer) exitWith {};
#include "extraMissionDefines.sqf";

private ["_InfantryGroup", "_moneyAmount", "_groupsAmount", "_cash", "_nbUnits", "_moneyText"];

_setupVars =
{
	_locationsArray = MissionSpawnMarkers;
	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };	
};

_setupObjects =
{	
	_InfantryGroup =
	selectRandom [
		// Small
		[
			"LIGHT: Small Infantry Group", // Marker text
			200000, // Money
			_nbUnits
		],
		// Medium
		[
			"MIDDLE: Medium Infantry Group", // Marker text
			350000, // Money
			(_nbUnits) * 2
		],
		// Large
		[
			"MIDDLE: Large Infantry Group", // Marker text
			500000, // Money
			(_nbUnits) * 3
		],
		// Heavy
		[
			"HARD: Heavy Infantry Group", // Marker text
			750000, // Money
			(_nbUnits) * 4
		]
	];

	_missionType = _InfantryGroup select 0;
	_moneyAmount = _InfantryGroup select 1;
	_groupsAmount = _InfantryGroup select 2;

	_moneyText = format ["$%1", [_moneyAmount] call fn_numbersText];
	
	_missionPos = markerPos _missionLocation;
	
	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos, _groupsAmount] call createCustomGroup4;
	
	_aiGroup setCombatMode "RED";
	_aiGroup setBehaviour "COMBAT";
	_aiGroup setFormation "VEE";

	_missionHintText = format ["Take out %3 Infantry soldiers to earn <t color='%1'>%2</t>!", extraMissionColor, _moneyText, _groupsAmount];
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec = nil;

_successExec =
{
	// Mission completed

	_cash = createVehicle ["Land_Money_F", _lastPos, [], 5, "None"];
	_cash setPos ([_lastPos, [[2 + random 3,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
	_cash setDir random 360;
	_cash setVariable ["cmoney", _moneyAmount, true];
	_cash setVariable ["owner", "world", true];
	_successHintMessage = "Well done, the money is yours.";
};

_this call extraMissionProcessor;