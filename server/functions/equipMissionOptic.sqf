// Upgrade missing or weak optics to DMS (2x-4x). Keep existing 4x+ scopes.
// Weapons without a compatible optics mount (e.g. SDAR) keep their own sights.
if (!isServer) exitWith {};

private _unit = _this;
private _weapon = primaryWeapon _unit;
if (_weapon == "") exitWith {};

private _oldOptic = (primaryWeaponItems _unit) param [2, ""];
private _needsUpgrade = _oldOptic == "";

if (_oldOptic != "") then {
    private _config = configFile >> "CfgWeapons" >> _oldOptic;
    private _modes = configProperties [_config >> "ItemInfo" >> "OpticsModes", "isClass _x", true];
    if (count _modes == 0) then { _modes = [_config >> "ItemInfo", _config] };
    private _zooms = [];
    {
        private _zoom = getNumber (_x >> "opticsZoomMin");
        if (_zoom > 0) then { _zooms pushBack _zoom };
        _zooms append ((getArray (_x >> "discretefov")) select {_x isEqualType 0 && {_x > 0}});
    } forEach _modes;

    // Smaller FOV means higher magnification: 4x corresponds to 0.25 / 4.
    // Preserve unknown mod scopes when their magnification cannot be read.
    _needsUpgrade = count _zooms > 0 && {(selectMin _zooms) > ((0.25 / 4) + 0.00001)};
};
if (!_needsUpgrade) exitWith {};

private _compatible = (compatibleItems _weapon) apply { toLower _x };
private _optics = ["optic_DMS", "optic_DMS_ghex_F"];
private _index = _optics findIf { (toLower _x) in _compatible };
if (_index < 0) exitWith {};

// Only remove the old attachment after finding a compatible replacement.
if (_oldOptic != "") then { _unit removePrimaryWeaponItem _oldOptic };
_unit addPrimaryWeaponItem (_optics select _index);
