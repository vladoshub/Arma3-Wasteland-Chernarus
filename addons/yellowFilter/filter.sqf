private ["_filter", "_handle", "_priority"];
_filter = player getVariable ["armaYellowFilter", false];

if (_filter) then {
 while { 
  _handle = ppEffectCreate ["ColorCorrections", 1500]; 
  _handle < 0 
 } do { 
  _priority = _priority + 1; 
 }; 
 _handle ppEffectEnable true; 
 _handle ppEffectAdjust [1, 1, 0, [0, 0, 0, 0],  [1, 1, 1, 1], [0.299, 0.587, 0.114, 0]]; 
 _handle ppEffectCommit 0; 
 player setVariable ["armaYellowFilter", false];

} else {
  while { 
  _handle = ppEffectCreate ["ColorCorrections", 1500]; 
  _handle < 0 
 } do { 
  _priority = _priority + 1; 
 }; 
 _handle ppEffectEnable true; 
 _handle ppEffectAdjust [0.9, 0.9, 0, [0, 0, 0, 0], [1.4, 1.3, 1, 0.45], [0.299, 0.587, 0.114, 0]]; 
 _handle ppEffectCommit 0; 
 player setVariable ["armaYellowFilter", true];

};
