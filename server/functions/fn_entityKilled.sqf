// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2018 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_entityKilled.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

params ["_entity", "_presumedKiller", "_instigator"];

// AI killed
if (_entity isKindOf "CAManBase" && !isPlayer _entity && {isNil {_entity getVariable "cmoney"} && getText (configFile >> "CfgVehicles" >> typeOf _entity >> "simulation") != "UAVPilot"}) then
{
	[_entity, _presumedKiller, "", _instigator] call FAR_setKillerInfo;

	private _killer = _entity getVariable "FAR_killerUnit";

	if (isNil "_killer" || {isNull _killer}) then
	{
		_killer = [_instigator, _presumedKiller] select isNull _instigator;
	};

	[_entity, effectiveCommander _killer, effectiveCommander _presumedKiller] call A3W_fnc_serverPlayerDied;
};

if(isPlayer _entity) then {
	_entity setVariable ["forCleanMission", false, true];
};


if ((_entity getVariable ["fpvInit", "0"]) == "2") then {
if (count (attachedObjects (_entity)) > 0) then {
	private _exp = "SmallSecondary";
	{
		_exp = (getMagazineCargo _x) select 0 select 0;
		_exp = getText (configFile >> "cfgMagazines" >> _exp >> "ammo");
 		detach _x;
 		deleteVehicle _x;
	} forEach attachedObjects (_entity);	
	private _bombDrone = _exp createVehicle (getpos _entity);
	_bombDrone setPosATL (getPosATL _entity);
	_bombDrone setDir (getDir _entity);
	_bombDrone setDamage 1;
};
_entity setVariable ["fpvInit", "0", true];
_entity setVariable ["fpvInitOwnerUid", "", true];
deleteVehicle _entity;
};