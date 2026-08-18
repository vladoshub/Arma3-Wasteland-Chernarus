
if (!hasInterface || isServer) exitWith {};
waitUntil {sleep 0.1; alive player && !(player getVariable ["playerSpawning", true])};

private ["_wait", "_sound", "_soundSource", "_health", "_wait", "_waitSleep"];

while {true} do {


	_wait = 0;
	_health = (1 - damage player) * 100;
	if(_health < 50 && _health > 0) then {
		_wait = 60 + (round (random 10));
	};
	if(_health >= 50 && _health < 75) then {
		_wait = 120 + (round (random 20));
	};
	if(_health >= 75 && _health < 95) then {
		_wait = 180 + (round (random 30));
	};
	if(_health >= 95 && _health < 99) then {
		_wait = 300 + (round (random 40));
	};

	if (_wait != 0 && (isNull objectParent player) && alive player) then {
		_sound = selectRandom ["georgeDamageg101", "georgeDamageg102", "georgeDamageg103", "georgeDamageg104", "georgeDamageg201", "georgeDamageg202", "georgeDamageg203", "georgeDamageg207", "jennikDamageg101", "jennikDamageg102", "jennikDamageg104", "jennikDamageg105", "jennikDamageg106", "jennikDamageg107", "vasaDamageg101", "vasaDamageg102", "vasaDamageg103", "vasaDamageg104", "vasaDamageg105"];
		
		[player, _sound] remoteExec ["global_say_3d", 2];
		
		sleep _wait;
	};
	

	_waitSleep = 10 + (round (random 5));
	sleep _waitSleep;
	
};