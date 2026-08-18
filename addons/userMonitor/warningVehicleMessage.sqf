params ["_message" , "_simplMessage", "_clientOwner"];

//[
//	_message
//] call hintBroadcast;

sleep 5;
"Alarm" remoteExec ["playSound", -_clientOwner];
_message remoteExec ["hint", -_clientOwner];
sleep 5;
"Alarm" remoteExec ["playSound", -_clientOwner];
_message remoteExec ["hint", -_clientOwner];
sleep 5;
"Alarm" remoteExec ["playSound", -_clientOwner];
_message remoteExec ["hint", -_clientOwner];



//sleep 2;
//[
//	_message
//] call hintBroadcast;
//sleep 2;
//[
//	_message
//] call hintBroadcast;

//_message remoteExec ["hint", -2];