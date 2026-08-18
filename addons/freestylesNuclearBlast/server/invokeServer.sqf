if(isServer) then {

private _pos = param[0];

private _useCrater = true;

private _dist = 200;
private _poiMarkers = allMapMarkers select {markerType _x isEqualTo "Empty" && {[["VehStore","Mission_","ForestMission_","LandConvoy_","BigBoat_","UltraMission_", "UnlockBuildBase", "BaseCapture_", "Spawn_", "Town_"], _x] call fn_startsWith}};

//base_flag addon
private _nearFlags = _pos nearObjects  ["FlagChecked_F", 400];
private _nearFlagsCount = ({ _x getVariable ["is_base_flag_activate", false] } count _nearFlags);  

if (({ (_pos) vectorDistance (ATLtoASL getMarkerPos _x) < _dist } count _poiMarkers > 0) || (_nearFlagsCount > 0) || (count ((nearestObjects [(ASLToAGL _pos), ["Land_Atm_01_F", "Land_i_Shed_Ind_F", "Land_Pallet_MilBoxes_F", "Land_bags_EP1", "Land_ConcreteWell_02_F", "Land_ToiletBox_F", "C_Truck_02_box_F"], 150])) > 0) ) then
	{
		_useCrater = false;
	};

[_pos, 3, true, [_useCrater, true, true, true, true, true, true, true, true, true], 0.3, 10] spawn freestylesNuclearBlast_fnc_initBlast; 

};
