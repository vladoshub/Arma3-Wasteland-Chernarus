// Returns [blocked by online player count, remaining cooldown in seconds].
params ["_marker", ["_playerCount", -1]];

private _matches = (call spawnList) select { (_x select 0) isEqualTo _marker };
private _entry = _matches param [0, []];
private _playerLimit = _entry param [1, -1];
private _baseCooldown = _entry param [3, 200];

if (_playerCount < 0) then
{
	_playerCount = count (allPlayers - (entities "HeadlessClient_F"));
};

if (_playerLimit >= 0 && {_playerCount >= _playerLimit}) exitWith { [true, 0] };

private _lastSpawn = player getVariable [_marker + "_lastSpawn", false];
if !(_lastSpawn isEqualType 0) exitWith { [false, 0] };

private _cooldown = _baseCooldown + (5 * 60) * (floor (_playerCount / 8) min 3);
[false, (_cooldown - (diag_tickTime - _lastSpawn)) max 0]
