sleep 60;
while {true} do
{
	private _players = allPlayers - entities "HeadlessClient_F";
	{ deleteMarker ("Artillery_" + getPlayerUID _x); } forEach (_players);

	sleep 45 + (random 45);
};
