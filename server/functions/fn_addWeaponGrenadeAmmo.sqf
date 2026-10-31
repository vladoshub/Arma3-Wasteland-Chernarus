// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2026 A3Wasteland.com *
// ******************************************************************************************
// Add 0-3 compatible explosive underbarrel grenades for one spawned weapon.
// Only single-round magazines qualify, so the roll counts grenades, not multi-round packs.

if (!isServer) exitWith {};

params [["_container", objNull, [objNull]], ["_weapon", "", [""]]];
if (isNull _container || {_weapon == ""}) exitWith {};

private _grenadeMags = [];
{
	private _muzzle = _x;
	if (toLower _muzzle != "this" && {toLower _muzzle != toLower _weapon}) then
	{
		{
			private _magCfg = configFile >> "CfgMagazines" >> _x;
			private _ammo = getText (_magCfg >> "ammo");
			if (getNumber (_magCfg >> "scope") == 2 &&
				{getNumber (_magCfg >> "count") == 1} &&
				{_ammo isKindOf ["GrenadeBase", configFile >> "CfgAmmo"]} &&
				{getNumber (configFile >> "CfgAmmo" >> _ammo >> "explosive") > 0}) then
			{
				_grenadeMags pushBackUnique _x;
			};
		} forEach compatibleMagazines [_weapon, _muzzle];
	};
} forEach getArray (configFile >> "CfgWeapons" >> _weapon >> "muzzles");

if (count _grenadeMags == 0) exitWith {};

private _count = floor random 4;
if (_count > 0) then
{
	_container addMagazineCargoGlobal [selectRandom _grenadeMags, _count];
};
