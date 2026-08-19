// ******************************************************************************************
// Dynamic store availability helper
//
// Preferred row-aware call:
//   [_row, "rifleArray"] call A3W_fnc_isStoreItemAvailable
//
// Compatibility call using only className is also supported for legacy purchase code.
// ******************************************************************************************

params ["_item", ["_section", "", [""]]];

private _available = missionNamespace getVariable ["A3W_dynamicStoreAvailableItems", nil];

// Fail open while the first server rotation is still being generated/synchronized.
if (isNil "_available") exitWith { true };

if (_item isEqualType []) exitWith
{
    if (_section != "") then
    {
        (format ["%1|%2", _section, str _item]) in _available
    }
    else
    {
        // Used by server-side object/vehicle spawning where the exact row is known
        // but the caller does not retain the source section name.
        private _rowText = str _item;
        private _sections =
        [
            "pistolArray", "smgArray", "gLauncherArray", "rifleArray", "lmgArray", "launcherArray",
            "staticGunsArray", "throwputArray", "ammoArray", "accessoriesArray",
            "headArray", "uniformArray", "vestArray", "backpackArray", "goggleArray",
            "genItemArray", "gasItemArray", "genObjectsArray", "customPlayerItems",
            "landArray", "armoredArray", "tanksArray", "helicoptersArray", "planesArray", "boatsArray"
        ];

        _sections findIf { (format ["%1|%2", _x, _rowText]) in _available } >= 0
    };
};

if (_item isEqualType "") exitWith
{
    if (_item isEqualTo "") exitWith { true };
    private _classes = missionNamespace getVariable ["A3W_dynamicStoreAvailableClasses", []];
    _item in _classes
};

true
