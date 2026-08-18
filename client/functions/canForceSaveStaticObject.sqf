//based on client/functions/canForceSaveStaticWeapon.sqf

alive _this && {cameraOn distance _this <= (sizeOf typeOf _this / 2) max 2} && 
(["A3W_extDB_SaveUnlockedObjects"] call isConfigOn || _this getVariable ["objectLocked", false]) &&
{!(_this isKindOf "StaticWeapon") && (!(_this getVariable ["R3F_LOG_disabled", false]) || locked _this == 2)}
