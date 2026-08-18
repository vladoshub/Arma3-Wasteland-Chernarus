
if (!hasInterface || isServer) exitWith {};
waitUntil {sleep 0.1; alive player && !(player getVariable ["playerSpawning", true])};

private ["_wait", "_sound", "_soundSource", "_wait", "_objCount", "_waitSleep"];

while {true} do {

	_wait = 0;

	_objCount = count (player nearObjects  ["Land_ToiletBox_F", 25]);
	if(_objCount > 0) then {
		_wait = 200 + (round (random 20));
	};

	if (_wait != 0 && (isNull objectParent player) && alive player) then {
		_sound = selectRandom ["1.ogg", "2.ogg", "3.ogg", "4.ogg", "5.ogg", "6.ogg"];
		_soundSource = getMissionPath format ["client\sounds\rofl\%1", _sound];
		playSound3D [_soundSource, player, false, getPosASL player, 3, 1, 50];
		sleep _wait;
	};


	_waitSleep = 2 + (round (random 2));
	sleep _waitSleep;
};