private "_updateType";
_varType1 = param [0, "", [""]];
_slider1 = ctrlIDC (param [1, 0, [0, controlNull]]);
private _sliderPos = param [2, 0, [0]];
_text1 = param [3, 0, [0, controlNull]];

sliderSetPosition [_slider1, _sliderPos min CHVD_maxObj max 0];
ctrlSetText [_text1, str round (_sliderPos min CHVD_maxObj max 0)];
call compile format ["%1 = %2", _varType1, _sliderPos min CHVD_maxObj max 0];
call compile format ["profileNamespace setVariable ['%1',%1]", _varType1];


