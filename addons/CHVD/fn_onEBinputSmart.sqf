private ["_textValue","_updateType"];
_varType1 = param [0, "", [""]];
_slider1 = param [1, controlNull, [0, controlNull]];
_text1 = param [2, controlNull, [0, controlNull]];

_textValue = [ctrlText _text1, "0123456789"] call BIS_fnc_filterString;
_textValue = if (_textValue == "") then {0} else {call compile _textValue min 12000 max 0};
sliderSetPosition [_slider1, _textValue min CHVD_maxObj max 0];
call compile format ["%1 = %2", _varType1, _textValue min CHVD_maxObj max 0];
call compile format ["profileNamespace setVariable ['%1',%1]", _varType1];




