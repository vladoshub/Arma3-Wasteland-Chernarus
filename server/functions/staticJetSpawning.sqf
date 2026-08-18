// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: staticJetsSpawning.sqf
//	@file Author: [404] Costlyy, AgentRev
//	@file Created: 20/12/2012 21:00
//	@file Description: Random static helis
//	@file Args:

if (!isServer) exitWith {}; //BY_VLADOS

private ["_count", "_position", "_markerName", "_marker", "_newPos", "_i", "_doSpawnWreck"];
_count = 0;

{
	_marker = _x;

	if (["jetSpawn_", _marker] call fn_startsWith) then
	{
		if (!(_marker in currentStaticJets) && {random 1 < 0.15}) then // 15% chance spawning
		{
			_position = markerPos _marker;
			[0, _position] call staticJetCreation;

			currentStaticJets pushBack _marker;

			_count = _count + 1;
		};
	};
} forEach allMapMarkers;

//no_log format["WASTELAND SERVER - %1 Static jets Spawned",_count];