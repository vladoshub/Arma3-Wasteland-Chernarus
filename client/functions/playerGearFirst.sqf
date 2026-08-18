/*
	Author: AryX (noaim)
	Description: Gear Level 1
	Version: 0.7
	Updated: 02.11.2019
	Range: 0 to 2000000
*/

#define DLC_APEX 395180
#define DLC_LAWSOFWAR 571710 
#define DLC_JETS 601670
#define DLC_MARKSMEN 332350
#define DLC_HELICOPTERS 304380
#define DLC_KARTS 288520
#define DLC_TEST 1337
#define DLC_TANKS 798390
#define DLC_TACOPS 744950
#define DLC_CONTACT 1021790

private "_game";
private "_weaponR";
private _arma = [];
private _dlc = [];
private _dlc2 = [];

private _player = _this;


//private _uniform = [_player, "uniform"] call getDefaultClothing;
//private _goggles = [_player, "goggles"] call getDefaultClothing;

//if (_uniform != "") then { _player forceAddUniform _uniform };
//if (_goggles != "") then { _player addGoggles _goggles };

removeAllItems _player; //BY_VLADOS
removeAllWeapons _player;
removeBackpack _player;

/*

// Clothing
if (player getVariable ["bmoney",0] < 2000000) then {
	systemChat "Gear Level 1 Loaded";
	
	player call playerClothingGearLevel1;
};

//Level 2 2.000.000
if ((player getVariable ["bmoney",0] >= 2000000) && (player getVariable ["bmoney",0] < 4000000))then {
	systemChat "Gear Level 2 Loaded";
	
	player call playerClothingGearLevel2;
};

//Level 3 4.000.000
if ((player getVariable ["bmoney",0] >= 4000000) && (player getVariable ["bmoney",0] < 8000000))then {
	systemChat "Gear Level 3 Loaded";
	
	player call playerClothingGearLevel3;
};

//Level 4 8.000.000
if ((player getVariable ["bmoney",0] >= 8000000) && (player getVariable ["bmoney",0] < 16000000))then {
	systemChat "Gear Level 4 Loaded";
	
	player call playerClothingGearLevel4;
};

//Level 5 16.000.000
if ((player getVariable ["bmoney",0] >= 16000000) && (player getVariable ["bmoney",0] < 32000000))then {
	systemChat "Gear Level 5 Loaded";
	
	player call playerClothingGearLevel5;
};

//Level 6 32.000.000
if ((player getVariable ["bmoney",0] >= 32000000) && (player getVariable ["bmoney",0] < 48000000))then {
	systemChat "Gear Level 6 Loaded";
	
	player call playerClothingGearLevel6;
};

//Level 7 48.000.000
if ((player getVariable ["bmoney",0] >= 48000000) && (player getVariable ["bmoney",0] < 64000000))then {
	systemChat "Gear Level 7 Loaded";
	
	player call playerClothingGearLevel7;
};

//Level 8 64.000.000
if (player getVariable ["bmoney",0] >= 64000000) then {
	systemChat "Gear Level 8 Loaded";
	
	player call playerClothingGearLevel8;
};

*/

if (_player isEqualTo player) then {
	thirstLevel = 100;
	hungerLevel = 100;
};
