// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: getInventory.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [404] Pulse
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\genstoreDefines.sqf";
disableSerialization;

private ["_dialog", "_itemlisttext", "_itemlist", "_class", "_qty", "_listIndex"];

// Grab access to the controls
_dialog = findDisplay genstore_DIALOG;
_itemlisttext = _dialog displayCtrl genstore_item_TEXT;
_itemlist = _dialog displayCtrl genstore_sell_list;

//Clear the list
[_itemlist, -1] call A3W_fnc_updateStorePreview;
lbClear _itemlist;
_itemlist lbSetCurSel -1;

{
	_class = _x select 0;
	_qty = _x select 1;

	if (_qty > 0) then
	{
		{
			if (_class == _x select 1) exitWith
			{
				for "_i" from 1 to _qty do
				{
					_listIndex = _itemlist lbAdd format ["%1", _x select 0];
					_itemlist lbSetPicture [_listIndex, _x select 3];
					_itemlist lbSetData [_listIndex, _x select 1];
				};
			};
		} forEach call customPlayerItems;
	};
} forEach call mf_inventory_all;

private _gearItems = items player;
{
	private _gearClass = _x;
	private _gearKey = toLower _gearClass;
	private _gearConfig = configFile >> "CfgWeapons" >> _gearClass;
	private _quantity = { (toLower _x) isEqualTo _gearKey } count _gearItems;

	for "_i" from 1 to _quantity do
	{
		private _row = _itemlist lbAdd getText (_gearConfig >> "displayName");
		_itemlist lbSetPicture [_row, getText (_gearConfig >> "picture")];
		_itemlist lbSetData [_row, _gearClass];
	};
} forEach GENSTORE_SELL_GEAR_CLASSES;
