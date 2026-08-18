// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: generateAtmArray.sqf
//	@file Author: AgentRev

private "_editorOnly";
_editorOnly = ["A3W_atmEditorPlacedOnly"] call isConfigOn;

if (isNil "A3W_atmArray") then
{
	A3W_atmArray = allMissionObjects "Land_Atm_01_F" + allMissionObjects "Land_Atm_02_F";
};

{
	{
		if ((str _x) find ": atm_" != -1) then
		{
			if (_editorOnly && !(_x getVariable ["A3W_atmEditorPlaced", false])) then
			{
				if (alive _x) then { _x setDamage 1 };
			}
			else
			{
				if !(_x in A3W_atmArray) then { A3W_atmArray pushBack _x };
			};
		};
	//} forEach nearestObjects [_x, [], 5];
	} forEach nearestTerrainObjects [_x, ["HIDE"], 5]; //https://github.com/A3Wasteland/ArmA3_Wasteland.Altis/commit/9cc182c6aff0dfa2f9f28925ce9d9ac9d2f60339
} forEach call compile preprocessFileLineNumbers format ["mapConfig\%1\atmPositions.sqf", (["A3W_map", "chernarus"] call getPublicVar)];

// Get rid of map ATMs that are within 3m of mission ones
{
	if (_x getVariable ["A3W_atmEditorPlaced", false]) then
	{
		{
			if ((str _x) find ": atm_" != -1 && {alive _x && !(_x getVariable ["A3W_atmEditorPlaced", false])}) then
			{
				_x setDamage 1;
			};
		//} forEach nearestObjects [_x, [], 3];
		} forEach nearestTerrainObjects [_x, ["HIDE"], 3]; //https://github.com/A3Wasteland/ArmA3_Wasteland.Altis/commit/9cc182c6aff0dfa2f9f28925ce9d9ac9d2f60339
	};
} forEach A3W_atmArray;

if !(["A3W_atmEnabled"] call isConfigOn) then
{
	// Remove ATMs so as not to confuse people into thinking that they might be able to use them when they actually can't
	if (["A3W_atmRemoveIfDisabled"] call isConfigOn) then
	{
		{
			if (alive _x) then
			{
				if (_x getVariable ["A3W_atmEditorPlaced", false]) then
				{
					hideObject _x; // only hide since it's owned by the server
				}
				else
				{
					_x setDamage 1;
				};
			};
		} forEach A3W_atmArray;
	};

	A3W_atmArray = nil; // prevent icons from being drawn
};
