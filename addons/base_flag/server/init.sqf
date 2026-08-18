if (isServer) then {
Base_flag_srv_activate = compile preprocessFileLineNumbers "addons\base_flag\server\activate.sqf";
Base_flag_srv_disable = compile preprocessFileLineNumbers "addons\base_flag\server\disable.sqf";
Base_flag_srv_enable_respawn = compile preprocessFileLineNumbers "addons\base_flag\server\enable_respawn.sqf";
Base_flag_srv_enable_security = compile preprocessFileLineNumbers "addons\base_flag\server\enable_security.sqf";
Base_flag_srv_activate_one = compile preprocessFileLineNumbers "addons\base_flag\server\activate_one.sqf";
Base_flag_srv_disable_one = compile preprocessFileLineNumbers "addons\base_flag\server\disable_one.sqf";
Base_flag_srv_pay_build = compile preprocessFileLineNumbers "addons\base_flag\server\pay_build.sqf";
Base_flag_srv_killed = compile preprocessFileLineNumbers "addons\base_flag\server\killEnemy.sqf";
};


