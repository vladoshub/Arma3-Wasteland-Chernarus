params ["_cursorObject"];

_hasCode = _cursorObject getVariable ["hasCode", false];
//_building = _cursorObject getVariable ["building", nil];
//_doorNumber = _cursorObject getVariable ["doorNumber", nil];


hintSilent "";
if (_hasCode) then
{
	_ctrlIndicator = (findDisplay 1234) displayCtrl 1001;
	ctrlSetText [1001, "Door Locked"];
	_ctrlIndicator ctrlSetTextColor [1, 0, 0, 1];

	private _doorCount = 0;
	{
		if(_cursorObject isKindOf (_x select 0)) exitWith {
			_doorCount = (_x select 1);
		};
		
	} forEach CODE_LOCK_DOORS_CONFIG;

	if(_doorCount > 0) then {
		for "_i" from 1 to _doorCount do
		{
			_lockDoor = format ["bis_disabled_Door_%1", _i];
			_closeDoor = format ["Door_%1_rot", _i];
			_cursorObject animate [_closeDoor, 0, false];
			_cursorObject setVariable [_lockDoor, 1, true];
		};
	};
	
	_cursorObject setVariable ["isLocked", true, true];
}
else
{
	hint "A code must be set to lock the building";
};