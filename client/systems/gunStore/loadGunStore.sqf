// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: loadGunStore.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\gunstoreDefines.sqf";
disableSerialization;

private ["_gunshopDialog", "_Dialog", "_playerMoney", "_owner", "_gunStoreObjectArmament"];
_gunshopDialog = createDialog "gunshopd";

_Dialog = findDisplay gunshop_DIALOG;
_playerMoney = _Dialog displayCtrl gunshop_money;
_gunStoreObjectArmament = _Dialog displayCtrl gunshop_armament_button;

private _payCard = ["Select a Payment Method. For purchases and sales with a CARD, the commission is about 30%.", "Payment", "Card", "Cash"] call BIS_fnc_guiMessage;
if(_payCard) then {
	player setVariable ["playerPayType", "bmoney", true];
} else {
	player setVariable ["playerPayType", "cmoney", true];
};

_playerMoney ctrlSetText format[player getVariable [(player getVariable ["playerPayType", "bmoney"]), 0] call fn_numbersText];


if (!isNil "_this") then { _owner = _this select 0 };
if (!isNil "_owner") then
{
	currentOwnerID = _owner;
	currentOwnerName = vehicleVarName _owner;
};

{
	if (_x select 0 == currentOwnerName) exitWith
	{
		// The array of which vehicle types are unvailable at this store
		{
			switch (toLower _x) do
			{
				case "armament":
				{
					_gunStoreObjectArmament ctrlEnable false;
				};
			};
		} forEach (_x select 3);
	};
} foreach (call storeOwnerConfig);

[] spawn
{
	disableSerialization;
	_dialog = findDisplay gunshop_DIALOG;
	while {!isNull _dialog} do
	{
		_escMenu = findDisplay 49;
		if (!isNull _escMenu) exitWith { _escMenu closeDisplay 0 }; // Force close Esc menu if open
		sleep 0.1;
	};
};
