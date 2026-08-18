/**
 * Remorque l'objet point� au v�hicule remorqueur valide le plus proche
 * 
 * @param 0 l'objet � remorquer
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
	
	private ["_objet", "_remorqueur", "_offset_attach_y"];
	
	_objet = _this select 0;
	
	// Recherche du remorqueur valide le plus proche
	_remorqueur = objNull;

	if (unitIsUAV _objet && {!(_objet getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) && !(group (uavControl _objet select 0) in [grpNull, group player])}) exitWith
	{
			R3F_LOG_mutex_local_verrou = false;
			player globalChat STR_R3F_LOG_action_selectionner_objet_remorque_UAV_group;
	};




	{
		if (
			_x != _objet && (_x getVariable ["R3F_LOG_fonctionnalites", R3F_LOG_CST_zero_log] select R3F_LOG_IDX_can_tow) &&
			alive _x && isNull (_x getVariable "R3F_LOG_est_transporte_par") &&
			isNull (_x getVariable "R3F_LOG_remorque") && (vectorMagnitude velocity _x < 6) &&
			!([_x, player] call R3F_LOG_FNCT_objet_est_verrouille) && VEHICLE_UNLOCKED(_x) && !(_x getVariable "R3F_LOG_disabled") &&
			{

				private ["_delta_pos"];
				
				_delta_pos =
				(
					_objet modelToWorld
					[
						boundingCenter _objet select 0,
						boundingBoxReal _objet select 1 select 1,
						boundingBoxReal _objet select 0 select 2
					]
				) vectorDiff (
					_x modelToWorld
					[
						boundingCenter _x select 0,
						boundingBoxReal _x select 0 select 1,
						boundingBoxReal _x select 0 select 2
					]
				);
				
				// L'arri�re du remorqueur est proche de l'avant de l'objet point�
				abs (_delta_pos select 0) < 3 && abs (_delta_pos select 1) < 5
			}
		) exitWith {_remorqueur = _x;};
	} forEach (nearestObjects [_objet, ["All"], 30]);
	
	if (!isNull _remorqueur) then
	{
		if (isNull (_objet getVariable "R3F_LOG_est_transporte_par") && (isNull (_objet getVariable "R3F_LOG_est_deplace_par") || (!alive (_objet getVariable "R3F_LOG_est_deplace_par")) || (!isPlayer (_objet getVariable "R3F_LOG_est_deplace_par")))) then
		{


			//base_flag addon
			private _isBusy = false;

			{
				if (isPlayer _x && alive _x && _x distance _objet < 100) then
				{
					if (_x getVariable "mutex_net_obj" isEqualTo netId _objet) exitWith
					{
						_isBusy = true;
					};
				};
			} forEach playableUnits;

			if(_isBusy) exitWith {
				R3F_LOG_mutex_local_verrou = false;
				playSound "FD_CP_Not_Clear_F";
				["Object is busy!", 5] call mf_notify_client;
			};

			//


			[_remorqueur, player] call R3F_LOG_FNCT_definir_proprietaire_verrou;
			
			_remorqueur setVariable ["R3F_LOG_remorque", _objet, true];

			_objet setVariable ["R3F_LOG_est_transporte_par", _remorqueur, true];

			
			// On place le joueur sur le c�t� du v�hicule en fonction qu'il se trouve � sa gauche ou droite
			if ((_remorqueur worldToModel (player modelToWorld [0,0,0])) select 0 > 0) then
			{
				player attachTo [_remorqueur, [
					(boundingBoxReal _remorqueur select 1 select 0) + 0.5,
					(boundingBoxReal _remorqueur select 0 select 1),
					(boundingBoxReal _remorqueur select 0 select 2) - (boundingBoxReal player select 0 select 2)
				]];
				
				player setDir 270;
			}
			else
			{
				player attachTo [_remorqueur, [
					(boundingBoxReal _remorqueur select 0 select 0) - 0.5,
					(boundingBoxReal _remorqueur select 0 select 1),
					(boundingBoxReal _remorqueur select 0 select 2) - (boundingBoxReal player select 0 select 2)
				]];
				
				player setDir 90;
			};
			
			player playMove format ["AinvPknlMstpSlay%1Dnon_medic", switch (currentWeapon player) do
			{
				case "": {"Wnon"};
				case primaryWeapon player: {"Wrfl"};
				case secondaryWeapon player: {"Wlnr"};
				case handgunWeapon player: {"Wpst"};
				default {"Wrfl"};
			}];
			sleep 2;



			_isBusy = false;
			{
				if (isPlayer _x && alive _x && _x distance _objet < 100) then
				{
					if (_x getVariable "mutex_net_obj" isEqualTo netId _objet) exitWith
					{
						_isBusy = true;
					};
				};
			} forEach playableUnits;

			if(_isBusy) exitWith {
				R3F_LOG_mutex_local_verrou = false;
				playSound "FD_CP_Not_Clear_F";
				["Object is busy!", 5] call mf_notify_client;
			};
			
			// Quelques corrections visuelles pour des classes sp�cifiques
			if (typeOf _remorqueur == "B_Truck_01_mover_F") then {_offset_attach_y = 1.0;}
			else {_offset_attach_y = 0.2;};
			
			// Attacher � l'arri�re du v�hicule au ras du sol
			_objet attachTo [_remorqueur, [
				(boundingCenter _objet select 0),
				(boundingBoxReal _remorqueur select 0 select 1) + (boundingBoxReal _objet select 0 select 1) + _offset_attach_y,
				(boundingBoxReal _remorqueur select 0 select 2) - (boundingBoxReal _objet select 0 select 2)
			]];
			
			R3F_LOG_objet_selectionne = objNull;

			
			//["disableDriving", _objet] call A3W_fnc_towingHelper;
			
			detach player;
			
			// Si l'objet est une arme statique, on corrige l'orientation en fonction de la direction du canon
			if (_objet isKindOf "StaticWeapon") then
			{
				private ["_azimut_canon"];
				
				_azimut_canon = ((_objet weaponDirection (weapons _objet select 0)) select 0) atan2 ((_objet weaponDirection (weapons _objet select 0)) select 1);
				
				// Seul le D30 a le canon pointant vers le v�hicule
				if !(_objet isKindOf "D30_Base") then // All in Arma
				{
					_azimut_canon = _azimut_canon + 180;
				};
				
				[_objet, "setDir", (getDir _objet)-_azimut_canon] call R3F_LOG_FNCT_exec_commande_MP;
			};
			
			sleep 7;
		}
		else
		{
			hintC format [STR_R3F_LOG_objet_en_cours_transport, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
		};
	};
	
	R3F_LOG_mutex_local_verrou = false;
};