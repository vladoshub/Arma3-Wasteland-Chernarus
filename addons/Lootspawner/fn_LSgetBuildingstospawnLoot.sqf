// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	Lootspawner spawn script
//	Author: Na_Palm (BIS forums)
//  Note by AgentRev: This script is a very good example of bad coding. If you are learning how to code, do NOT do it that way.
//-------------------------------------------------------------------------------------
//local to Server Var. "BuildingLoot" array of [state, time], placed on buildings that can spawn loot
//												state: 0-not assigned, 1-has loot, 2-currently in use/blockaded
//												time : timestamp of last spawn
//
//local to Server Var. "Lootready" time, placed on generated lootobject, needed for removing old loot
//									time: timestamp of spawn, object is ready for use by player and loot deleter
// A3W_lootSpawner marks LS objects; A3W_lootSpawnerBuilding identifies their source building.
// A3W_lootSpawnerObjects on the building keeps references, including objects moved elsewhere.
//-------------------------------------------------------------------------------------
private["_BaPname","_lootClass","_buildPosViable_list","_buildPosZadj_list","_lBuildVar","_timeStamp","_spwnPos","_randChance","_lootholder","_loot","_chfullf","_tmpPos","_lootType","_mags","_height"];

//BaP - Buildings around Player
private _BaP_list = _this select 0;
private _spInterval = _this select 1;
private _chfullfuel = _this select 2;
private _genZadjust = _this select 3;
private _chpSpot = _this select 4;

private _lootLists = [lootWeapon_list, lootMagazine_list, lootItem_list, lootBackpack_list, lootworldObject_list];
{
	private _building = _x;
	if (!(_x getVariable ["A3W_purchasedStoreObject", false]) && isNil {_x getVariable "baseSaving_hoursAlive"}) then
	{
		_BaPname = "";
		_lootClass = 0;
		_buildPosViable_list = [];
		_buildPosZadj_list = [];
		private _canSpawn = false;
		// Claim the building atomically: simultaneous client requests must not spawn two batches.
		isNil {
			_lBuildVar = _building getVariable ["BuildingLoot", [0, 0]];
			_timeStamp = _lBuildVar select 1;
			if ((_lBuildVar select 0) < 2 && {_timeStamp == 0 || {serverTime - _timeStamp > _spInterval}}) then {
				_building setVariable ["BuildingLoot", [2, _timeStamp], true];
				_canSpawn = true;
			};
		};
		if (_canSpawn) then {
			// Always remove this building's entire previous LS batch before creating another.
			_building call LSclearBuildingLoot;
			private _buildingLoot = _building getVariable ["A3W_lootSpawnerObjects", []];
			//get building class
			_BaPname = typeOf _x;
			//here an other _x
			{
				//if junction found, get lists and -> exit forEach
				if (_BaPname == (_x select 0)) exitWith {
					_lootClass = (_x select 1);
					//get viable positions Idx
					_buildPosViable_list pushBack ((Buildingpositions_list select _forEachIndex) select 1);
					if (swSpZadjust) then {
						//get position adjustments
						_buildPosZadj_list pushBack ((Buildingpositions_list select _forEachIndex) select 2);
					};
				};
				sleep 0.001;
			}forEach Buildingstoloot_list;
			if (count _buildPosViable_list > 0 && {{_x > 0} count (spawnClassChance_list select _lootClass) > 0}) then
			{
				for "_poscount" from 0 to (count (_buildPosViable_list select 0) - 1) do
				{
					//consider chance per Slot
					if ((floor random 100) < _chpSpot) then {
						_spwnPos = _building buildingPos ((_buildPosViable_list select 0) select _poscount);
						_tmpPos = [(_spwnPos select 0), (_spwnPos select 1), 60000];
						if ((_spwnPos select 0) == 0 && (_spwnPos select 1) == 0) then {
							_spwnPos = getPosATL _x;
							_tmpPos = [(_spwnPos select 0), (_spwnPos select 1), 60000];
						};
						if (swSpZadjust) then {
							_spwnPos = [_spwnPos select 0, _spwnPos select 1, (_spwnPos select 2) + ((_buildPosZadj_list select 0) select _poscount)];
						};
						//generally add 0.1 on z
						_spwnPos = [_spwnPos select 0, _spwnPos select 1, (_spwnPos select 2) + _genZadjust];
						//check if position has old loot
						if ((count (nearestObjects [_spwnPos, LSusedclass_list, 0.5])) == 0) then {
							sleep 0.001;
							//check what type of loot to spawn, get chance for loot every time, so all combos in spawnClassChance_list are viable
							_lootType = [[1,2,3,4,5], spawnClassChance_list select _lootClass] call fn_selectRandomWeighted;

							if (isNil "_lootType") exitWith {};

							_loot = (((_lootLists select (_lootType - 1)) select _lootClass) select 1) call fn_selectRandomLoot;

							// Roll before creating a holder, so disabled/failed entries leave no empty objects.
							if (_loot != "") then {
								_lootholder = objNull;

								if (_lootType < 5) then
								{
									_lootholder = createVehicle ["GroundWeaponHolder", _tmpPos, [], 0, "CAN_COLLIDE"];
									_lootholder setPosATL _tmpPos;
								};

								switch (_lootType) do
								{
									//special for weapons
									case 1:
									{
										_lootholder addWeaponCargoGlobal [_loot, 1];
										// always spawn 1-3 magazines to use the weapon with, otherwise nobody will take it
										_mags = getArray (configFile >> "CfgWeapons" >> _loot >> "magazines");
										if (count _mags > 0) then
										{
											_lootholder addMagazineCargoGlobal [_mags select 0, 2 + floor random 2];
										};
									};
									//special for magazines: spawn 1-5
									case 2:
									{
										_randChance = 1 + floor(random(1));
										for "_rm" from 1 to _randChance do {
											_lootholder addMagazineCargoGlobal [_loot, 1];
										};
									};
									//special for item/cloth/vests
									case 3:
									{
										_lootholder addItemCargoGlobal [_loot, 1];
									};
									//special for backpacks
									case 4:
									{
										_lootholder addBackpackCargoGlobal [_loot, 1];
									};
									//special for world objects: account for Wasteland and other items
									case 5:
									{
										if (_loot == "Land_Can_V3_F" && {["A3W_unlimitedStamina"] call isConfigOn} ||
										{(_loot == "Land_BakedBeans_F" || _loot == "Land_BottlePlastic_V2_F") && !(["A3W_survivalSystem"] call isConfigOn)}) exitWith
										{
											_lootholder = objNull;
										};

										_lootholder = createVehicle [_loot, _tmpPos, [], 0, "CAN_COLLIDE"];
										_lootholder setPosATL _tmpPos;
										if(_loot == "Land_CanisterFuel_F") then {
											_chfullf = (random 100);
											if (_chfullfuel > _chfullf) then {
												_lootholder setVariable["mf_item_id", "jerrycanfull", true];
											} else {
												_lootholder setVariable["mf_item_id", "jerrycanempty", true];
											};
										};
										if(_loot == "Land_CanisterOil_F") then {
											_lootholder setVariable["mf_item_id", "syphonhose", true];
										};
										if(_loot == "Land_Can_V3_F") then {
											_lootholder setVariable["mf_item_id", "energydrink", true];
										};
										if(_loot == "Land_BakedBeans_F") then {
											_lootholder setVariable["mf_item_id", "cannedfood", true];
										};
										if(_loot == "Land_BottlePlastic_V2_F") then {
											_lootholder setVariable["mf_item_id", "water", true];
										};
										if(_loot == "Land_Suitcase_F") then {
											_lootholder setVariable["mf_item_id", "repairkit", true];
										};
										//if container clear its cargo
										if (({_loot isKindOf _x} count exclcontainer_list) > 0) then {
											clearWeaponCargoGlobal _lootholder;
											clearMagazineCargoGlobal _lootholder;
											clearBackpackCargoGlobal _lootholder;
											clearItemCargoGlobal _lootholder;
										};
									};
								};

								if (!isNull _lootholder) then
								{
									_lootholder setVariable ["A3W_lootSpawner", true, true];
									_lootholder setVariable ["A3W_lootSpawnerBuilding", _building];
									_lootholder setVariable ["Lootready", diag_tickTime];
									_buildingLoot pushBack _lootholder;
									LS_spawnedLoot pushBack _lootholder;

									_height = getTerrainHeightASL _spwnPos;

									// buildingPos returns ATL over ground and ASL over water
									if (_height < 0) then {
										_lootholder setPosASL _spwnPos;
									} else {
										_lootholder setPosATL _spwnPos;
									};

									sleep 0.001;
									// Fix for wrong height (getPos Z = height above floor under object)
									_spwnPos set [2, (_spwnPos select 2) - ((getPos _lootholder) select 2)];

									// must be done twice
									if (_height < 0) then {
										_lootholder setPosASL _spwnPos;
									} else {
										_lootholder setPosATL _spwnPos;
									};

									_lootholder setdir (random 360);

									//1 category loot only per place so -> exit For
									//no lootpiling
									_lootholder setVariable ["Lootready", diag_tickTime];
								};
							};
						};
					};
				};
			};
			//release building with new timestamp
			_building setVariable ["BuildingLoot", [1, serverTime], true];
		};
		sleep 0.001;
	};
}forEach _BaP_list;
