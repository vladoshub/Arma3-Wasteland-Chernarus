params ["_unit"];
if (isNull _unit) exitWith {};

private _sound = _unit getVariable ["A3W_staminaBreathSound", -1];
if (_sound >= 0) then {stopSound _sound};
_unit setVariable ["A3W_staminaBreathSound", -1];

// Restore only coefficients still owned by this system.
if (local _unit) then
{
	if (abs (getAnimSpeedCoef _unit - (_unit getVariable ["A3W_staminaAppliedSpeed", 1])) < 0.0001) then
	{
		_unit setAnimSpeedCoef (_unit getVariable ["A3W_staminaBaseSpeed", 1]);
	};
	if (abs (getCustomAimCoef _unit - (_unit getVariable ["A3W_staminaAppliedAim", 0.3])) < 0.0001) then
	{
		_unit setCustomAimCoef (_unit getVariable ["A3W_staminaBaseAim", 0.3]);
	};
};

if (_unit isEqualTo (missionNamespace getVariable ["A3W_staminaLocalUnit", objNull])) then
{
	A3W_staminaLocalUnit = objNull;
};
