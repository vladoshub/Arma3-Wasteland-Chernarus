
#define PORTAL_ACTIVATE_CONDITION "(player distance _target < 5 && cursorObject == _target)"

private ["_laptop", "_laptopVarName", "_startsWith", "_structure", "_table", "_soundSource", "_wait", "_waitSleep", "_sound"];

_laptop = _this select 0;
_laptopVarName = vehicleVarName _laptop;

_laptop allowDamage false;
_laptop enableSimulationGlobal false;

if (hasInterface) then
{
	_startsWith =
	{
		private ["_needle", "_testArr"];
		_needle = _this select 0;
		_testArr = toArray (_this select 1);
		_testArr resize count toArray _needle;
		(toString _testArr == _needle)
	};
	if (["Portal", _laptopVarName] call _startsWith) then
	{
		_laptop addAction ["<img image='client\icons\portal.paa'/> Open Portal", "client\systems\portalTP\openPortal.sqf", [_laptopVarName], 100, true, true, "", PORTAL_ACTIVATE_CONDITION]; //1
	};
};
