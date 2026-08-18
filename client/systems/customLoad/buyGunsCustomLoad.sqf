// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: buyGunsCustomLoad.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [KoS] His_Shadow, AgentRev
//	@file Created: 20/11/2012 05:13
//	@file Args: [int (0 = buy to player 1 = buy to crate)]


if (!isNil "storePurchaseHandle" && {typeName storePurchaseHandle == "SCRIPT"} && {!scriptDone storePurchaseHandle}) exitWith {hint "Please wait, your previous purchase is being processed"};

#include "dialog\customLoadDefines.sqf";

#define PURCHASED_CRATE_TYPE_AMMO 60
#define PURCHASED_CRATE_TYPE_WEAPON 61

#define GET_DISPLAY (findDisplay balca_debug_VC_IDD)
#define GET_CTRL(a) (GET_DISPLAY displayCtrl ##a)
#define GET_SELECTED_DATA(a) ([##a] call {_idc = _this select 0;_selection = (lbSelection GET_CTRL(_idc) select 0);if (isNil {_selection}) then {_selection = 0};(GET_CTRL(_idc) lbData _selection)})
#define KINDOF_ARRAY(a,b) [##a,##b] call {_veh = _this select 0;_types = _this select 1;_res = false; {if (_veh isKindOf _x) exitwith { _res = true };} forEach _types;_res}

#define CEIL_PRICE(PRICE) (ceil ((PRICE) / 5) * 5)

storePurchaseHandle = _this spawn
{
	disableSerialization;

	private ["_name", "_switch", "_price", "_dialog", "_ammoList", "_playerMoneyText", "_playerMoney", "_itemIndex", "_itemText", "_itemData", "_class", "_name", "_mag", "_type", "_backpack", "_gunsList", "_weapon", "_successHint", "_requestKey", "_balance"];

	//Initialize Values
	_switch = _this select 0;
	_successHint = true;

	// Grab access to the controls
	_dialog = findDisplay customloadout_DIALOG;
	_gunsList = _dialog displayCtrl gunshop_gun_list;
	_playerMoneyText = _dialog displayCtrl gunshop_money;
	_balance = _dialog displayCtrl gunshop_balance_TEXT; //BY_VLADOS
	_playerMoney = player getVariable ["bmoney", 0];

	_itemIndex = lbCurSel gunshop_gun_list;
	_itemText = _gunsList lbText _itemIndex;
	_itemData = _gunsList lbData _itemIndex;

	_showInsufficientFundsError =
	{
		_itemText = _this select 0;
		hint parseText format ["Not enough money for<br/>""%1""", _itemText];
		playSound "FD_CP_Not_Clear_F";
		_price = -1;
	};

	_showInsufficientSpaceError =
	{
		_itemText = _this select 0;
		hint parseText format ["Not enough space for<br/>""%1""", _itemText];
		playSound "FD_CP_Not_Clear_F";
		_price = -1;
	};

	_showItemSpawnTimeoutError =
	{
		_itemText = _this select 0;
		hint parseText format ["<t color='#ffff00'>An unknown error occurred.</t><br/>The purchase of ""%1"" has been cancelled.", _itemText];
		playSound "FD_CP_Not_Clear_F";
		_price = -1;
	};

	_showItemSpawnedOutsideMessage =
	{
		_itemText = _this select 0;
		hint format ["""%1"" has been spawned outside, in front of the store.", _itemText];
		playSound "FD_Finish_F";
		_successHint = false;
	};

	_showAlreadyHaveTypeMessage =
	{
		_itemText = _this select 0;
		hint format ["Your inventory is full, or you already have a weapon of this type. Please unequip it before purchasing ""%1""", _itemText];
		playSound "FD_CP_Not_Clear_F";
		_price = -1;
	};

	switch (_switch) do
	{
		//Buy To Player
		case 0:
		{
			if (isNil "_price") then
			{
				{
					if (_itemData == _x select 1) exitWith
					{
						_class = _x select 1;
						_price = ((_x select 2) * 3);
						_weapon = configFile >> "CfgWeapons" >> _class;

						// Ensure the player has enough money
						if (_price > _playerMoney) exitWith
						{
							[_itemText] call _showInsufficientFundsError;
						};

						if ((!([_class, 1] call isWeaponType) || primaryWeapon player == "") &&
							{!([_class, 2] call isWeaponType) || handgunWeapon player == ""} &&
							{!([_class, 4] call isWeaponType) || secondaryWeapon player == ""}) then
						{
							player addWeapon _class;
						}
						else
						{
							if !([player, _class] call addWeaponInventory) then
							{
								[_itemText] call _showInsufficientSpaceError;
							};
						};
					};
				} forEach (call allGunStoreFirearms);
			};

			if (isNil "_price") then
			{
				{
					if (_itemData == _x select 1) exitWith
					{
						_class = _x select 1;
						_price = ((_x select 2) * 3);

						// Ensure the player has enough money
						if (_price > _playerMoney) exitWith
						{
							[_itemText] call _showInsufficientFundsError;
						};

						if ([player, _class] call fn_fitsInventory) then
						{
							[player, _class] call fn_forceAddItem;
						}
						else
						{
							[_itemText] call _showInsufficientSpaceError;
						};
					}
				} forEach (call throwputArray);
			};

			if (isNil "_price") then
			{
				{
					if (_itemData == _x select 1) exitWith
					{
						_class = _x select 1;
						_price = ((_x select 2) * 3);

						// Ensure the player has enough money
						if (_price > _playerMoney) exitWith
						{
							[_itemText] call _showInsufficientFundsError;
						};

						switch (_x select 3) do
						{
							case "item":
							{
								if ([player, _class] call fn_fitsInventory) then
								{
									[player, _class] call fn_forceAddItem;
								}
								else
								{
									[_itemText] call _showInsufficientSpaceError;
								};
							};
						};
					};
				} forEach (call accessoriesArray);
			};

			if (isNil "_price") then
			{
				{
					if (_itemData == _x select 1) exitWith
					{
						_class = _x select 1;
						_price = ((_x select 2) * 3);

						// Ensure the player has enough money
						if (_price > _playerMoney) exitWith
						{
							[_itemText] call _showInsufficientFundsError;
						};

						removeBackpack player;
						player addBackpack _class;
					};
				} forEach (call backpackArray);
			};

			if (isNil "_price") then
			{
				{
					// Exact copy of genObjectsArray call in buyItems.sqf
					if (_itemData == _x select 1) exitWith
					{
						_class = _x select 1;
						_price = ((_x select 2) * 3);

						// Ensure the player has enough money
						if (_price > _playerMoney) exitWith
						{
							[_itemText] call _showInsufficientFundsError;
						};

						_requestKey = call A3W_fnc_generateKey;
						_x call requestStoreObject;
					};
				} forEach (call staticGunsArray);
			};
















	if (isNil "_price") then
	{
		{
			if (_itemData == _x select 1) exitWith
			{
				_class = _x select 1;

				if (_x select 3 == "vest") then
				{
					([_class] call fn_getItemArmor) params ["_ballArmor", "_explArmor"];
					_price = CEIL_PRICE(([_class] call getCapacity) / 2 + _ballArmor*3 + _explArmor*2); // price formula also defined in getItemInfo.sqf
				}
				else
				{
					_price = _x select 2;
				};

				_price = _price * 3;

				// Ensure the player has enough money
				if (_price > _playerMoney) exitWith
				{
					[_itemText] call _showInsufficientFundsError;
				};

				switch (_x select 3) do
				{
					case "binoc":
					{
						_currentBinoc = binocular player;

						if (_currentBinoc == "") then
						{
							if (_class select [0,15] == "Laserdesignator" && {{_x == "Laserbatteries"} count magazines player == 0}) then
							{
								[player, "Laserbatteries"] call fn_forceAddItem;
							};

							player addWeapon _class;
						}
						else
						{
							if !([player, _class] call addWeaponInventory) then
							{
								[_itemText] call _showInsufficientSpaceError;
							};
						};
					};
					case "item":
					{
						if ([player, _class] call fn_fitsInventory) then
						{
							[player, _class] call fn_forceAddItem;
						}
						else
						{
							[_itemText] call _showInsufficientSpaceError;
						};
					};
					case "mag":
					{
						if ([player, _class] call fn_fitsInventory) then
						{
							[player, _class] call fn_forceAddItem;
						}
						else
						{
							[_itemText] call _showInsufficientSpaceError;
						};
					};
					case "backpack":
					{
						if (backpack player == _class) exitWith
						{
							["backpack"] call _showAlreadyHaveItemMessage;
						};

						// Confirm replace
						if (backpack player != "" && {!(["backpack"] call _showReplaceConfirmMessage)}) exitWith {};

						removeBackpack player;
						player addBackpack _class;
					};
					case "gogg":
					{
						if (goggles player == _class) exitWith
						{
							["goggles", true] call _showAlreadyHaveItemMessage;
						};

						// Confirm replace
						if (goggles player != "" && {!(["goggles", true] call _showReplaceConfirmMessage)}) exitWith {};

						removeGoggles player;
						player addGoggles _class;
					};
					case "nvg":
					{
						if ({["NVGoggles", _x] call fn_startsWith} count assignedItems player == 0) then
						{
							player linkItem _class;
						}
						else
						{
							if ([player, _class] call fn_fitsInventory) then
							{
								[player, _class] call fn_forceAddItem;
							}
							else
							{
								[_itemText] call _showInsufficientSpaceError;
							};
						};
					};
					case "gps":
					{
						if ({_x in ["ItemGPS", "B_UavTerminal", "O_UavTerminal", "I_UavTerminal"]} count assignedItems player == 0) then
						{
							player linkItem _class;
						}
						else
						{
							if ([player, _class] call fn_fitsInventory) then
							{
								[player, _class] call fn_forceAddItem;
							}
							else
							{
								[_itemText] call _showInsufficientSpaceError;
							};
						};
					};
					// Crates transferred to genObjectsArray below
					/*case "ammocrate":
					{
						[currentOwnerID, currentOwnerName, PURCHASED_CRATE_TYPE_AMMO] execVM "client\functions\placePurchasedCrate.sqf";
						//_playerPos = getPos player;
						//_ammoTypes = ["Box_NATO_Ammo_F","Box_NATO_Grenades_F","Box_NATO_AmmoOrd_F","Box_IND_Ammo_F","Box_IND_Grenades_F","Box_IND_AmmoOrd_F","Box_EAST_Ammo_F","Box_EAST_Grenades_F","Box_EAST_AmmoOrd_F"];
						//_sbox = createVehicle [_ammoTypes call BIS_fnc_selectRandom,[(_playerPos select 0), (_playerPos select 1),0],[], 0, "NONE"];
						//clearMagazineCargoGlobal _sbox;
						//clearWeaponCargoGlobal _sbox;
						//clearItemCargoGlobal _sbox;
					};
					case "weaponcrate":
					{
						[currentOwnerID, currentOwnerName, PURCHASED_CRATE_TYPE_WEAPON] execVM "client\functions\placePurchasedCrate.sqf";
						//_playerPos = getPos player;
						//_weaponTypes = ["Box_NATO_Wps_F","Box_NATO_WpsLaunch_F","Box_NATO_WpsSpecial_F","B_supplyCrate_F","Box_NATO_Support_F","Box_IND_Wps_F","Box_IND_WpsLaunch_F","Box_IND_WpsSpecial_F","I_supplyCrate_F","Box_IND_Support_F", "Box_EAST_Wps_F","Box_EAST_WpsLaunch_F","Box_EAST_WpsSpecial_F","O_supplyCrate_F","Box_EAST_Support_F"];
						//_sbox = createVehicle [_weaponTypes call BIS_fnc_selectRandom,[(_playerPos select 0), (_playerPos select 1),0],[], 0, "NONE"];
						//clearMagazineCargoGlobal _sbox;
						//clearWeaponCargoGlobal _sbox;
						//clearItemCargoGlobal _sbox;
					};*/
				};
			};
		} forEach (call genItemArray);
	};






			if (isNil "_price") then
			{
				{
					if (_itemData == _x select 1) exitWith
					{
						_price = _x select 4;

						_price = _price * 3;

						// Ensure the player has enough money
						if (_price > _playerMoney) exitWith
						{
							[_itemText] call _showInsufficientFundsError;
						};

						if !(_itemData call mf_inventory_is_full) then
						{
							[_itemData, 1] call mf_inventory_add;
						}
						else
						{
							[_itemText] call _showInsufficientSpaceError;
						};

						//populate the inventory items
						[] execVM "client\systems\customLoad\getInventory.sqf";
					};
				} forEach (call customPlayerItems);
			};





				if (isNil "_price") then
			{
		{
			if (_itemData == _x select 1) exitWith
			{
				_class = _x select 1;
				_price = _x select 2;
				_price = _price * 3;

				if (headgear player == _class) exitWith
				{
					["headgear"] call _showAlreadyHaveItemMessage;
				};

				// Ensure the player has enough money
				if (_price > _playerMoney) exitWith
				{
					[_itemText] call _showInsufficientFundsError;
				};

				// Confirm replace
				if (headgear player != "" && {!(["headgear", false, true] call _showReplaceConfirmMessage)}) exitWith {};

				removeHeadgear player;
				player addHeadgear _class;
			};
			} forEach (call headArray);
			};



				if (isNil "_price") then
	{
		{
			if (_itemData == _x select 1) exitWith
			{
				_class = _x select 1;
				_price = _x select 2;

				_price = _price * 3;

				if (goggles player == _class) exitWith
				{
					["goggles", true] call _showAlreadyHaveItemMessage;
				};

				// Ensure the player has enough money
				if (_price > _playerMoney) exitWith
				{
					[_itemText] call _showInsufficientFundsError;
				};

				// Confirm replace
				if (goggles player != "" && {!(["goggles", true] call _showReplaceConfirmMessage)}) exitWith {};

				removeGoggles player;
				player addGoggles _class;
			};
		} forEach (call goggleArray);
	};

		};
	};

	if (!isNil "_price" && {_price > -1}) then
	{
		// Re-check for money after purchase
		if (isNil "_requestKey" && _price > player getVariable ["bmoney", 0]) exitWith
		{
			[_itemText] call _showInsufficientFundsError;
		};

		//player setVariable ["cmoney", _playerMoney - _price, true];
		if (isNil "_requestKey") then // static gun price now handled in spawnStoreObject.sqf
		{
			//[player, -_price] call A3W_fnc_setCMoney;
			private _newBalance = _playerMoney - _price;
			player setVariable ["bmoney", _newBalance, true];
			[] call fn_savePlayerData;
			_balance ctrlSetText format ["Balance: $%1", [_newBalance] call fn_numbersText];

		};

		_playerMoneyText ctrlSetText format ["Cash: $%1", [player getVariable ["bmoney", 0]] call fn_numbersText];
		if (_successHint) then { hint "Purchase successful!" };
		playSound "FD_Finish_F";
	};

	if (!isNil "_requestKey" && {!isNil _requestKey}) then
	{
		missionNamespace setVariable [_requestKey, nil];
	};

	sleep 0.25; // double-click protection
};

if (typeName storePurchaseHandle == "SCRIPT") then
{
	private "_storePurchaseHandle";
	_storePurchaseHandle = storePurchaseHandle;
	waitUntil {scriptDone _storePurchaseHandle};
};

storePurchaseHandle = nil;
