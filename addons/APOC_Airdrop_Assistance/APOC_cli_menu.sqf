// Build fresh menus using the latest shared server rotation.
AirdropMenu = [["Airdrop", true]];
{
    _x params ["_title", "_menuName", "_type", "_arrayName"];
    private _menu = [[_title, true]];
    {
        private _index = _forEachIndex;
        if (["Airdrop", _type, _index] call A3W_fnc_isAssistanceItemAvailable) then
        {
            _menu pushBack [
                format ["%1 ($%2)", _x select 0, [_x select 2] call fn_numbersText],
                [count _menu + 1], "", -5,
                [["expression", format ['["%1",%2,player] execVM "addons\APOC_Airdrop_Assistance\APOC_cli_startAirdrop.sqf"', _type, _index]]],
                "1", "1"
            ];
        };
    } forEach (missionNamespace getVariable [_arrayName, []]);
    _menu pushBack ["Cancel Airdrop", [count _menu + 1], "", -3, [["expression", ""]], "1", "1"];
    missionNamespace setVariable [_menuName, _menu];
    AirdropMenu pushBack [_title, [_forEachIndex + 2], "#USER:" + _menuName, -5, [["expression", ""]], "1", "1"];
} forEach [
    ["Light Vehicles", "VehicleMenu", "vehicle", "APOC_AA_VehOptions"],
    ["Armored Vehicles", "Vehicle2Menu", "vehicle2", "APOC_AA_Veh2Options"],
    ["Civil Vehicles", "Vehicle3Menu", "vehicle3", "APOC_AA_Veh3Options"],
    ["Air Vehicles", "Vehicle4Menu", "vehicle4", "APOC_AA_Veh4Options"],
    ["Supplies", "SupplyMenu", "supply", "APOC_AA_SupOptions"],
    ["Base", "BaseMenu", "base", "APOC_AA_Base_one"]
];
AirdropMenu pushBack ["Cancel Airdrop", [8], "", -3, [["expression", ""]], "1", "1"];
showCommandingMenu "#USER:AirdropMenu";
