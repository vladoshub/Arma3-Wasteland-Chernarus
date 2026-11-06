// EachFrame is unscheduled, so a bullet impact cannot race the fatigue update.
#include "config.hpp"

private _unit = missionNamespace getVariable ["A3W_staminaLocalUnit", objNull];
if (isNull _unit) exitWith {};
if (!alive _unit || {!local _unit} || {_unit != player}) exitWith
{
	[_unit] call A3W_fnc_staminaStop;
};

private _now = diag_tickTime;
private _lastUpdate = _unit getVariable ["A3W_staminaUpdatedAt", _now];
if (_now - _lastUpdate < 0.1) exitWith {};
private _delta = _now - (_lastUpdate max (_unit getVariable ["A3W_staminaImpactAt", -1]));
_unit setVariable ["A3W_staminaUpdatedAt", _now];

private _active = !(_unit getVariable ["playerSpawning", false]) && {!(_unit call A3W_fnc_isUnconscious)};
private _onFoot = isNull objectParent _unit;
private _velocity = velocity _unit;
private _moving = abs (_velocity select 0) + abs (_velocity select 1) > 0.1;
// Read the animation mode, so slowing a run never causes it to count as walking.
private _movement = toLower ([_unit, ["M"]] call getMoveParams);
private _running = _active && {_onFoot} && {_moving} && {stance _unit in ["STAND", "CROUCH"]} && {_movement in ["mrun", "mtac", "meva"]};

private _total = A3W_STAMINA_FREE_RUN + A3W_STAMINA_PENALTY_RUN;
private _exertion = _unit getVariable ["A3W_staminaExertion", 0];
if (_running) then
{
	_exertion = (_exertion + _delta) min _total;
}
else
{
	_exertion = (_exertion - _delta * (_total / A3W_STAMINA_RECOVERY)) max 0;
};
private _penalty = (((_exertion - A3W_STAMINA_FREE_RUN) / A3W_STAMINA_PENALTY_RUN) max 0) min 1;
_unit setVariable ["A3W_staminaExertion", _exertion];
_unit setVariable ["A3W_staminaPenalty", _penalty];

// Compose with other scripts' coefficients, including stash and vehicle entry.
private _currentSpeed = getAnimSpeedCoef _unit;
private _baseSpeed = _unit getVariable ["A3W_staminaBaseSpeed", 1];
if (abs (_currentSpeed - (_unit getVariable ["A3W_staminaAppliedSpeed", _currentSpeed])) > 0.0001) then
{
	_baseSpeed = _currentSpeed;
	_unit setVariable ["A3W_staminaBaseSpeed", _baseSpeed];
};
private _speedMultiplier = 1;
if (_running) then {_speedMultiplier = 1 - A3W_STAMINA_SPEED_PENALTY * _penalty};
private _speed = _baseSpeed * _speedMultiplier;
if (abs (_currentSpeed - _speed) > 0.0001) then {_unit setAnimSpeedCoef _speed};
_unit setVariable ["A3W_staminaAppliedSpeed", _speed];

private _currentAim = getCustomAimCoef _unit;
private _baseAim = _unit getVariable ["A3W_staminaBaseAim", 0.3];
if (abs (_currentAim - (_unit getVariable ["A3W_staminaAppliedAim", _currentAim])) > 0.0001) then
{
	_baseAim = _currentAim;
	_unit setVariable ["A3W_staminaBaseAim", _baseAim];
};
private _aim = _baseAim * (1 + (A3W_STAMINA_AIM_MULTIPLIER - 1) * _penalty);
if (abs (_currentAim - _aim) > 0.0001) then {_unit setCustomAimCoef _aim};
_unit setVariable ["A3W_staminaAppliedAim", _aim];

private _breathSound = _unit getVariable ["A3W_staminaBreathSound", -1];
private _recoveredSound = _unit getVariable ["A3W_staminaRecoveredSound", -1];
private _impactSound = _unit getVariable ["A3W_staminaImpactSound", -1];
// Observe the actual end of playback, including when no more bullets arrive.
if (_impactSound >= 0 && {(soundParams _impactSound) isEqualTo []}) then
{
	_impactSound = -1;
	_unit setVariable ["A3W_staminaImpactSound", -1];
	_unit setVariable ["A3W_staminaImpactSoundReadyAt", _now + A3W_STAMINA_IMPACT_SOUND_GAP];
};
private _hadPenalty = _unit getVariable ["A3W_staminaHadPenalty", false];
private _recoveryPending = _unit getVariable ["A3W_staminaRecoveryPending", false];
if (_penalty > 0) then
{
	// A fresh penalty cancels a recovery announcement that has not started yet.
	_recoveryPending = false;
}
else
{
	if (_hadPenalty) then {_recoveryPending = true};
};

if (!_active || {!_onFoot}) then
{
	// Vehicle entry and incapacitation silence all sounds and discard the queue.
	if (_impactSound >= 0) then
	{
		_unit setVariable ["A3W_staminaImpactSoundReadyAt", _now + A3W_STAMINA_IMPACT_SOUND_GAP];
	};
	{
		private _sound = _unit getVariable [_x, -1];
		if (_sound >= 0) then {stopSound _sound};
		_unit setVariable [_x, -1];
	} forEach ["A3W_staminaBreathSound", "A3W_staminaRecoveredSound", "A3W_staminaImpactSound"];
	_recoveryPending = false;
}
else
{
	private _breathPlaying = _breathSound >= 0 && {!((soundParams _breathSound) isEqualTo [])};
	private _recoveredPlaying = _recoveredSound >= 0 && {!((soundParams _recoveredSound) isEqualTo [])};
	if (!_breathPlaying) then {_unit setVariable ["A3W_staminaBreathSound", -1]};
	if (!_recoveredPlaying) then {_unit setVariable ["A3W_staminaRecoveredSound", -1]};

	// Start the next clip only after the current one has finished naturally.
	if (!_breathPlaying && {!_recoveredPlaying}) then
	{
		if (_penalty > 0) then
		{
			if (A3W_STAMINA_HEAVY_SOUND != "") then
			{
				_unit setVariable ["A3W_staminaBreathSound", playSoundUI [A3W_STAMINA_HEAVY_SOUND, 1, 1, true]];
			};
		}
		else
		{
			if (_recoveryPending) then
			{
				if (A3W_STAMINA_RECOVERED_SOUND != "") then
				{
					_unit setVariable ["A3W_staminaRecoveredSound", playSoundUI [A3W_STAMINA_RECOVERED_SOUND, 1, 1, true]];
				};
				_recoveryPending = false;
			};
		};
	};
};
_unit setVariable ["A3W_staminaRecoveryPending", _recoveryPending];
_unit setVariable ["A3W_staminaHadPenalty", _penalty > 0];
