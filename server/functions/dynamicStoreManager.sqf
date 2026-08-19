// ******************************************************************************************
// Dynamic Store Manager
// Rolls every store position independently using the ["chance", X] value stored in that row.
// Each section is kept separate, so duplicate classNames/variants can roll independently.
// ******************************************************************************************

if (!isServer) exitWith {};

waitUntil { !isNil "storeConfigDone" };

private _enabled = missionNamespace getVariable ["A3W_dynamicStoreEnabled", true];
if (_enabled isEqualType 0) then { _enabled = _enabled > 0 };
if !(_enabled isEqualType true) then { _enabled = true };

if (!_enabled) exitWith
{
    missionNamespace setVariable ["A3W_dynamicStoreAvailableItems", nil, true];
    missionNamespace setVariable ["A3W_dynamicStoreAvailableClasses", nil, true];
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

private _refreshInterval = missionNamespace getVariable ["A3W_dynamicStoreRefreshInterval", 2 * 60 * 60];
_refreshInterval = _refreshInterval max 0;

private _revision = 0;

while {true} do
{
    private _availableKeys = [];
    private _availableClasses = [];
    private _totalRows = 0;

    {
        private _section = _x;
        private _arrayCode = missionNamespace getVariable [_section, nil];

        if (!isNil "_arrayCode" && {_arrayCode isEqualType {}}) then
        {
            {
                private _row = _x;
                private _class = _row param [1, "", [""]];

                if !(_class isEqualTo "") then
                {
                    _totalRows = _totalRows + 1;

                    private _chance = 1;
                    private _chanceTagIndex = _row findIf
                    {
                        _x isEqualType [] &&
                        {count _x >= 2} &&
                        {toLower (_x param [0, "", [""]]) isEqualTo "chance"}
                    };

                    if (_chanceTagIndex >= 0) then
                    {
                        _chance = (_row select _chanceTagIndex) param [1, 1, [0]];
                    };

                    // Support either 0..1 or 0..100 notation.
                    if (_chance > 1) then { _chance = _chance / 100 };
                    _chance = (_chance max 0) min 1;

                    if (_chance >= 1 || {_chance > 0 && {random 1 < _chance}}) then
                    {
                        // Section is part of the key so the same class/row can roll independently
                        // when it appears in different store sections.
                        _availableKeys pushBack format ["%1|%2", _section, str _row];
                        _availableClasses pushBackUnique _class;
                    };
                };
            } forEach (call _arrayCode);
        };
    } forEach _arrayNames;

    _revision = _revision + 1;

    missionNamespace setVariable ["A3W_dynamicStoreAvailableItems", _availableKeys, true];
    missionNamespace setVariable ["A3W_dynamicStoreAvailableClasses", _availableClasses, true];
    missionNamespace setVariable ["A3W_dynamicStoreRevision", _revision, true];
    missionNamespace setVariable
    [
        "A3W_dynamicStoreNextRefresh",
        if (_refreshInterval > 0) then {serverTime + _refreshInterval} else {-1},
        true
    ];

    diag_log format
    [
        "[DynamicStore] Rotation #%1 generated: %2/%3 store positions available; next refresh in %4 sec",
        _revision,
        count _availableKeys,
        _totalRows,
        _refreshInterval
    ];

    if (_refreshInterval <= 0) exitWith {};
    sleep _refreshInterval;
};
