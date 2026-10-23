// Conservative horizontal radius, including the vehicle's length and width.
private _vehicle = _this;
private _radius = _vehicle getVariable ["A3W_missionVehicleRadius", -1];
if (_radius >= 0) exitWith { _radius };

private _bounds = boundingBoxReal _vehicle;
private _min = _bounds select 0;
private _max = _bounds select 1;
private _width = (abs (_min select 0)) max (abs (_max select 0));
private _length = (abs (_min select 1)) max (abs (_max select 1));
_radius = sqrt (_width * _width + _length * _length);
_vehicle setVariable ["A3W_missionVehicleRadius", _radius];
_radius
