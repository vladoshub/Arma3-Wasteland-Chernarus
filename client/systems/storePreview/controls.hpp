#include "defines.hpp"

// Leave the upper-right portion of the screen available for mission hints.
#define A3W_STORE_PREVIEW_LEFT (safezoneX + 0.75 * safezoneW)
#define A3W_STORE_PREVIEW_RIGHT (safezoneX + 0.985 * safezoneW)
#define A3W_STORE_PREVIEW_GAP (0.01 * safezoneW)
#define A3W_STORE_DIALOG_X(WIDTH) ((CENTER(1, WIDTH) min (A3W_STORE_PREVIEW_LEFT - WIDTH - A3W_STORE_PREVIEW_GAP)) max safezoneX)
#define A3W_STORE_PREVIEW_X(WIDTH) (A3W_STORE_PREVIEW_LEFT max (A3W_STORE_DIALOG_X(WIDTH) + WIDTH + A3W_STORE_PREVIEW_GAP))

class A3W_StoreTitle: w_RscTextCenter
{
	onLoad = "if ((missionNamespace getVariable ['A3W_dynamicStoreNextRefresh', -1]) > 0) then { private _title = _this select 0; _title ctrlSetText format [localize 'STR_WL_Store_RotationTitle', ctrlText _title]; _title ctrlSetFontHeight (0.7 * ctrlFontHeight _title) }";
};

class A3W_StorePreviewBackground: RscText
{
	idc = A3W_STORE_PREVIEW_BACKGROUND;
	colorBackground[] = {0, 0, 0, 0.65};
	x = A3W_STORE_PREVIEW_LEFT;
	y = safezoneY + 0.62 * safezoneH;
	w = A3W_STORE_PREVIEW_RIGHT - A3W_STORE_PREVIEW_LEFT;
	h = 0.25 * safezoneH;
	onLoad = "(_this select 0) ctrlShow false";
};

class A3W_StorePreviewPicture: RscPicture
{
	idc = A3W_STORE_PREVIEW_PICTURE;
	style = ST_PICTURE + 0x800; // Keep aspect ratio.
	onLoad = "(_this select 0) ctrlShow false";
};

class A3W_StorePreviewModel
{
	idc = A3W_STORE_PREVIEW_MODEL;
	type = CT_OBJECT_CONTAINER;
	model = "\A3\ui_f\objects\Compass.p3d";
	scale = 0;
	direction[] = {0.7071, 0, 0.7071};
	up[] = {0, 1, 0};
	x = 0.5;
	y = 0.5;
	z = 1;
	inBack = 0;
	enableZoom = 0;
	zoomDuration = 0;
	onLoad = "(_this select 0) ctrlEnable false; (_this select 0) ctrlShow false";
};
