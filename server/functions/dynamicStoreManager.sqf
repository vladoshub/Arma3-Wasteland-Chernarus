// ******************************************************************************************
// Dynamic Store Manager
// Rolls one server-wide store rotation at mission start and then at a configurable interval.
// Availability is synchronized to all clients (including JIP clients) via public mission vars.
// ******************************************************************************************

if (!isServer) exitWith {};

waitUntil { !isNil "storeConfigDone" };

private _enabled = missionNamespace getVariable ["A3W_dynamicStoreEnabled", true];
if (_enabled isEqualType 0) then { _enabled = _enabled > 0 };
if !(_enabled isEqualType true) then { _enabled = true };

if (!_enabled) exitWith
{
    missionNamespace setVariable ["A3W_dynamicStoreAvailableItems", nil, true];
    missionNamespace setVariable ["A3W_dynamicStoreNextRefresh", -1, true];
    diag_log "[DynamicStore] Disabled";
};

private _arrayNames =
[
    // Gun store
    "pistolArray", "smgArray", "gLauncherArray", "rifleArray", "lmgArray", "launcherArray",
    "staticGunsArray", "throwputArray", "ammoArray", "accessoriesArray",

    // General store
    "headArray", "uniformArray", "vestArray", "backpackArray", "goggleArray",
    "genItemArray", "gasItemArray", "genObjectsArray", "customPlayerItems",

    // Vehicle store
    "landArray", "armoredArray", "tanksArray", "helicoptersArray", "planesArray", "boatsArray"
];

private _allClasses = [];
private _inlineChances = [];

{
    private _arrayCode = missionNamespace getVariable [_x, nil];

    if (!isNil "_arrayCode" && {_arrayCode isEqualType {}}) then
    {
        {
            private _class = _x param [1, "", [""]];
            if !(_class isEqualTo "") then
            {
                _allClasses pushBackUnique _class;

                // Optional inline syntax in storeConfig_*.sqf:
                // ["Name", "Class", price, ..., ["chance", 0.25]]
                private _chanceTagIndex = _x findIf
                {
                    _x isEqualType [] &&
                    {count _x >= 2} &&
                    {toLower (_x param [0, "", [""]]) isEqualTo "chance"}
                };

                if (_chanceTagIndex >= 0) then
                {
                    private _inlineChance = (_x select _chanceTagIndex) param [1, 1, [0]];
                    private _existingIndex = _inlineChances findIf {(_x select 0) isEqualTo _class};

                    if (_existingIndex >= 0) then
                    {
                        _inlineChances set [_existingIndex, [_class, _inlineChance]];
                    }
                    else
                    {
                        _inlineChances pushBack [_class, _inlineChance];
                    };
                };
            };
        } forEach (call _arrayCode);
    };
} forEach _arrayNames;

private _getChance =
{
    params ["_class"];

    private _chance = missionNamespace getVariable ["A3W_dynamicStoreDefaultChance", 1];

    // Inline chance from the store row, if present.
    private _inlineIndex = _inlineChances findIf {(_x select 0) isEqualTo _class};
    if (_inlineIndex >= 0) then
    {
        _chance = (_inlineChances select _inlineIndex) param [1, _chance, [0]];
    };

    // Server config override has the highest priority.
    private _overrides = missionNamespace getVariable ["A3W_dynamicStoreItemChances", []];
    private _index = _overrides findIf
    {
        _x isEqualType [] && {count _x >= 2} && {(_x param [0, "", [""]]) isEqualTo _class}
    };

    if (_index >= 0) then
    {
        _chance = (_overrides select _index) param [1, _chance, [0]];
    };

    // Accept both 0..1 and 0..100 notation. Examples: 0.25 or 25 = 25%.
    if (_chance > 1) then { _chance = _chance / 100 };
    (_chance max 0) min 1
};

private _refreshInterval = missionNamespace getVariable ["A3W_dynamicStoreRefreshInterval", 2 * 60 * 60];
_refreshInterval = _refreshInterval max 0;

private _revision = 0;

while {true} do
{
    private _available = [];

    {
        private _chance = [_x] call _getChance;

        if (_chance >= 1 || {_chance > 0 && {random 1 < _chance}}) then
        {
            _available pushBack _x;
        };
    } forEach _allClasses;

    _revision = _revision + 1;

    missionNamespace setVariable ["A3W_dynamicStoreAvailableItems", _available, true];
    missionNamespace setVariable ["A3W_dynamicStoreRevision", _revision, true];
    missionNamespace setVariable
    [
        "A3W_dynamicStoreNextRefresh",
        if (_refreshInterval > 0) then {serverTime + _refreshInterval} else {-1},
        true
    ];

    diag_log format
    [
        "[DynamicStore] Rotation #%1 generated: %2/%3 items available; next refresh in %4 sec",
        _revision,
        count _available,
        count _allClasses,
        _refreshInterval
    ];

    if (_refreshInterval <= 0) exitWith {};
    sleep _refreshInterval;
};
