
private _spawns =
[
	["Spawn_Kamen", -1, "Kamen"],
	["Spawn_Sea", -1, "Sea"],
	["Spawn_Aircraft", -1, "Aircraft"],
	["Spawn_North", -1, "North"],
	["Spawn_Myshkino", -1, "Myshkino"],
	["Spawn_KamenkaForest", -1, "Kamenka Forest"],
	["Spawn_Prud", -1, "Prud"]
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