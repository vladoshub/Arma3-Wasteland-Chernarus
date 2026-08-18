if (!hasInterface || isServer) exitWith {};

private ["_artMarkerPosRandom", "_imul", "_imulTwo"];

private _pos = param[0];
private _activityType = param[1];
private _isMlrs = param[2];
//sleep 5;
private _radars = player nearObjects  ["B_Radar_System_02_F", 300];
_radars append (player nearObjects  ["B_Radar_System_01_F", 300]);


private _friendlyCount = ({(_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) || (_x getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _x == group player) || ((side _x == side player) && (str(side player) == "WEST" || str(side player) == "EAST"))} count _radars);  //UAV friendly


if(_friendlyCount > 0) then {

private _markerName = "Artillery_" + getPlayerUID player + "_" + str(floor random [0, 500, 1000]);


/*
_randPos = floor random [-10, 0, 10];
if(_randPos > 0) then {
	_xPos = (_pos select 0) + (floor random [0, 250, 500]);
} else {
	_xPos = (_pos select 0) + (floor random [-500, -250, 0]);
};

_randPos = floor random [-10, 0, 10];
if(_randPos > 0) then {
	_yPos = (_pos select 1) + (floor random [0, 250, 500]);
} else {
	_yPos = (_pos select 1) + (floor random [-500, -250, 0]);
};
*/
private _chance = (floor random [-5, 0, 5]);
if (_chance > 0) then {
	_imul = 1;
} else {
	_imul = -1;
};

_chance = (floor random [-5, 0, 5]);
if (_chance > 0) then {
	_imulTwo = 1;
} else {
	_imulTwo = -1;
};

if(_isMlrs) then {
	_artMarkerPosRandom = [((_pos select 0) + ((floor random [50, 100, 200]) * _imul)), ((_pos select 1) + ((floor random [50, 100, 200]) * _imulTwo)), (_pos select 2)];
} else {
	_artMarkerPosRandom = [((_pos select 0) + ((floor random [100, 200, 300]) * _imul)), ((_pos select 1) + ((floor random [100, 200, 300]) * _imulTwo)), (_pos select 2)];
};
//_artMarkerPosRandom = [_xPos, _yPos, (_pos select 2)];

private _marker = createMarkerLocal [_markerName , _artMarkerPosRandom];

_markerName setMarkerTextLocal "Artillery!";
_markerName setMarkerSizeLocal [0.75, 0.75];
_markerName setMarkerShapeLocal "ICON";
_markerName setMarkerTypeLocal "b_art";
_markerName setMarkerColorLocal "ColorBlue";
_markerName setMarkerAlphaLocal 0.75;

private _currentMarkers = player getVariable ["mortarMarkers", []];

_currentMarkers pushBack _markerName; 

player setVariable ["mortarMarkers", _currentMarkers];

//systemChat "Check Artillery on the Map!";


/*
_time = time;
_currentAlpha = 1;
_showMarkerTime = 30 + random 15;


while {(time - _time) < _showMarkerTime} do {

	if(_currentAlpha < 0) then {
		_markerName setMarkerAlphaLocal 0;
	} else {
		_markerName setMarkerAlphaLocal _currentAlpha;
	};

	_currentAlpha = _currentAlpha - 0.15;
	sleep 5;
};


deleteMarkerLocal _markerName;

*/

};