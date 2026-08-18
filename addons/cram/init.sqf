//based ON https://forums.bohemia.net/forums/topic/235801-active-protection-system-script/ and https://github.com/Dankan37/Arma-3-CRAM

if(isServer) then {

private _unit = param[0];
private _distance = param[1];

[_unit, _distance] call addToTrophy;

};
