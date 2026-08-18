overCastCurrentChangeTime = 30*60;
overCastDefaultTime = 30*60;
overCastChangeDivision = 20*60;


overCastDivision = 0.170;
overCastMod = 0;
overCastCount = -1;
overCastPositiveDirection = 1;
syncRainTime = 10;
chanceToSmoothing = 70;
timeMultiplierFast = 50;

get_smoothing = {

			diag_log "TAKE abs";
			overCastMod = _differenceOverCast%overCastDivision;
			overCastCount = floor (_differenceOverCast/overCastDivision);
			overCastCurrentChangeTime = overCastChangeDivision;
			if(overcast > _currentFromRandom) then {
				overCastPositiveDirection = -1;
			} else {
				overCastPositiveDirection = 1;
			};
			diag_log format ["TAKE _overCastMod %1", overCastMod];
			diag_log format ["TAKE _overCastCount %1", overCastCount];
			diag_log format ["TAKE _overCastCurrentChangeTime %1", overCastCurrentChangeTime];
			diag_log format ["TAKE _overCastPositiveDirection %1", overCastPositiveDirection];

};

smoothing_process = { 
	_currentFromRandom = 0;
		if(overCastCount > 0) then {
			_currentFromRandom = overcast + (overCastDivision * overCastPositiveDirection);
			diag_log format ["TAKE sampling > 0 %1", _currentFromRandom];
		} else {
			_currentFromRandom = overcast + (overCastMod * overCastPositiveDirection);
			overCastCurrentChangeTime = overCastDefaultTime;
			diag_log format ["TAKE sampling else 0 %1", _currentFromRandom];
		};
		overCastCount = overCastCount - 1;	
		_currentFromRandom;
};


get_fog = {
	private _outFog = 0; 
	private _currentRain = rain;
	private _typeOfFog = floor (random 20);
	if(_currentRain > 0) then {
		if(_typeOfFog == 0) then {
			_outFog = random [0, 0.05, 0.3];
		};
		if(_typeOfFog == 1) then {
			_outFog = 0.2;
		};
		if(_typeOfFog == 2) then {
			_outFog = 0.025;
		};
		if(_typeOfFog == 3) then {
			_outFog = 0;
		};
		if(_typeOfFog == 4) then {
			_outFog = 0.035;
		};
		if(_typeOfFog == 5) then {
			_outFog = 0;
		};
		if(_typeOfFog == 6) then {
			_outFog = 0;
		};
		if(_typeOfFog == 7) then {
			_outFog = 0.1;
		};
		if(_typeOfFog == 8) then {
			_outFog = 0.7;
		};
		if(_typeOfFog == 9) then {
			_outFog = 0.05;
		};	
		if(_typeOfFog == 10) then {
			_outFog = 0;
		};
		if(_typeOfFog == 11) then {
			_outFog = 0.1;
		};
		if(_typeOfFog == 12) then {
			_outFog = 0;
		};
		if(_typeOfFog == 13) then {
			_outFog = 0.2;
		};
		if(_typeOfFog == 14) then {
			_outFog = 0.1;
		};
		if(_typeOfFog == 15) then {
			_outFog = 0;
		};
		if(_typeOfFog == 16) then {
			_outFog = 0.1;
		};
		if(_typeOfFog == 17) then {
			_outFog = 0.3;
		};
		if(_typeOfFog == 18) then {
			_outFog = 0.01;
		};
		if(_typeOfFog == 19) then {
			_outFog = 0;
		};
	} else {
		if(_typeOfFog == 0) then {
			_outFog = 0.1;
		};
		if(_typeOfFog == 1) then {
			_outFog = random [0, 0.05, 0.3];
		};
		if(_typeOfFog == 2) then {
			_outFog = 0;
		};
		if(_typeOfFog == 3) then {
			_outFog = 0;
		};
		if(_typeOfFog == 4) then {
			_outFog = 0.035;
		};
		if(_typeOfFog == 5) then {
			_outFog = 0.3;
		};
		if(_typeOfFog == 6) then {
			_outFog = 0.7;
		};
		if(_typeOfFog == 7) then {
			_outFog = 0.015;
		};
		if(_typeOfFog == 8) then {
			_outFog = 0;
		};
		if(_typeOfFog == 9) then {
			_outFog = 0.05;
		};
		if(_typeOfFog == 10) then {
			_outFog = 0;
		};
		if(_typeOfFog == 11) then {
			_outFog = 0;
		};
		if(_typeOfFog == 12) then {
			_outFog = 0.03;
		};
		if(_typeOfFog == 13) then {
			_outFog = 0;
		};
		if(_typeOfFog == 14) then {
			_outFog = 0.1;
		};
		if(_typeOfFog == 15) then {
			_outFog = 0;
		};
		if(_typeOfFog == 16) then {
			_outFog = 0.025;
		};
		if(_typeOfFog == 17) then {
			_outFog = 0;
		};
		if(_typeOfFog == 18) then {
			_outFog = 0;
		};
		if(_typeOfFog == 19) then {
			_outFog = 0.05;
		};
	};
	_outFog;
};


get_fog_high = {
	private _outFog = 0; 
	private _currentRain = rain;
	private _typeOfFog = floor (random 20);
	if(_currentRain > 0) then {
		if(_typeOfFog == 0) then {
			_outFog = random [0, 0.5, 0.85];
		};
		if(_typeOfFog == 1) then {
			_outFog = 0;
		};
		if(_typeOfFog == 2) then {
			_outFog = 0.25;
		};
		if(_typeOfFog == 3) then {
			_outFog = 0;
		};
		if(_typeOfFog == 4) then {
			_outFog = 0.35;
		};
		if(_typeOfFog == 5) then {
			_outFog = 0;
		};
		if(_typeOfFog == 6) then {
			_outFog = 0;
		};
		if(_typeOfFog == 7) then {
			_outFog = 0.4;
		};
		if(_typeOfFog == 8) then {
			_outFog = 0.65;
		};
		if(_typeOfFog == 9) then {
			_outFog = 0;
		};	
		if(_typeOfFog == 10) then {
			_outFog = 0;
		};
		if(_typeOfFog == 11) then {
			_outFog = 0;
		};
		if(_typeOfFog == 12) then {
			_outFog = 0;
		};
		if(_typeOfFog == 13) then {
			_outFog = 0;
		};
		if(_typeOfFog == 14) then {
			_outFog = 0;
		};
		if(_typeOfFog == 15) then {
			_outFog = 0;
		};
		if(_typeOfFog == 16) then {
			_outFog = 0;
		};
		if(_typeOfFog == 17) then {
			_outFog = 0.8;
		};
		if(_typeOfFog == 18) then {
			_outFog = 0.1;
		};
		if(_typeOfFog == 19) then {
			_outFog = 0;
		};
	} else {
		if(_typeOfFog == 0) then {
			_outFog = 0.1;
		};
		if(_typeOfFog == 1) then {
			_outFog = random [0, 0.5, 0.85];
		};
		if(_typeOfFog == 2) then {
			_outFog = 0;
		};
		if(_typeOfFog == 3) then {
			_outFog = 0;
		};
		if(_typeOfFog == 4) then {
			_outFog = 0.35;
		};
		if(_typeOfFog == 5) then {
			_outFog = 0.8;
		};
		if(_typeOfFog == 6) then {
			_outFog = 0.65;
		};
		if(_typeOfFog == 7) then {
			_outFog = 0.15;
		};
		if(_typeOfFog == 8) then {
			_outFog = 0;
		};
		if(_typeOfFog == 9) then {
			_outFog = 0;
		};
		if(_typeOfFog == 10) then {
			_outFog = 0;
		};
		if(_typeOfFog == 11) then {
			_outFog = 0;
		};
		if(_typeOfFog == 12) then {
			_outFog = 0;
		};
		if(_typeOfFog == 13) then {
			_outFog = 0;
		};
		if(_typeOfFog == 14) then {
			_outFog = 0;
		};
		if(_typeOfFog == 15) then {
			_outFog = 0;
		};
		if(_typeOfFog == 16) then {
			_outFog = 0.25;
		};
		if(_typeOfFog == 17) then {
			_outFog = 0;
		};
		if(_typeOfFog == 18) then {
			_outFog = 0;
		};
		if(_typeOfFog == 19) then {
			_outFog = 0;
		};
	};
	_outFog;
};


get_overcast = { 
	_currentFromRandom = 0;
	if(overCastCount == -1) then {

		private _daytime = dayTime;
		private _hours = floor _daytime;
		private _typeOfOverCast = 0;
		if(_hours > 20 || _hours < 5) then {
			_typeOfOverCast = floor (random 15);
			diag_log  format ["%1 _typeOfOverCast night", _typeOfOverCast];
		} else {
			_typeOfOverCast = floor (random 15);
			diag_log  format ["%1 _typeOfOverCast day", _typeOfOverCast];
		};

		if (_typeOfOverCast == 0) then { 
			_currentFromRandom = 0;
		};
		if (_typeOfOverCast == 1) then {
			_currentFromRandom = random [0, 0.25, 1]; 
		};
		if (_typeOfOverCast == 2) then {
			_currentFromRandom = 0.35;
		};
		if (_typeOfOverCast == 3) then {
			_currentFromRandom = random [0, 0.65, 1]; 
		};
		if (_typeOfOverCast == 4) then { 
			_currentFromRandom = 0; 
		};
		if (_typeOfOverCast == 5) then { 
			_currentFromRandom = random [0, 0.1, 1]; 
		};
		if (_typeOfOverCast == 6) then { 
			_currentFromRandom = 0.15;
		};
		if (_typeOfOverCast == 7) then { 
			_currentFromRandom = 0;
		};
		if (_typeOfOverCast == 8) then { 
			_currentFromRandom = 1;
		};
		if (_typeOfOverCast == 9) then { 
			_currentFromRandom = 0; 
		};
		if (_typeOfOverCast == 10) then { 
			_currentFromRandom = 0; 
		};
		if (_typeOfOverCast == 11) then { 
			_currentFromRandom = 0;
		};
		if (_typeOfOverCast == 12) then { 
			_currentFromRandom = 0.55;
		};
		if (_typeOfOverCast == 13) then { 
			_currentFromRandom = 0.25;
		};
		if (_typeOfOverCast == 14) then { 
			_currentFromRandom = 0;
		};

		diag_log  format ["TAKE -1 _currentFromRandom %1", _currentFromRandom];
		_differenceOverCast = abs(overcast - _currentFromRandom);
		private _absChance = random 100;
		diag_log  format ["abs chance %1", _absChance];
		if ((_differenceOverCast > overCastDivision) && (_absChance < chanceToSmoothing)) then {
			call get_smoothing;
			_currentFromRandom =  call smoothing_process;
		};
	} else {
		_currentFromRandom = call smoothing_process;
	};

	if(_currentFromRandom > 1) then {
		_currentFromRandom = 1;
	};
	if(_currentFromRandom < 0) then {
		_currentFromRandom = 0;
	};
	_currentFromRandom;
};

while {true} do
{
	private _currentOvercast = overcast;
	private _nextOvercast = call get_overcast;	
	diag_log format ["OUT %1", _nextOvercast];
	//_timeChangeFog = missionNamespace getVariable "_timeChangeFog";
	//diag_log  format ["fog sleep %1", _timeChangeFog];
	//sleep _timeChangeFog;
	0 setOvercast _nextOvercast;
	if (_currentOvercast >= 0.75 && _nextOvercast < 0.75) then {
		0 setRain 0;
		0 setLightnings 0;
		0 setWaves 0;
	};
	forceWeatherChange;
	//if( (abs(_currentOvercast - _nextOvercast) > 0.200) || (_currentOvercast == 0 && _nextOvercast >0 ) || (_currentOvercast == 1 && _nextOvercast < 1)) then {
		//forceWeatherChange;
	//};
	//if ((_currentOvercast == 0 && _nextOvercast > 0 ) || (_currentOvercast == 1 && _nextOvercast < 1)) then {
		//forceWeatherChange;
	//} else {
	if (_currentOvercast >= 0.75 && _nextOvercast < 0.75) then {
		sleep syncRainTime;
		0 setRain 0;
		0 setLightnings 0;
		0 setWaves 0;
	};
	//};

	private _isChangeFog = 0;
	_isChangeFog = floor (random 3);
	if (_isChangeFog > 0 || fog > 0.03) then {
	sleep 10;
	private _nextFog = call get_fog;	
	if(!((["A3W_map", "chernarus"] call getPublicVar) in ["chernarus", "altis"])) then {
		_nextFog = call get_fog_high;
	};
	private _typeOfFogSpeed = floor (random 3);
	private _fogSpeedCurrent = 0;
	if(_typeOfFogSpeed == 0) then {
		_fogSpeedCurrent = random [0, 200, 400];
	};
	if(_typeOfFogSpeed == 1) then {
		_fogSpeedCurrent = random [0, 100, 200];
	};
	if(_typeOfFogSpeed == 2) then {
		_fogSpeedCurrent = timeMultiplierFast;
	};
	private _differenceFog = abs(fog - _nextFog);
	private _timeChangeFog = (_differenceFog * _fogSpeedCurrent);
	diag_log format ["current FOG %1", fog];
	diag_log format ["next FOG %1", _nextFog];
	_timeChangeFog setFog [_nextFog,  0.0, 0];
	private _sleepFogTime = _timeChangeFog * 1.2;
	sleep _sleepFogTime;
	};

	sleep overCastCurrentChangeTime;	
};








