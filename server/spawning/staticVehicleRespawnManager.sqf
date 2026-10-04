// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: staticVehicleRespawnManager.sqf
//	@file Description: Retry random vehicle spawns at empty static spawn markers.

if (!isServer) exitWith {};

private _interval = ["A3W_staticVehicleRespawnInterval", 30*60] call getPublicVar;
if (_interval <= 0) exitWith {}; // Keep the startup spawns, disable further attempts.

private _spawnHelis = compile preprocessFileLineNumbers "server\functions\staticHeliSpawning.sqf";
private _spawnJets = compile preprocessFileLineNumbers "server\functions\staticJetSpawning.sqf";
private _spawnTanks = compile preprocessFileLineNumbers "server\functions\staticTankSpawning.sqf";

while {true} do
{
	uiSleep _interval;

	if (!(["A3W_serverSpawning"] call isConfigOn) || {!(["A3W_heliSpawning"] call isConfigOn)}) exitWith {};

	private _helis = call _spawnHelis;
	private _jets = call _spawnJets;
	private _tanks = call _spawnTanks;

	diag_log format ["[StaticVehicleRespawn] Spawned %1 helicopters, %2 jets, %3 tanks", _helis, _jets, _tanks];
};
