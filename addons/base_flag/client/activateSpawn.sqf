private _object = _this select 0;


_object setVariable ["flag_respawn", true, true];
_object setVariable ["LastSide", str playerSide, true];
pvar_manualObjectSave = netId _object;
publicVariableServer "pvar_manualObjectSave";
