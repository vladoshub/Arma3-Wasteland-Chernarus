// Executed on the affected player's owner, including a hosted server's player.
#include "config.hpp"

params [["_position", [], [[]], 3], ["_shooter", objNull, [objNull]], ["_instigator", objNull, [objNull]]];
if (!hasInterface || {isNull player} || {!alive player}) exitWith {};
if !(player isEqualTo (missionNamespace getVariable ["A3W_staminaLocalUnit", objNull])) exitWith {};
if !(["A3W_unlimitedStaminaV2"] call isConfigOn) exitWith {};
if (!isNull objectParent player || {player getVariable ["playerSpawning", false]} || {player in [_shooter, _instigator]}) exitWith {};
if ((getPosASL player) distance _position > A3W_STAMINA_IMPACT_RADIUS) exitWith {};

player setVariable ["A3W_staminaExertion", A3W_STAMINA_FREE_RUN + A3W_STAMINA_PENALTY_RUN];
player setVariable ["A3W_staminaImpactAt", diag_tickTime];
// Force the next frame to apply the penalty, even if the last update was recent.
player setVariable ["A3W_staminaUpdatedAt", diag_tickTime - 0.1];
