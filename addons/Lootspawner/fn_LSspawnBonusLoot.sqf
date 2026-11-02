// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2026 A3Wasteland.com *
// ******************************************************************************************
// Run before ordinary loot, while BuildingLoot is locked.
// Roll once per classname per building; successful types get separate free positions.

params ["_building", "_positionIds", "_zAdjustments", "_genZadjust", "_chfullfuel"];

// Duplicate config entries must not grant extra trials or copies of the same classname.
private _bonusClasses = lootBonus_list arrayIntersect lootBonus_list;
// Same server-config lookup as A3W_buildingLootChances; percent applies per building.
private _bonusChance = ((["A3W_buildingLootBonusChances", 5] call getPublicVar) max 0 min 100) / 100;
private _requests = [];
{
	private _roll = random 1;
	if (_roll < _bonusChance) then {_requests pushBack _x};
	if (swDebugLS) then
	{
		diag_log format ["[LS bonus] building=%1 class=%2 roll=%3 passed=%4", netId _building, _x, _roll, _roll < _bonusChance];
	};
} forEach _bonusClasses;

if (count _requests == 0) exitWith {[]};

// Keep the model's validated building positions instead of shifting objects towards walls.
// Positions are kept in ASL for comparisons so terrain elevation and different floors work.
private _candidates = [];
{
	private _pos = _building buildingPos _x;
	if ((_pos select 0) == 0 && {(_pos select 1) == 0}) then {_pos = getPosATL _building};
	if (swSpZadjust) then {_pos set [2, (_pos select 2) + (_zAdjustments select _forEachIndex)]};
	_pos set [2, (_pos select 2) + _genZadjust];
	if (getTerrainHeightASL _pos >= 0) then {_pos = ATLToASL _pos};
	_candidates pushBack _pos;
} forEach _positionIds;

private _buildingLoot = _building getVariable ["A3W_lootSpawnerObjects", []];
private _clearance = 1.0;
private _bonusPositions = [];

{
	private _bonusClass = _x;
	private _freeIndices = [];
	{
		private _candidate = _x;
		// Check registered objects as well as nearby loot from other buildings/spawners.
		private _occupied = (_buildingLoot findIf {
			!isNull _x && {(getPosASL _x) vectorDistance _candidate <= _clearance}
		}) >= 0;
		if (!_occupied && {count (nearestObjects [ASLToATL _candidate, LSusedclass_list, _clearance]) == 0}) then
		{
			_freeIndices pushBack _forEachIndex;
		};
	} forEach _candidates;

	if (count _freeIndices > 0) then
	{
		private _bonusPos = _candidates deleteAt (selectRandom _freeIndices);
		// Spawn away from the building, then place at a separate, unoccupied model position.
		private _tmpPos = [_bonusPos select 0, _bonusPos select 1, 60000];
		private _bonusHolder = objNull;
		if (_bonusClass == "FirstAidKit") then
		{
			_bonusHolder = createVehicle ["GroundWeaponHolder", _tmpPos, [], 0, "CAN_COLLIDE"];
			_bonusHolder addItemCargoGlobal ["FirstAidKit", 1];
		}
		else
		{
			_bonusHolder = createVehicle [_bonusClass, _tmpPos, [], 0, "CAN_COLLIDE"];
			private _itemId = "repairkit";
			if (_bonusClass == "Land_CanisterFuel_F") then
			{
				_itemId = if (random 100 < _chfullfuel) then {"jerrycanfull"} else {"jerrycanempty"};
			};
			_bonusHolder setVariable ["mf_item_id", _itemId, true];
		};

		if (!isNull _bonusHolder) then
		{
			_bonusHolder setVariable ["A3W_lootSpawner", true, true];
			_bonusHolder setVariable ["A3W_lootSpawnerBuilding", _building];
			_bonusHolder setVariable ["A3W_lootSpawnerBonusClass", _bonusClass];
			_bonusHolder setVariable ["Lootready", diag_tickTime];
			_buildingLoot pushBack _bonusHolder;
			LS_spawnedLoot pushBack _bonusHolder;
			_bonusHolder setDir (random 360);
			_bonusHolder setPosASL _bonusPos;
			sleep 0.001;
			// Preserve the existing floor-height correction, starting from this object's own slot.
			_bonusPos set [2, (_bonusPos select 2) - ((getPos _bonusHolder) select 2)];
			_bonusHolder setPosASL _bonusPos;
			_bonusHolder setVariable ["Lootready", diag_tickTime];
			_bonusPositions pushBack (getPosASL _bonusHolder);
		};
	}
	else
	{
		// A successful roll with no free slot is skipped; never reroll or stack onto existing loot.
		if (swDebugLS) then {diag_log format ["[LS bonus] building=%1 class=%2 skipped: no free position", netId _building, _bonusClass]};
	};
} forEach _requests;

_building setVariable ["A3W_lootSpawnerObjects", _buildingLoot];

_bonusPositions
