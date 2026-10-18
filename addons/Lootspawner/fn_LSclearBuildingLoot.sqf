// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2026 A3Wasteland.com *
// ******************************************************************************************
// Called in scheduled code while BuildingLoot is locked for this building.
// Keep references so moved loot is also removed, without touching another spawner's objects.

private _building = _this;
private _oldLoot = (_building getVariable ["A3W_lootSpawnerObjects", []]) select
{
	!isNull _x && {_x getVariable ["A3W_lootSpawner", false]} &&
	{(_x getVariable ["A3W_lootSpawnerBuilding", objNull]) isEqualTo _building}
};

{ deleteVehicle _x } forEach _oldLoot;

// deleteVehicle completes on the next frame. Finish removal before testing spawn positions.
if (count _oldLoot > 0) then
{
	waitUntil {uiSleep 0.01; { !isNull _x } count _oldLoot == 0};
};

_building setVariable ["A3W_lootSpawnerObjects", []];
