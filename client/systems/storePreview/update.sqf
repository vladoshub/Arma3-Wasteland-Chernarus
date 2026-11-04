// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************

#include "defines.hpp"
#include "..\..\inventory\define.sqf"
disableSerialization;

params ["_list", "_row", ["_vehicleRow", false]];
if (isNull _list) exitWith {};

private _display = ctrlParent _list;
private _listId = ctrlIDC _list;
private _previousSelection = _display getVariable ["A3W_storePreviewSelection", []];
if (_row < 0 && {_listId != (_previousSelection param [0, -1])}) exitWith {};

private _data = if (_row >= 0 && {_row < lbSize _list}) then { _list lbData _row } else { "" };
private _selection = if (_data == "") then { [] } else { [_listId, _row, _data] };
if (_selection isEqualTo _previousSelection) exitWith {};
_display setVariable ["A3W_storePreviewSelection", _selection];
_display setVariable ["A3W_storePreviewDrag", []];

private _background = _display displayCtrl A3W_STORE_PREVIEW_BACKGROUND;
private _pictureCtrl = _display displayCtrl A3W_STORE_PREVIEW_PICTURE;
private _modelCtrl = _display displayCtrl A3W_STORE_PREVIEW_MODEL;

private _rotation = _display getVariable ["A3W_storePreviewRotation", -1];
if (_rotation != -1) then
{
	removeMissionEventHandler ["EachFrame", _rotation];
	_display setVariable ["A3W_storePreviewRotation", -1];
};

_background ctrlShow false;
_pictureCtrl ctrlShow false;
_modelCtrl ctrlShow false;
if (_data == "") exitWith {};

// Vehicle store rows keep the full catalog entry for the purchase script.
private _class = if (_vehicleRow) then { (parseSimpleArray _data) param [1, ""] } else { _data };
private _cfg = configFile >> "CfgVehicles" >> _class;
if (!isClass _cfg) then
{
	{
		_cfg = configFile >> _x >> _class;
		if (isClass _cfg) exitWith {};
	} forEach ["CfgWeapons", "CfgMagazines", "CfgGlasses"];
};

if (!isClass _cfg) then
{
	// Wasteland inventory entries can use the class of their dropped object.
	private _item = _class call mf_inventory_get;
	private _objectClass = if (_item isEqualType []) then { _item select OBJECT } else { "" };
	if (_objectClass == "") then
	{
		// These items deploy an object directly and have no dropped object.
		_objectClass = switch (_class) do
		{
			case "quad": { "I_G_Quadbike_01_F" };
			case "shield": { "Land_Mil_WallBig_corner_battered_F" };
			case "carSpawns": { "C_Hatchback_01_sport_F" };
			case "heliSpawns": { "C_Heli_Light_01_civil_F" };
			default { "" };
		};
	};
	_cfg = configFile >> "CfgVehicles" >> _objectClass;
};

(ctrlPosition _background) params ["_x", "_y", "_w", "_h"];
if (_w <= 0) exitWith {};

private _model = getText (_cfg >> "model");
private _modelSize = [0, 0, 0];
private _center = [0, 0, 0];
if (_model != "" && {!isNull _modelCtrl}) then
{
	if ((toLower _model) find ".p3d" == -1) then { _model = _model + ".p3d" };
	if (_model select [0, 1] != "\") then { _model = "\" + _model };

	if (fileExists _model) then
	{
		// Only measure the model. The visible copy belongs to the dialog.
		private _sample = createSimpleObject [_model select [1], [0, 0, -1000], true];
		if (!isNull _sample) then
		{
			// ClipVisual measures the rendered model instead of its collision or shadow bounds.
			private _bounds = 0 boundingBoxReal _sample;
			if ((_bounds select 0) isEqualTo (_bounds select 1)) then { _bounds = boundingBoxReal _sample };
			_bounds params ["_min", "_max"];
			deleteVehicle _sample;
			_modelSize = _max vectorDiff _min;
			_center = (_min vectorAdd _max) vectorMultiply 0.5;
		};
	};
};

if (vectorMagnitude _modelSize > 0) exitWith
{
	private _horizontalSpan = vectorMagnitude [_modelSize select 0, _modelSize select 1, 0];
	private _height = _modelSize select 2;
	private _panelCenter = [_x + _w / 2, _y + _h / 2];

	_display setVariable ["A3W_storePreviewAutoRotate", true];
	_display setVariable ["A3W_storePreviewAngles", [45, 15]];

	if !(_display getVariable ["A3W_storePreviewMouseHandlers", false]) then
	{
		_display displayAddEventHandler ["MouseButtonDown",
		{
			params ["_display", "_button"];
			if (_button != 0) exitWith { false };
			if !(ctrlShown (_display displayCtrl A3W_STORE_PREVIEW_MODEL)) exitWith { false };

			(ctrlPosition (_display displayCtrl A3W_STORE_PREVIEW_BACKGROUND)) params ["_x", "_y", "_w", "_h"];
			private _mouse = getMousePosition;
			_mouse params ["_mouseX", "_mouseY"];
			if (_mouseX < _x || {_mouseX > _x + _w} || {_mouseY < _y} || {_mouseY > _y + _h}) exitWith { false };

			_display setVariable ["A3W_storePreviewAutoRotate", false];
			_display setVariable ["A3W_storePreviewDrag", [_mouse, _display getVariable "A3W_storePreviewAngles"]];
			true
		}];

		// Listen on the display so releasing outside the preview also ends the drag.
		_display displayAddEventHandler ["MouseButtonUp",
		{
			params ["_display", "_button"];
			private _drag = _display getVariable ["A3W_storePreviewDrag", []];
			if (_button != 0 || {_drag isEqualTo []}) exitWith { false };

			// Pass the release position to the renderer so it also applies the final movement.
			_display setVariable ["A3W_storePreviewDrag", (_drag select [0, 2]) + [getMousePosition]];
			true
		}];

		_display setVariable ["A3W_storePreviewMouseHandlers", true];
	};

	_modelCtrl ctrlSetModel _model;
	_background ctrlShow true;

	_rotation = addMissionEventHandler ["EachFrame",
	{
		_thisArgs params ["_modelCtrl", "_panelCenter", "_center", "_horizontalSpan", "_height", "_w", "_h", "_start"];
		if (isNull _modelCtrl) exitWith { removeMissionEventHandler ["EachFrame", _thisEventHandler] };

		private _display = ctrlParent _modelCtrl;
		private _autoRotate = _display getVariable "A3W_storePreviewAutoRotate";
		private _drag = _display getVariable "A3W_storePreviewDrag";
		if (!_autoRotate && {_drag isEqualTo []}) exitWith {};

		private _angle = 45 + ((diag_tickTime - _start) mod 5) * 72;
		private _pitch = 15;
		if (!_autoRotate) then
		{
			_drag params ["_mouseStart", "_anglesStart", ["_mouseEnd", []]];
			private _mouse = getMousePosition;
			if !(_mouseEnd isEqualTo []) then
			{
				_mouse = _mouseEnd;
				_display setVariable ["A3W_storePreviewDrag", []];
			};
			_angle = ((_anglesStart select 0) + ((_mouse select 0) - (_mouseStart select 0)) * 180 / _w) mod 360;
			_pitch = (((_anglesStart select 1) + ((_mouse select 1) - (_mouseStart select 1)) * 90 / _h) max -45) min 45;
		};

		private _tiltSin = sin _pitch;
		private _tiltCos = cos _pitch;
		private _verticalSpan = _height * _tiltCos + _horizontalSpan * abs _tiltSin;
		private _halfDepth = (_horizontalSpan * _tiltCos + _height * abs _tiltSin) / 2;

		// Fit the entire turn at one scale for this pitch, with padding for perspective.
		private _fit = 0.86 * (((_w * 4 / 3) / (_horizontalSpan max 0.001)) min (_h / (_verticalSpan max 0.001)));
		private _scale = _fit / (1 + _fit * _halfDepth);
		private _shown = ctrlShown _modelCtrl;
		private _previousAngles = _display getVariable "A3W_storePreviewAngles";
		if (!_shown || {_pitch != (_previousAngles select 1)}) then { _modelCtrl ctrlSetModelScale _scale };
		_display setVariable ["A3W_storePreviewAngles", [_angle, _pitch]];

		private _sin = sin _angle;
		private _cos = cos _angle;
		private _direction = [_sin, _cos * _tiltCos, _cos * _tiltSin];
		private _up = [0, -_tiltSin, _tiltCos];

		// Keep the center of the visible geometry fixed even if the P3D origin is off-center.
		private _offset = _center vectorMultiply _scale;
		private _sideOffset = _offset vectorDotProduct [_cos, -_sin, 0];
		private _forwardOffset = _offset vectorDotProduct [_sin, _cos, 0];
		private _heightOffset = _offset select 2;
		private _depthOffset = _forwardOffset * _tiltCos - _heightOffset * _tiltSin;
		private _upOffset = _forwardOffset * _tiltSin + _heightOffset * _tiltCos;

		_modelCtrl ctrlSetModelDirAndUp [_direction, _up];
		_modelCtrl ctrlSetPosition [(_panelCenter select 0) - _sideOffset * 0.75, 1 - _depthOffset, (_panelCenter select 1) + _upOffset];
		if (!_shown) then { _modelCtrl ctrlShow true };
	}, [_modelCtrl, _panelCenter, _center, _horizontalSpan, _height, _w, _h, diag_tickTime]];
	_display setVariable ["A3W_storePreviewRotation", _rotation];
};

private _pictures = [getText (_cfg >> "editorPreview"), _list lbPicture _row, getText (_cfg >> "picture")];
private _index = _pictures findIf { _x != "" && {fileExists _x} };
if (_index == -1) exitWith {};

private _pad = 0.06 * (_w min _h);
_pictureCtrl ctrlSetPosition [_x + _pad, _y + _pad, _w - 2 * _pad, _h - 2 * _pad];
_pictureCtrl ctrlCommit 0;
_pictureCtrl ctrlSetText (_pictures select _index);
_pictureCtrl ctrlShow true;
_background ctrlShow true;
