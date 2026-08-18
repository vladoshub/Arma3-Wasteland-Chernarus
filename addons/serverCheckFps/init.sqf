/*
Author: Sarogahtyp
File: fps_watch.sqf

Descripion:
Watchs servers fps and shuts it down if 20 min average fps are lower than 10.

Parameters - none
 return value - none
*/

// sleep 5 minutes after server is started


private ["_fps_limit", "_average_period", "_need", "_fast", "_fps_array", "_start_watch", "_log_delay", "_log_time", "_sum", "_num", "_average", "_msg_str", "_msg_time"];

if( isServer) then {
sleep 300;

_fps_limit = 10;
_average_period = 1200; // 20 minutes for averaging fps
_need = "12345abz!";

_fast = true;
_fps_array = [];
_start_watch = diag_tickTime + _average_period;
_log_delay = _average_period;
_log_time = 0;

while {_fast} do
{
 //collect fps data and its time
 _fps_array pushBack [diag_tickTime, diag_fps];

 //start analyzing after enough data is collected
 if(diag_tickTime > _start_watch) then
 {

  //select all data which is younger than average period (10 mins)
  _fps_array = _fps_array select { _x select 0 > (diag_tickTime - _average_period)};

  //calculate average fps
  _sum = 0;
  _num =
  {
   _sum = _sum + (_x select 1);
   true
  } count _fps_array;

  //prevent zero deviding
  if (_num > 0) then
  {
   _average = _sum / _num;

   if (diag_tickTime > _log_time) then
   {
    diag_log format ["################# SERVER speed 20 min average: %1 fps ###################", _average];
    diag_log format ["################# current SERVER speed: %1 fps ###################", diag_fps];
	_log_time = diag_tickTime + _log_delay;
   };

   if ( _average < _fps_limit) then
   {
    //lock server to prevent new players to connect
    _need serverCommand "#lock";
	
    _fast = false; //fps to low - break while loop and restart mission
   };
  };
 };
 sleep (1 + random 1);
};

// inform players about upcoming server restart
{
 _msg_str = str format ["SERVER MSG: Mission is laggy, server restarts in %1. Restart will take 5 minutes. Disconnect now and come back after %2!", (_x select 0), (_x select 1)];
 _msg_str remoteExec ["hint", -2];
 _msg_str remoteExec ["systemChat", -2];

 _msg_time = diag_tickTime + (_x select 2);
 waitUntil {sleep 1; diag_tickTime > _msg_time};
 
 true
}count [["2 min", "7 min", 30], ["90 s", "6.5 min", 30], ["1 min", "6 min", 30], ["30 s", "5.5 min", 15], ["15 s", "5 min", 5], ["10 s", "5 min", 5], ["5 s", "5 min", 5]];

// inform players about server restart now

"SERVER RESTARTS NOW !!!" remoteExec ["hint", -2];
"SERVER RESTARTS NOW !!!" remoteExec ["systemChat", -2];

sleep 3;

// halt server  (server shutdown is detected by linux and ne server will be started)
_need serverCommand "#shutdown";
};