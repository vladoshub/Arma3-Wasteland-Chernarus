private ["_FPV", "_mag", "_secondWeaponSize", "_status", "_complete", "_fpvNotInit", "_magArray", "_secWeaponArray", "_magArray", "_inventWeap"];

_FPV = _this select 0;
_mag = magazines player;
_secondWeaponSize = count (secondaryWeaponMagazine player);
_status = _FPV getVariable ["fpvInit", "0"];
_complete = false;
_fpvNotInit = false;
_magArray = ["SatchelCharge_Remote_Mag", "DemoCharge_Remote_Mag"];
_secWeaponArray = ["RPG7_F"];
_magArray append _secWeaponArray;

if(_status != "2") then {
	_fpvNotInit = true;
};

if(!((getConnectedUAV player) isEqualTo  objNull) || count (attachedObjects (player)) > 0) then {
	["You cant assemble drone when uav is connecting or uav is attaching! To avoid this, you can temporarily drop the UAV terminal on the ground.", 5] call mf_notify_client;
} else {

//_inventWeap = ("RPG7_F" in _mag || "SatchelCharge_Remote_Mag" in _mag || "DemoCharge_Remote_Mag" in _mag);
//_secondWeap = ("RPG7_F" in _secondWeapon);


_inventWeap = "";

{
	if(_x in _mag) then {
		_inventWeap = _x;
		break;
	};
} 
forEach _magArray;

/*
{
	if(_x in _secondWeapon) then {
		_secondWeap = _x;
		break;
	};
} 
forEach _magArray
*/

if ((_inventWeap != "" || _secondWeaponSize > 0) && _fpvNotInit) then {

	_checks = {
	private ["_progress", "_FPV", "_failed", "_text", "_success"];
	_progress = _this select 0;
	_FPV = _this select 1;
	_text = "";
	_failed = true;
	switch (true) do {
		case (!alive player): {}; // player is dead, no need for a notification
		case (vehicle player != player): {_text = "Assembling Failed! You can't do that in a drone"};
		case (player distance _FPV > (sizeOf typeOf _FPV / 3) max 4): {_text = "Assembling Failed! You moved too far away from the drone, try again"};
		case (!alive _FPV): {_text = "The drone is too damaged to assembling"};
		case ((_FPV getVariable ["fpvInit", "0"]) == "2"): {_text = "The drone is ready!"};
		case (doCancelAction): {_text = "Assembling cancelled!"; doCancelAction = false;};
		default {
			_text = format["Assembling %1%2 Complete", round(100 * _progress), "%"];
			_failed = false;
		};
	};
	[_failed, _text];
	};

	private _success = [20, "AinvPknlMstpSlayWrflDnon_medic", _checks, [_FPV]] call a3w_actions_start;

	if(_success && (_FPV getVariable ["fpvInit", "0"]) != "2") then {
	_FPV setVariable ["fpvInit", "2", true];
	_FPV setVariable ["fpvInitOwnerUid", getPlayerUID player, true];
	_complete = true;
	private _result = "SmallSecondary";
	if(_secondWeaponSize > 0) then {
		_secondaryWeapon = (secondaryWeaponMagazine player) select 0;
		player removeSecondaryWeaponItem _secondaryWeapon;
		_result = _secondaryWeapon;
	} else {
		player removeMagazine _inventWeap;
		_result = _inventWeap;
	};
	private _fpvPos = getPosATL _FPV;
	private _lootholder = createVehicle ["GroundWeaponHolder", _fpvPos, [], 0, "CAN_COLLIDE"];
	_lootholder addMagazineCargoGlobal [_result, 1];
	_lootholder attachTo [_FPV];
	_lootholder setVectorDirAndUp [[ -1 , 0 , 0 ],[ 0 , 0 , 1 ]];
	_lootholder setVariable ["processedDeath", -1, true];
	_lootholder setVariable ["forDeleteObject", false, true];

	//if(typeOf _FPV in ["B_UAV_06_F", "O_UAV_06_F", "I_UAV_01_F"]) then {
	//	_lootholder setVectorDirAndUp [[ -1 , 0 , 0 ],[ 0 , 0 , 1 ]];
	//};

	["Assembled!", 2] call mf_notify_client;
	};
	

	/*
	_FPV addMPEventHandler ["MPKilled", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	if (count (attachedObjects (_unit)) > 0) then {
		_exp = "SmallSecondary";
	{
		_exp = (getMagazineCargo _x) select 0 select 0;
		_exp = getText (configFile >> "cfgMagazines" >> _exp >> "ammo");
  		detach _x;
  		deleteVehicle _x;
	} forEach attachedObjects (_unit);	
	_bombMpghdgkgExp = _exp createVehicle (getpos _unit);
	_bombMpghdgkgExp setPosATL (getPosATL _unit);
	_bombMpghdgkgExp setDamage 1;
	};
	_unit setVariable ["fpvInit", "0", true];
	_unit removeAllMPEventHandlers "MPKilled";
	}];
	
	["Assembled!", 2] call mf_notify_client;
	};*/
	
};

if(!(_complete)) then {
	["You must have rocket from launcher or explosive to assemble drone!", 5] call mf_notify_client;
};
};
