// Этот код можно выполнить через spawn или call
disableSerialization;
private _display = findDisplay 2001;
private _timeout = time + 5; // Таймаут 5 секунд
    
waitUntil {
    sleep 0.1;
    _display = findDisplay 2001;
    !isNull _display || time > _timeout
};

if (isNull _display) exitWith {};

private _progressBar = _display displayCtrl 1032;
private _textLabel = _display displayCtrl 1031;

private _progressBarVest = _display displayCtrl 1033;
private _textLabelVest = _display displayCtrl 1034;

private _progressBarUniform = _display displayCtrl 1036;
private _textLabelUniform = _display displayCtrl 1037;

if (isNull _progressBar || isNull _textLabel || isNull _progressBarVest || isNull _textLabelVest) exitWith {};

// Бесконечный цикл обновления
while {!isNull _display} do {
    private _backpack = unitBackpack player;
    private _vest = vest player;
    private _uniform = uniform player;
    
    if (!isNull _backpack) then {
        private _load = load _backpack;
        
        // Обновляем прогресс-бар
        _progressBar progressSetPosition _load;
        
        // Меняем цвет
        private _color = if (_load < 0.5) then {
            [0, 1, 0, 0.8]
        } else {
            if (_load < 0.8) then {
                [1, 1, 0, 0.8]
            } else {
                [1, 0, 0, 0.8]
            };
        };
        _progressBar ctrlSetForegroundColor _color;
        
        // Обновляем текст
        _textLabel ctrlSetStructuredText parseText format["Backpack LOAD: %1%2", round (_load * 100), "%"];
    } else {
        _progressBar progressSetPosition 0;
        _textLabel ctrlSetStructuredText parseText "No backpack";
    };


    if (_vest != "") then {
        private _loadVest = loadVest player;
        
        // Обновляем прогресс-бар
        _progressBarVest progressSetPosition _loadVest;
        
        // Меняем цвет
        private _colorVest = if (_loadVest < 0.5) then {
            [0, 1, 0, 0.8]
        } else {
            if (_loadVest < 0.8) then {
                [1, 1, 0, 0.8]
            } else {
                [1, 0, 0, 0.8]
            };
        };
        _progressBarVest ctrlSetForegroundColor _colorVest;
        
        // Обновляем текст
        _textLabelVest ctrlSetStructuredText parseText format["Vest LOAD: %1%2", round (_loadVest * 100), "%"];
    } else {
        _progressBarVest progressSetPosition 0;
        _textLabelVest ctrlSetStructuredText parseText "No vest";
    };



    if (_uniform != "") then {
        private _loadUniform = loadUniform player;
        
        // Обновляем прогресс-бар
        _progressBarUniform progressSetPosition _loadUniform;
        
        // Меняем цвет
        private _colorUniform = if (_loadUniform < 0.5) then {
            [0, 1, 0, 0.8]
        } else {
            if (_loadUniform < 0.8) then {
                [1, 1, 0, 0.8]
            } else {
                [1, 0, 0, 0.8]
            };
        };
        _progressBarUniform ctrlSetForegroundColor _colorUniform;
        
        // Обновляем текст
        _textLabelUniform ctrlSetStructuredText parseText format["Uniform LOAD: %1%2", round (_loadUniform * 100), "%"];
    } else {
        _progressBarUniform progressSetPosition 0;
        _textLabelUniform ctrlSetStructuredText parseText "No uniform";
    };
    
    sleep 0.1;
};