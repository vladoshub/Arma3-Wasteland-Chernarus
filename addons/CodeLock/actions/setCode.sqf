_cursorObject = (_this select 0);
_isLocked = _cursorObject getVariable ["isLocked", false];
_hasLetter = false;

_newCode = ctrlText 1000;
_abc = ["P", "l", "e", "a", "s", "e", "S", "e", "t", "A", "C", "o", "d", "e", " "];

{
	_test = _newCode find _x;
	if (_test != -1) exitWith {_hasLetter = true};
} forEach _abc;

if (!_hasLetter) then
{
	if (!_isLocked && _cursorObject getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) then
	{
		_cursorObject setVariable ["hasCode", true, true];
		if (_newCode == "" || count _newCode > 16) then
		{
			hint "Wrong code entered, code must not be empty and no more than 16 characters. code reset";
			ctrlSetText [1000, "Please Set A Code"];
			_cursorObject setVariable ["hasCode", false, true];
			_cursorObject setVariable ["theCode", nil, true];
		}
		else
		{
			hint format ["New Building Code: %1", _newCode];
			ctrlSetText [1000, ""];
			_cursorObject setVariable ["theCode", _newCode, true];
		};
		pvar_manualObjectSave = netId _cursorObject;
		publicVariableServer "pvar_manualObjectSave";
		
	}
	else
	{
		hint "Building must be unlocked to set a new code or you should own this door";
	};
}
else
{
	hint "Code cannot contain letters, re-enter code";
};
