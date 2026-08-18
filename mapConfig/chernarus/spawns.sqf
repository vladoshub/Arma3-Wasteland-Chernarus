
private _spawns =
[
	["Spawn_WindyMountain", -1, "Windy Mountain"],
	["Spawn_Dobry", -1, "Dobry"],
	["Spawn_BlackMountain", -1, "Black Mountain"],
	["Spawn_Dubina", -1, "Dubina"],
	["Spawn_Aircraft", -1, "Aircraft"],
	["Spawn_PassOreshka", -1, "Pass Oreshka"],
	["Spawn_North", -1, "North"],
	["Spawn_Myshkino", -1, "Myshkino"],
	["Spawn_KamenkaForest", -1, "Kamenka Forest"],
	["Spawn_Quarry", -1, "Quarry"],
	["Spawn_Bashnya", -1, "Bashnya"],
	["Spawn_VishnoyeForest", -1, "Vishnoye Forest"],
	["Spawn_KabaninoField", -1, "Kabanino Field"],
	["Spawn_Altar", -1, "Altar"]
];

//copyToClipboard str ((allMapMarkers select {_x select [0,5] == "Town_"}) apply {[_x, -1, markerText _x]})

private "_size";
 
{
	_x params ["_marker"];

	if (markerShape _marker == "ELLIPSE") then
	{
		_size = markerSize _marker;
		_x set [1, (_size select 0) min (_size select 1)];
	};
} forEach _spawns;

_spawns