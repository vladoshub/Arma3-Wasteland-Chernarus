if(isServer)then{
 addToTrophy = {
  params["_vehicle","_range"];
  _null = [_vehicle,_range]spawn {
		private["_vehicle","_range","_incoming","_target","_wep","_wasIncoming","_incomingProcess","_aslCram","_aslCramFix","_relDir","_time", "_isAutonomous", "_countCramInit", "_chance"];
	_vehicle = _this select 0;
	_range = _this select 1;
	_isAutonomous = true;//isAutonomous _vehicle;
	_countCramInit= ({ _x getVariable["cramInit", false] } count allMissionObjects "B_AAA_System_01_F");
	if ((_vehicle getVariable ["cramInit", false]) || !(alive _vehicle)|| _countCramInit > 30) exitWith {};
	_vehicle setVariable ["cramInit", true, true];

	{
	_x setSkill 1;
	}foreach crew _vehicle;	 

	_vehicle setVehicleRadar 1;

	while{alive _vehicle && (_vehicle getVariable ["cramInit", false])} do {
	if(_isAutonomous) then {

	if(!(isVehicleRadarOn _vehicle)) then {
		_vehicle setVehicleRadar 1;
	};
	 // Enables Trophy to intercept large caliber shells
	 _incoming = _vehicle nearObjects ["ShellBase",_range];
	 
	 // Enables Trophy to intercept missiles
	 _incoming = _incoming + (_vehicle nearObjects ["MissileBase",_range]);
	 
	 // Enables Trophy to intercept rockets
	 _incoming = _incoming + (_vehicle nearObjects ["RocketBase",_range]);
	 
	 /* The order in which these threat types are listed determine the order in which they
	 are added to the array of incoming threats. Thus, large calibers shells have priority
	 over missiles, which have priority over rockets
	 */

	_wep = currentweapon _vehicle;
	_wasIncoming = false;
	 if(count _incoming > 0) then {
		_wasIncoming = true;
	 };
	 _incomingProcess = 0;
	 while{count _incoming > 0 && _incomingProcess < 10} do {
		_vehicle setAutonomous false;
		_incomingProcess = _incomingProcess + 1;
		// Takes first element of _incoming and attempts to engage it
		_target = _incoming select 0; 
		
		/*
		// True bearing of the vehicle from the projectile's perspective
		_fromTarget = _target getDir _vehicle; 
		
		// Heading the projectile is flying at
		_dirTarget = direction _target; 
		
		// Vertical coordinate of projectile
		_targetZ = (getPosASL _target) select 2; 
		
		// Vertical coordinate of vehicle
		_vehicleZ = ((getPosASL _vehicle) select 2) + 1.8;
		
		// Approach angle of projectile
		_targetSlope = (_targetZ - _vehicleZ) / (_vehicle distance2D _target);
		*/
		
		/*
		Trophy will only engage if the vehicle is 30 degrees left or right of the projectile's heading
		and isn't coming too steeply from above or below. The elevation limits are set at 80 degrees up
		or down by default
		*/

		_aslCram = (getPosASL _vehicle);
		_aslCramFix = [(_aslCram select 0), (_aslCram select 1), ((_aslCram select 2) + 2)];
		_relDir = (_vehicle getRelDir _target);

		//_terrainBlock = terrainIntersectASL [(getPosASL _vehicle), (getPosASL _target)];
		
		//if ((_dirTarget < _fromTarget + 30) && (_dirTarget > _fromTarget - 30) && (_targetSlope < 5.76) && (_targetSlope > -5.76) && ((!_lineBlock) && (!_terrainBlock))) then {
		if (_relDir < 120) then {	

			_vehicle doWatch _target;
			_vehicle doTarget _target;

			// Creates small explosion

			/*_time = time;
			_vehicle doWatch _target;
			_vehicle doTarget _target;

			waitUntil{_vehicle aimedAtTarget [_target, _wep] > 0.2 or (time - _time) > 0.7};
			*/

			//_vehicle doFire _target;
			//_vehicle fireAtTarget [_target];

			_time = time;
			_relDir = (_vehicle getRelDir _target);
			while{_relDir > 60 && (time - _time) < 2} do {
				_relDir = (_vehicle getRelDir _target);
				sleep 0.5;
			};	
			//0.75

			//while{alive _target && _count < 5} do {

				/*
				_timeSleep = 0.1 + random 0.3;
				_timeFire = time;
				while{(time - _timeFire) < _timeSleep} do {
					//[_vehicle, _wep] call BIS_fnc_fire; 
					//sleep 0.01;
				};
				//sleep _timeSleep;
				*/
				
				_chance = random 1;
				_relDir = (_vehicle getRelDir _target);

				if (_chance < 0.45 && _relDir < 25) then { //0.65
					if (!(lineIntersects [_aslCramFix, (getPosASL _target), _vehicle, _target])) then {
					[_vehicle, _wep] call BIS_fnc_fire; 
					"SmallSecondary" createVehicle (getPos _target); 
					// Deletes projectile
					deleteVehicle _target; 
					}
				};
				//sleep 0.1; 
			//};

			//_vehicle doWatch objNull;
			
			// Removes _target from the array of projectiles
			_incoming = _incoming - [_target]; 
			
			// Script has a delay before engaging the next projectile in the array
			sleep 0.2; //0.2
		};
	 };
	 if(_wasIncoming && (alive _vehicle)) then {
		_vehicle doWatch objNull;
		_vehicle setAutonomous true;
		_vehicle setVehicleRadar 0;
	 };
	 
	 /* 
	 This is how often the system checks for incoming projectiles
	 within the range specified in the init.sqf. If you want the APS to
	 intercept faster munitions like tank shells, you need to decrease the interval length.
	 This can have performance issues if too many vehicles with the APS are included in a mission
	 and the interval is very short.
	 */
	 if(count _incoming == 0) then {
	 sleep 0.05; 
	 };
	};
	};
  };
 };
}
  