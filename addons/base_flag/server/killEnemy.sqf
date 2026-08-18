if(isServer) then {



private _player = _this select 0;
private _killer = _this select 1;
private _currentSidePlayer = _this select 2;


private _friendlyFlags = _player nearObjects ["FlagChecked_F", 300] select { ( (_x getVariable ["is_base_flag_activate", false]) && ((str(_currentSidePlayer)) == (_x getVariable ["LastSide", (str(_currentSidePlayer))])) && ((_x getVariable ["ownerUID","0"] isEqualTo getPlayerUID _player) || (_x getVariable ["ownerUID", "0"] in ((units _player) apply {getPlayerUID _x})) || (group _x == group _player) || ((side _x == _currentSidePlayer) && (str(_currentSidePlayer) == "WEST" || str(_currentSidePlayer) == "EAST")) || ((str(_currentSidePlayer) == "WEST" || str(_currentSidePlayer) == "EAST") && (str(_currentSidePlayer)) == (_x getVariable ["LastSide", ""]))) ) };
private _nearFlagsCount = count (_friendlyFlags); 

if(_nearFlagsCount == 1) then {
	private _flag = _friendlyFlags select 0;
	if(_flag getVariable ["flagsDenyActivate", 0] < serverTime) then {


	waitUntil { sleep 0.001; !BlockFlagKillEnemy};
	BlockFlagKillEnemy = true;
	if(_flag getVariable ["flagsKillTime", 0] > serverTime) then {
		_flag setVariable ["flagsKill", ((_flag getVariable ["flagsKill", 0]) + 1), true];
	} else {
		_flag setVariable ["flagsKillTime", serverTime + (1300 + (floor	(random 900))), true];
		_flag setVariable ["flagsKill", 1, true];
	};
	BlockFlagKillEnemy = false;

	private _playersFriendlyFlag = allPlayers select { ( (((str(_currentSidePlayer)) == _flag getVariable ["LastSide", (str(_currentSidePlayer))])) && ((((_flag getVariable ["ownerUID","0"] isEqualTo getPlayerUID _x) || (_flag getVariable ["ownerUID", "0"] in ((units _x) apply {getPlayerUID _flag})) || (group _flag == group _x) || ((side _flag == _currentSidePlayer) && (str(_currentSidePlayer) == "WEST" || str(_currentSidePlayer) == "EAST")) || ((str(_currentSidePlayer) == "WEST" || str(_currentSidePlayer) == "EAST") && (str(_currentSidePlayer)) == (_flag getVariable ["LastSide", ""])) ) ) || ((_flag getVariable ["ownerUID","0"] isEqualTo getPlayerUID _x) && (_flag getVariable ["is_base_flag_activate", false])) )) };
	private _playersInFlag = _playersFriendlyFlag select { (_x distance _flag) < 305  };
	private _countPlayers = count (_playersFriendlyFlag);
	private _countPlayersInFlag = count (_playersInFlag);

		if((_flag getVariable ["flagsKill", 0]) > round(2 + (_countPlayersInFlag * 1.25)) ) then {
			_flag setVariable ["flagsKill", 0, true];
			_flag setVariable ["flagsKillTime", 0, true];

			_flag setVariable ["flagsDenyActivate", serverTime + 1200, true];
			private _allObj = _flag nearObjects 350;
			private _filterObj = [];

			{ 
				if ( (_x getVariable ["secure_by_flag", false]) && (typeOf _x != "FlagChecked_F")) then 
					{
						_filterObj pushBack _x;
					};
			} forEach _allObj;

			{	_x setVariable ["secure_by_flag", nil, true];
				_x setVariable ["non_unlock_mode", nil, true];
				private _class = typeOf _x;
				_x EnableSimulationGlobal true;
				if (_class != "Land_Sacks_goods_F" && _class != "Land_BarrelWater_F" && !(_class isKindOf "ReammoBox_F")) then
				{ 
					_x setVariable ["allowDamage", true, true];
					_x allowDamage true;
					[_x, true] remoteExec ["allowDamage", -2];
				};

				private _currFilterObj = _x;
				if(_class == "Land_ConcreteWall_01_l_gate_F") then {
				private _doorCount = 0;
				{
					if(_currFilterObj isKindOf (_x select 0)) exitWith {
						_doorCount = (_x select 1);
					};
	
				} forEach CODE_LOCK_DOORS_CONFIG;


				if(_doorCount > 0) then {
					for "_i" from 1 to _doorCount do
					{
						private _lockDoor = format ["bis_disabled_Door_%1", _i];
						_currFilterObj setVariable [_lockDoor, 0, true];
					};
				};
				_currFilterObj setVariable ["isLocked", false, true];
				};

				_x call fn_manualObjectSave;
			}
			forEach _filterObj;


			_flag setVariable ["is_base_flag_activate", nil, true];
			_flag setVariable ["non_unlock_mode", nil, true];
			_flag setVariable ["allowDamage", true, true];
			_flag setVariable ["flag_respawn", nil, true];
			_flag setVariable ["objectLocked", false, true];
			_flag setVariable ["ownerUID", nil, true];
			_flag setVariable ["baseSaving_hoursAlive", nil, true];
			_flag setVariable ["baseSaving_spawningTime", nil, true];
			_flag EnableSimulationGlobal true;
			_flag allowDamage true;
			[_flag, true] remoteExec ["allowDamage", -2];
			_flag call fn_manualObjectSave;

			{
				"Your base is unlocked!" remoteExec ["hint", owner _x];
			}
			forEach _playersInFlag;

			"Base is unlocked!" remoteExec ["hint", owner _killer];

			private _markerName = "BaseFlagAttack_" + netId _flag;
			createMarker [_markerName, getPosATL _flag];
			_markerName setMarkerText "Base Flag Attack!";
			_markerName setMarkerSize [0.75, 0.75];
			_markerName setMarkerShape "ICON";
			_markerName setMarkerType "hd_flag";

		};

    };
};

};