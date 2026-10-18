// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
// Lootspawner deleter: expire every tracked LS object, even with players nearby.
// Original authors: Na_Palm (BIS forums), AgentRev.

private _objLifetime = _this;

while {true} do
{
	private _countDel = _objLifetime call LSexpireLoot;

	if (_countDel > 0) then
	{
		diag_log format ["-- LOOTSPAWNER deleted %1 objects --", _countDel];
	};

	uiSleep 60;
};
