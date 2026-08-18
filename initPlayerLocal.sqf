// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: initPlayerLocal.sqf
//	@file Author: AgentRev
Aryx_Logit = compileFinal preprocessFile "server\aryx_log.sqf";
if (!isServer) then {
	"BIS_fnc_MP_packet" addPublicVariableEventHandler compileFinal preprocessFileLineNumbers "server\antihack\filterExecAttempt.sqf";
	
	//0 = [] spawn { //BY VLADOS
  	//waitUntil {!isNull findDisplay 46};
  	//findDisplay 46 displayAddEventHandler ["keyDown",{
    //	params ["_ctrl","_key"];
    //	private _h = false;
    //	if (_key == 199) then {_h = true}; //home
    //	_h
  	//}]
	//};
};