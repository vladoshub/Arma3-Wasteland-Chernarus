// Register once on clients, the server and headless clients for locally fired bullets.
#include "config.hpp"

if (isNil "A3W_staminaProjectileEH") then
{
	A3W_staminaProjectileEH = addMissionEventHandler ["ProjectileCreated",
	{
		params ["_projectile"];
		if (isNil "isConfigOn" || {!(["A3W_unlimitedStaminaV2"] call isConfigOn)} || {!local _projectile} || {!(_projectile isKindOf "BulletBase")}) exitWith {};

		_projectile addEventHandler ["HitPart",
		{
			params ["", "", "_shooter", "_position", "", "", "", "", "", ["_instigator", objNull]];
			private _source = if (isNull _instigator) then {_shooter} else {_instigator};
			if (!local _source) exitWith {};

			// HitPart also reports hits on terrain. Only nearby player owners receive an RPC.
			private _targets = ((ASLToAGL _position) nearEntities ["CAManBase", A3W_STAMINA_IMPACT_RADIUS]) select
			{
				isPlayer _x && {alive _x} && {isNull objectParent _x} && {_x != _source} && {_x != _shooter}
			};
			if !(_targets isEqualTo []) then
			{
				[_position, _shooter, _instigator] remoteExecCall ["A3W_fnc_staminaImpact", _targets];
			};
		}];
	}];
};

if (hasInterface && {isNil "A3W_staminaUpdateEH"}) then
{
	A3W_staminaUpdateEH = addMissionEventHandler ["EachFrame", {call A3W_fnc_staminaUpdate}];
};
