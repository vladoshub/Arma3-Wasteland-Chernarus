params ["_unit"];
if (!hasInterface || {!local _unit} || {_unit != player}) exitWith {};

private _previousUnit = missionNamespace getVariable ["A3W_staminaLocalUnit", objNull];
if (!isNull _previousUnit) then
{
	[_previousUnit] call A3W_fnc_staminaStop;
};

_unit setVariable ["A3W_staminaExertion", 0];
_unit setVariable ["A3W_staminaPenalty", 0];
_unit setVariable ["A3W_staminaUpdatedAt", diag_tickTime];
_unit setVariable ["A3W_staminaImpactAt", -1];
_unit setVariable ["A3W_staminaBaseSpeed", getAnimSpeedCoef _unit];
_unit setVariable ["A3W_staminaAppliedSpeed", getAnimSpeedCoef _unit];
_unit setVariable ["A3W_staminaBaseAim", getCustomAimCoef _unit];
_unit setVariable ["A3W_staminaAppliedAim", getCustomAimCoef _unit];
_unit setVariable ["A3W_staminaBreathSound", -1];
A3W_staminaLocalUnit = _unit;
