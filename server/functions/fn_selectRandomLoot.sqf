// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2026 A3Wasteland.com *
// ******************************************************************************************
// Select one entry, then roll its spawn chance. A failed roll leaves the slot empty.
// Entries: "classname" (chance 1), ["classname", chance], or nested groups of entries.
// Chance is clamped to 0..1. Return "" for an empty pool or a failed roll; never reroll.

private _entry = _this;
private _chance = 1;

while {!isNil "_entry" && {_entry isEqualType []}} do
{
	if (count _entry == 0) exitWith {_entry = ""};
	if (count _entry == 2 && {(_entry select 1) isEqualType 0}) then
	{
		_chance = _chance * (((_entry select 1) max 0) min 1);
		_entry = _entry select 0;
	}
	else
	{
		_entry = selectRandom _entry;
	};
};

if (isNil "_entry" || {!(_entry isEqualType "")} || {_entry == ""}) exitWith {""};
if (_chance <= 0 || {_chance < 1 && {random 1 >= _chance}}) exitWith {""};

_entry
