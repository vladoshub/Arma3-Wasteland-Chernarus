//Chernarus cup

{

		_localWaterPos = getPosATL _x;

		_markerName = format["marker_shop_title_%1",_x];
		deleteMarkerLocal _markerName;
		_marker = createMarkerLocal [_markerName, _localWaterPos];
		_markerName setMarkerShapeLocal "ICON";
		_markerName setMarkerTypeLocal "mil_dot";
		_markerName setMarkerColorLocal "Color4_FD_F";
		_markerName setMarkerSizeLocal [0.75, 0.75];
} forEach ((getMarkerPos "center") nearObjects ["Land_ConcreteWell_02_F", 25000]);

{
		_localFoodPos = getPosATL _x;

		_markerName = format["marker_shop_title_%1",_x];
		deleteMarkerLocal _markerName;
		_marker = createMarkerLocal [_markerName, _localFoodPos];
		_markerName setMarkerShapeLocal "ICON";
		_markerName setMarkerTypeLocal "mil_dot";
		_markerName setMarkerColorLocal "ColorBrown";
		_markerName setMarkerSizeLocal [0.75, 0.75];
} forEach allMissionObjects "Land_bags_EP1";