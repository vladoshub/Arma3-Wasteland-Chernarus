// Called once after mission setup. Only AI-driven ground guards are controlled.
// Avoidance changes their destination temporarily; PATH and MOVE stay enabled.
if (!isServer) exitWith { scriptNull };
params ["_group", "_prizes", ["_minimumDistance", 20]];
if (isNull _group || {count _prizes == 0}) exitWith { scriptNull };

private _getArea = {
    params ["_prizes"];
    private _center = [0, 0, 0];
    { _center = _center vectorAdd (getPosATL _x) } forEach _prizes;
    _center = _center vectorMultiply (1 / count _prizes);
    _center set [2, 0];
    private _radius = 0;
    {
        _radius = _radius max ((_center distance2D _x) + (_x call A3W_fnc_missionVehicleRadius));
    } forEach _prizes;
    [_center, _radius]
};

private _getGuards = {
    params ["_group"];
    private _guards = [];
    {
        private _vehicle = vehicle _x;
        if (alive _x && {_x isEqualTo driver _vehicle} &&
            {_vehicle isKindOf "LandVehicle"} && {!(_vehicle isKindOf "StaticWeapon")} &&
            {local _vehicle} && {({isPlayer _x} count crew _vehicle) == 0}) then {
            _guards pushBackUnique _vehicle;
        };
    } forEach units _group;
    _guards
};

private _findDestination = {
    params ["_vehicle", "_center", "_keepOut", "_targetRadius", "_allowArc"];
    private _position = getPosATL _vehicle;
    private _distance = _position distance2D _center;
    private _direction = _center getDir _position;
    private _offset = 0;
    if (_allowArc && {_distance > _keepOut + 15}) then {
        // Pick the side closest to the current heading, so the guard drives around.
        private _left = _center getPos [_targetRadius, _direction - 35];
        private _right = _center getPos [_targetRadius, _direction + 35];
        _offset = if (abs (((_vehicle getDir _left) - getDir _vehicle + 540) % 360 - 180) <
            abs (((_vehicle getDir _right) - getDir _vehicle + 540) % 360 - 180)) then {-35} else {35};
    };

    private _result = [];
    // Fall back to a radial retreat if an arc would cut through the protected area.
    {
        private _target = _center getPos [_targetRadius, _direction + _x];
        private _safe = [_target, 0, 10, 5, 0, 0.5, 0,
            [[_center, _keepOut + 8]], [_target, _target]] call BIS_fnc_findSafePos;
        _safe set [2, 0];

        private _segment = _safe vectorDiff _position;
        _segment set [2, 0];
        private _lengthSqr = _segment vectorDotProduct _segment;
        private _along = if (_lengthSqr > 0) then {
            (((_center vectorDiff _position) vectorDotProduct _segment) / _lengthSqr) max 0 min 1
        } else {0};
        private _closest = _position vectorAdd (_segment vectorMultiply _along);

        if (!surfaceIsWater _safe && {_safe distance2D _center >= _keepOut + 8} &&
            {_closest distance2D _center >= ((_distance min (_keepOut + 5)) - 0.1)}) exitWith {
            _result = _safe;
        };
    } forEach [_offset, 0];
    _result
};

private _guards = [_group] call _getGuards;
if (count _guards == 0) exitWith { scriptNull };

// Spread out newly spawned guards before announcing the mission. Never teleport
// vehicles during the live avoidance loop below.
private _area = [_prizes] call _getArea;
_area params ["_center", "_prizeRadius"];
{
    private _vehicle = _x;
    private _keepOut = _minimumDistance + _prizeRadius + (_vehicle call A3W_fnc_missionVehicleRadius);
    if (_vehicle distance2D _center < _keepOut + 10) then {
        private _position = [_vehicle, _center, _keepOut, _keepOut + 25, false] call _findDestination;
        if (count _position > 0) then {
            _position set [2, 0.1];
            _vehicle setVelocity [0, 0, 0];
            _vehicle setPosATL _position;
            _vehicle setVectorUp (surfaceNormal _position);
        };
    };
} forEach _guards;

_group setVariable ["A3W_missionVehicleAvoidanceActive", true];
[_group, _prizes, _minimumDistance, _getArea, _getGuards, _findDestination] spawn {
    params ["_group", "_prizes", "_minimumDistance", "_getArea", "_getGuards", "_findDestination"];
    private _states = [];
    private _restore = {
        params ["_vehicle", "_driver", "_forcedSpeed", "_autoCombat"];
        _vehicle setVariable ["A3W_missionVehicleAvoiding", false];
        if (local _vehicle) then { _vehicle forceSpeed _forcedSpeed };
        if (alive _driver && {local _driver} && {!isPlayer _driver}) then {
            _driver enableAIFeature ["AUTOCOMBAT", _autoCombat];
            if ((leader group _driver) != _driver) then { _driver doFollow (leader group _driver) };
        };
    };

    while {!isNull _group && {_group getVariable ["A3W_missionVehicleAvoidanceActive", false]} &&
        {({alive _x} count units _group) > 0} && {count _prizes > 0}} do {
        _prizes = _prizes select {alive _x};
        if (count _prizes == 0) exitWith {};
        private _area = [_prizes] call _getArea;
        _area params ["_center", "_prizeRadius"];
        private _guards = [_group] call _getGuards;

        // A dead/replaced driver or player takeover must release our overrides.
        for "_i" from ((count _states) - 1) to 0 step -1 do {
            private _state = _states select _i;
            if (!((_state select 0) in _guards) ||
                {driver (_state select 0) != (_state select 1)}) then {
                _state call _restore;
                _states deleteAt _i;
            };
        };
        if (count _guards == 0) exitWith {};

        {
            private _vehicle = _x;
            private _driver = driver _vehicle;
            private _keepOut = _minimumDistance + _prizeRadius + (_vehicle call A3W_fnc_missionVehicleRadius);
            private _distance = _vehicle distance2D _center;
            private _speed = vectorMagnitude (velocity _vehicle);
            // Start early enough to slow down instead of waiting for a breach.
            private _buffer = 12 + (_speed * _speed / 6);
            private _index = _states findIf {(_x select 0) isEqualTo _vehicle};

            if (_index >= 0 && {_distance > _keepOut + _buffer + 15}) then {
                (_states deleteAt _index) call _restore;
            } else {
                if (_distance < _keepOut + _buffer || {_index >= 0}) then {
                    if (_index < 0) then {
                        _index = _states pushBack [_vehicle, _driver, getForcedSpeed _vehicle,
                            _driver checkAIFeature "AUTOCOMBAT", -10, [], -10];
                        _vehicle setVariable ["A3W_missionVehicleAvoiding", true];
                        _driver disableAI "AUTOCOMBAT";
                        doStop _driver;
                    };
                    private _state = _states select _index;
                    private _maxSpeed = if (_distance < _keepOut + 5) then {3} else {5};
                    private _oldSpeed = _state select 2;
                    if (_oldSpeed >= 0) then { _maxSpeed = _maxSpeed min _oldSpeed };
                    _vehicle forceSpeed _maxSpeed;

                    private _destination = _state select 5;
                    if (diag_tickTime - (_state select 6) >= 2 && {
                        count _destination == 0 || {_vehicle distance2D _destination < 8} ||
                        {diag_tickTime - (_state select 6) > 8}
                    }) then {
                        _destination = [_vehicle, _center, _keepOut, _keepOut + _buffer + 30, true] call _findDestination;
                        _state set [5, _destination];
                        _state set [6, diag_tickTime];
                    };
                    if (count _destination > 0 && {diag_tickTime - (_state select 4) >= 2}) then {
                        _driver doMove _destination;
                        _state set [4, diag_tickTime];
                    };
                };
            };
        } forEach _guards;
        sleep 0.25;
    };
    { _x call _restore } forEach _states;
};
