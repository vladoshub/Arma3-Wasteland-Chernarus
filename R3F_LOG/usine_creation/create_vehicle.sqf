if(isServer) then {
/*
private _object = nil;
private _type = _this select 2;

private _class = _this select 0;
private _pos = _this select 1;

if(_type) then {
	_object = createVehicle [_class, _pos, [], 0, "NONE"];
} else {
	_object = _class createVehicle _pos;
};

[_object] call vehicleSetup;
_object
*/
private _object = _this select 0;
[_object] call vehicleSetup;
};