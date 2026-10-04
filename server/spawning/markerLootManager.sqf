// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
// Refresh marker-owned ground weapons in terrain buildings around loots_spawn_* markers.

if (!isServer || {missionNamespace getVariable ["A3W_markerLootRunning", false]}) exitWith {};

private _radius = (["A3W_markerLootRadius", 100] call getPublicVar) max 0;
private _interval = ["A3W_markerLootInterval", 15*60] call getPublicVar;
private _markerLimit = floor ((["A3W_markerLootMaxWeapons", 100] call getPublicVar) max 0);
private _buildingLimit = 3;

// Inclusive ammunition range for the launcher classnames below.
private _launcherMagazineMin = 1;
private _launcherMagazineMax = 2;

// Classification only; the spawn list is still A3W_markerLootWeapons plus the CUP block.
private _launcherWeapons = [
    "CUP_launch_Javelin",
    "CUP_lmg_M60E4",
    "CUP_launch_M47",
    "launch_Titan_F",
    "launch_MRAWS_green_rail_F",
    "launch_O_Vorona_brown_F",
    "launch_RPG7_F",
    "launch_RPG32_F",
    "launch_O_Titan_ghex_F"
];
{ _launcherWeapons set [_forEachIndex, toLower _x] } forEach _launcherWeapons;

private _weaponList = +(["A3W_markerLootWeapons", []] call getPublicVar);

if (["A3W_use_CUP", false] call getPublicVar) then
{
    _weaponList append [
        "CUP_launch_Javelin",
        "CUP_launch_M47",
        "CUP_lmg_Pecheneg_woodland",
        "CUP_srifle_M107_LeupoldVX3",
        "CUP_srifle_AS50_SBPMII",
        "CUP_sgun_AA12"
    ];
};

private _allocate = compile preprocessFileLineNumbers "server\functions\markerLootAllocate.sqf";

if (_interval <= 0) exitWith {diag_log "[MarkerLoot] Disabled: interval must be greater than zero"};

// storeConfig_*.sqf is started with execVM; wait for its compiled ammo table.
waitUntil {uiSleep 0.1; !isNil "ammoArray"};
private _ammoRows = call ammoArray;

// Keep only the highest-priced compatible primary magazines. Unknown prices are a fallback.
private _expensiveMagazines =
{
    params ["_magazines"];
    private _compatibleClasses = [];
    { _compatibleClasses pushBack (toLower _x) } forEach _magazines;
    private _highestPrice = -1;
    private _expensiveClasses = [];

    {
        if (_x isEqualType [] && {count _x >= 3}) then
        {
            private _class = _x select 1;
            private _price = _x select 2;
            if (_class isEqualType "" && {_price isEqualType 0} && {_price >= 0} &&
                {(toLower _class) in _compatibleClasses}) then
            {
                if (_price > _highestPrice) then
                {
                    _highestPrice = _price;
                    _expensiveClasses = [];
                };
                if (_price == _highestPrice) then
                {
                    _expensiveClasses pushBackUnique (toLower _class);
                };
            };
        };
    } forEach _ammoRows;

    if (count _expensiveClasses > 0) then
    {
        _magazines select {(toLower _x) in _expensiveClasses}
    }
    else
    {
        _magazines
    }
};

// Validate the list once. Query only the primary muzzle, including magazine wells.
private _weaponPool = [];
{
    if (_x isEqualType "") then
    {
        private _cfg = configFile >> "CfgWeapons" >> _x;
        if (isClass _cfg && {getNumber (_cfg >> "scope") > 0} && {getNumber (_cfg >> "type") in [1, 2, 4]}) then
        {
            private _weapon = configName _cfg;
            private _magazines = (compatibleMagazines [_weapon, "this"]) select
            {
                private _magCfg = configFile >> "CfgMagazines" >> _x;
                isClass _magCfg && {getNumber (_magCfg >> "scope") > 0} && {getNumber (_magCfg >> "count") > 0}
            };
            if (count _magazines > 0) then
            {
                _magazines = [_magazines] call _expensiveMagazines;
                _weaponPool pushBack [_weapon, _magazines];
            }
            else
            {
                diag_log format ["[MarkerLoot] Ignoring weapon without compatible magazines: %1", _x];
            };
        }
        else
        {
            diag_log format ["[MarkerLoot] Ignoring invalid weapon classname: %1", _x];
        };
    };
} forEach _weaponList;

if (count _weaponPool == 0) exitWith {diag_log "[MarkerLoot] Disabled: no usable weapons in A3W_markerLootWeapons"};
A3W_markerLootRunning = true;

// Count actual weapons, not holders: a position can contain several weapons.
// Ownership is checked even for holders carried away from the marker radius.
private _countWeapons =
{
    params ["_holders", "_marker", ["_building", objNull]];
    private _total = 0;
    {
        private _source = _x getVariable ["A3W_markerLootSource", ""];
        if (!isNull _x && {_source != ""} && {_marker == "" || {_source == _marker}} &&
            {isNull _building || {(_x getVariable ["A3W_markerLootBuilding", objNull]) isEqualTo _building}}) then
        {
            { _total = _total + _x } forEach ((getWeaponCargo _x) select 1);
        };
    } forEach _holders;
    _total
};

private _onGround =
{
    params ["_holder"];
    isNull attachedTo _holder &&
    {isNull (_holder getVariable ["R3F_LOG_est_transporte_par", objNull])} &&
    {isNull (_holder getVariable ["R3F_LOG_est_deplace_par", objNull])}
};

private _indoorPositions =
{
    params ["_building", "_center", "_range", "_height"];
    private _positions = [];
    {
        if (_x distance2D _center <= _range) then
        {
            private _asl = AGLToASL _x;
            private _start = _asl vectorAdd [0, 0, 0.3];
            // buildingPos can include roofs and balconies. Require this building overhead.
            private _roof = lineIntersectsSurfaces [_start, _asl vectorAdd [0, 0, _height + 2], objNull, objNull, true, -1, "GEOM", "FIRE"];
            if ({(_x select 2) isEqualTo _building || {(_x select 3) isEqualTo _building}} count _roof > 0) then
            {
                // Snap to the walkable floor. ROADWAY is checked separately from geometry.
                private _end = _asl vectorAdd [0, 0, -2];
                private _floor = lineIntersectsSurfaces [_start, _end, objNull, objNull, true, 1, "ROADWAY", "NONE"];
                if (count _floor == 0) then
                {
                    _floor = lineIntersectsSurfaces [_start, _end, objNull, objNull, true, 1, "GEOM", "FIRE"];
                };
                if (count _floor > 0) then
                {
                    private _hit = _floor select 0;
                    if (((_hit select 1) select 2) > 0.5 &&
                        {isNull (_hit select 2) || {(_hit select 2) isEqualTo _building} || {(_hit select 3) isEqualTo _building}}) then
                    {
                        _positions pushBackUnique ((_hit select 0) vectorAdd [0, 0, 0.03]);
                    };
                };
            };
        };
    } forEach (_building buildingPos -1);
    _positions call BIS_fnc_arrayShuffle
};

while {["A3W_markerLoot"] call isConfigOn} do
{
    private _nextRefresh = diag_tickTime + _interval;
    private _markers = allMapMarkers select {(_x find "loots_spawn_") == 0};
    private _ownedHolders = (allMissionObjects "GroundWeaponHolder") select
    {
        (_x getVariable ["A3W_markerLootSource", ""]) != ""
    };

    // Remove orphaned ground holders if their marker was deleted. Never touch unmarked loot.
    {
        if (!((_x getVariable ["A3W_markerLootSource", ""]) in _markers) && {[_x] call _onGround}) then
        {
            _x setVariable ["A3W_markerLootSource", nil, true];
            deleteVehicle _x;
        };
    } forEach _ownedHolders;
    _ownedHolders = _ownedHolders select {!isNull _x && {(_x getVariable ["A3W_markerLootSource", ""]) != ""}};

    // Shuffle to share overlapping buildings; their capacity applies to all markers combined.
    {
        private _marker = _x;
        private _center = getMarkerPos _marker;
        private _refreshCounts = [];

        // Remember the actual weapons before replacing this marker's ground loot.
        // Other markers and off-ground holders still reserve their building slots.
        {
            if ((_x getVariable ["A3W_markerLootSource", ""]) == _marker && {[_x] call _onGround}) then
            {
                _refreshCounts pushBack
                [
                    _x getVariable ["A3W_markerLootBuilding", objNull],
                    [[_x], _marker] call _countWeapons
                ];
                _x setVariable ["A3W_markerLootSource", nil, true];
                deleteVehicle _x;
            };
        } forEach _ownedHolders;
        _ownedHolders = _ownedHolders select {!isNull _x && {(_x getVariable ["A3W_markerLootSource", ""]) != ""}};

        private _remaining = (_markerLimit - ([_ownedHolders, _marker] call _countWeapons)) max 0;
        private _buildings = [];
        private _replacementCapacities = [];
        private _additionCapacities = [];
        private _terrainBuildings = nearestTerrainObjects [_center, ["HOUSE", "BUILDING", "CHURCH", "CHAPEL", "BUNKER", "FORTRESS", "HOSPITAL"], _radius, false, true];

        {
            private _building = _x;
            if (_remaining > 0 && {alive _building} && {!isObjectHidden _building} &&
                {!(_building getVariable ["A3W_purchasedStoreObject", false])} && {isNil {_building getVariable "baseSaving_hoursAlive"}}) then
            {
                private _box = boundingBoxReal _building;
                private _size = (_box select 1) vectorDiff (_box select 0);
                private _capacity = (_buildingLimit - ([_ownedHolders, "", _building] call _countWeapons)) max 0;
                if (_capacity > 0) then
                {
                    private _positions = [_building, _center, _radius, _size select 2] call _indoorPositions;
                    if (count _positions > 0) then
                    {
                        private _replacementCount = 0;
                        {
                            if ((_x select 0) isEqualTo _building) then
                            {
                                _replacementCount = _replacementCount + (_x select 1);
                            };
                        } forEach _refreshCounts;
                        _replacementCount = _replacementCount min _capacity;

                        _buildings pushBack [_building, _positions];
                        _replacementCapacities pushBack _replacementCount;
                        // Inclusive random addition: empty building 0-3, one weapon 0-2, etc.
                        _additionCapacities pushBack (floor random (_capacity - _replacementCount + 1));
                    };
                };
            };
        } forEach (_terrainBuildings call BIS_fnc_arrayShuffle);

        // Replace existing weapons first, then share the remaining marker budget for additions.
        private _replacementQuotas = [_replacementCapacities, _remaining] call _allocate;
        { _remaining = _remaining - _x } forEach _replacementQuotas;
        private _additionQuotas = [_additionCapacities, _remaining] call _allocate;
        private _spawned = 0;
        {
            _x params ["_building", "_positions"];
            private _quota = (_replacementQuotas select _forEachIndex) + (_additionQuotas select _forEachIndex);
            private _holdersAtPositions = [];
            { _holdersAtPositions pushBack objNull } forEach _positions;

            for "_i" from 0 to (_quota - 1) do
            {
                private _index = _i mod count _positions;
                private _holder = _holdersAtPositions select _index;
                private _position = _positions select _index;
                private _entry = selectRandom _weaponPool;
                private _magazine = selectRandom (_entry select 1);
                private _magazineCount = if ((toLower (_entry select 0)) in _launcherWeapons) then
                {
                    _launcherMagazineMin + floor random (_launcherMagazineMax - _launcherMagazineMin + 1)
                }
                else
                {
                    3 + floor random 3
                };

                // Complete creation and ownership setup before a cleanup script can see it.
                isNil
                {
                    if (isNull _holder) then
                    {
                        _holder = createVehicle ["GroundWeaponHolder", ASLToAGL _position, [], 0, "CAN_COLLIDE"];
                        if (!isNull _holder) then
                        {
                            _holder setPosASL _position;
                            _holder setDir random 360;
                            _holder setVariable ["A3W_markerLootSource", _marker, true];
                            _holder setVariable ["A3W_markerLootBuilding", _building];
                            _holder setVariable ["persistent", true, true];
                            _holder setVariable ["R3F_LOG_disabled", true, true];
                            _holdersAtPositions set [_index, _holder];
                            _ownedHolders pushBack _holder;
                        };
                    };
                    if (!isNull _holder) then
                    {
                        _holder addWeaponCargoGlobal [_entry select 0, 1];
                        _holder addMagazineCargoGlobal [_magazine, _magazineCount];
                        _spawned = _spawned + 1;
                    };
                };
            };
        } forEach _buildings;

        diag_log format ["[MarkerLoot] %1: spawned %2 weapons in %3 buildings, marker total %4/%5", _marker, _spawned, count _buildings, [_ownedHolders, _marker] call _countWeapons, _markerLimit];
        uiSleep 0.01;
    } forEach (_markers call BIS_fnc_arrayShuffle);

    uiSleep ((_nextRefresh - diag_tickTime) max 1);
};

A3W_markerLootRunning = false;
