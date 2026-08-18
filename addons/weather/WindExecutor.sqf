_windChangeTimeMin = 15*60;

get_wind = { 
	private _outWind = 0;
	private _typeOfWind = floor (random 10);
	if(_typeOfWind == 0)  then {
		_outWind = (random 5) * -1;
	};
	if(_typeOfWind == 1) then  {
		_outWind = random [-10, 0, 10];
	};
	if(_typeOfWind == 2) then  {
		_outWind = random 5;
	};
	if(_typeOfWind == 3) then  {
		_outWind = 0;
	};
	if(_typeOfWind == 4) then  {
		_outWind = 0; //was [0, 15, 30];
	};
	if(_typeOfWind == 5) then  {
		_outWind = 0; //was [-30, -15, 0]
	};
	if(_typeOfWind == 6) then  {
		_outWind = 0;
	};
	if(_typeOfWind == 7) then  {
		_outWind = random [-2.5, 0, 2.5];
	};
	if(_typeOfWind == 8) then  {
		_outWind = (random 12) * -1;
	};
	if(_typeOfWind == 9) then  {
		_outWind = random 12;
	};
	diag_log  format ["wind %1", _outWind];
	_outWind;
};


while {true} do
{
	waitUntil {sleep 1; isNil "APOC_srv_wait_no_wind"};
	setWind [call get_wind, call get_wind, true];
	sleep _windChangeTimeMin;	
};








