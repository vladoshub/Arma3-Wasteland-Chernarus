rainChangeTimeMin = 10*60;
rainCheckTimeSec = 30;
currentRainTimeExecutor = 30;


_probeRainOverCast = 0.75;


get_rain = { 
	private _typeOfRain = floor (random 10);
	private _currentFromRandomRain = 0;
	if (_typeOfRain == 0) then { 
		_currentFromRandomRain = random [0, 0.25, 1]; 
	};
	if (_typeOfRain == 1) then {
		_currentFromRandomRain = random [0, 0.5, 1]; 
	};
	if (_typeOfRain == 2) then {
		_currentFromRandomRain = 1;
	};
	if (_typeOfRain == 3) then {
		_currentFromRandomRain = 0.35;
	};
	if (_typeOfRain == 4) then { 
		_currentFromRandomRain = 0;
	};
	if (_typeOfRain == 6) then { 
		_currentFromRandomRain = 0;
	};
	if (_typeOfRain == 7) then { 
		_currentFromRandomRain = 0;
	};
	if (_typeOfRain == 8) then { 
		_currentFromRandomRain = 0;
	};
	if (_typeOfRain == 9) then { 
		_currentFromRandomRain = 0.2;
	};
	_currentFromRandomRain;
};


get_other = { 
	private _mid = _this;
	private _currentFromRandomRain = random [0, _mid, 1]; 
};

while {true} do
{
	if(overcast >= _probeRainOverCast) then {
		private _currentRain = rain;
		private _nextRain = call get_rain;
		private _nextLightnings = call get_rain;
		private _nextWaves = call get_rain;
		0 setRain _nextRain;
		0 setLightnings _nextLightnings;
		0 setWaves _nextWaves;
		currentRainTimeExecutor = rainChangeTimeMin;
//		if( (abs(_currentRain - _nextRain) > 0.200) || (_currentRain == 0 && _nextRain > 0 ) || (_currentRain == 1 && _nextRain < 1)) then {
//			forceWeatherChange;
//		};
	} else {
		currentRainTimeExecutor = rainCheckTimeSec;
	};

	sleep currentRainTimeExecutor;	
};








