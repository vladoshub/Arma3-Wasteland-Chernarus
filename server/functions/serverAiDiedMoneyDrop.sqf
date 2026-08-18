if (!isServer) exitWith {};

params ["_unit", "_killer", "_instigator"];


private _chance = floor (random 10);
if (_chance > 0) then {

private _moneyAmount = 100;

switch (_chance) do
{
	case 1: { _moneyAmount = floor random 10000 };
	case 2: { _moneyAmount = floor random 1000 };
	case 3: { _moneyAmount = floor random 500 };
	case 4: { _moneyAmount = floor random 10000 };
	case 5: { _moneyAmount = floor random 3000 };
	case 6: { _moneyAmount = floor random 100 };
	case 7: { _moneyAmount = floor random 5000 };
	case 8: { _moneyAmount = floor random 1000 };
	case 9: {_moneyAmount  = floor random 1000 };
	default { _moneyAmount = 100 };
};

if ( (random 1) < 0.04) then {
	_moneyAmount = floor random 100000;
};

private _cash = createVehicle ["Land_Money_F", getPos _unit, [], 5, "None"];
_cash setDir random 360;
_cash setVariable ["cmoney", _moneyAmount, true];
_cash setVariable ["owner", "world", true];

};