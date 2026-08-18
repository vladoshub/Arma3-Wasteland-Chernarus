/*
	Author: AryX (noaim)
	Description: Gear Level 7
	Version: 0.7
	Updated: 02.11.2019
	Range: 48000000 to 64000000
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
		//_player addHeadgear "H_HelmetSpecO_ocamo";
		//_player addVest "V_PlateCarrierSpec_rgr";
		_player addBackpack "B_Carryall_cbr";
	};
	case east: {
		//_player addHeadgear "H_HelmetSpecO_ocamo";
		//_player addVest "V_PlateCarrierSpec_mtp";
		_player addBackpack "B_Carryall_ocamo";
	};
	case independent: {
		//if (DLC_APEX in (getDLCs 1)) then { _player addHeadgear "H_HelmetSpecO_ghex_F"; } else { _player addHeadgear "H_HelmetSpecO_ocamo"; };
		//_player addVest "V_PlateCarrierSpec_rgr";
		_player addBackpack "B_Carryall_oli";
	};
};
