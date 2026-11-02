// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
// Apply a fresh empty-tank roll to each newly spawned or respawned vehicle.
// Use the source list name so nested lists and classnames shared by different pools work correctly.

if (!isServer) exitWith {};

params ["_vehicle", "_normalFuel", ["_spawnCategory", "", [""]]];

private _emptyFuelChance = 0;

if (_spawnCategory in ["mediumMilitaryVehicles", "lightMilitaryVehicles", "staticJetList", "staticHeliList", "staticTankList", "staticPlaneList"]) then
{
	_emptyFuelChance = ((["A3W_vehicleEmptyFuelChance", 50] call getPublicVar) max 0) min 100;


	//if (_spawnCategory == "lightMilitaryVehicles") then
	//{
	//	_emptyFuelChance = (_emptyFuelChance - 25) max 0;
	//};

};

_vehicle setFuel (if (random 100 < _emptyFuelChance) then {0} else {_normalFuel});
