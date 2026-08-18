//Init for Airdrop Assistance
//Author: Apoc
//
#include "config.sqf"

if (isServer) then {
APOC_srv_startAirdrop 	= compile preprocessFileLineNumbers "addons\APOC_Airdrop_Assistance\APOC_srv_startAirdrop.sqf";
APOC_srv_startAirdrop_disable_wind 	= compile preprocessFileLineNumbers "addons\APOC_Airdrop_Assistance\APOC_srv_startAirdrop_disable_wind.sqf";  
};



