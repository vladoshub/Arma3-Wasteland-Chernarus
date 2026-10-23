// Independent payout table for mission AI, copied from serverAiDiedMoneyDrop.sqf.
if (!isServer) exitWith {};

params ["_unit", "_killer", "_instigator"];

// A group can be initialized more than once; each unit gets only one money roll.
if (isNull _unit || {isPlayer _unit} || {_unit getVariable ["A3W_missionMoneyDropProcessed", false]}) exitWith {};
_unit setVariable ["A3W_missionMoneyDropProcessed", true];


private _chance = floor (random 10);
if (_chance > 6) then {

private _moneyAmount = floor random 30000;

if ( (random 1) < 0.04) then {
	_moneyAmount = floor random 300000;
};

private _cash = createVehicle ["Land_Money_F", getPos _unit, [], 5, "None"];
_cash setDir random 360;
_cash setVariable ["cmoney", _moneyAmount, true];
_cash setVariable ["owner", "world", true];
[_cash] call A3W_fnc_setItemCleanup;

};
