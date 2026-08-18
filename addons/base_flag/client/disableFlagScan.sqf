//	@file Version: 1.0
//	@file Name: beacondetector.sqf
//	@file Author: wiking.at
//	Allows tracking of spawn beacons
// Check if script is already active
// mod by vlados
if (DisableSpawnFlagInProgress) exitWith {
	["You are already performing another device scan.", 5] call mf_notify_client;
};

_beaconsnear = nearestObjects [player, ["FlagChecked_F"], 330] select { (_x getVariable["flag_respawn", false]) && !(  !(_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) && ( ((_x getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _x == group player) || ((side _x == side player) && (str(side player) == "WEST" || str(side player) == "EAST")) || ((str(side player) == "WEST" || str(side player) == "EAST") && (str(side player)) == (_x getVariable ["LastSide", ""])) ) && ((str(side player)) == _x getVariable ["LastSide", (str(side player))]) )) && ((_x getVariable ["diable_flag_wait", 0]) < serverTime) };

if ((count _beaconsnear) > 0 ) then {
	
	playSound "beep9"; ["Flags found - disabling started. Wait 20 sec", 5] call mf_notify_client;
	DisableSpawnFlagInProgress = true;


	private _checks =
		{
			private ["_progress", "_failed", "_text"];
			_progress = _this select 0;
			_text = "";
			_failed = true;

			switch (true) do
			{
				case (!alive player || player call A3W_fnc_isUnconscious): { _text = "player dead" };
				case (doCancelAction): { doCancelAction = false; _text = "Disabling cancelled" };
				case (vehicle player != player): { _text = "Action failed! You can't do this in a vehicle" };
				default
				{
					_failed = false;
					_text = format ["Disabling %1%2 complete", floor (_progress * 100), "%"];
				};
			};

			[_failed, _text];
		};

	private _success = [60, "AinvPknlMstpSlayWrflDnon_medic", _checks, []] call a3w_actions_start;

	_beaconsnear = nearestObjects [player, ["FlagChecked_F"], 330] select { (_x getVariable["flag_respawn", false]) && !(!(_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) && ((_x getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _x == group player) || ((side _x == side player) && (str(side player) == "WEST" || str(side player) == "EAST")))) && ((_x getVariable ["diable_flag_wait", 0]) < serverTime) };

	if (_success && (count _beaconsnear) > 0) then {
		{
			_x setVariable ["flag_respawn", false, true];
			_x setVariable ["diable_flag_wait", serverTime + (60 * 60), true];
			
		} forEach _beaconsnear;
	} else {
		playSound "beep9"; ["You are out of range.", 5] call mf_notify_client;
	};

	DisableSpawnFlagInProgress = false;

} else {
	playSound "beep9";
	["No flags range.", 5] call mf_notify_client;
};