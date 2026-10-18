// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2026 A3Wasteland.com *
// ******************************************************************************************
// Expire every tracked LS object, regardless of nearby players, locks or cargo.

private _objLifetime = _this;
private _countDel = 0;
{
	if (!isNull _x && {_x getVariable ["A3W_lootSpawner", false]} &&
		{diag_tickTime - (_x getVariable ["Lootready", diag_tickTime]) > _objLifetime}) then
	{
		deleteVehicle _x;
		_countDel = _countDel + 1;
	};
} forEach +LS_spawnedLoot;

// Prune collected/deleted holders without losing registrations from concurrent spawn jobs.
isNil {LS_spawnedLoot = LS_spawnedLoot select {!isNull _x}};

_countDel
