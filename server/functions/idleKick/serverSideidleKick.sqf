private _need = "12345abz!";
params["_user"];
_need serverCommand format["#kick %1", _user];
private _outMsg = format["Player % kicked by timeout", _user];
_outMsg remoteExec ["systemChat", -2];