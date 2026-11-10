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
// Sprinting spends stamina. Jogging and tactical running hold the current exertion.
if (_running && {_movement isEqualTo "meva"}) then
{
	_exertion = (_exertion + _delta) min _total;
};
if (!_running) then
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
if (!_active || {!_onFoot}) exitWith
{
	if (_breathSound >= 0) then
	{
		stopSound _breathSound;
		_unit setVariable ["A3W_staminaBreathSound", -1];
	};
};

// Finish the current clip before choosing a sound for the current penalty.
if (_breathSound >= 0 && {!((soundParams _breathSound) isEqualTo [])}) exitWith {};
if (_breathSound >= 0) then {_unit setVariable ["A3W_staminaBreathSound", -1]};
if (_penalty <= 0) exitWith {};

private _sounds = if (_penalty >= 1) then {A3W_STAMINA_SPRINT_SOUNDS} else {A3W_STAMINA_RUN_SOUNDS};
if (_sounds isEqualTo []) exitWith {};

_unit setVariable ["A3W_staminaBreathSound", playSoundUI [selectRandom _sounds, 1, 1, true]];
