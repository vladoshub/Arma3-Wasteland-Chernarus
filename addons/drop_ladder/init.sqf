if (!hasInterface || isServer) exitWith {};

private _ladder_object = ['Land_BagBunker_Tower_F', 'Land_PierLadder_F', 'Land_Pier_Box_F', 'land_bunker_garage'];

while {true} do {

	private _currentAnimState = animationState player;
	if(_currentAnimState == 'laddercivilstatic' || _currentAnimState == 'ladderciviluploop' || _currentAnimState == 'laddercivildownloop') then {
	
	//&& _x getVariable ["is_base_flag_activate", false])
	//check locked near enemy object near 100m
	if({ (_x getVariable ["objectLocked", false]) && ( (player distance _x) <= (((sizeOf (typeOf _x)) /2) + 1) ) && ( !( (_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) || (_x getVariable ["ownerUID", "0"] in ((units player) apply {getPlayerUID _x})) || (group _x == group player) || ((side _x == side player) && (str(side player) == "WEST" || str(side player) == "EAST")) || ((str(side player) == "WEST" || str(side player) == "EAST") && (str(side player)) == (_x getVariable ["LastSide", ""])) ) || ((str(side player)) != _x getVariable ["LastSide", (str(side player))])) } count (player nearObjects (100)) > 0) then {

		//{
		//	player action ["ladderOff", (position _x)];
		//} forEach nearestTerrainObjects [player, _ladder_object, 20];
		
		//check player on ladder object 
		if ({ !(_x getVariable["R3F_LOG_disabled", false]) && !(_x getVariable ["objectLocked", false]) && (typeOf _x in ['Land_BagBunker_Tower_F', 'Land_PierLadder_F'] ) } count (player nearObjects 5) > 0)  then {
			[player, ""] call switchMoveGlobal;
			playSound "FD_CP_Not_Clear_F";
			["You are not allowed to use ladder near saved enemy objects!.", 5] call mf_notify_client;
		};

		if ({ !(_x getVariable["R3F_LOG_disabled", false]) && !(_x getVariable ["objectLocked", false]) && (typeOf _x in ['Land_Pier_Box_F'] ) } count (player nearObjects 65) > 0)  then {
			[player, ""] call switchMoveGlobal;
			playSound "FD_CP_Not_Clear_F";
			["You are not allowed to use ladder near saved enemy objects!.", 5] call mf_notify_client;
		};

		if ({ !(_x getVariable["R3F_LOG_disabled", false]) && !(_x getVariable ["objectLocked", false]) && (typeOf _x in ['land_bunker_garage'] ) } count (player nearObjects 25) > 0)  then {
			[player, ""] call switchMoveGlobal;
			playSound "FD_CP_Not_Clear_F";
			["You are not allowed to use ladder near saved enemy objects!.", 5] call mf_notify_client;
		};

	};
	
	};

	sleep 0.5;


	
};