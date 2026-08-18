// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: createLegendMarkers.sqf
//	@file Author: AgentRev

_markers =
[
	["Legend:", "EmptyIcon", "ColorWhite", [1,1]],

	["GS - General Store", "mil_dot", "ColorBlue", [1,1]],
	["VS - Vehicle Store", "mil_dot", "ColorOrange", [1,1]],
	["GUN STORE", "mil_dot", "ColorYellow", [1,1]]
];


if (["A3W_privateParking"] call isConfigOn) then
{
	_markers pushBack ["Parking", "mil_dot", "ColorCIV", [1,1]];
};

if (["A3W_privateStorage"] call isConfigOn) then
{
	_markers pushBack ["Storage", "mil_dot", "ColorUNKNOWN", [1,1]];
};


_markers pushBack ["Portal", "mil_dot", "ColorGreen", [1,1]];
_markers pushBack ["Resupply Truck", "mil_dot", "ColorPink", [1,1]];
_markers pushBack ["ATM", "mil_dot", "ColorWhite", [1,1]];
_markers pushBack ["Food", "mil_dot", "ColorBrown", [1,1]];
_markers pushBack ["Water", "mil_dot", "Color4_FD_F", [1,1]];
_markers pushBack ["Air Spawn (Clickable at respawn)", "respawn_para", "Default", [1,1]];
_markers pushBack ["Mission", "mil_destroy", "ColorRed", [1,1]];


// _mapSize = getNumber (configFile >> "CfgWorlds" >> worldName >> "mapSize");
_mapSize = worldSize;
_markerSpacing = 0.025 * _mapSize;
_legendMarginX = 0.035 * _mapSize;
_legendMarginY = 0.035 * _mapSize;
_markerX = _mapSize + _legendMarginX;
_legendTop = _legendMarginY + (_markerSpacing * (count _markers - 1));

{
	_x params ["_text", "_type", "_color", "_size"];

	/*
	if(_type == "ATM") then {
		AtmIconLegeng = (call currMissionDir) + "client\icons\suatmm_icon.paa";

		PosXLegend = _markerX - ([0, 0.02 * _mapSize] select (_type == "EmptyIcon"));
		PosYLegend = _legendTop - (_forEachIndex * _markerSpacing);

		// Дубликат маркера (левый верхний угол) - ВЫХОДИТ ЗА КАРТУ
		PosXMirrorIcon = -_legendMarginX * 5 + ([0, 0.02 * _mapSize] select (_type == "EmptyIcon"));
		PosYMirrorIcon = _mapSize - _legendMarginY - (_forEachIndex * _markerSpacing); // Такая же высота как у оригиналов

		findDisplay 12 displayCtrl 51 ctrlAddEventHandler  [ "Draw" , { 
		_this  select  0  drawIcon  ["iconStaticMG", [1,1,1,1], [PosXLegend, PosYLegend], {(0.3 / ctrlMapScale (_this select 0)) max 9 min 24}, 0, 0, "ATM"] 
		}];

		findDisplay 12 displayCtrl 51 ctrlAddEventHandler  [ "Draw" , { 
		_this  select  0  drawIcon  ["iconStaticMG", [1,1,1,1], [PosXMirrorIcon, PosYMirrorIcon], {(0.3 / ctrlMapScale (_this select 0)) max 9 min 24}, 0, 0, "ATM"] 
		}];


	} else {
		*/

	_marker = format ["LegendMarker%1", _forEachIndex];
	_posX = _markerX - ([0, 0.02 * _mapSize] select (_type == "EmptyIcon"));
	_posY = _legendTop - (_forEachIndex * _markerSpacing);

	// Дубликат маркера (левый верхний угол) - ВЫХОДИТ ЗА КАРТУ
	_markerMirror = format ["LegendMarkerMirror%1", _forEachIndex];
	_posXMirror = -_legendMarginX * 5 + ([0, 0.02 * _mapSize] select (_type == "EmptyIcon"));
	_posYMirror = _mapSize - _legendMarginY - (_forEachIndex * _markerSpacing); // Такая же высота как у оригиналов

	if(_text == "ATM") then {
		_type = "EmptyIcon";
	};

	deleteMarkerLocal _marker;
	createMarkerLocal [_marker, [_posX, _posY]];

	_marker setMarkerTextLocal _text;
	_marker setMarkerTypeLocal _type;
	_marker setMarkerColorLocal _color;
	_marker setMarkerSizeLocal _size;
	_marker setMarkerShapeLocal "ICON";


	deleteMarkerLocal _markerMirror;
	createMarkerLocal [_markerMirror, [_posXMirror, _posYMirror]];

	_markerMirror setMarkerTextLocal _text;
	_markerMirror setMarkerTypeLocal _type;
	_markerMirror setMarkerColorLocal _color;
	_markerMirror setMarkerSizeLocal _size;
	_markerMirror setMarkerShapeLocal "ICON";
	//};


} forEach _markers;
