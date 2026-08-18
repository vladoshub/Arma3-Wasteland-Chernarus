/**
 * Passe la variable R3F_LOG_joueur_deplace_objet � objNull pour informer le script "deplacer" d'arr�ter de d�placer l'objet
 */

private _objet = _this select 0;
private _error = false;
private _poiDist = ["A3W_poiObjLockDistance", 100] call getPublicVar;
private _poiMarkers = allMapMarkers select {markerType _x isEqualTo "Empty" && {[["VehStore","Mission_","ForestMission_","LandConvoy_","BigBoat_","UltraMission_", "UnlockBuildBase"], _x] call fn_startsWith}};
if ((({ (getPosASL _objet) vectorDistance (ATLtoASL getMarkerPos _x) < _poiDist } count _poiMarkers > 0) || ((count (_objet nearEntities ["Land_Atm_01_F", 100]) > 0) || (count (_objet nearEntities ["Land_CampingTable_small_F", 100]) > 0)) ) && ({ (([["UnlockBuildBase"], _x] call fn_startsWith) && ((getPosASL _objet) vectorDistance (ATLtoASL getMarkerPos _x) < 400)) } count _poiMarkers == 0))  then //BY VLADOS
	{
		playSound "FD_CP_Not_Clear_F";
		[format ["You are not allowed to release objects within %1m of stores and mission spawns or ATMs or Parkings. ONLY LOADING IN THE VEHICLE", _poiDist], 5] call mf_notify_client;
		_error = true;
	};

/*
private _nearFlags = _objet nearObjects ["FlagChecked_F", 20];
private _nearFlagsCount = ({ _x getVariable ["is_base_flag_activate", false] } count _nearFlags);

private _wrongObj = false;

if(_nearFlagsCount > 0) then {

	private _bbrObj = boundingBoxReal _objet;
	private _p1Obj = _bbrObj select 0;
	private _p2Obj = _bbrObj select 1;
	private _maxWidthObj = abs ((_p2Obj select 0) - (_p1Obj select 0));
	private _maxLengthObj = abs ((_p2Obj select 1) - (_p1Obj select 1));
	private _maxHeightObj = abs ((_p2Obj select 2) - (_p1Obj select 2));
	private _zObjHPoint = ((getPosATL _objet) select 2) + _maxHeightObj;



	private _ritchBank = _objet call BIS_fnc_getPitchBank;
	private _angleYObj = _ritchBank select 0;
	private _angleXObj = _ritchBank select 1;

	if(_angleYObj > 15 || _angleXObj > 15) then {
		_wrongObj = true;
	};

	{

		private _bbrFlag = boundingBoxReal _x;
		private _p1Flag = _bbrFlag select 0;
		private _p2Flag = _bbrFlag select 1;
		private _maxWidthFlag = abs ((_p2Flag select 0) - (_p1Flag select 0));
		private _maxLengthFlag = abs ((_p2Flag select 1) - (_p1Flag select 1));
		private _maxHeightFlag = abs ((_p2Flag select 2) - (_p1Flag select 2));
		private _zFlagHPoint = ((getPosATL _x) select 2) + _maxHeightFlag;

		if((_zFlagHPoint - _zObjHPoint) < 1.5 || _wrongObj) exitWith { // flag should higher then obj
			_wrongObj = true;
		};
		
	} forEach _nearFlags;

};


if(_wrongObj) exitWith {
	hint format "You cannot put object near the flag when object higher then flag (in 20m radius)";
	playSound "FD_CP_Not_Clear_F";
};
*/





if (R3F_LOG_mutex_local_verrou || _error) then
{
	if(!_error) then {
	hintC STR_R3F_LOG_mutex_action_en_cours;
	};
}
else
{
	R3F_LOG_mutex_local_verrou = true;
	

	R3F_LOG_joueur_deplace_objet = objNull;
	sleep 0.25;
	
	R3F_LOG_mutex_local_verrou = false;
};