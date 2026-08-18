while {true} do {
	

sleep 0.1;
if !(player == vehicle player) then {
if ((!(isNull ((vehicle player) getVariable "R3F_LOG_est_deplace_par")) && (alive ((vehicle player) getVariable "R3F_LOG_est_deplace_par")) && (isPlayer ((vehicle player) getVariable "R3F_LOG_est_deplace_par"))) || !(isNull ((vehicle player) getVariable "R3F_LOG_est_transporte_par"))) then
	{
		(player) action ["GetOut", (vehicle player)];
		(player) action ["Eject", (vehicle player)];
};
};
/*
if(count (attachedObjects player) > 0) then {



	{
		if( !(isNull ((vehicle player) getVariable "R3F_LOG_est_deplace_par")) ) exitWith {
			_this call R3F_LOG_FNCT_objet_relacher;
		}
		
	} forEach (attachedObjects player);

};
*/
};