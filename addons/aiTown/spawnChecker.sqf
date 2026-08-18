while {true} do {


	private _currentTime = serverTime;
	private _expTownGroups = ((allGroups) select { ((_x getVariable ["expAITown", -1]) != -1) && (( _currentTime - (_x getVariable ["expAITown", -1])) > 0) } );

	{
		private _currentGroup = _x;
		{ deleteVehicle _x; } forEach units _currentGroup;
		
	} forEach _expTownGroups;

	{
		private _currentPlayer = _x;
		private _townArray = (call cityListLimit) select {_currentPlayer inArea (_x select 0)};
		if(count _townArray == 1) then {
			private _town = _townArray select 0;
			private _squareM = ((markerSize (_town select 0)) select 0) * ((markerSize (_town select 0)) select 1);
			[_currentPlayer ,_squareM, random [30, 40, 50], (_town select 0)] execVM "addons\aiTown\spawnAI.sqf";
		};
		
	} forEach ((allPlayers - entities "HeadlessClient_F") select { isPlayer _x && alive _x });

	sleep 45;
};