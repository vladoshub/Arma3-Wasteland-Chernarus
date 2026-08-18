/**
 * MAIN CONFIGURATION FILE
 * 
 * English and French comments
 * Commentaires anglais et fran�ais
 * 
 * (EN)
 * This file contains the configuration variables of the logistics system.
 * For the configuration of the creation factory, see the file "config_creation_factory.sqf".
 * IMPORTANT NOTE : when a logistics feature is given to an object/vehicle class name, all the classes which inherit
 *                  of the parent/generic class (according to the CfgVehicles) will also have this feature.
 *                  CfgVehicles tree view example : http://madbull.arma.free.fr/A3_stable_1.20.124746_CfgVehicles_tree.html
 * 
 * (FR)
 * Fichier contenant les variables de configuration du syst�me de logistique.
 * Pour la configuration de l'usine de cr�ation, voir le fichier "config_creation_factory.sqf".
 * NOTE IMPORTANTE : lorsqu'une fonctionnalit� logistique est accord�e � un nom de classe d'objet/v�hicule, les classes
 *                   h�ritant de cette classe m�re/g�n�rique (selon le CfgVehicles) se verront �galement dot�es de cette fonctionnalit�.
 *                   Exemple d'arborescence du CfgVehicles : http://madbull.arma.free.fr/A3_stable_1.20.124746_CfgVehicles_tree.html
 */

/**
 * DISABLE LOGISTICS ON OBJECTS BY DEFAULT
 * 
 * (EN)
 * Define if objects and vehicles have logistics features by default,
 * or if it must be allowed explicitely on specific objects/vehicles.
 * 
 * If false : all objects are enabled according to the class names listed in this configuration file
 *            You can disable some objects with : object setVariable ["R3F_LOG_disabled", true];
 * If true :  all objects are disabled by default
 *            You can enable some objects with : object setVariable ["R3F_LOG_disabled", false];
 * 
 * 
 * (FR)
 * D�fini si les objets et v�hicules disposent des fonctionnalit�s logistiques par d�faut,
 * ou si elles doivent �tre autoris�s explicitement sur des objets/v�hicules sp�cifiques.
 * 
 * Si false : tous les objets sont actifs en accord avec les noms de classes list�s dans ce fichier
 *            Vous pouvez d�sactiver certains objets avec : objet setVariable ["R3F_LOG_disabled", true];
 * Si true :  tous les objets sont inactifs par d�faut
 *            Vous pouvez activer quelques objets avec : objet setVariable ["R3F_LOG_disabled", false];
 */
R3F_LOG_CFG_disabled_by_default = false;

/**
 * LOCK THE LOGISTICS FEATURES TO SIDE, FACTION OR PLAYER
 * 
 * (EN)
 * Define the lock mode of the logistics features for an object.
 * An object can be locked to the a side, faction, a player (respawn) or a unit (life).
 * If the object is locked, the player can unlock it according to the
 * value of the config variable R3F_LOG_CFG_unlock_objects_timer.
 * 
 * If "none" : no lock features, everyone can used the logistics features.
 * If "side" : the object is locked to the last side which interacts with it.
 * If "faction" : the object is locked to the last faction which interacts with it.
 * If "player" : the object is locked to the last player which interacts with it. The lock is transmitted after respawn.
 * If "unit" : the object is locked to the last player which interacts with it. The lock is lost when the unit dies.
 * 
 * Note : for military objects (not civilian), the lock is initialized to the object's side.
 * 
 * See also the config variable R3F_LOG_CFG_unlock_objects_timer.
 * 
 * (FR)
 * D�fini le mode de verrouillage des fonctionnalit�s logistics pour un objet donn�.
 * Un objet peut �tre verrouill� pour une side, une faction, un joueur (respawn) ou une unit� (vie).
 * Si l'objet est verrouill�, le joueur peut le d�verrouiller en fonction de la
 * valeur de la variable de configiration R3F_LOG_CFG_unlock_objects_timer.
 * 
 * Si "none" : pas de verrouillage, tout le monde peut utiliser les fonctionnalit�s logistiques.
 * Si "side" : l'objet est verrouill� pour la derni�re side ayant interagit avec lui.
 * Si "faction" : l'objet est verrouill� pour la derni�re faction ayant interagit avec lui.
 * Si "player" : l'objet est verrouill� pour le dernier joueur ayant interagit avec lui. Le verrou est transmis apr�s respawn.
 * Si "unit" : l'objet est verrouill� pour le dernier joueur ayant interagit avec lui. Le verrou est perdu quand l'unit� meurt.
 * 
 * Note : pour les objets militaires (non civils), le verrou est initialis� � la side de l'objet.
 * 
 * Voir aussi la variable de configiration R3F_LOG_CFG_unlock_objects_timer.
 */
R3F_LOG_CFG_lock_objects_mode = "none";

/**
 * COUNTDOWN TO UNLOCK AN OBJECT
 * 
 * Define the countdown duration (in seconds) to unlock a locked object.
 * Set to -1 to deny the unlock of objects.
 * See also the config variable R3F_LOG_CFG_lock_objects_mode.
 * 
 * D�fini la dur�e (en secondes) du compte-�-rebours pour d�verrouiller un objet.
 * Mettre � -1 pour qu'on ne puisse pas d�verrouiller les objets.
 * Voir aussi la variable de configiration R3F_LOG_CFG_lock_objects_mode.
 */
R3F_LOG_CFG_unlock_objects_timer = 30;

/**
 * ALLOW NO GRAVITY OVER GROUND
 * 
 * Define if movable objects with no gravity simulation can be set in height over the ground (no ground contact).
 * The no gravity objects corresponds to most of decoration and constructions items.
 * 
 * D�fini si les objets d�pla�able sans simulation de gravit� peuvent �tre position en hauteur sans �tre contact avec le sol.
 * Les objets sans gravit� correspondent � la plupart des objets de d�cors et de construction.
 */
R3F_LOG_CFG_no_gravity_objects_can_be_set_in_height_over_ground = true;

/**
 * LANGUAGE
 * 
 * Automatic language selection according to the game language.
 * New languages can be easily added (read below).
 * 
 * S�lection automatique de la langue en fonction de la langue du jeu.
 * De nouveaux langages peuvent facilement �tre ajout�s (voir ci-dessous).
 */
R3F_LOG_CFG_language = switch (language) do
{
	case "English":{"en"};
	case "French":{"fr"};
	
	// Feel free to create you own language file named "XX_strings_lang.sqf", where "XX" is the language code.
	// Make a copy of an existing language file (e.g. en_strings_lang.sqf) and translate it.
	// Then add a line with this syntax : case "YOUR_GAME_LANGUAGE":{"LANGUAGE_CODE"};
	// For example :
	
	//case "Czech":{"cz"}; // Not supported. Need your own "cz_strings_lang.sqf"
	//case "Polish":{"pl"}; // Not supported. Need your own "pl_strings_lang.sqf"
	//case "Portuguese":{"pt"}; // Not supported. Need your own "pt_strings_lang.sqf"
	//case "YOUR_GAME_LANGUAGE":{"LANGUAGE_CODE"};  // Need your own "LANGUAGE_CODE_strings_lang.sqf"
	
	default {"en"}; // If language is not supported, use English
};

/**
 * CONDITION TO ALLOW LOGISTICS
 * 
 * (EN)
 * This variable allow to set a dynamic SQF condition to allow/deny all logistics features only on specific clients.
 * The variable must be a STRING delimited by quotes and containing a valid SQF condition to evaluate during the game.
 * For example you can allow logistics only on few clients having a known game ID by setting the variable to :
 * "getPlayerUID player in [""76xxxxxxxxxxxxxxx"", ""76yyyyyyyyyyyyyyy"", ""76zzzzzzzzzzzzzzz""]"
 * Or based on the profile name : "profileName in [""john"", ""jack"", ""james""]"
 * Or only for the server admin : "serverCommandAvailable "#kick"""
 * The condition is evaluted in real time, so it can use condition depending on the mission progress : "alive officer && taskState task1 == ""Succeeded"""
 * Or to deny logistics in a circular area defined by a marker : "player distance getMarkerPos ""markerName"" > getMarkerSize ""markerName"" select 0"
 * Note that quotes of the strings inside the string condition must be doubled.
 * Note : if the condition depends of the aimed objects/vehicle, you can use the command cursorTarget
 * To allow the logistics to everyone, just set the condition to "true".
 * 
 * (FR)
 * Cette variable permet d'utiliser une condition SQF dynamique pour autoriser ou non les fonctions logistiques sur des clients sp�cifiques.
 * La variable doit �tre une CHAINE de caract�res d�limit�e par des guillemets et doit contenir une condition SQF valide qui sera �valu�e durant la mission.
 * Par exemple pour autoriser la logistique sur seulement quelques joueurs ayant un ID de jeu connu, la variable peut �tre d�fini comme suit :
 * "getPlayerUID player in [""76xxxxxxxxxxxxxxx"", ""76yyyyyyyyyyyyyyy"", ""76zzzzzzzzzzzzzzz""]"
 * Ou elle peut se baser sur le nom de profil : "profileName in [""maxime"", ""martin"", ""marc""]"
 * Ou pour n'autoriser que l'admin de serveur : "serverCommandAvailable "#kick"""
 * Les condition sont �valu�es en temps r�el, et peuvent donc d�pendre du d�roulement de la mission : "alive officier && taskState tache1 == ""Succeeded"""
 * Ou pour interdire la logistique dans la zone d�fini par un marqueur circulaire : "player distance getMarkerPos ""markerName"" > getMarkerSize ""markerName"" select 0"
 * Notez que les guillemets des cha�nes de caract�res dans la cha�ne de condition doivent �tre doubl�s.
 * Note : si la condition d�pend de l'objet/v�hicule point�, vous pouvez utiliser la commande cursorTarget
 * Pour autoriser la logistique chez tout le monde, il suffit de d�finir la condition � "true".
 */
R3F_LOG_CFG_string_condition_allow_logistics_on_this_client = "true";

/**
 * CONDITION TO ALLOW CREATION FACTORY
 * 
 * (EN)
 * This variable allow to set a dynamic SQF condition to allow/deny the access to the creation factory only on specific clients.
 * The variable must be a STRING delimited by quotes and containing a valid SQF condition to evaluate during the game.
 * For example you can allow the creation factory only on few clients having a known game ID by setting the variable to :
 * "getPlayerUID player in [""76xxxxxxxxxxxxxxx"", ""76yyyyyyyyyyyyyyy"", ""76zzzzzzzzzzzzzzz""]"
 * Or based on the profile name : "profileName in [""john"", ""jack"", ""james""]"
 * Or only for the server admin : "serverCommandAvailable "#kick"""
 * Note that quotes of the strings inside the string condition must be doubled.
 * Note : if the condition depends of the aimed objects/v�hicule, you can use the command cursorTarget
 * Note also that the condition is evaluted in real time, so it can use condition depending on the mission progress :
 * "alive officer && taskState task1 == ""Succeeded"""
 * To allow the creation factory to everyone, just set the condition to "true".
 * 
 * (FR)
 * Cette variable permet d'utiliser une condition SQF dynamique pour rendre accessible ou non l'usine de cr�ation sur des clients sp�cifiques.
 * La variable doit �tre une CHAINE de caract�res d�limit�e par des guillemets et doit contenir une condition SQF valide qui sera �valu�e durant la mission.
 * Par exemple pour autoriser l'usine de cr�ation sur seulement quelques joueurs ayant un ID de jeu connu, la variable peut �tre d�fini comme suit :
 * "getPlayerUID player in [""76xxxxxxxxxxxxxxx"", ""76yyyyyyyyyyyyyyy"", ""76zzzzzzzzzzzzzzz""]"
 * Ou elle peut se baser sur le nom de profil : "profileName in [""maxime"", ""martin"", ""marc""]"
 * Ou pour n'autoriser que l'admin de serveur : "serverCommandAvailable "#kick"""
 * Notez que les guillemets des cha�nes de caract�res dans la cha�ne de condition doivent �tre doubl�s.
 * Note : si la condition d�pend de l'objet/v�hicule point�, vous pouvez utiliser la commande cursorTarget
 * Notez aussi que les condition sont �valu�es en temps r�el, et peuvent donc d�pendre du d�roulement de la mission :
 * "alive officier && taskState tache1 == ""Succeeded"""
 * Pour autoriser l'usine de cr�ation chez tout le monde, il suffit de d�finir la condition � "true".
 */
R3F_LOG_CFG_string_condition_allow_creation_factory_on_this_client = "true";

/*
 ********************************************************************************************
 * BELOW IS THE CLASS NAMES CONFIGURATION / CI-DESSOUS LA CONFIGURATION DES NOMS DE CLASSES *
 ********************************************************************************************
 * 
 * (EN)
 * There are two ways to manage new objects with the logistics system. The first one is to add these objects in the
 * following appropriate lists. The second one is to create a new external file in the /addons_config/ directory,
 * based on /addons_config/TEMPLATE.sqf, and to add a #include below to.
 * The first method is better to add/fix only some various class names.
 * The second method is better to take into account an additional addon.
 * 
 * These variables are based on the inheritance principle according to the CfgVehicles tree.
 * It means that a features accorded to a class name, is also accorded to all child classes.
 * Inheritance tree view : http://madbull.arma.free.fr/A3_1.32_CfgVehicles_tree.html
 * 
 * (FR)
 * Deux moyens existent pour g�rer de nouveaux objets avec le syst�me logistique. Le premier consiste � ajouter
 * ces objets dans les listes appropri�es ci-dessous. Le deuxi�me est de cr�er un fichier externe dans le r�pertoire
 * /addons_config/ bas� sur /addons_config/TEMPLATE.sqf, et d'ajouter un #include ci-dessous.
 * La premi�re m�thode est pr�f�rable lorsqu'il s'agit d'ajouter ou corriger quelques classes diverses.
 * La deuxi�me m�thode est pr�f�rable s'il s'agit de prendre en compte le contenu d'un addon suppl�mentaire.
 * 
 * Ces variables sont bas�es sur le principe d'h�ritage utilis�s dans l'arborescence du CfgVehicles.
 * Cela signifie qu'une fonctionnalit� accord�e � une classe, le sera aussi pour toutes ses classes filles.
 * Vue de l'arborescence d'h�ritage : http://madbull.arma.free.fr/A3_1.32_CfgVehicles_tree.html
 */

/****** LIST OF ADDONS CONFIG TO INCLUDE / LISTE DES CONFIG D'ADDONS A INCLURE ******/
#include "addons_config\A3_vanilla.sqf"
#include "addons_config\All_in_Arma.sqf"
#include "addons_config\R3F_addons.sqf"
//#include "addons_config\YOUR_ADDITIONAL_ADDON.sqf"

/****** TOW WITH VEHICLE / REMORQUER AVEC VEHICULE ******/

/**
 * List of class names of ground vehicles which can tow objects.
 * Liste des noms de classes des v�hicules terrestres pouvant remorquer des objets.
 */
R3F_LOG_CFG_can_tow = R3F_LOG_CFG_can_tow +
[
	"CUP_C_Ikarus_TKC",
	"CUP_I_Tractor_Old_SYND",
	"C_Tractor_01_F",
	"Van_01_base_F",
	"Van_02_base_F",
	"LSV_01_base_F",
	"LSV_02_base_F",
	"MRAP_01_base_F",
	"MRAP_02_base_F",
	"MRAP_03_base_F",
	"B_MRAP_01_gmg_F",
	"O_T_MRAP_02_gmg_ghex_F",
	"LT_01_base_F",
	"CUP_TT650_Base",
	"CUP_M1030_Base",
	"CUP_UAZ_Base",
	"CUP_UAZ_METIS_Base",
	"CUP_UAZ_MG_Base",
	"CUP_UAZ_Open_Base",
	"CUP_UAZ_SPG9_Base",
	"CUP_UAZ_Unarmed_Base",
	"CUP_UpHMMWV_Base",
	"CUP_Ural_Base",
	"CUP_C_Ural_Civ_02",
	"CUP_HMMWV_Unarmed_Base",
	"CUP_HMMWV_M2_Base",
	"CUP_HMMWV_MK19_Base",
	"CUP_HMMWV_TOW_Base",
	"CUP_HMMWV_M1114_Base",
	"CUP_B_HMMWV_Avenger_USMC",
	"CUP_HMMWV_Ambulance_Base",
	"CUP_HMMWV_Transport_Base",
	"CUP_HMMWV_M2_GPK_Base",
	"CUP_HMMWV_DSHKM_GPK_Base",
	"CUP_HMMWV_Terminal_Base",
	"CUP_HMMWV_AGS_GPK_Base",
	"CUP_HMMWV_SOV_Base",
	"CUP_HMMWV_SOV_M2_Base",
	"CUP_HMMWV_Crows_M2_Base",
	"CUP_HMMWV_crows_MK19_Base",
	"CUP_RG31_BASE",
	"CUP_Ridgback_Base",
	"CUP_Wolfhound_Base",
	"CUP_LR_Base",
	"Boat_Armed_01_base_F",
	"I_Truck_02_ammo_F",
	"I_Truck_02_transport_F",
	"I_Truck_02_covered_F",
	"I_Truck_02_fuel_F",
	"I_Truck_02_medical_F",
	"I_Truck_02_box_F",
	"CUP_B_Ural_ZU23_CDF",
	"CUP_B_Ural_Repair_CDF",
	"CUP_B_Ural_Refuel_CDF",
	"CUP_B_Ural_Empty_CDF",
	"CUP_B_Ural_CDF",
	"CUP_B_Ural_Reammo_CDF",
	"CUP_B_Ural_Open_CDF",
	"CUP_O_T90_RU",
	"CUP_B_T72_CDF",
	"CUP_O_BTR90_RU",
	"CUP_O_T55_CHDKZ",
	"CUP_I_T34_TK_GUE",
	"CUP_B_M1A1_DES_US_Army",
	"CUP_B_M1A2_TUSK_MG_DES_US_Army",
	"CUP_B_M7Bradley_USA_D",
	"O_MBT_04_command_F",
	"O_MBT_04_cannon_F",
	"O_MBT_02_cannon_F",
	"CUP_B_T810_Repair_CZ_DES",
	"CUP_B_T810_Armed_CZ_DES",
	"CUP_B_T810_Refuel_CZ_DES",
	"CUP_B_T810_Unarmed_CZ_WDL",
	"CUP_B_T810_Reammo_CZ_WDL",
	"CUP_B_MTVR_Repair_USA",
	"CUP_B_MTVR_Refuel_USA",
	"CUP_B_MTVR_USA",
	"CUP_B_MTVR_Ammo_USA",
	"CUP_I_V3S_Open_TKG",
	"CUP_I_V3S_Rearm_TKG",
	"CUP_I_V3S_Refuel_TKG",
	"CUP_I_V3S_Covered_TKG",
	"CUP_I_V3S_Repair_TKG",
	"CUP_C_Ural_Open_Civ_03",
	"CUP_C_Ural_Civ_03",
	"CUP_C_V3S_Covered_TKC",
	"CUP_C_V3S_Open_TKC",
	"CUP_O_GAZ_Vodnik_PK_RU",
	"CUP_O_GAZ_Vodnik_AGS_RU",
	"CUP_O_GAZ_Vodnik_BPPU_RU",
	"CUP_O_BTR60_TK",
	"CUP_B_LAV25_USMC",
	"CUP_I_BMP1_TK_GUE",
	"CUP_B_BMP2_CDF",
	"CUP_O_BMP3_RU",
	"CUP_B_BRDM2_ATGM_CDF",
	"CUP_B_BRDM2_CDF",
	"CUP_B_ZSU23_CDF",
	"CUP_O_2S6M_RU",
	"O_APC_Tracked_02_AA_F",
	"CUP_B_Challenger2_Desert_BAF",
	"C_Van_01_box_F",
	"C_Van_01_transport_F",
	"C_Van_01_fuel_F",
	"I_Truck_02_medical_F",
	"Truck_F",
	"Tank_F",
	"Tractor_01_base_F",
	"Truck_01_base_F",
	"Truck_02_base_F",
	"Truck_03_base_F",
	"Wheeled_APC_F",
	"APC_Tracked_01_base_F",
	"APC_Tracked_02_base_F",
	"APC_Tracked_03_base_F",
	"MBT_01_base_F",
	"MBT_02_base_F",
	"MBT_03_base_F",
	"MBT_04_base_F"
];

/**
 * List of class names of objects which can be towed.
 * Liste des noms de classes des objets remorquables.
 */
R3F_LOG_CFG_can_be_towed = R3F_LOG_CFG_can_be_towed +
[
	"Car_F",
	"Ship_F",
	"Plane",
	"LT_01_base_F",
	"UAV_03_base_F",
	"Heli_Light_01_base_F",
	"Heli_Light_02_base_F",
	"Heli_light_03_base_F",
	"Heli_Attack_01_base_F",
	"B_AAA_System_01_F",
	"B_SAM_System_03_F",
	"O_SAM_System_04_F",
	"B_Radar_System_01_F",
	"B_Radar_System_02_F",
	"Land_RampConcreteHigh_F",
	"Land_ConcreteRamp",
	"CUP_O_ZU23_ChDKZ",
	"Land_BagBunker_Large_F",
	"Land_PierLadder_F",
	"Land_BagBunker_Tower_F",
	"Tractor_01_base_F",
	"Wheeled_APC_F",
	"APC_Tracked_01_base_F",
	"APC_Tracked_02_base_F",
	"APC_Tracked_03_base_F",
	"MBT_01_base_F",
	"MBT_02_base_F",
	"MBT_03_base_F",
	"MBT_04_base_F",
	"Heli_Attack_02_base_F",
	"Heli_Transport_01_base_F",
	"Heli_Transport_02_base_F",
	"Heli_Transport_03_base_F",
	"Heli_Transport_04_base_F",
	"VTOL_base_F",
	"UAV_05_Base_F",
	"Plane_Fighter_01_Base_F",
	"Plane_Fighter_02_Base_F",
	"Plane_CAS_01_base_F",
	"Plane_CAS_02_base_F"
];


/****** LIFT WITH VEHICLE / HELIPORTER AVEC VEHICULE ******/

/**
 * List of class names of helicopters which can lift objects.
 * Liste des noms de classes des h�licopt�res pouvant h�liporter des objets.
 */
R3F_LOG_CFG_can_lift = R3F_LOG_CFG_can_lift +
[
	"Heli_Attack_01_base_F",
	"Heli_Attack_02_base_F",
	"VTOL_base_F",
	"CUP_O_Mi24_V_Dynamic_RU",
	"CUP_O_Mi24_P_Dynamic_RU",
	"CUP_B_Mi24_D_MEV_Dynamic_CDF",
	"CUP_O_Ka52_RU",
	"CUP_O_Ka50_DL_SLA",
	"CUP_B_Mi171Sh_ACR",
	"CUP_B_Mi171Sh_Unarmed_ACR",
	"O_Heli_Attack_02_dynamicLoadout_F",
	"CUP_B_AH64D_DL_USA",
	"CUP_B_AH64D_DL_USA",
	"CUP_B_AH64_DL_USA",
	"CUP_B_CH47F_GB",
	"CUP_B_CH47F_VIV_GB",
	"CUP_B_MH47E_GB",
	"CUP_B_Mi17_medevac_CDF",
	"CUP_O_Mi24_D_Dynamic_SLA",
	"CUP_B_AH1Z_Dynamic_USMC",
	"CUP_I_Mi24_Mk3_ION",
	"CUP_I_Mi24_Mk4_ION",
	"CUP_B_Mi35_Dynamic_CZ",
    "B_Heli_Attack_01_dynamicLoadout_F",
	"CUP_B_AH1_DL_BAF",
	"O_Heli_Transport_04_covered_F",
	"B_Heli_Transport_03_unarmed_F",
	"I_Heli_Transport_02_F"
];

/**
 * List of class names of objects which can be lifted.
 * Liste des noms de classes des objets h�liportables.
 */
R3F_LOG_CFG_can_be_lifted = R3F_LOG_CFG_can_be_lifted +
[
	"Car_F",
	"Ship_F",
	"Plane",
	"LT_01_base_F",
	"UAV_03_base_F",
	"Heli_Light_01_base_F",
	"B_AAA_System_01_F",
	"B_SAM_System_03_F",
	"O_SAM_System_04_F",
	"B_Radar_System_01_F",
	"B_Radar_System_02_F",
	"Tank_F",
	"Tractor_01_base_F",
	"Wheeled_APC_F",
	"APC_Tracked_01_base_F",
	"APC_Tracked_02_base_F",
	"APC_Tracked_03_base_F",
	"MBT_01_base_F",
	"MBT_02_base_F",
	"MBT_03_base_F",
	"MBT_04_base_F",
	"Heli_Light_02_base_F",
	"Heli_light_03_base_F",
	"Heli_Attack_01_base_F",
	"Heli_Attack_02_base_F",
	"Heli_Transport_01_base_F",
	"Heli_Transport_02_base_F",
	"Heli_Transport_03_base_F",
	"Heli_Transport_04_base_F",
	"Plane_CAS_01_base_F",
	"Plane_CAS_02_base_F",
	"Plane_Fighter_03_base_F",
	"VTOL_01_base_F",
	"VTOL_02_base_F",
	"Land_Cargo40_white_F",
	"Land_SCF_01_shredder_F",
	"Land_i_Garage_V1_F",
	"Land_Atm_01_malden_F"
];


/****** LOAD IN VEHICLE / CHARGER DANS LE VEHICULE ******/

/*
* (EN)
 * This section uses a numeric quantification of capacity and cost of the objets.
 * For example, in a vehicle has a capacity of 100, we will be able to load in 5 objects costing 20 capacity units.
 * The capacity doesn't represent a real volume or weight, but a choice made for gameplay.
 * 
 * (FR)
 * Cette section utilise une quantification num�rique de la capacit� et du co�t des objets.
 * Par exemple, dans un v�hicule d'une capacit� de 100, nous pouvons charger 5 objets co�tant 20 unit�s de capacit�.
 * La capacit� ne repr�sente ni un poids, ni un volume, mais un choix fait pour la jouabilit�.
 */

/**
 * List of class names of vehicles or cargo objects which can transport objects.
 * The second element of the nested arrays is the load capacity (in relation with the capacity cost of the objects).
 * 
 * Liste des noms de classes des v�hicules ou "objets contenant" pouvant transporter des objets.
 * Le deuxi�me �l�ment des sous-tableaux est la capacit� de chargement (en relation avec le co�t de capacit� des objets).
 */
R3F_LOG_CFG_can_transport_cargo = R3F_LOG_CFG_can_transport_cargo +
[
	["Quadbike_01_base_F", 5],
	["C_Tractor_01_F", 10],
	["CUP_I_Tractor_Old_SYND", 5],
	["C_Hatchback_01_F", 7],
	["CUP_C_Ikarus_TKC", 20],
	["C_Hatchback_01_sport_F", 1],
	["C_SUV_01_F", 15],
	["CUP_I_V3S_Covered_TKG", 50],
	["CUP_I_V3S_Open_TKG", 50],
	["CUP_I_SUV_UNO", 15],
	["CUP_C_Octavia_CIV", 5],
	["CUP_B_S1203_Ambulance_CR", 10],
	["CUP_C_Ural_Civ_02", 60],
	["CUP_C_Skoda_White_CIV", 5],
	["CUP_C_Volha_CR_CIV", 7],
	["CUP_C_Lada_White_CIV", 5],
	["CUP_C_Bus_City_CRCIV", 30],
	["CUP_C_S1203_CIV_CR", 10],
	["CUP_C_Golf4_black_Civ", 5],
	["CUP_O_LR_Transport_TKA", 10],
	["C_Offroad_01_F", 15],
	["I_G_Offroad_01_F", 15],
	["C_Offroad_02_unarmed_F", 15],
	["I_C_Offroad_02_unarmed_F", 15],
	["C_Van_01_transport_F", 15],
	["C_Van_01_box_F", 15],
	["CUP_B_UAZ_AGS30_CDF", 10],
    ["I_Truck_02_medical_F", 35],
	["CUP_B_UAZ_METIS_CDF", 10],
	["CUP_O_BTR40_TKA", 15],
	["CUP_B_Ural_CDF", 60],
	["CUP_B_Ural_ZU23_CDF", 20],
	["CUP_B_Ural_Repair_CDF", 20],
	["CUP_B_Ural_Refuel_CDF", 20],
	["B_T_LSV_01_unarmed_F", 10],
	["B_T_LSV_01_armed_F", 10],
	["O_T_LSV_02_unarmed_F", 10],
	["CUP_I_Datsun_AA_Random", 10],
	["CUP_I_Datsun_PK", 10],
	["CUP_I_Hilux_zu23_NAPA", 15],
	["CUP_I_TT650_NAPA", 7],
	["CUP_I_SUV_Armored_ION", 15],
	["CUP_I_Hilux_BMP1_NAPA", 15],
	["CUP_TT650_Base", 5],
	["CUP_M1030_Base", 5],
	["CUP_Volha_Base", 7],
	["CUP_UAZ_Base", 10],
	["CUP_UAZ_METIS_Base", 10],
	["CUP_UAZ_MG_Base", 10],
	["CUP_UAZ_Open_Base", 10],
	["CUP_UAZ_SPG9_Base", 10],
	["CUP_UAZ_Unarmed_Base", 10],
	["CUP_UpHMMWV_Base", 20],
	["CUP_Ural_Base", 20],
	["CUP_HMMWV_Unarmed_Base", 20],
	["CUP_HMMWV_M2_Base", 20],
	["CUP_HMMWV_MK19_Base", 20],
	["CUP_HMMWV_TOW_Base", 20],
	["CUP_HMMWV_M1114_Base", 20],
	["CUP_B_HMMWV_Avenger_USMC", 20],
	["CUP_HMMWV_Ambulance_Base", 20],
	["CUP_HMMWV_Transport_Base", 20],
	["CUP_HMMWV_M2_GPK_Base", 20],
	["CUP_HMMWV_DSHKM_GPK_Base", 20],
	["CUP_HMMWV_Terminal_Base", 20],
	["CUP_HMMWV_AGS_GPK_Base", 20],
	["CUP_HMMWV_SOV_Base", 20],
	["CUP_HMMWV_SOV_M2_Base", 20],
	["CUP_HMMWV_Crows_M2_Base", 20],
	["CUP_HMMWV_crows_MK19_Base", 20],
	["CUP_S1203_Base", 10],
	["CUP_S1203_Ambulance_Base", 10],
	["CUP_S1203_LM_Base", 10],
	["CUP_RG31_BASE", 20],
	["CUP_Ridgback_Base", 20],
	["CUP_Wolfhound_Base", 20],
	["CUP_LR_Base", 10],
	["UGV_01_base_F", 10],
	["Hatchback_01_base_F", 10],
	["SUV_01_base_F", 15],
	["Offroad_01_base_F", 30],
	["Offroad_02_base_F", 20],
	["Van_01_base_F", 40],
	["Van_02_base_F", 50],
	["LSV_01_base_F", 15],
	["LSV_02_base_F", 15],
	["MRAP_01_base_F", 20],
	["MRAP_02_base_F", 20],
	["MRAP_03_base_F", 20],
	["Tractor_01_base_F", 20],
	["Truck_F", 100],
	["Wheeled_APC_F", 30],
	["UGV_02_Base_F", 3],
	["LT_01_base_F", 10],
	["Tank_F", 40],
	["Scooter_Transport_01_base_F", 5],
	["SDV_01_base_F", 10],
	["Rubber_duck_base_F", 10],
	["Boat_Civil_01_base_F", 10],
	["Boat_Transport_02_base_F", 15],
	["Boat_Armed_01_base_F", 20],
	["CUP_B_MK10_GB", 50],
	["O_Boat_Armed_01_hmg_F", 35],
	["O_SDV_01_F", 35],
	["I_SDV_01_F", 35],
	["B_SDV_01_F", 35],
	["Heli_Light_01_base_F", 10],
	["Heli_Light_02_base_F", 20],
	["Heli_light_03_base_F", 20],
	["Heli_Transport_01_base_F", 25],
	["Heli_Transport_02_base_F", 30],
	["Heli_Transport_03_base_F", 30],
	["Heli_Transport_04_base_F", 30],
	["B_Heli_Attack_01_dynamicLoadout_F", 15],
	["CUP_B_AH1_DL_BAF", 10],
	["Heli_Attack_01_base_F", 10],
	["Heli_Attack_02_base_F", 20],
	["CUP_I_Ka60_GL_Blk_ION", 20],
	["CUP_I_Ka60_Blk_ION", 20],
	["CUP_O_Ka50_DL_SLA", 15],
	["CUP_O_Ka52_RU", 15],
	["CUP_I_Mi24_Mk3_ION", 25],
	["CUP_I_Mi24_Mk4_ION",25],
	["CUP_O_Mi24_V_Dynamic_RU", 25],
	["CUP_O_Mi24_D_Dynamic_SLA",25],
	["CUP_O_Mi24_P_Dynamic_RU", 25],
	["CUP_B_Mi24_D_MEV_Dynamic_CDF", 25],
	["CUP_O_UH1H_armed_SLA", 15],
	["CUP_O_UH1H_gunship_SLA", 15],
	["CUP_O_UH1H_SLA", 15],
	["O_Heli_Attack_02_dynamicLoadout_F", 35],
	["CUP_B_Mi171Sh_ACR", 35],
	["CUP_B_Mi171Sh_Unarmed_ACR", 35],
	["CUP_B_Mi35_Dynamic_CZ", 25],
	["CUP_B_MI6T_CDF", 100],
	["CUP_B_Mi17_medevac_CDF", 35],
	["CUP_B_CH47F_GB", 50],
	["CUP_B_CH47F_VIV_GB", 50],
	["CUP_B_MH47E_GB", 50],
	["CUP_B_Mi17_VIV_CDF", 35],
	["CUP_B_Mi17_CDF", 35],
	["CUP_B_MH6J_USA",10],
	["CUP_B_MH6J_OBS_USA", 10],
	["CUP_B_AH6J_USA",10],
	["CUP_B_AH6M_USA", 10],
	["CUP_B_AH64D_DL_USA", 20],
	["CUP_B_AH64_DL_USA", 20],
	["CUP_B_UH1D_GER_KSK", 15],
	["CUP_B_UH1D_armed_GER_KSK_Des", 15],
	["CUP_B_UH1D_gunship_GER_KSK_Des", 15],
	["CUP_B_UH1D_slick_GER_KSK_Des", 15],
	["CUP_B_AH1Z_Dynamic_USMC", 15],
	["CUP_B_UH1Y_Gunship_Dynamic_USMC", 15],
	["CUP_B_UH1Y_MEV_USMC", 15],
	["CUP_B_UH1Y_UNA_USMC", 15],
	["CUP_O_UH1H_slick_SLA", 15],
	["CUP_UH1H_base", 20],
	["Plane_Civil_01_base_F", 5],
	["VTOL_01_base_F", 50],
	["VTOL_02_base_F", 30],
	["Land_Cargo40_white_F", 60],
	["O_Heli_Transport_04_covered_F", 100],
	["B_Heli_Transport_03_unarmed_F", 100],
	["I_Heli_Transport_02_F", 100]
];

/**
 * List of class names of objects which can be loaded in transport vehicle/cargo.
 * The second element of the nested arrays is the cost capacity (in relation with the capacity of the vehicles).
 * 
 * Liste des noms de classes des objets transportables.
 * Le deuxi�me �l�ment des sous-tableaux est le co�t de capacit� (en relation avec la capacit� des v�hicules).
 */
R3F_LOG_CFG_can_be_transported_cargo = R3F_LOG_CFG_can_be_transported_cargo +
[
	["Static_Designator_01_base_F", 2],
	["Static_Designator_02_base_F", 2],
	["StaticWeapon", 5],
	["Box_NATO_AmmoVeh_F", 5],
	["B_supplyCrate_F", 2],
	["C_IDAP_supplyCrate_F", 2],
	["ReammoBox_F", 2],
	["Kart_01_Base_F", 5],
	["Quadbike_01_base_F", 10],
	["Rubber_duck_base_F", 10],
	["UAV_01_base_F", 2],
	["UAV_06_base_F", 2],
	["UGV_02_base_F", 2],
	["Land_BagBunker_Large_F", 5],
	["Land_PierLadder_F", 3],
	["Land_BagBunker_Tower_F", 7],
	["Land_BagBunker_Small_F", 3],
	["Land_BagFence_Corner_F", 3],
	["Land_BagFence_End_F", 2],
	["Land_BagFence_Long_F", 3],
	["Land_BagFence_Round_F", 2],
	["Land_BagFence_Short_F", 2],
	["Land_BarGate_F", 3],
	["Land_Canal_WallSmall_10m_F", 4],
	["Land_Canal_Wall_Stairs_F", 3],
	["Land_CargoBox_V1_F", 5],
	["Land_Cargo40_white_F", 30],
	["Land_Cargo_Patrol_V1_F", 10],
	["Land_Cargo_Tower_V1_F", 25],
	["Land_CncBarrier_F", 4],
	["Land_CncBarrierMedium_F", 4],
	["Land_CncBarrierMedium4_F", 4],
	["Land_CncShelter_F", 2],
	["Land_CncWall1_F", 3],
	["Land_CncWall4_F", 5],
	["Land_Crash_barrier_F", 3],
	["Land_HBarrierBig_F", 3],
	["Land_HBarrierTower_F", 8],
	["Land_HBarrierWall4_F", 4],
	["Land_HBarrierWall6_F", 6],
	["Land_HBarrier_1_F", 3],
	["Land_HBarrier_3_F", 4],
	["Land_HBarrier_5_F", 5],
	["Land_LampHarbour_F", 2],
	["Land_LampShabby_F", 2],
	["Land_MetalBarrel_F", 2],
	["Land_Mil_ConcreteWall_F", 5],
	["Land_Mil_WallBig_4m_F", 5],
	["Land_Obstacle_Ramp_F", 5],
	["Land_Pipes_large_F", 5],
	["Land_RampConcreteHigh_F", 6],
	["Land_ConcreteRamp", 10],
	["RampConcrete", 7],
	["Land_RampConcrete_F", 5],
	["Land_Razorwire_F", 5],
	["Land_Sacks_goods_F", 2],
	["Land_Scaffolding_F", 5],
	["Land_Shoot_House_Wall_F", 3],
	["Land_Stone_8m_F", 5],
	["Land_BarrelWater_F", 2],
	["Land_Rampart_F", 5],
	["Land_fort_rampart_EP1", 5],
	["Dirthump_3_F", 5],
	["Land_CncBarrier_stripes_F", 3],
	["Dirthump_4_F", 10],
	["Land_Dirthump03", 10],
	["Land_WoodenRamp", 2],
	["TK_WarfareBBarrier10xTall_EP1", 8],
	["Land_Cargo_Tower_V4_F", 15],
	["Land_ConcreteBlock", 7],
	["BlockConcrete_F", 7],
	["Land_fort_artillery_nest", 5],
	["land_bunker_garage", 30],
	["Land_fort_bagfence_long", 5],
	["Land_fort_bagfence_corner", 2],
	["Land_fort_bagfence_round", 2],
	["CUP_O_ZU23_ChDKZ", 5],
	["CUP_O_SPG9_ChDKZ", 2],
	["CUP_O_DSHKM_ChDKZ", 2],
	["CUP_O_AGS_ChDKZ", 2],
	["CUP_O_Igla_AA_pod_ChDKZ", 5],
	["WarfareBDepot", 20],
	["WarfareBCamp", 10],
	["B_Radar_System_02_F", 5], //BY_VLADOS
	["B_Radar_System_01_F", 5], //BY_VLADOS
	["B_AAA_System_01_F", 5], //BY_VLADOS
	["CUP_B_TOW_TriPod_USMC", 5], //BY_VLADOS
	["CUP_O_Metis_RU", 5], //BY_VLADOS
	["B_SAM_System_03_F", 10],
	["O_SAM_System_04_F", 10],
	["Fortress2", 15],
	["Land_A_Castle_Stairs_A", 5],
	["Land_Campfire_burning", 1],
	["Land_SCF_01_shredder_F", 20],
	["Land_Atm_01_malden_F", 10],
	["FlagChecked_F", 1],
	["Land_GH_Stairs_F", 7],
	["Static Titan Launcher (AT)", 5],
    ["Static Titan Launcher (AA)", 5],
	["B_G_Mortar_01_F", 7],
	["I_G_HMG_02_high_F", 7],
	["I_G_HMG_02_F", 5],
	["B_T_GMG_01_F", 5],
	["Land_ConcreteWall_01_l_gate_F", 10],
	["Land_PierConcrete_01_16m_F", 30],
	["Land_Pier_Box_F", 50],
	["Land_Bunker_01_big_F", 15]

];

/****** MOVABLE-BY-PLAYER OBJECTS / OBJETS DEPLACABLES PAR LE JOUEUR ******/

/**
 * List of class names of objects which can be carried and moved by a player.
 * Liste des noms de classes des objets qui peuvent �tre port�s et d�plac�s par le joueur.
 */
R3F_LOG_CFG_can_be_moved_by_player = R3F_LOG_CFG_can_be_moved_by_player +
[
	"StaticWeapon",
	"ReammoBox_F",
	"Kart_01_Base_F",
	"Quadbike_01_base_F",
	"Rubber_duck_base_F",
	"SDV_01_base_F",
	"UAV_01_base_F",
	"UAV_06_base_F",
	"UGV_02_base_F",
	"Land_PierLadder_F",
	"Land_BagBunker_Large_F",
	"Land_BagBunker_Small_F",
	"Land_BagFence_Corner_F",
	"Land_BagFence_End_F",
	"Land_BagFence_Long_F",
	"Land_BagFence_Round_F",
	"Land_BagFence_Short_F",
	"Land_BarGate_F",
	"Land_Canal_WallSmall_10m_F",
	"Land_Canal_Wall_Stairs_F",
	"Land_CargoBox_V1_F",
	"Land_Cargo_Patrol_V1_F",
	"Land_Cargo_Tower_V1_F",
	"Land_CncBarrier_F",
	"Land_CncBarrierMedium_F",
	"Land_CncBarrierMedium4_F",
	"Land_CncShelter_F",
	"Land_CncWall1_F",
	"Land_CncWall4_F",
	"Land_Crash_barrier_F",
	"Land_HBarrierBig_F",
	"Land_HBarrierTower_F",
	"Land_HBarrierWall4_F",
	"Land_HBarrierWall6_F",
	"Land_HBarrier_1_F",
	"Land_HBarrier_3_F",
	"Land_HBarrier_5_F",
	"Land_LampHarbour_F",
	"Land_LampShabby_F",
	"Land_MetalBarrel_F",
	"Land_Mil_ConcreteWall_F",
	"Land_Mil_WallBig_4m_F",
	"Land_Obstacle_Ramp_F",
	"Land_Pipes_large_F",
	"Land_RampConcreteHigh_F",
	"Land_ConcreteRamp",
	"RampConcrete",
	"Land_RampConcrete_F",
	"Land_Razorwire_F",
	"Land_Sacks_goods_F",
	"Land_Scaffolding_F",
	"Land_Shoot_House_Wall_F",
	"Land_Stone_8m_F",
	"Land_BarrelWater_F",
	"Dirthump_3_F",
	"Dirthump_4_F",
	"Land_Dirthump03",
	"Land_Rampart_F",
	"Land_fort_rampart_EP1",
	"Land_WoodenRamp",
	"TK_WarfareBBarrier10xTall_EP1",
	"Land_Cargo_Tower_V4_F",
	"Land_ConcreteBlock",
	"Land_CncBarrier_stripes_F",
	"BlockConcrete_F",
	"Land_fort_artillery_nest",
	"land_bunker_garage",
	"Land_fort_bagfence_long",
	"Land_fort_bagfence_corner",
	"Land_fort_bagfence_round",
	"CUP_O_ZU23_ChDKZ",
	"CUP_O_SPG9_ChDKZ",
	"CUP_O_DSHKM_ChDKZ",
	"CUP_O_AGS_ChDKZ",
	"CUP_O_Igla_AA_pod_ChDKZ",
	"WarfareBDepot",
	"WarfareBCamp",
	"B_Radar_System_02_F", //BY_VLADOS
    "B_Radar_System_01_F", //BY_VLADOS
	"B_AAA_System_01_F", //BY_VLADOS
	"CUP_O_Metis_RU",
	"CUP_B_TOW_TriPod_USMC",
	"B_SAM_System_03_F",
	"O_SAM_System_04_F",
	"Fortress2",
	"Land_A_Castle_Stairs_A",
	"Land_Campfire_burning",
	"Land_Cargo40_white_F",
	"Land_SCF_01_shredder_F",
	"Land_i_Garage_V1_F",
	"Land_Atm_01_malden_F",
	"FlagChecked_F",
	"Land_ConcreteWall_01_l_gate_F",
	"Land_PierConcrete_01_16m_F",
	"Land_Pier_Box_F",
	"Land_GH_Stairs_F",
	"Land_Bunker_01_big_F"
];