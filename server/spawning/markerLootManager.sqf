// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
// Refresh marker-owned ground weapons in terrain buildings around loots_spawn_* markers.

if (!isServer || {missionNamespace getVariable ["A3W_markerLootRunning", false]}) exitWith {};

private _radius = (["A3W_markerLootRadius", 100] call getPublicVar) max 0;
private _interval = ["A3W_markerLootInterval", 15*60] call getPublicVar;
private _markerLimit = floor ((["A3W_markerLootMaxWeapons", 100] call getPublicVar) max 0);
private _density = (["A3W_markerLootWeaponsPerMeter", 2] call getPublicVar) max 0;

// Inclusive ammunition range for the launcher classnames below.
private _launcherMagazineMin = 1;
private _launcherMagazineMax = 3;

// Classification only; the spawn list is still A3W_markerLootWeapons plus the CUP block.
private _launcherWeapons = [
    "CUP_launch_Javelin",
    "CUP_launch_M47",
    "launch_Titan_F",
    "launch_MRAWS_green_rail_F",
    "launch_O_Vorona_brown_F",
    "launch_RPG7_F",
    "launch_RPG32_F"
];
{ _launcherWeapons set [_forEachIndex, toLower _x] } forEach _launcherWeapons;

private _weaponList = +(["A3W_markerLootWeapons", []] call getPublicVar);

if (["A3W_use_CUP", false] call getPublicVar) then
{
    _weaponList append [
        "CUP_launch_Javelin",
        "CUP_launch_M47",
        "CUP_lmg_Pecheneg_woodland",
        "CUP_lmg_M60E4",
        "CUP_lmg_PKM",
        "CUP_srifle_M107_LeupoldVX3",
        "CUP_srifle_AS50_SBPMII",
        "CUP_srifle_m110_kac_black",
        "CUP_srifle_SVD",
        "CUP_sgun_AA12",
        "CUP_arifle_AK107_GL_pso",
        "CUP_glaunch_Mk13",
        "CUP_srifle_VSSVintorez_pso",
        "CUP_arifle_M16A4_GL"
    ];
};

private _allocate = compile preprocessFileLineNumbers "server\functions\markerLootAllocate.sqf";

if (_interval <= 0) exitWith {diag_log "[MarkerLoot] Disabled: interval must be greater than zero"};

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

    // One complete refresh, even if nothing was collected. Never touch unmarked loot.
    // Also remove orphaned ground holders if their marker was deleted.
    {
        if ([_x] call _onGround) then
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
        private _remaining = (_markerLimit - ([_ownedHolders, _marker] call _countWeapons)) max 0;
        private _buildings = [];
        private _capacities = [];
        private _terrainBuildings = nearestTerrainObjects [_center, ["HOUSE", "BUILDING", "CHURCH", "CHAPEL", "BUNKER", "FORTRESS", "HOSPITAL"], _radius, false, true];

        {
            private _building = _x;
            if (_remaining > 0 && {alive _building} && {!isObjectHidden _building} &&
                {!(_building getVariable ["A3W_purchasedStoreObject", false])} && {isNil {_building getVariable "baseSaving_hoursAlive"}}) then
            {
                private _box = boundingBoxReal _building;
                private _size = (_box select 1) vectorDiff (_box select 0);
                private _width = _size select 0;
                private _length = _size select 1;
                private _diameter = sqrt (_width * _width + _length * _length);
                private _capacity = (floor (_diameter * _density) - ([_ownedHolders, "", _building] call _countWeapons)) max 0;
                if (_capacity > 0) then
                {
                    private _positions = [_building, _center, _radius, _size select 2] call _indoorPositions;
                    if (count _positions > 0) then
                    {
                        _buildings pushBack [_building, _positions];
                        _capacities pushBack _capacity;
                    };
                };
            };
        } forEach (_terrainBuildings call BIS_fnc_arrayShuffle);

        private _quotas = [_capacities, _remaining] call _allocate;
        private _spawned = 0;
        {
            _x params ["_building", "_positions"];
            private _quota = _quotas select _forEachIndex;
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
                    3 + floor random 2
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
