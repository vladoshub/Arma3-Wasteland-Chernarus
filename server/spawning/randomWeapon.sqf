// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: randomWeapon.sqf
//	@file Author: [404] Deadbeat, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args: Element 0 = Vehicle.

if (!isServer) exitWith {};

private ["_car", "_additionArray", "_nightTime", "_weapon", "_mag", "_additionOne", "_additionTwo", "_additionThree", "_buildingLootOn", "_random", "_launchers", "_wasLaunchers"];

_launchers = ["launch_Titan_F", "launch_Titan_short_F", "launch_RPG7_F", "CUP_launch_Metis", "CUP_launch_Javelin"];


//Grabs car object from array in execVM
_car = _this select 0;
_additionArray = vehicleAddition;
_nightTime = (date select 3 >= 18 || date select 3 < 5); // spawn night items between 18:00 and 05:00 (sunlight is completely gone by 20:00)

// If night is falling, add flashlight, IR pointers, and NV goggles to loot possibilities
if (_nightTime) then
{
	{ _additionArray pushBack _x} forEach ["acc_flashlight", "acc_pointer_IR"];
	//if (random 1 < 0.15) then { _car addItemCargoGlobal ["NVGoggles", 1]};
};

if (random 1 < 0.05) then { _car addItemCargoGlobal ["NVGoggles", 1]};


if (random 1 < 0.05) then { _car addItemCargoGlobal ["HandGrenade", 1 + floor random 2]};

if (random 1 < 0.03) then { _car addItemCargoGlobal ["1Rnd_HE_Grenade_shell", 1 + floor random 2]};

if (random 1 < 0.03) then { _car addItemCargoGlobal ["CUP_1Rnd_HE_M203", 1 + floor random 2]};

if (random 1 < 0.03) then { _car addItemCargoGlobal ["CUP_1Rnd_HEDP_M203", 1 + floor random 2]};

if (random 1 < 0.03) then { _car addItemCargoGlobal ["CUP_1Rnd_HE_GP25_M", 1 + floor random 2]};

if (random 1 < 0.01) then { _car addItemCargoGlobal ["DemoCharge_Remote_Mag", 1]};

if (random 1 < 0.05) then { _car addItemCargoGlobal ["NVGoggles", 1]};

if (random 1 < 0.3) then { _car addWeaponCargoGlobal ["Binocular", 1]};


if (random 1 < 0.1) then { _car addWeaponCargoGlobal ["FirstAidKit", 1]};

if (random 1 < 0.03) then { _car addWeaponCargoGlobal ["Rangefinder", 1]};


if (random 1 < 0.02) then { 
	_car addItemCargoGlobal ["RPG7_F", 1];
	_car addBackpackCargoGlobal ["I_UAV_06_backpack_F", 1];
	_car addItemCargoGlobal ["I_UavTerminal", 1];
};


//Get Random Gun From randomWeapons Array.

_additionOne = _additionArray call fn_selectRandomNested;
_additionArray = _additionArray - [_additionOne];
_additionTwo = _additionArray call fn_selectRandomNested;
//_additionArray = _additionArray - [_additionTwo];
_additionThree = vehicleAddition2 call fn_selectRandomNested;

_buildingLootOn = (["A3W_buildingLootWeapons"] call isConfigOn && (isNil "A3W_buildingLoot" || {["A3W_buildingLoot"] call isConfigOn}));

// A3W_vehicleloot
//Add guns and magazines, note the Global at the end
//add a probability of 50% of a vehicle getting a gun or some more additional loot instead
_wasLaunchers = false;
_weapon = vehicleWeapons call fn_selectRandomNested;

if (_weapon in _launchers && (random 1 < 0.2)) then { //BY_VLADOS
	_weapon = "launch_RPG7_F";
	_wasLaunchers = true;
};

_mag = ((getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines")) select 0) call getBallMagazine;

switch (["A3W_vehicleLoot", 1] call getPublicVar) do
{
	case 1:
	{
		_random = random 1;

		// If building loot is turned off, give everything, otherwise 50/50 chance between gun or items
		if (_random < 0.75 || !_buildingLootOn) then
		{
			_car addWeaponCargoGlobal [_weapon, 1];
			_car addMagazineCargoGlobal [_mag, 1 + floor random 2];
		};
		if (_random >= 0.5 || !_buildingLootOn) then
		{
			_car addItemCargoGlobal [_additionTwo, 1];
			//if (_nightTime) then { _car addItemCargoGlobal ["acc_flashlight", 1] };
		};

		_car addItemCargoGlobal [_additionOne, 1];
	};
	case 2:
	{
		if(random 1 < 0.75) then {
			_car addWeaponCargoGlobal [_weapon, 1];
			_car addMagazineCargoGlobal [_mag, 2 + floor random 3];
		};

		if(random 1 < 0.7) then {
			_car addItemCargoGlobal [_additionOne, 1];
		};

		if(random 1 < 0.4) then {
			_car addItemCargoGlobal [_additionTwo, 1];
		};
		//if (_nightTime) then { _car addItemCargoGlobal ["acc_flashlight", 1] };
	};
	case 3:
	{
		if(random 1 < 0.8) then {
			_car addWeaponCargoGlobal [_weapon, 1];
			_car addMagazineCargoGlobal [_mag, 1 + floor random 2];
		};

		// 2nd weapon
		if(random 1 < 0.2) then {
			_weapon = vehicleWeapons call fn_selectRandomNested;
			if (_weapon in _launchers && (random 1 < 0.5)) then {
				_weapon = "launch_RPG7_F";
			};
			_mag = ((getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines")) select 0) call getBallMagazine;
			_car addWeaponCargoGlobal [_weapon, 1];
			_car addMagazineCargoGlobal [_mag, 1 + floor random 2];
		};

		if(random 1 < 0.7) then {
			_car addItemCargoGlobal [_additionOne, 1];
		};
		if(random 1 < 0.4) then {
			_car addItemCargoGlobal [_additionTwo, 1];
		};
		//if (_nightTime) then { _car addItemCargoGlobal ["acc_flashlight", 1] };
	};
};

if(_wasLaunchers) then {
	_weapon = vehicleWeapons call fn_selectRandomNested;
	if (_weapon in _launchers && (random 1 < 0.2)) then { //BY_VLADOS
		_weapon = "launch_RPG7_F";
	};
	_mag = ((getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines")) select 0) call getBallMagazine;

	if(random 1 < 0.9) then {
		_car addWeaponCargoGlobal [_weapon, 1];
		_car addMagazineCargoGlobal [_mag, 2 + floor random 3];
	};
	_wasLaunchers = false;

};
