/*
	Author: AryX (noaim)
	Description: Gear Level 8
	Version: 0.7
	Updated: 02.11.2019
	Range: 64000000 to 82000000
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

private _memberLevel = player getVariable ["memberLevel", 0];

if (_memberLevel isEqualTo 1) then {
	systemChat "Member loaded";
};

// Clothing
switch (playerSide) do {
	case west: {
		//_player addHeadgear "H_HelmetLeaderO_ocamo";
		//_player addVest "V_PlateCarrierSpec_rgr";
		_player addBackpack "B_Carryall_cbr";
	};
	case east: {
		//_player addHeadgear "H_HelmetLeaderO_ocamo";
		//_player addVest "V_PlateCarrierSpec_mtp";
		_player addBackpack "B_Carryall_ocamo";
	};
	case independent: {
		//if (DLC_APEX in (getDLCs 1)) then { _player addHeadgear "H_HelmetLeaderO_ghex_F"; } else { _player addHeadgear "H_HelmetLeaderO_oucamo"; };
		// _player addVest "V_PlateCarrierSpec_rgr";
		//if (DLC_CONTACT in (getDLCs 1)) then { _player addVest "V_PlateCarrierSpec_wdl"; } else { _player addVest "V_PlateCarrierSpec_rgr"; };
		_player addBackpack "B_Carryall_oli";
	};
};


