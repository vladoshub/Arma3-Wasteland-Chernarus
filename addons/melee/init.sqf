//////////////////////////////////////////////////////////////////
// Script File for [Arma 3] - init.sqf
// Created by: Das Attorney
// Modified by: AgentRev
//////////////////////////////////////////////////////////////////

if (!hasInterface) exitWith {};

_handled_melee = false;
meleee_detect_key_input = "addons\melee\detect_key_input.sqf" call mf_compile;

waitUntil {!isNull findDisplay 46};
(findDisplay 46) displayAddEventHandler ["KeyDown", meleee_detect_key_input];
