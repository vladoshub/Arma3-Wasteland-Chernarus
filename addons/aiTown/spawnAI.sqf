params ["_player", "_mSize", "_timeWait", "_townMarker"];


sleep _timeWait;

private _squareM = (markerSize (_townMarker) select 0) * (markerSize (_townMarker) select 1);
private _aiCount = round (_squareM / 2000);
private _sqrtMarker = round (sqrt _squareM);
//private _aiSpawn = _aiCount - count (allUnits select { !([_x, _player] call A3W_fnc_isFriendly) && !(isPlayer _x) && side _x != sideLogic && _x inArea (_townMarker) && _x getVariable ["expAIIUnitFlag",false]});
private _aiSpawn = _aiCount - count (allUnits select { !([_x, _player] call A3W_fnc_isFriendly) && !(isPlayer _x) && side _x != sideLogic && ((_x distance markerPos (_townMarker)) < (_sqrtMarker + 50)) && _x getVariable ["expAIIUnitFlag",false]});
_aiSpawn = round (random [0, _aiSpawn/2, (_aiSpawn + 1)]);

if(_player inArea _townMarker && ((serverTime - (missionNamespace getVariable [(_townMarker) + "_last_spawn_ai",  0])) > 0) ) then {
	if(_aiSpawn >= 2 && (random 1) <= 0.15) then {
		[(getPos _player), _aiSpawn, _mSize] call createCustomGroupTown;
	};
	missionNamespace setVariable [_townMarker + "_last_spawn_ai", serverTime + (800 + random [0, 150, 400]), true];
};