/**
 * Initialise un objet d�pla�able/h�liportable/remorquable/transportable
 * 
 * @param 0 l'objet
 * 
 * Copyright (C) 2014 Team ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

private ["_objet", "_config", "_nom", "_fonctionnalites"];

_objet = _this select 0;

_doLock = 0;
_doUnlock = 1;

_config = configFile >> "CfgVehicles" >> (typeOf _objet);
_nom = getText (_config >> "displayName");

// D�finition locale de la variable si elle n'est pas d�finie sur le r�seau
if (isNil {_objet getVariable "R3F_LOG_est_transporte_par"}) then
{
	_objet setVariable ["R3F_LOG_est_transporte_par", objNull, false];
};

// D�finition locale de la variable si elle n'est pas d�finie sur le r�seau
if (isNil {_objet getVariable "R3F_LOG_est_deplace_par"}) then
{
	_objet setVariable ["R3F_LOG_est_deplace_par", objNull, false];
};

// D�finition locale de la variable si elle n'est pas d�finie sur le r�seau
if (isNil {_objet getVariable "R3F_LOG_proprietaire_verrou"}) then
{
	// En mode de lock side : uniquement si l'objet appartient initialement � une side militaire
	if (R3F_LOG_CFG_lock_objects_mode == "side") then
	{
		switch (getNumber (_config >> "side")) do
		{
			case 0: {_objet setVariable ["R3F_LOG_proprietaire_verrou", east, false];};
			case 1: {_objet setVariable ["R3F_LOG_proprietaire_verrou", west, false];};
			case 2: {_objet setVariable ["R3F_LOG_proprietaire_verrou", independent, false];};
		};
	}
	else
	{
		// En mode de lock faction : uniquement si l'objet appartient initialement � une side militaire
		if (R3F_LOG_CFG_lock_objects_mode == "faction") then
		{
			switch (getNumber (_config >> "side")) do
			{
				case 0; case 1; case 2:
				{_objet setVariable ["R3F_LOG_proprietaire_verrou", getText (_config >> "faction"), false];};
			};
		};
	};
};

// Si on peut embarquer dans l'objet
if (isNumber (_config >> "preciseGetInOut")) then
{
	// Ne pas monter dans un v�hicule qui est en cours de transport
	_objet addEventHandler ["GetIn", R3F_LOG_FNCT_EH_GetIn];
};

// Indices du tableau des fonctionnalit�s retourn� par R3F_LOG_FNCT_determiner_fonctionnalites_logistique
#define __can_be_depl_heli_remorq_transp 0
#define __can_be_moved_by_player 1
#define __can_lift 2
#define __can_be_lifted 3
#define __can_tow 4
#define __can_be_towed 5
#define __can_transport_cargo 6
#define __can_transport_cargo_cout 7
#define __can_be_transported_cargo 8
#define __can_be_transported_cargo_cout 9

_fonctionnalites = _objet getVariable "R3F_LOG_fonctionnalites";

if (R3F_LOG_CFG_unlock_objects_timer != -1) then
{
	_objet addAction [("<t color=""#ee0000"">" + format [STR_R3F_LOG_action_deverrouiller, _nom] + "</t>"), {_this call R3F_LOG_FNCT_deverrouiller_objet}, false, 11, false, true, "", "!R3F_LOG_mutex_local_verrou && ( ({ unitIsUAV _x } count (crew _target)) == (count crew _target) ) && R3F_LOG_objet_addAction == _target && R3F_LOG_action_deverrouiller_valide && !(_target getVariable ['secure_by_flag', false])"];
}
else
{
	_objet addAction [("<t color=""#ee0000"">" + STR_R3F_LOG_action_deverrouiller_impossible + "</t>"), {hintC STR_R3F_LOG_action_deverrouiller_impossible;}, false, 11, false, true, "", "!R3F_LOG_mutex_local_verrou && ( ({ unitIsUAV _x } count (crew _target)) == (count crew _target) ) && R3F_LOG_objet_addAction == _target && R3F_LOG_action_deverrouiller_valide && !(_target getVariable ['secure_by_flag', false])"];
};


if (_fonctionnalites select __can_be_moved_by_player && !(_objet isKindOf "Land_Money_F")) then
{
	_objet addAction [("<t color=""#00eeff"">" + format [STR_R3F_LOG_action_deplacer_objet, _nom] + "</t>"), {_this call R3F_LOG_FNCT_objet_deplacer_with_check}, false, 5, false, true, "", "!R3F_LOG_mutex_local_verrou && ( ({ unitIsUAV _x } count (crew _target)) == (count crew _target) ) && R3F_LOG_objet_addAction == _target && R3F_LOG_action_deplacer_objet_valide && !(_target getVariable ['objectLocked', false]) && !(_target getVariable ['secure_by_flag', false]) && R3F_LOG_action_deplacer_objet_valide_enemy && R3F_LOG_action_deplacer_objet_valide_not_busy"];
	_objet addAction [("<img image='client\icons\r3f_lock.paa' color='#ff0000'/> <t color='#ff0000'>" + "Lock Object" + "</t>"),"R3F_LOG\lock\objectLockStateMachine.sqf", _doLock, -5, false, true, "", "R3F_LOG_objet_addAction == _target && R3F_LOG_action_deplacer_objet_valide && Object_canLock && (!(_target isKindOf 'AllVehicles') || {_target isKindOf 'StaticWeapon'}) && !(_target getVariable ['secure_by_flag', false])"];
	_objet addAction [("<img image='client\icons\r3f_unlock.paa' color='#06ef00'/> <t color='#06ef00'>" + "Unlock Object" + "</t>"), "R3F_LOG\lock\objectLockStateMachine.sqf", _doUnlock, -5, false, true, "", "R3F_LOG_objet_addAction == _target && R3F_LOG_action_deplacer_objet_valide && !Object_canLock"];
	
	//attach 
	//(sizeOf (typeOf _transporter) * 0.75) >= sizeOf (typeOf _objet)
	//_objet addAction [("<t color=""#00dd00"">" + format [STR_R3F_LOG_action_attach, _nom] + "</t>"), {_this call R3F_LOG_FNCT_remorqueur_attach_direct}, nil, 5, false, true, "", "!R3F_LOG_mutex_local_verrou && !(_target isKindOf 'Plane' || _target isKindOf 'Helicopter' || _target isKindOf 'Tank' || _target isKindOf 'Boat' || _target isKindOf 'Ship') && ( ({ unitIsUAV _x } count (crew _target)) == (count crew _target) ) && R3F_LOG_objet_addAction == _target && R3F_LOG_action_remorquer_direct_valide && Object_canLock && !(_target getVariable ['secure_by_flag', false]) && R3F_LOG_action_deplacer_objet_valide_not_busy"];
};


if (_fonctionnalites select __can_be_towed) then
{
	if (_fonctionnalites select __can_be_moved_by_player) then
	{
		_objet addAction [("<t color=""#00dd00"">" + STR_R3F_LOG_action_remorquer_deplace + "</t>"), {_this call R3F_LOG_FNCT_remorqueur_remorquer_deplace}, nil, 6, true, true, "", "!R3F_LOG_mutex_local_verrou && ( ({ unitIsUAV _x } count (crew _target)) == (count crew _target) ) && R3F_LOG_objet_addAction == _target && R3F_LOG_joueur_deplace_objet == _target && R3F_LOG_action_remorquer_deplace_valide && Object_canLock && !(_target getVariable ['secure_by_flag', false]) && R3F_LOG_action_deplacer_objet_valide_not_busy"];
	};
	
	_objet addAction [("<t color=""#00dd00"">" + format [STR_R3F_LOG_action_remorquer_direct, _nom] + "</t>"), {_this call R3F_LOG_FNCT_remorqueur_remorquer_direct}, nil, 5, false, true, "", "!R3F_LOG_mutex_local_verrou && ( ({ unitIsUAV _x } count (crew _target)) == (count crew _target) ) && R3F_LOG_objet_addAction == _target && R3F_LOG_action_remorquer_direct_valide && Object_canLock && !(_target getVariable ['secure_by_flag', false]) && R3F_LOG_action_deplacer_objet_valide_not_busy"];
		
	_objet addAction [("<t color=""#00dd00"">" + STR_R3F_LOG_action_detacher + "</t>"), {_this call R3F_LOG_FNCT_remorqueur_detacher}, nil, 6, true, true, "", "!R3F_LOG_mutex_local_verrou && ( ({ unitIsUAV _x } count (crew _target)) == (count crew _target) ) && R3F_LOG_objet_addAction == _target && R3F_LOG_action_detacher_valide && Object_canLock && !(_target getVariable ['secure_by_flag', false]) && R3F_LOG_action_deplacer_objet_valide_enemy"];
};

if (_fonctionnalites select __can_be_transported_cargo && !(_objet isKindOf "Land_Money_F")) then
{
	if (_fonctionnalites select __can_be_moved_by_player) then
	{
		_objet addAction [("<t color=""#dddd00"">" + STR_R3F_LOG_action_charger_deplace + "</t>"), {_this call R3F_LOG_FNCT_transporteur_charger_deplace}, nil, 8, true, true, "", "!R3F_LOG_mutex_local_verrou && ( ({ unitIsUAV _x } count (crew _target)) == (count crew _target) ) && R3F_LOG_objet_addAction == _target && R3F_LOG_joueur_deplace_objet == _target && R3F_LOG_action_charger_deplace_valide && Object_canLock && !(_target getVariable ['secure_by_flag', false]) && R3F_LOG_action_deplacer_objet_valide_not_busy"];
	};
	
	_objet addAction [("<t color=""#dddd00"">" + format [STR_R3F_LOG_action_selectionner_objet_charge, _nom] + "</t>"), {_this call R3F_LOG_FNCT_transporteur_selectionner_objet}, nil, 5, false, true, "", "!R3F_LOG_mutex_local_verrou && ( ({ unitIsUAV _x } count (crew _target)) == (count crew _target) ) && R3F_LOG_objet_addAction == _target && R3F_LOG_action_selectionner_objet_charge_valide && Object_canLock && !(_target getVariable ['secure_by_flag', false]) && R3F_LOG_action_deplacer_objet_valide_not_busy"];
};

if (_fonctionnalites select __can_be_moved_by_player) then
{
	//_objet addAction [("<t color=""#ff9600"">" + STR_R3F_LOG_action_revendre_usine_deplace + "</t>"), {_this call R3F_LOG_FNCT_usine_revendre_deplace}, nil, 7, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_revendre_usine_deplace_valide && !(_target getVariable ['non_unlock_mode', false])"];
};


//BY VLADOS
if (_objet isKindOf "B_AAA_System_01_F") then //CRAM2
{
	_objet addAction [("Activate Def mode CRAM"), "addons\cram\initClient.sqf", nil, 6, false, true, "", "!(_target getVariable ['cramInit', false]) && (R3F_LOG_action_deplacer_objet_valide) && alive _target"];
	_objet addAction [("Disable Def mode CRAM"), "addons\cram\disableCram.sqf", nil, 6, false, true, "", "(_target getVariable ['cramInit', false]) && (R3F_LOG_action_deplacer_objet_valide) && alive _target"];
};


//BY VLADOS
if (_objet isKindOf "B_UAV_06_F" || _objet isKindOf "O_UAV_06_F" || _objet isKindOf "I_UAV_06_F" || _objet isKindOf "B_UAV_01_F" || _objet isKindOf "I_UAV_01_F" || _objet isKindOf "O_UAV_01_F") then //FPV
{
	_objet addAction [("Assemble kamikaze drone"), "addons\fpv\client\assembly.sqf", nil, 6, false, true, "", "_target getVariable ['fpvInit', '1'] == '1' && (R3F_LOG_action_deplacer_objet_valide) && !(_target getVariable ['objectLocked', false]) && alive _target"];
	_objet addAction [("Drop explosive"), "addons\fpv\client\unpin.sqf", nil, 6, false, true, "", "_target getVariable ['fpvInit', '0'] == '2' && (R3F_LOG_action_deplacer_objet_valide) && !(_target getVariable ['objectLocked', false])"];
	_objet addAction [("Explode"), "addons\fpv\client\explode.sqf", nil, 6, false, true, "", "_target getVariable ['fpvInit', '0'] == '2' && alive _target && (_target getVariable ['fpvInitOwnerUid', '']) == getPlayerUID player"];
}; 

if (_objet isKindOf "Land_SCF_01_shredder_F") then //Factory
{
	_objet addAction [("Activate Factory"), "R3F_LOG\usine_creation\invoke.sqf", nil, 6, false, true, "", "(R3F_LOG_action_deplacer_objet_valide) && alive _target && (_target getVariable ['R3F_LOG_CF_disabled', true])"];
	_objet addAction [("Use card for payment"), "R3F_LOG\usine_creation\set_bmoney.sqf", nil, 6, false, true, "", "(R3F_LOG_action_deplacer_objet_valide) && alive _target && !(_target getVariable ['R3F_LOG_CF_disabled', true]) && (player getVariable ['playerPayType', 'bmoney']) == 'cmoney'"];
	_objet addAction [("Use cash for payment"), "R3F_LOG\usine_creation\set_cmoney.sqf", nil, 6, false, true, "", "(R3F_LOG_action_deplacer_objet_valide) && alive _target && !(_target getVariable ['R3F_LOG_CF_disabled', true]) && (player getVariable ['playerPayType', 'bmoney']) == 'bmoney'"];
}; 



if (_objet isKindOf "Land_i_Garage_V1_F") then //Mobile Parking
{
	_objet addAction [("Enable parking"), "addons\parking\enable_parking.sqf", nil, 6, false, true, "", "(R3F_LOG_action_deplacer_objet_valide) && alive _target && !(_target getVariable ['is_parking', false])"];
	_objet addAction [("Disable parking"), "addons\parking\disable_parking.sqf", nil, 6, false, true, "", "(R3F_LOG_action_deplacer_objet_valide) && alive _target && (_target getVariable ['is_parking', false])"];
}; 

//base_flag addon
if (_objet isKindOf "FlagChecked_F") then //Base flag
{
	_objet addAction [("Activate (protecting buildings 300m). Required pay 300000 for guard base every 9 days. IT IS RECOMMENDED TO POSITION THE FLAG SO THAT IT DOES NOT TOUCH THE SURFACE!"), "addons\base_flag\client\activate.sqf", nil, 6, false, true, "", "R3F_LOG_action_deplacer_objet_valide && alive _target && !(_target getVariable ['is_base_flag_activate', false])"];
	_objet addAction [("Check this place for flag placement"), "addons\base_flag\client\activateCheck.sqf", nil, 6, false, true, "", "R3F_LOG_action_deplacer_objet_valide && alive _target && !(_target getVariable ['is_base_flag_activate', false])"];
	_objet addAction [("Activate spawn"), "addons\base_flag\client\activateSpawn.sqf", nil, 6, false, true, "", "R3F_LOG_action_deplacer_objet_valide && alive _target && (_target getVariable ['is_base_flag_activate', false]) && !(_target getVariable ['flag_respawn', false])"];
	_objet addAction [("Disable spawn"), "addons\base_flag\client\disableSpawn.sqf", nil, 6, false, true, "", "R3F_LOG_action_deplacer_objet_valide && alive _target && (_target getVariable ['is_base_flag_activate', false]) && (_target getVariable ['flag_respawn', false])"];
	_objet addAction [("Pay 300000 for guard base (exp: " + str((_objet getVariable "payBuild") select 0) + "-" + str((_objet getVariable "payBuild") select 1) + "-" + str((_objet getVariable "payBuild") select 2) + ") required every 9 days"), "addons\base_flag\client\pay_build.sqf", nil, 6, false, true, "", "R3F_LOG_action_deplacer_objet_valide && alive _target && (_target getVariable ['is_base_flag_activate', false]) && (count (_target getVariable ['payBuild', []]) != 0) && !(_target getVariable ['isUpdatePayBuild', false])"];
}; 


//codeLock
if (_objet isKindOf "Land_ConcreteWall_01_l_gate_F") then //codeLock
{
	_objet addAction [("Open keypad panel"), "addons\CodeLock\client\openDialog.sqf", nil, 6, false, true, "", "alive _target"];
}; 
