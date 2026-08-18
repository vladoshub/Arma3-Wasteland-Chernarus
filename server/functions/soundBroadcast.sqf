messageSystem = _this select 0;
publicVariable "soundSystem";

if (!isDedicated) then
{
	waitUntil {!isNil "playerCompiledScripts" && {playerCompiledScripts}};
	[] spawn serverMessage;
};
