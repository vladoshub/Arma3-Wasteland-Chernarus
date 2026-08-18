// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: CfgRemoteExec_fnc.hpp
//	@file Author: AgentRev

// remoteExec & BIS_fnc_MP functions whitelist (client only, server calls are not filtered)

// BIS
// class BIS_fnc_debugConsoleExec {};
class BIS_fnc_effectKilledAirDestruction {};
class BIS_fnc_effectKilledSecondaries {};
class BIS_fnc_fire {}; // railgun tank
class BIS_fnc_initVehicle {}; // required for vehicle parts like tank cages
class BIS_fnc_setCustomSoundController {}; // police siren
class BIS_fnc_objectVar {};

// do NOT whitelist BIS_fnc_execVM or BIS_fnc_spawn, it will allow exploits!

//kick by idle
class KICK_by_idle { allowedTargets = 2; }; //BY_VLADOS

class hard_vehicle_message { allowedTargets = 2; }; //BY_VLADOS

class CRAM_unit { allowedTargets = 2; };
class User_monitor { allowedTargets = 1; };
class freestylesNuclearBlastInvoke { allowedTargets = 2; }; //freestylesNuclearBlast 

class global_say_3d { allowedTargets = 2; };

class sa_scan_friendly_foe { allowedTargets = 2; }; //BY_VLADOS
class fnc_sa_local_add_to_jamm_list { allowedTargets = 2; }; //BY_VLADOS
class sa_jamm { allowedTargets = 2; }; //BY_VLADOS
class sa_1st_antenna_dummy { allowedTargets = 2; }; //BY_VLADOS
class sa_is_signal_uav { allowedTargets = 2; }; //BY_VLADOS

class fnc_sa_add_spike_signal { allowedTargets = 2; }; //BY_VLADOS
class fnc_sa_calc_terrain_fade { allowedTargets = 2; }; //BY_VLADOS
class fnc_sa_calc_signal_str { allowedTargets = 2; }; //BY_VLADOS


// A3W vanilla
class A3W_fnc_adminMenuLog { allowedTargets = 2; };
class A3W_fnc_artilleryStrike { allowedTargets = 2; };
class A3W_fnc_chatBroadcast {};
class A3W_fnc_checkHackedVehicles { allowedTargets = 2; };
class A3W_fnc_checkPlayerFlag { allowedTargets = 2; };
class A3W_fnc_copilotTakeControl {};
class A3W_fnc_deathMessage {};
class A3W_fnc_deleteEmptyGroup { allowedTargets = 2; };
class A3W_fnc_deletePlayerData { allowedTargets = 2; };
class A3W_fnc_flagHandler { allowedTargets = 2; };
class A3W_fnc_getInFast {};
class A3W_fnc_initPlayerServer { allowedTargets = 2; };
class A3W_fnc_killBroadcast { allowedTargets = 2; };
class A3W_fnc_logMemAnomaly { allowedTargets = 2; };
class A3W_fnc_playerRespawnServer { allowedTargets = 2; };
class A3W_fnc_processTransaction { allowedTargets = 2; };
class A3W_fnc_cleanupObjects { allowedTargets = 2; };
class A3W_fnc_pushVehicle {};
//class A3W_fnc_registerKillScore { allowedTargets = 2; }; // only needed for injury kill points, not currently enabled due to point farming concerns
class A3W_fnc_requestPlayerData { allowedTargets = 2; };
class A3W_fnc_requestTickTime { allowedTargets = 2; };
class A3W_fnc_savePlayerData { allowedTargets = 2; };
class A3W_fnc_serverPlayerDied { allowedTargets = 2; };
class A3W_fnc_setCMoney { allowedTargets = 2; };
class A3W_fnc_setItemCleanup { allowedTargets = 2; };
class A3W_fnc_setLockState {};
class A3W_fnc_setName { jip = 1; };
class A3W_fnc_takeOwnership { allowedTargets = 2; };
class A3W_fnc_takeArtilleryStrike { allowedTargets = 2; };
class A3W_fnc_setVarServer { allowedTargets = 2; };
class A3W_fnc_titleTextMessage {};
class A3W_fnc_towingHelper {};
class A3W_fnc_updateSpawnTimestamp { allowedTargets = 2; };
class FAR_fnc_headshotHitPartEH {};
class FAR_fnc_public_EH {};
class mf_remote_refuel {};
class mf_remote_repair {};
class mf_remote_syphon {};

// Third-party
class A3W_fnc_addMagazineTurret {};
class A3W_fnc_addMagazineTurretBaheli {};
class A3W_fnc_addMagazineTurretBcas {};
class A3W_fnc_addMagazineTurretHorca {};
class A3W_fnc_addMagazineTurretIcas {};
class A3W_fnc_addMagazineTurretLheli {};
class A3W_fnc_addMagazineTurretMortar {};
class A3W_fnc_addMagazineTurretOaheli {};
class A3W_fnc_addMagazineTurretOcas {};
class A3W_fnc_addMagazineTurretUav2 {};
class A3W_fnc_hideObjectGlobal {};
class A3W_fnc_lock {};
class A3W_fnc_removeMagazinesTurret {};
class A3W_fnc_setVectorUpAndDir { jip = 1; };
class A3W_fnc_setVehicleAmmoDef {};
class A3W_fnc_unflip {};
class APOC_srv_startAirdrop { allowedTargets = 2; };
class APOC_srv_startAirdrop_disable_wind { allowedTargets = 2; };
class JTS_FNC_SENT {};
class saky_fnc_irToIncendiary { jip = 1; };
class A3W_fnc_flashBang { allowedTargets = 1; };
class A3W_fnc_pulloutVeh { allowedTargets = 0; };
//base_flag addon
class Base_flag_srv_activate { allowedTargets = 2; };
class Base_flag_srv_disable { allowedTargets = 2; };
class Base_flag_srv_enable_respawn { allowedTargets = 2; };
class Base_flag_srv_enable_security { allowedTargets = 2; };
class Base_flag_srv_activate_one { allowedTargets = 2; };
class Base_flag_srv_disable_one { allowedTargets = 2; };
class Base_flag_srv_pay_build { allowedTargets = 2; };
class Base_flag_srv_killed { allowedTargets = 2; };
class Create_Vehicle_R3F_LOG { allowedTargets = 2; };


class A3W_fnc_spawn_ai { allowedTargets = 2; };
