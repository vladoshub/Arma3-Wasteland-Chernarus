// Initialise
sleep 100;
if (!isServer) then {




private _time = time + 1800;

// Detect keypress
fnc_key = 
{
_time = time + 1800;
};

(findDisplay 46) displayAddEventHandler ["MouseMoving", "_this call fnc_key"];

// Scan for idleness!	
while {true} do
{
	if (time > _time) then
	{
		sleep 1;
		if ((count allPlayers) > 45) then {
		profilename remoteExec ["KICK_by_idle"];
		};
	};
	sleep 5;	
};
};