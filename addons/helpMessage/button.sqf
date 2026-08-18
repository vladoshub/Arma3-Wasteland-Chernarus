private _help = !(profileNamespace getVariable ["userHelpMessages", true]);

if(_help) then {
	hint "Help Messages Enabled";
} else {
	hint "Help Messages Disabled";
};

profileNamespace setVariable["userHelpMessages", _help];