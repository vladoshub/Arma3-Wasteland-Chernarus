// Server-generated availability, shared with all clients including JIP.
params ["_catalog", "_section", "_item"];
private _available = missionNamespace getVariable [format ["A3W_dynamic%1AvailableItems", _catalog], nil];
if (isNil "_available") exitWith {true};
private _key = if (_item isEqualType "") then {toLower _item} else {str _item};
(format ["%1|%2", _section, _key]) in _available
