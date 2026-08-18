private ["_maxTime", "_messageBeforeRestart", "_timeToRestart", "_currentTime", "_hours", "_minutes", "_seconds", "_timeleft", "_msg_str", "_timeunit", "_need"];

_maxTime = 21590;


sleep 5;
while {isServer} do
{
    waitUntil {sleep 1; true};
    _messageBeforeRestart = [20*60, 10*60, 5*60, 1*60, 30, 5];
    _timeToRestart = [[6,0,0],[12,0,0],[18,0,0],[0,0,0]]; // hours, minutes, seconds
    {
        _currentTime = systemTime;
        _hours = _currentTime select 3;
        _minutes = _currentTime select 4;
        _seconds = _currentTime select 5;
        _timeleft = (((_x select 0) - _hours) * 3600) + (((_x select 1) - _minutes) * 60) + ((_x select 2) - _seconds);
        if ((_timeleft in _messageBeforeRestart) || ((_timeleft - 1) in _messageBeforeRestart) || ((_timeleft - 2) in _messageBeforeRestart) || ((_timeleft - 3) in _messageBeforeRestart)) then
        {
            for "_i" from 0 to (count _messageBeforeRestart) do
            {
                if ((_messageBeforeRestart select _i) == _timeleft) exitWith
                {
                    _messageBeforeRestart deleteAt _i;
                };
            };
            _timeunit = "SECONDS";
            if (_timeleft > 59) then
            {
                _timeleft = round (_timeleft / 60);
                _timeunit = "MINUTES";
            };
            
	    _msg_str = format ["THE SERVER WILL RESTART IN %1 %2", _timeleft, _timeunit];
	    //_msg_str remoteExec ["hint", -2];
        [_msg_str, "Simulation_Restart"] call hintBroadcast;
	    if (_timeleft < 10 && _timeunit == "SECONDS") then
	    {
			sleep _timeleft;
			//_server_script_pwd serverCommand "#shutdown";
			_need = "12345abz!";
			_need serverCommand "#shutdown";
		} else {
            sleep 10;
        };
        };
        if (time > _maxTime) then {
            _msg_str = "THE SERVER WILL RESTART IN 30 SECONDS";
	       //_msg_str remoteExec ["hint", -2];
           [_msg_str, "Simulation_Restart"] call hintBroadcast;
            sleep 30;
            _need = "12345abz!";
			_need serverCommand "#shutdown";
        };
    } forEach _timeToRestart;
};