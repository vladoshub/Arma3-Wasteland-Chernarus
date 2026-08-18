/*
	Author: AryX (noaim)
	Description: Gear Level 5
	Version: 0.7
	Updated: 02.11.2019
	Range: 16000000 to 32000000
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

// Clothing
switch (playerSide) do {
	case west: {
		//_player addHeadgear "H_HelmetSpecB_paint1";
		//_player addVest "V_PlateCarrier2_rgr";
		_player addBackpack "B_Kitbag_tan";
	};
	case east: {
		//_player addHeadgear "H_HelmetSpecB_sand";
		//_player addVest "V_PlateCarrierH_CTRG";
		_player addBackpack "B_Kitbag_mcamo";
	};
	case independent: {
		//_player addHeadgear "H_HelmetSpecB_snakeskin";
		//_player addVest "V_PlateCarrier2_rgr";
		_player addBackpack "B_Kitbag_rgr";
	};
};
