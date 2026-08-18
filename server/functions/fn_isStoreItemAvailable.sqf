// ******************************************************************************************
// Dynamic store availability helper
// Returns true when an item is currently available, or when dynamic store data is not ready.
// ******************************************************************************************

params [["_class", "", [""]]];

if (_class isEqualTo "") exitWith { true };

private _available = missionNamespace getVariable ["A3W_dynamicStoreAvailableItems", nil];

// Fail open while the server is still building / synchronizing the first rotation.
if (isNil "_available") exitWith { true };

_class in _available
