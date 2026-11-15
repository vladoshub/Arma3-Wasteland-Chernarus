// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: unitHandleDamage.sqf
//	@file Author: AgentRev

#define IMPACT_DAMAGE_MULTIPLIER 0.5
#define IMPACT_DAMAGE_SEATED_MULTIPLIER 0.1
#define BOT_DAMAGE_MULTIPLIER 0.5  // Новый множитель для урона от ботов
#define BOT_DAMAGE_LIMIT 0.5

params ["_unit", "_selection", "_damage", "_source", "_ammo", ["_hitPartIndex", -1]];

if (_unit getVariable ["playerSpawning", false]) exitWith {0};

if (_selection != "?") then
{
	// Different hit points can share a selection name, so read the damage by event index.
	private _oldDamage = switch (true) do
	{
		case (_selection == ""):     { damage _unit };
		case (_hitPartIndex >= 0):   { _unit getHitIndex _hitPartIndex };
		default                     { _unit getHit _selection };
	};
	private _hitDamage = _damage - _oldDamage;

	// Infantry AI damage
	if (!isNull _source && _source isKindOf "CAManBase" && !isPlayer _source && _ammo != "" && _damage > 0) then
	{
		_hitDamage = ((_hitDamage max 0) * BOT_DAMAGE_MULTIPLIER) min BOT_DAMAGE_LIMIT;
		_damage = (damage _unit) + _hitDamage;
	}
	else
	{
		// Vehicle collisions and falling damage
		if (_ammo == "" && (vehicle _source) in [vehicle _unit, objNull]) then
		{
			_hitDamage = switch (true) do
			{
				case ((vehicle _unit) isKindOf "ParachuteBase"): { 0 }; // Disable self-collision damage while in parachute
				case (!isNull objectParent _unit):               { _hitDamage * IMPACT_DAMAGE_SEATED_MULTIPLIER };
				default                                         { _hitDamage * IMPACT_DAMAGE_MULTIPLIER };
			};
			_damage = _oldDamage + _hitDamage;
		};
	};

	// FAR uses the damage added by this hit, separate from the total for the selection.
	call FAR_HandleDamage_EH;

	//diag_log str [_unit, _selection, _damage, typeOf _source, _ammo];
};

_damage
