/**
 * S�lectionne un objet � charger dans un transporteur
 * 
 * @param 0 l'objet � s�lectionner
 */

if (R3F_LOG_mutex_local_verrou) then
{
	hintC STR_R3F_LOG_mutex_action_en_cours;
}
else
{
	R3F_LOG_mutex_local_verrou = true;
	
	R3F_LOG_objet_selectionne = _this select 0;


	//base_flag addon
	private _isBusy = false;

	{
		if (isPlayer _x && alive _x && _x distance R3F_LOG_objet_selectionne < 100) then
			{
				if (_x getVariable "mutex_net_obj" isEqualTo netId R3F_LOG_objet_selectionne) exitWith
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


	systemChat format [STR_R3F_LOG_action_selectionner_objet_fait, getText (configFile >> "CfgVehicles" >> (typeOf R3F_LOG_objet_selectionne) >> "displayName")];
	
	[R3F_LOG_objet_selectionne, player] call R3F_LOG_FNCT_definir_proprietaire_verrou;
	
	// D�selectionner l'objet si le joueur n'en fait rien
	[] spawn
	{
		while {!isNull R3F_LOG_objet_selectionne} do
		{
			if (!alive player || player call A3W_fnc_isUnconscious) then
			{
				R3F_LOG_objet_selectionne = objNull;
			}
			else
			{
				if (vehicle player != player || (player distance R3F_LOG_objet_selectionne > 40) || !isNull R3F_LOG_joueur_deplace_objet) then
				{
					R3F_LOG_objet_selectionne = objNull;
				};
			};
			
			sleep 0.2;
		};
	};
	
	R3F_LOG_mutex_local_verrou = false;
};