// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: respawn_functions.sqf
//	@file Author: AgentRev

_getPlayersInfo =
{
	private ["_location", "_isBeacon"];
	_location = _this; // spawn beacon object or town marker name
	
	_localHqTypes = ["B_T_VTOL_01_armed_olive_F", "CUP_O_BTR90_HQ_RU", "CUP_B_BRDM2_HQ_CDF", "CUP_B_BMP_HQ_CDF", "B_T_APC_Tracked_01_rcws_F", "CUP_I_ZUBR_UN", "B_T_APC_Wheeled_01_cannon_F"];

	private _notHQ = true;
	if(typeName _location == "OBJECT") then {
		if((typeOf _location) in _localHqTypes) then {
			_notHQ = false;
		};
	};
	_isBeacon = (typeName _location == "OBJECT" && !(_location isKindOf "FlagChecked_F") && _notHQ);

	_friendlyUnits = [];
	_friendlyPlayers = 0;
	_friendlyNPCs = 0;
	_enemyPlayers = 0;
	_enemyNPCs = 0;

	if (_isBeacon) then
	{
		_friendlyUnits = _location getVariable ["friendlyUnits", []];
		_friendlyPlayers = _location getVariable ["friendlyPlayers", 0];
		_friendlyNPCs = _location getVariable ["friendlyNPCs", 0];
		_enemyPlayers = _location getVariable ["enemyPlayers", 0];
		_enemyNPCs = _location getVariable ["enemyNPCs", 0];
	}
	else // town or flag
	{
		_friendlyUnits = missionNamespace getVariable [format ["%1_friendlyUnits", _location], []];
		_friendlyPlayers = missionNamespace getVariable [format ["%1_friendlyPlayers", _location], 0];
		_friendlyNPCs = missionNamespace getVariable [format ["%1_friendlyNPCs", _location], 0];
		_enemyPlayers = missionNamespace getVariable [format ["%1_enemyPlayers", _location], 0];
		_enemyNPCs = missionNamespace getVariable [format ["%1_enemyNPCs", _location], 0];
	};
};
