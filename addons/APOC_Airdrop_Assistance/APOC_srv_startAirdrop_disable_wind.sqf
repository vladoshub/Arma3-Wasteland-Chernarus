//Disable wind when use a airdrop

if(!isServer) exitWith {};

if (!isNil "APOC_srv_wait_no_wind") exitWith {APOC_srv_wait_no_wind = (diag_tickTime + 120)};

APOC_srv_wait_no_wind = (diag_tickTime + 120);

private _wind = wind;
private _windX = _wind select 0;
private _windY = _wind select 1;

setWind [0, 0, true];
waitUntil {sleep 1; diag_tickTime > APOC_srv_wait_no_wind};

setWind [_windX, _windY, true];
APOC_srv_wait_no_wind = nil;