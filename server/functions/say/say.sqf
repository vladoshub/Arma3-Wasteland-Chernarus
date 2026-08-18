params ["_object" , "_sound"];

if(isServer) then {
	[_object, _sound] remoteExec ["say3D", -2, false]; 
};
