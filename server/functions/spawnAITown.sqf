params ["_playerPos", "_aiSpawn","_townName", "_mSize"];

[_playerPos, _aiSpawn, _mSize] call createCustomGroupTown;
missionNamespace setVariable [_townName + "_last_spawn_ai", serverTime + 300, true];