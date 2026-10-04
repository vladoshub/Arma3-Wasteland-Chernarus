// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
// Distribute a weapon budget across buildings without exceeding their remaining capacities.

params ["_capacities", "_maximum"];

private _quotas = [];
{ _quotas pushBack 0 } forEach _capacities;
private _remaining = floor (_maximum max 0);
private _available = true;

while {_remaining > 0 && {_available}} do
{
	_available = false;
	{
		private _index = _forEachIndex;
		if (_remaining > 0 && {(_quotas select _index) < floor (_x max 0)}) then
		{
			_quotas set [_index, (_quotas select _index) + 1];
			_remaining = _remaining - 1;
			_available = true;
		};
	} forEach _capacities;
};

_quotas
