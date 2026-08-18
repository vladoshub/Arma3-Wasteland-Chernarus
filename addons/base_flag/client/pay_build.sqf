private _payCard = ["Select a Payment Method. The CARD commission is about 30%", "Payment", "Card", "Cash"] call BIS_fnc_guiMessage;
if(_payCard) then {
	player setVariable ["playerPayType", "bmoney", true];
} else {
	player setVariable ["playerPayType", "cmoney", true];
};


private _payType = player getVariable ["playerPayType", "bmoney"];
private _playerMoney = 0;
if(_payType isEqualTo "cmoney") then {
	_playerMoney = player getVariable ["cmoney", 0];
} else {
	_playerMoney = player getVariable ["bmoney", 0];
};

private _price = 300000;

if((player getVariable ["playerPayType", "bmoney"]) == "bmoney") then {
	_price = ceil(_price * 1.3);
};

if (_price > _playerMoney) exitWith
{
	_text = format ["Not enough money! You need $%1 to protect base.",_price];
	[_text, 10] call mf_notify_client;
	playSound "FD_CP_Not_Clear_F";
};

if ((_this select 0) getVariable ["isUpdatePayBuild", false]) exitWith
{
	_text = format ["You've already done this recently",_price];
	[_text, 10] call mf_notify_client;
	playSound "FD_CP_Not_Clear_F";
};

if (_price < _playerMoney) then
{
	if(_payType isEqualTo "bmoney") then {
		private _newBalance = _playerMoney - _price;
	  	player setVariable ["bmoney", _newBalance, true];
	} else {
		[player, -_price] call A3W_fnc_setCMoney;
	};

	[[_this select 0],"Base_flag_srv_pay_build",false,false,false] call BIS_fnc_MP;
	_text = "You protected base!";
	[_text, 10] call mf_notify_client;
	[] call fn_savePlayerData;

};

