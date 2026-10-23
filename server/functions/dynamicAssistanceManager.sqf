// Independent server rotations. Config arrays and airdrop indices never change.
if (!isServer) exitWith {};
params ["_catalog", "_readyVariable", "_sections"];
waitUntil {sleep 0.1; missionNamespace getVariable [_readyVariable, false]};
private _prefix = format ["A3W_dynamic%1", _catalog];
private _enabled = missionNamespace getVariable [_prefix + "Enabled", true];
if (_enabled isEqualType 0) then {_enabled = _enabled > 0};
if !(_enabled isEqualType true) then {_enabled = true};
if (!_enabled) exitWith
{
    missionNamespace setVariable [_prefix + "AvailableItems", nil, true];
    missionNamespace setVariable [_prefix + "NextRefresh", -1, true];
    diag_log format ["[Dynamic%1] Disabled", _catalog];
};
private _interval = missionNamespace getVariable [_prefix + "RefreshInterval", 2 * 60 * 45];
if !(_interval isEqualType 0) then {_interval = 2 * 60 * 45};
_interval = _interval max 0;
private _revision = 0;
while {true} do
{
    private _available = [];
    private _total = 0;
    {
        _x params ["_section", "_arrayName"];
        {
            private _row = _x;
            private _key = if (_catalog == "Factory") then {toLower (_row select 0)} else {str _forEachIndex};
            // Duplicate factory classes must have a single roll, since R3F displays each class once.
            private _chance = 1;
            // Airdrop cargo is also an array; only string-headed arrays can be chance tags.
            private _tag = _row findIf
            {
                _x isEqualType [] && {count _x >= 2} &&
                {(_x select 0) isEqualType ""} &&
                {toLower (_x select 0) == "chance"}
            };
            if (_tag >= 0) then {_chance = (_row select _tag) param [1, 1, [0]]};
            if (_chance > 1) then {_chance = _chance / 100};
            _chance = (_chance max 0) min 1;
            _total = _total + 1;
            if (_chance >= 1 || {_chance > 0 && {random 1 < _chance}}) then
            {
                _available pushBackUnique format ["%1|%2", _section, _key];
            };
        } forEach (missionNamespace getVariable [_arrayName, []]);
    } forEach _sections;
    _revision = _revision + 1;
    missionNamespace setVariable [_prefix + "AvailableItems", _available, true];
    missionNamespace setVariable [_prefix + "Revision", _revision, true];
    missionNamespace setVariable [_prefix + "NextRefresh", if (_interval > 0) then {serverTime + _interval} else {-1}, true];
    diag_log format ["[Dynamic%1] Rotation #%2: %3/%4 positions available; interval %5 sec", _catalog, _revision, count _available, _total, _interval];
    if (_interval <= 0) exitWith {};
    sleep _interval;
};
