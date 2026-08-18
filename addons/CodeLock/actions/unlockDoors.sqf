
_building = (_this select 0);
//_doorNumber = (_this select 1);

_ctrlIndicator = (findDisplay 1234) displayCtrl 1001;
ctrlSetText [1001, "Door Unlocked"];
_ctrlIndicator ctrlSetTextColor [0, 1, 0, 1];


//_doorCount = getNumber (configFile >> "cfgVehicles" >> typeOf _building >> "numberOfDoors");


if(_building getVariable ["secure_by_flag", false]) then {


	private _allObj = _building nearObjects 650;
	private _filterObj = [];

	{ 
		if ( (_x getVariable ["secure_by_flag", false]) && (typeOf _x != "FlagChecked_F") && (typeOf _x == "Land_ConcreteWall_01_l_gate_F") && _x getVariable ["isLocked", false]) then 
			{
				_filterObj pushBack _x;
			};
	} forEach _allObj;


	{
	private _doorCountFor = 0;
	private _currentObj = _x;
		{
			if(_currentObj isKindOf (_x select 0)) exitWith {
				_doorCountFor = (_x select 1);
			};
	
		} forEach CODE_LOCK_DOORS_CONFIG;


		if(_doorCountFor > 0) then {
			for "_i" from 1 to _doorCountFor do
			{
				_lockDoor = format ["bis_disabled_Door_%1", _i];
				_currentObj setVariable [_lockDoor, 0, true];
				};
			};
		_currentObj setVariable ["isLocked", false, true];
	} forEach _filterObj;


};


private _doorCount = 0;
{
	if(_building isKindOf (_x select 0)) exitWith {
		_doorCount = (_x select 1);
	};
	
} forEach CODE_LOCK_DOORS_CONFIG;


if(_doorCount > 0) then {
	for "_i" from 1 to _doorCount do
	{
		_lockDoor = format ["bis_disabled_Door_%1", _i];
		_building setVariable [_lockDoor, 0, true];

		// (player nearObjects ["Land_Brana02", 10] select 0) setVariable ["bis_disabled_Door_1", 0, true];
	};
};