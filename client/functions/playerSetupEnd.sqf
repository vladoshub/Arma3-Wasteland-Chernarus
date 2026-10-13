// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: playerSetupEnd.sqf
//	@file Author: [GoT] JoSchaap, AgentRev

private "_player";
_player = _this;

_player addRating 1e11;

[objNull, _player] call mf_player_actions_refresh;
[] execVM "client\functions\playerActions.sqf";


private _edenFace = _player getVariable ["A3W_edenFace", ""];

if (_edenFace != "") then {
    [_player, _edenFace] remoteExec ["setFace", 0, _player];
};

_player groupChat "Wasteland - Initialization Complete";
playerSetupComplete = true;
