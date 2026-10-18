// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2026 A3Wasteland.com *
// ******************************************************************************************
// Try the configured entry once. On failure, make one 80% fallback attempt using only
// entries with spawnChance exactly 1.0. Legacy strings have an implicit chance of 1.

private _weapon = _this call fn_selectRandomLoot;
if (_weapon != "") exitWith {_weapon};
if (random 1 >= 0.8) exitWith {""};

private _guaranteed = [];
private _collectGuaranteed = {
	private _entry = _this;
	if (isNil "_entry") exitWith {};
	if (_entry isEqualType "") exitWith {
		if (_entry != "") then {_guaranteed pushBack _entry};
	};
	if !(_entry isEqualType []) exitWith {};

	if (count _entry == 2 && {(_entry select 1) isEqualType 0}) exitWith {
		if ((_entry select 1) == 1) then {
			(_entry select 0) call _collectGuaranteed;
		};
	};

	{_x call _collectGuaranteed} forEach _entry;
};

_this call _collectGuaranteed;
if (count _guaranteed == 0) exitWith {""};

selectRandom _guaranteed
