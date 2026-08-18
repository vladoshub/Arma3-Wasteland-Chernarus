params ["_message" , "_simplMessage", "_clientOwner"];

//[
//	_message
//] call hintBroadcast;

sleep 3;
_message remoteExec ["hint", -_clientOwner];
sleep 3;
_message remoteExec ["hint", -_clientOwner];
sleep 3;
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