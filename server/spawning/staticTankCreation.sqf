// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: staticTankCreation.sqf
//	@file Author: [404] Costlyy
//	@file Created: 20/12/2012 21:00
//	@file Description: Random static helis
//	@file Args: [int (0 = not wreck | 1 = wreck), array (position)]

if (!isServer) exitWith {};

private ["_isWreck", "_spawnPos", "_spawnType", "_finalPos", "_currTank"]; //BY_VLADOS

_isWreck = _this select 0;
_spawnPos = _this select 1;

_spawnType = staticTankList call fn_selectRandomNested;
_finalPos = _spawnPos findEmptyPosition [0, 50, _spawnType];

if (count _finalPos == 0) then { _finalPos = _spawnPos };

_currTank = createVehicle [_spawnType, _finalPos, [], 0, "None"];

_currTank setPosATL [_finalPos select 0, _finalPos select 1, (_finalPos select 2) + 0.1];
_currTank setDir random 360;
_currTank setVelocity [0,0,0.01];

[_currTank] call vehicleSetup;

_currTank setVariable ["A3W_notForSale", true, true];

_currTank setFuel (0.1 + random 0.2);
_currTank setVehicleAmmo 0.5;

_currTank enableSimulationGlobal true;
