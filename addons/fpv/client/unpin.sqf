
if(!((getConnectedUAV player) isEqualTo  objNull)) then {
	["You cant unpin drone when uav is connecting!", 5] call mf_notify_client;
} else {
{
  _x setVariable ["processedDeath", nil, true];
  _x setVariable ["forDeleteObject", nil, true];	
  detach _x;
} forEach attachedObjects (_this select 0);

(_this select 0) setVariable ["fpvInit", "1", true];
(_this select 0) setVariable ["fpvInitOwnerUid", "", true];


};