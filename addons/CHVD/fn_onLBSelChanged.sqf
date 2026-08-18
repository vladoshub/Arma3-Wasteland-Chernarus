private "_terrainGrid";
private _index = _this select 0;
_varType = _this select 1;
_text = _this select 2;

/*
switch (_index) do {
	case 0: {_terrainGrid = 50};
	case 1: {_terrainGrid = 25};
	case 2: {_terrainGrid = 12.5};
	case 3: {_terrainGrid = 3.125};
};
*/

switch (_index) do {
	case 0: {_terrainGrid = 48};
	case 1: {_terrainGrid = 12.5};
	case 2: {_terrainGrid = 6.25};
	case 3: {_terrainGrid = 3.125};
};

if (!CHVD_allowNoGrass) then {
	_terrainGrid = _terrainGrid min 48;
};
ctrlSetText [_text, str _terrainGrid];		
call compile format ["%1 = %2",_varType, _terrainGrid];
call compile format ["profileNamespace setVariable ['%1',%1]", _varType];
