/*
	Author: AryX (noaim)
	Description: Tear Gas (Yellow Smoke + GL Yellow Smoke)
	Version: 0.5
	Updated: 02.11.2019
*/

_gasMask = ["H_CrewHelmetHeli_B", "H_CrewHelmetHeli_O", "H_CrewHelmetHeli_I", "H_CrewHelmetHeli_I_E"];
_gasMaskGog = ["G_AirPurifyingRespirator_02_black_F", "G_AirPurifyingRespirator_02_olive_F", "G_AirPurifyingRespirator_02_sand_F", "G_AirPurifyingRespirator_01_F", "G_RegulatorMask_F"];
_exemptVehicles = ["B_MRAP_01_hmg_F", "B_MRAP_01_F", "B_MRAP_01_gmg_F", "O_MRAP_02_F", "O_T_MRAP_02_ghex_F", "O_MRAP_02_gmg_F", "O_T_MRAP_02_gmg_ghex_F", "O_MRAP_02_hmg_F", "I_MRAP_03_F", "I_MRAP_03_hmg_F", "I_MRAP_03_gmg_F", "B_MBT_01_cannon_F", "O_MBT_02_cannon_F", "O_APC_Wheeled_02_rcws_v2_F", "I_MBT_03_cannon_F", "B_APC_Wheeled_01_cannon_F", "O_APC_Wheeled_02_rcws_F", "I_APC_Wheeled_03_cannon_F", "B_APC_Tracked_01_AA_F", "B_APC_Tracked_01_CRV_F", "B_APC_Tracked_01_rcws_F", "O_APC_Tracked_02_AA_F", "O_APC_Tracked_02_cannon_F", "I_APC_tracked_03_cannon_F"];

while {true} do {
	"dynamicBlur" ppEffectEnable true; // enables ppeffect
	"dynamicBlur" ppEffectAdjust [0]; // enables normal vision
	"dynamicBlur" ppEffectCommit 15; // time it takes to normal
	resetCamShake; // resets the shake
	20 fadeSound 1; //fades the sound back to normal
	//by vlados 
	waitUntil{
		((nearestObject [getPosATL player, "SmokeShellYellow"]) distance player < 10) and (getPosATL (nearestObject [getPosATL player, "SmokeShellYellow"]) select 2 < 0.5) and ((nearestObject [getPosATL player, "land_bunker_garage"]) distance player > 25) and ((nearestObject [getPosATL player, "Land_BagBunker_Large_F"]) distance player > 15) and ((nearestObject [getPosATL player, "FlagChecked_F"]) distance player > 40) and ((nearestObject [getPosATL player, "Land_Bunker_01_big_F"]) distance player > 15) and ((nearestObject [getPosATL player, "WarfareBDepot"]) distance player > 20) and ((nearestObject [getPosATL player, "Land_Cargo_Tower_V4_F"]) distance player > 20) and ((nearestObject [getPosATL player, "Land_PierConcrete_01_16m_F"]) distance player > 30) and ((nearestObject [getPosATL player, "Land_Pier_Box_F"]) distance player > 50) and ((nearestObject [getPosATL player, "Land_Cargo_Patrol_V1_F"]) distance player > 7)
		or
		((nearestObject [getPosATL player, "G_40mm_SmokeYellow"]) distance player < 10) and (getPosATL (nearestObject [getPosATL player, "G_40mm_SmokeYellow"]) select 2 < 0.5) and ((nearestObject [getPosATL player, "land_bunker_garage"]) distance player > 25) and ((nearestObject [getPosATL player, "Land_BagBunker_Large_F"]) distance player > 15) and ((nearestObject [getPosATL player, "FlagChecked_F"]) distance player > 40) and ((nearestObject [getPosATL player, "Land_Bunker_01_big_F"]) distance player > 15) and ((nearestObject [getPosATL player, "WarfareBDepot"]) distance player > 20) and ((nearestObject [getPosATL player, "Land_Cargo_Tower_V4_F"]) distance player > 20) and ((nearestObject [getPosATL player, "Land_PierConcrete_01_16m_F"]) distance player > 30) and ((nearestObject [getPosATL player, "Land_Pier_Box_F"]) distance player > 50) and ((nearestObject [getPosATL player, "Land_Cargo_Patrol_V1_F"]) distance player > 7)
	};

	if ((headgear player in _gasMask) || (goggles player in _gasMaskGog) || ((typeOf vehicle player) in _exemptVehicles) || (typeOf vehicle player) isKindOf "Tank_F") then {
		"dynamicBlur" ppEffectEnable true; // enables ppeffect
		"dynamicBlur" ppEffectAdjust [0]; // intensity of blur
		"dynamicBlur" ppEffectCommit 3; // time till vision is fully blurred
		enableCamShake false; // enables camera shake
		5 fadeSound 0.1; // fades the sound to 10% in 5 seconds
	} else {
		"dynamicBlur" ppEffectEnable true; // enables ppeffect
		"dynamicBlur" ppEffectAdjust [20]; // intensity of blur
		"dynamicBlur" ppEffectCommit 3; // time till vision is fully blurred
		enableCamShake false; // enables camera shake
		addCamShake [10, 45, 10]; // sets shakevalues
		player setFatigue 1; // sets the fatigue to 100%
		5 fadeSound 0.1; // fades the sound to 10% in 5 seconds
	};
	uiSleep 0.5;
};