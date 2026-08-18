params [["_initialFog",-1,[0]], ["_initialOvercast",-1,[0]], ["_initialRain",-1,[0]], ["_initialWind",[],[[]]]]; 


if (isServer) then
{
private _windX = _initialWind param [0, nil, [0]];
private _windY = _initialWind param [1, nil, [0]];

if (_initialOvercast == -1) then {
	_initialOvercast = random 1;
}
else {
	_initialOvercast = _initialOvercast;
};

if (_initialRain == -1) then {
	_initialRain = 0; 
}
else {
	_initialRain = _initialRain;
};

if (_initialFog == -1) then {
	_initialFog = random 0.35;
}
else {
	_initialFog = _initialFog;
};


0 setOvercast _initialOvercast;
0 setRain _initialRain;
0 setFog [_initialFog,  0.0, 0];
setWind [_windX, _windY, true];
forceWeatherChange;


sleep 600;

missionNamespace setVariable ["_timeChangeFog", 0];


if(worldName == 'chernarus_winter') then {
	[] execVM "addons\weather\OverCastExecutorWinter.sqf";
	sleep 1;
	[] execVM "addons\weather\SnowExecutor.sqf";
} else {
	[] execVM "addons\weather\OverCastExecutor.sqf";
	sleep 1;
	[] execVM "addons\weather\RainExecutor.sqf";
};
sleep 1;
[] execVM "addons\weather\WindExecutor.sqf";

};





