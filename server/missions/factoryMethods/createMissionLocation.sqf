// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: createMissionLocation.sqf
//	@file Author: [404] Deadbeat, AgentRev
//	@file Created: 26/1/2013 15:19

if (!isServer) exitWith {};

private _validLocations = [MissionSpawnMarkers, { !(_x select 1) }] call BIS_fnc_conditionalSelect;

private _selectedMarker = (selectRandom _validLocations) select 0;
private _markerIndex = [MissionSpawnMarkers, _selectedMarker] call BIS_fnc_findInPairs;

(MissionSpawnMarkers select _markerIndex) set [1, true];

[markerPos _selectedMarker, _markerIndex]
