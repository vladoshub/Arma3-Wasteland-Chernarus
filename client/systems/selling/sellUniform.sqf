// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: sellUniform.sqf
//	@file Author: AgentRev
//	@file Created: 20/08/2013 00:29

#define DEFAULT_SELL_VALUE 25

#include "sellIncludesStart.sqf";

if (isNull uniformContainer player) exitWith
{
	playSound "FD_CP_Not_Clear_F";
	hint "You don't have a uniform to sell!";
};

storeSellingHandle = _this spawn
{
	_obj = uniformContainer player;
	_sellValue = 0;
	_originalCargo = CARGO_STRING(_obj);

	// Get all the items
	_allObjItems = _obj call getSellPriceList;

	_objClass = uniform player;
	_objName = getText (configFile >> "CfgWeapons" >> _objClass >> "displayName");

	_added = false;

	// Include uniform in item list
	{
		if (_x select 1 == _objClass) exitWith
		{

			private _price = GET_HALF_PRICE(_x select 2);

			if((player getVariable ["playerPayType", "bmoney"]) == "bmoney") then {
				_price = ceil(_price * 0.7);
			};


			_allObjItems = [[_objClass, 1, _objName, _price]] + _allObjItems;
			_added = true;
		};
	} forEach (call uniformArray);

	if (!_added) then
	{
		_allObjItems = [[_objClass, 1, _objName, DEFAULT_SELL_VALUE]] + _allObjItems;
	};

	// Calculate total value
	{
		if (count _x > 3) then
		{
			_sellValue = _sellValue + (_x select 3);
		};
	} forEach _allObjItems;

	// Add total sell value to confirm message
	_confirmMsg = format ["You will obtain $%1 for:<br/>", [_sellValue] call fn_numbersText];

	// Add item quantities and names to confirm message
	{
		_item = _x select 0;
		_itemQty = _x select 1;

		if (_itemQty > 0 && {count _x > 2}) then
		{
			_itemName = _x select 2;
			_confirmMsg = _confirmMsg + format ["<br/>%1 x  %2%3", _itemQty, _itemName, if (PRICE_DEBUGGING) then { format [" ($%1)", [_x select 3] call fn_numbersText] } else { "" }];
		};
	} forEach _allObjItems;

	// Display confirmation
	if ([parseText _confirmMsg, "Confirm", "Sell", true] call BIS_fnc_guiMessage) then
	{
		// Check if somebody else manipulated the cargo since the start
		if (CARGO_STRING(_obj) == _originalCargo) then
		{
			removeUniform player;

		private _payType = player getVariable ["playerPayType", "bmoney"];
		if(_payType isEqualTo "bmoney") then {
			private _playerMoney = player getVariable [(player getVariable ["playerPayType", "bmoney"]), 0];
			private _newBalance = _playerMoney + _sellValue;
			player setVariable ["bmoney", _newBalance, true];
		} else {
			[player, _sellValue] call A3W_fnc_setCMoney;
		};
			[] call fn_savePlayerData;
			hint format ['You sold "%1" for $%2', _objName, _sellValue];
			playSound "FD_Finish_F";
		}
		else
		{
			playSound "FD_CP_Not_Clear_F";
			[format ['The contents of "%1" have changed, please restart the selling process.', _objName], "Error"] call BIS_fnc_guiMessage;
		};
	};
};

#include "sellIncludesEnd.sqf";
