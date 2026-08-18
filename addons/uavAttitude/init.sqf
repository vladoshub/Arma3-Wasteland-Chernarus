private ["_maxAltitude", "_currentUAV", "_pos"];

if(!isServer) exitWith {};

while {true} do {
    {
	    _currentUAV = _x;
	    _maxAltitude = -1;
        if ({_currentUAV isKindOf _x} count ["I_E_UAV_06_medical_F","I_E_UAV_06_F","B_UAV_06_F","B_UAV_06_medical_F","C_IDAP_UAV_06_antimine_F","C_IDAP_UAV_06_F","C_IDAP_UAV_06_medical_F","C_UAV_06_F","C_UAV_06_medical_F","I_UAV_06_F","I_UAV_06_medical_F","O_UAV_06_F","O_UAV_06_medical_F"] > 0) then {
	       _maxAltitude = 100;	
	    };

	    if ({_currentUAV isKindOf _x} count ["B_UAV_01_F", "O_UAV_01_F", "I_UAV_01_F", "C_IDAP_UAV_01_F", "I_E_UAV_01_F"] > 0) then {
	       _maxAltitude = 50;	
	    };

		if(_maxAltitude != -1) then {
		_pos = getPosATL _x;
            if ((_pos select 2) > _maxAltitude) then {
                // Резкое ограничение
                _x setPosATL [_pos select 0, _pos select 1, _maxAltitude];
                _x setVelocity [
                    velocity _x select 0,
                    velocity _x select 1,
                    -10  // Сильно тянем вниз
                ];
            };
		};

    } forEach vehicles;
    
    sleep 1;
};
