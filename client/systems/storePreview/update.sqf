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
if (_row < 0 && {_listId != (_display getVariable ["A3W_storePreviewList", -1])}) exitWith {};
_display setVariable ["A3W_storePreviewList", _listId];

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
if (_row < 0 || {_row >= lbSize _list}) exitWith {};

private _data = _list lbData _row;
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
private _extent = 0;
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
			(boundingBoxReal _sample) params ["_min", "_max"];
			deleteVehicle _sample;
			_extent = vectorMagnitude (_max vectorDiff _min);
			_center = (_min vectorAdd _max) vectorMultiply 0.5;
		};
	};
};

if (_extent > 0) exitWith
{
	private _scale = 0.5 * ((_w * 4 / 3) min _h) / _extent;
	private _panelCenter = [_x + _w / 2, _y + _h / 2 + ((_center select 2) * _scale)];
	private _offset = _center vectorMultiply (_scale * 0.75);

	_modelCtrl ctrlSetModel _model;
	_modelCtrl ctrlSetModelScale _scale;
	_background ctrlShow true;

	_rotation = addMissionEventHandler ["EachFrame",
	{
		_thisArgs params ["_modelCtrl", "_panelCenter", "_offset", "_start"];
		if (isNull _modelCtrl) exitWith { removeMissionEventHandler ["EachFrame", _thisEventHandler] };

		private _angle = 45 + ((diag_tickTime - _start) mod 5) * 72;
		private _sin = sin _angle;
		private _cos = cos _angle;
		private _sideOffset = _offset vectorDotProduct [_cos, -_sin, 0];
		_modelCtrl ctrlSetModelDirAndUp [[_sin, _cos, 0], [0, 0, 1]];
		_modelCtrl ctrlSetPosition [(_panelCenter select 0) - _sideOffset, 1, _panelCenter select 1];
		if !(ctrlShown _modelCtrl) then { _modelCtrl ctrlShow true };
	}, [_modelCtrl, _panelCenter, _offset, diag_tickTime]];
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
