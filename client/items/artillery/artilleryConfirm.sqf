// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2018 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: artilleryConfirm.sqf
//	@file Author: AgentRev

#include "artillery_defines.hpp"

(findDisplay A3W_artilleryMenu_IDD displayCtrl A3W_artilleryMenu_ConfirmButton_IDC) ctrlEnable false;

0 spawn
{
	call
	{
		if (call mf_items_artillery_checkCooldown != "") exitWith {};

		_pos = A3W_artilleryMenu_targetPos;
		if (isNil "_pos") exitWith {};

		_msg = format ["You are about to fire %1 artillery shells at Grid %2.<br/><br/>The strike will take about 75 seconds to begin, with an average rate of 1 shell every 2 seconds.<br/><br/>Your Artillery Strike item will be consumed. <br/><br/>Do you want to proceed?", A3W_artilleryMenu_shellCount, mapGridPosition _pos];

		if !([_msg, "Confirm", true, true] call BIS_fnc_guiMessage) exitWith {};
		if (call mf_items_artillery_checkCooldown != "") exitWith {};

		if (!isServer) then { missionNamespace setVariable ["A3W_artilleryLastUse_" + getPlayerUID player, diag_tickTime + (["A3W_serverTickTimeDiff", 0] call getPublicVar)] };
		["artillery", 1] call mf_inventory_remove;

		[player, _pos] remoteExecCall ["A3W_fnc_artilleryStrike", 2];

		_message = parseText ([
			"<t color='#FF0000' size='1.5' align='center'>WARNING</t>",
			"<t color='#FFFFFF' shadow='1' shadowColor='#000000' align='center'>Someone is using Artillery Strike!!!</t>"
		] joinString "<br/>");
		_simplMessage = "Someone is using Artillery Strike!!!";
		_clientOwner = clientOwner;
		[_message, _simplMessage, _clientOwner] remoteExec ["hard_vehicle_message"];

		["Strike request sent...Wait 45 sec", 5] call a3w_actions_notify;
		playSound "Orange_Access_FM";

		waitUntil {closeDialog 0; !dialog};
	};

	(findDisplay A3W_artilleryMenu_IDD displayCtrl A3W_artilleryMenu_ConfirmButton_IDC) ctrlEnable true;
};
