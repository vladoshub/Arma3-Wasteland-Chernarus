

if (!hasInterface || isServer) exitWith {};

private ["_desiredFPS", "_minDistance", "_minDistanceObj", "_clientFPS", "_currentViewDist", "_currentViewDistObj", "_offset", "_offsetObj", "_objectOffset", "_targetView", "_targetViewObj", "_targetTerrain", "_nextView", "_nextViewObj", "_viewOffset"];

while {true} do {

	waitUntil {sleep 0.1; alive player && !(player getVariable ["playerSpawning", true]) && profileNamespace getVariable ["CHVD_autoMode", false]};

	_desiredFPS = profileNamespace getVariable ["CHVD_desiredFPS", 60];
	_minDistance = profileNamespace getVariable ["CHVD_MinViewDistance", 1600];
	_minDistanceObj = profileNamespace getVariable ["CHVD_MinViewDistanceObj", 1600];
	_clientFPS = round diag_fps;

	_currentViewDist = viewDistance;
	_currentViewDistObj = (getObjectViewDistance select 0);
	_offset = _currentViewDist * 0.08;
	_offsetObj = _currentViewDistObj * 0.08;


	
	if ((round (_clientFPS - _desiredFPS)) < ((_clientFPS * 0.1) * -1)) then {


	if(_currentViewDistObj > _minDistanceObj) then {

	_objectOffset = _currentViewDistObj - _offsetObj;
	if(_objectOffset >= _minDistanceObj) then {
	 	CHVD_footObj = _objectOffset;
	 	CHVD_carObj = _objectOffset;
	 	CHVD_airObj = _objectOffset;
	};
	} else {
		_objectOffset = _currentViewDistObj + _offsetObj;
		if(_objectOffset <= 4500) then {
			CHVD_footObj = _objectOffset;
	 		CHVD_carObj = _objectOffset;
	 		CHVD_airObj = _objectOffset;
		};
	};



	if(_currentViewDist > _minDistance) then {
		_viewOffset = _currentViewDist - _offset;
		if(_viewOffset >= _minDistance) then {
			CHVD_car = _viewOffset;
	 		CHVD_air = _viewOffset;
	 		CHVD_foot = _viewOffset;
		};
	} else {
		_viewOffset = _currentViewDist + _offset;
		if(_viewOffset <= 4500) then {
			CHVD_car = _viewOffset;
	 		CHVD_air = _viewOffset;
	 		CHVD_foot = _viewOffset;
		};
	};
	

	} else {
	
			//if((round (_clientFPS - _desiredFPS)) > 10) then {
				
			_targetView = 4500;
			_targetViewObj = 4500;
			_targetTerrain = 10; //50

			/*
			switch (true) do
			{			
				case (cameraOn isKindOf "LandVehicle" || cameraOn isKindOf "Ship"):
				{
					_targetView = profileNamespace getVariable ["CHVD_car", 4500];
					_targetViewObj = profileNamespace getVariable ["CHVD_carObj", 60450000];
					_targetTerrain = profileNamespace getVariable ["CHVD_carTerrain", 50];
				};
				case (cameraOn isKindOf "Air" || (animationState cameraOn) select [0,12] == "halofreefall"):
				{
					_targetView = profileNamespace getVariable ["CHVD_air", 4500];
					_targetViewObj = profileNamespace getVariable ["CHVD_airObj", 4500];
					_targetTerrain = profileNamespace getVariable ["CHVD_airTerrain", 50];
				};
				default
				{
					_targetView = profileNamespace getVariable ["CHVD_foot", 4500];
					_targetViewObj = profileNamespace getVariable ["CHVD_footObj", 4500];
					_targetTerrain = profileNamespace getVariable ["CHVD_footTerrain", 50];
				};
			};*/
			

			_nextView = _currentViewDist + _offset;
			_nextViewObj = _currentViewDistObj + _offsetObj;

			//if(_nextView < _targetView) then {
				//setViewDistance _nextView;
				if(_nextView < 4500) then {
				CHVD_car = _nextView;
	 			CHVD_air = _nextView;
	 			CHVD_foot = _nextView;
				};
			//};

			//if(_nextViewObj < _targetViewObj) then {
				//setObjectViewDistance _nextViewObj;
				if(_nextViewObj < 4500) then {
		 			CHVD_footObj = _nextViewObj;
	 				CHVD_carObj = _nextViewObj;
	 				CHVD_airObj = _nextViewObj;
				};
			//};

		//};
	};

	//sleep 2;
	sleep 1;
};