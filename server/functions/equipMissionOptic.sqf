if (!isServer) exitWith {};

private _unit = _this;

// Helmets with built-in NVGs can leave the HMD slot empty.
if (hmd _unit == "") then {
    private _weaponsConfig = configFile >> "CfgWeapons";
    private _helmet = headgear _unit;
    private _hasHelmetNVG = _helmet != "" && {
        (getArray (_weaponsConfig >> _helmet >> "subItems")) findIf {
            "NVG" in (getArray (_weaponsConfig >> _x >> "visionMode"))
        } >= 0
    };

    if (!_hasHelmetNVG && { random 1 < 0.5 }) then {
        _unit linkItem "NVGoggles";
    };
};

// Roll a target magnification, then find the closest compatible vanilla optic.
private _weapon = primaryWeapon _unit;
if (_weapon == "") exitWith {};

private _getMagnification = {
    private _config = configFile >> "CfgWeapons" >> _this;
    private _itemInfo = _config >> "ItemInfo";
    private _modes = configProperties [_itemInfo >> "OpticsModes", "isClass _x", true];
    if (_modes isEqualTo []) then { _modes = [_itemInfo, _config] };

    private _fovs = [];
    {
        private _fov = getNumber (_x >> "opticsZoomMin");
        if (_fov > 0) then { _fovs pushBack _fov };
        _fovs append ((getArray (_x >> "discreteFov")) select { _x isEqualType 0 && { _x > 0 } });
    } forEach _modes;

    if (_fovs isEqualTo []) exitWith { 0 };
    0.25 / (selectMin _fovs)
};

private _oldOptic = (primaryWeaponItems _unit) param [2, ""];
private _oldMagnification = if (_oldOptic == "") then { 0 } else { _oldOptic call _getMagnification };
if (_oldOptic != "" && { _oldMagnification == 0 }) exitWith {};

private _targetMagnification = [[4, 40], [8, 40], [12, 20]] call fn_selectRandomWeightedPairs;
private _compatible = (compatibleItems _weapon) apply { toLower _x };
private _vanillaOptics = [
    "optic_DMS", "optic_DMS_ghex_F", "optic_DMS_weathered_F", "optic_DMS_weathered_Kir_F",
    "optic_AMS", "optic_AMS_khk", "optic_AMS_snd",
    "optic_KHS_blk", "optic_KHS_hex", "optic_KHS_old", "optic_KHS_tan",
    "optic_SOS", "optic_SOS_khk_F"
];

private _newOptic = "";
private _newMagnification = 0;
private _closestDifference = 1e10;
{
    if ((toLower _x) in _compatible) then {
        private _magnification = _x call _getMagnification;
        private _difference = abs (_magnification - _targetMagnification);
        if (_magnification > 0 && { _difference < _closestDifference }) then {
            _newOptic = _x;
            _newMagnification = _magnification;
            _closestDifference = _difference;
        };
    };
} forEach _vanillaOptics;

if (_newOptic == "" || { _newMagnification <= _oldMagnification + 0.001 }) exitWith {};

if (_oldOptic != "") then { _unit removePrimaryWeaponItem _oldOptic };
_unit addPrimaryWeaponItem _newOptic;

if (_oldOptic != "" && { ((primaryWeaponItems _unit) param [2, ""]) == "" }) then {
    _unit addPrimaryWeaponItem _oldOptic;
};
