#include "sellIncludesStart.sqf";


private _payCard = ["Select a Payment Method. For sales with a CARD, the commission is about 30%.", "Payment", "Card", "Cash"] call BIS_fnc_guiMessage;
if(_payCard) then {
	player setVariable ["playerPayType", "bmoney", true];
} else {
	player setVariable ["playerPayType", "cmoney", true];
};

storeSellingHandle = _this spawn
{
	private _object = missionNamespace getVariable ["R3F_LOG_joueur_deplace_objet", objNull];

	if (_object getVariable ["A3W_notForSale", false]) exitWith
	{
		playSound "FD_CP_Not_Clear_F";
		["You cannot sell spawned object.", "Error"] call  BIS_fnc_guiMessage;
	};

	private _class = typeOf _object;
	private _objName = getText (configFile >> "CfgVehicles" >> _class >> "displayName");

	private _price = ceil ((call allGenStoreVanillaItems select { _x select 1 == _class } select 0 select 2));

	private _filterPrice = 2500;
	

	if (!isNil "_price") then
	{
		_price = _price * 0.5;
		_filterPrice = _price;
	};


	if((player getVariable ["playerPayType", "bmoney"]) == "bmoney") then {
		_filterPrice = ceil (_filterPrice * 0.7);
	};


		_confirmMsg = format ["Selling object %1 will give you $%2<br/>", _objName, [_filterPrice] call fn_numbersText];
		if ([parseText _confirmMsg, "Confirm", "Sell", true] call BIS_fnc_guiMessage) then
		{
			// remove the object
			[_object, player, -1, false] execVM "R3F_LOG\objet_deplacable\relacherWithOutCheck.sqf";
			deleteVehicle _object;

			private _payType = player getVariable ["playerPayType", "bmoney"];
			if(_payType isEqualTo "bmoney") then {
				private _playerMoney = player getVariable [_payType, 0];
				private _newBalance = _playerMoney + _filterPrice;
				player setVariable ["bmoney", _newBalance, true];
			} else {
				[player, _filterPrice] call A3W_fnc_setCMoney;
			};

			[format ['The object %1 has been sold!', _objname], "Thank You"] call BIS_fnc_guiMessage;

			if (["A3W_playerSaving"] call isConfigOn) then
			{
				[] spawn fn_savePlayerData;
			};
		};
};

#include "sellIncludesEnd.sqf";