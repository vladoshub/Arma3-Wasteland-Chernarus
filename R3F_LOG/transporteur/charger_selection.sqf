/**
 * Charger l'objet s�lectionn� (R3F_LOG_objet_selectionne) dans un transporteur
 * 
 * @param 0 le transporteur
 * 
 * Copyright (C) 2014 Team ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#define VEHICLE_UNLOCKED(VEH) (locked (VEH) < 2 || (VEH) getVariable ["ownerUID","0"] isEqualTo getPlayerUID player)


if (R3F_LOG_mutex_local_verrou) then
{
	hintC STR_R3F_LOG_mutex_action_en_cours;
}
else
{
	R3F_LOG_mutex_local_verrou = true;
	
	private ["_objet", "_transporteur"];
	
	_objet = R3F_LOG_objet_selectionne;
	_transporteur = _this select 0;
	
	if (!(isNull _objet) && VEHICLE_UNLOCKED(_objet) && !(_objet getVariable "R3F_LOG_disabled") && ({(isPlayer _x && alive _x && _x distance _objet < 100 && _x getVariable "mutex_net_obj" isEqualTo netId _objet)} count (playableUnits) < 1) && !(_objet getVariable ["objectLocked", false])) then
	{
		if (isNull (_objet getVariable "R3F_LOG_est_transporte_par") && (isNull (_objet getVariable "R3F_LOG_est_deplace_par") || (!alive (_objet getVariable "R3F_LOG_est_deplace_par")) || (!isPlayer (_objet getVariable "R3F_LOG_est_deplace_par")))) then
		{
			if (isNull (_objet getVariable ["R3F_LOG_remorque", objNull])) then
			{
				if (count crew _objet == 0 || getNumber (configFile >> "CfgVehicles" >> (typeOf _objet) >> "isUav") == 1) then
				{
					private ["_objets_charges", "_chargement", "_cout_chargement_objet"];
					
					_chargement = [_transporteur] call R3F_LOG_FNCT_calculer_chargement_vehicule;
					_cout_chargement_objet = _objet getVariable "R3F_LOG_fonctionnalites" select R3F_LOG_IDX_can_be_transported_cargo_cout;
					
					// Si l'objet loge dans le v�hicule
					if ((_chargement select 0) + _cout_chargement_objet <= (_chargement select 1)) then
					{
						if (_objet distance _transporteur <= 30) then
						{
							[_transporteur, player] call R3F_LOG_FNCT_definir_proprietaire_verrou;
							
							// On m�morise sur le r�seau le nouveau contenu du v�hicule
							_objets_charges = _transporteur getVariable ["R3F_LOG_objets_charges", []];
							_objets_charges = _objets_charges + [_objet];
							_transporteur setVariable ["R3F_LOG_objets_charges", _objets_charges, true];
							
							_objet setVariable ["R3F_LOG_est_transporte_par", _transporteur, true];
							
							systemChat STR_R3F_LOG_action_charger_en_cours;
							
							sleep 2;
							
							// Gestion conflit d'acc�s
							if (_objet getVariable "R3F_LOG_est_transporte_par" == _transporteur && _objet in (_transporteur getVariable "R3F_LOG_objets_charges")) then
							{
								//BY VLADOS

								_objet attachTo [R3F_LOG_PUBVAR_point_attache, [] call R3F_LOG_FNCT_3D_tirer_position_degagee_ciel];

								if (unitIsUAV _objet) then
								{
									[_objet, 2] call A3W_fnc_setLockState;
									//["disableDriving", _objet] call A3W_fnc_towingHelper;
								};
								
								systemChat format [STR_R3F_LOG_action_charger_fait,
									getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName"),
									getText (configFile >> "CfgVehicles" >> (typeOf _transporteur) >> "displayName")];
							}
							else
							{
								_objet setVariable ["R3F_LOG_est_transporte_par", objNull, true];
								hintC format ["ERROR : " + STR_R3F_LOG_objet_en_cours_transport, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
							};
						}
						else
						{
							hintC format [STR_R3F_LOG_trop_loin, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
						};
					}
					else
					{
						hintC STR_R3F_LOG_action_charger_pas_assez_de_place;
					};
				}
				else
				{
					hintC format [STR_R3F_LOG_joueur_dans_objet, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
				};
			}
			else
			{
				hintC format [STR_R3F_LOG_objet_remorque_en_cours, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
			};
		}
		else
		{
			hintC format [STR_R3F_LOG_objet_en_cours_transport, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
		};
	};
	
	R3F_LOG_objet_selectionne = objNull;
	
	R3F_LOG_mutex_local_verrou = false;
};