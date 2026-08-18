

params ["", "_key", "_shift", "_ctrlKey","_alt"];

private ["_findTarget", "_target", "_handled", "_previousAnim"];

_findTarget = false;
_handled = false;

if (_shift && !_ctrlKey && !_alt && _key == 46) then // shift + C
{
_handled = true;

if (_handled_melee) exitWith
{
	_handled = true;
};

//https://forums.bohemia.net/forums/topic/222256-melee-animation-to-kill/
if (!alive player || player getVariable ["playerSpawning", true] || player call A3W_fnc_isUnconscious || !(isNull objectParent player) || a3w_actions_mutex) exitWith {
	_handled = true;
};

_target = cursorObject;
if ((player distance _target <= 2) and (alive _target) and (_target iskindof "MAN") and (isNull objectParent _target) and (isPlayer _target) and !(["Unconscious", animationState _target] call fn_startsWith)) then {

	_findTarget = true;

};

if(!_findTarget) exitWith {
	_handled = true;
};

	_handled_melee = true;
	a3w_actions_mutex = true;
	_previousAnim = animationState player;
	[player, "Acts_Miller_Knockout", _previousAnim, _target] spawn
	{
		params ["_player", "_anim", "_prevAnim", "_target"];
		[_player, _anim] call switchMoveGlobal;
		sleep 2;
		if(isPlayer _target and (alive _target) and (_target iskindof "MAN") and (isNull objectParent _target) and (isPlayer _target) and !(["Unconscious", animationState _target] call fn_startsWith)) then {
			_target setDamage (damage _target + 0.35);
			[_target, ""] call switchMoveGlobal;
			[_target, "AinjPfalMstpSnonWnonDf_carried_fallwc"] call switchMoveGlobal;
		};
		sleep 2;
		[_player, _prevAnim] call switchMoveGlobal;
		if(isPlayer _target and (alive _target) and (_target iskindof "MAN") and (isNull objectParent _target) and (isPlayer _target) ) then {
			sleep 5;
			if(isPlayer _target and (alive _target) and (_target iskindof "MAN") and (isNull objectParent _target) and (isPlayer _target) and !(["Unconscious", animationState _target] call fn_startsWith) ) then {
				[_target, "Acts_UnconsciousStandUp_Actions"] call switchMoveGlobal;
			};
			sleep 0.3;
			private _notChange = (!alive _target || _target getVariable ["playerSpawning", true] || _target call A3W_fnc_isUnconscious || !(isNull objectParent _target) and !(["Unconscious", animationState _target] call fn_startsWith));
			if(!_notChange) then {
				[_target, ""] call switchMoveGlobal;
			};
		};
		a3w_actions_mutex = false;
		_handled_melee = false;
	};
	_handled = true;
};

_handled;


