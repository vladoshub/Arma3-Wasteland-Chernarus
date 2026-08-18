// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: towns.sqf
//	@file Author: AgentRev, JoSchaap

private _towns =
[
	/*
	["Town_Chernogorsk", -1, "Chernogorsk"],
	["Town_Elektrozavodsk", -1, "Elektrozavodsk"],
	["Town_Berezino", -1, "Berezino"],
	["Town_Solnichniy", -1, "Solnichniy"],
	["Town_Prigorodki", -1, "Prigorodki"],
	["Town_Zelenogorsk", -1, "Zelenogorsk"],
	["Town_Sosnovka", -1, "Sosnovka"],
	["Town_Myshkino", -1, "Myshkino"],
	["Town_Pustoschka", -1, "Pustoschka"],
	["Town_Vybor", -1, "Vybor"],
	["Town_Lopatino", -1, "Lopatino"],
	["Town_Grishino", -1, "Grishino"],
	["Town_Krasnostav", -1, "Krasnostav"],
	["Town_Gorka", -1, "Gorka"],
	["Town_Nizhnoye", -1, "Nizhnoye"],
	["Town_Khelm", -1, "Khelm"],
	["Town_Olsha", -1, "Olsha"],
	["Town_Polana", -1, "Polana"],
	["Town_Dolina", -1, "Dolina"],
	["Town_Shakhovka", -1, "Shakhovka"],
	["Town_Staroye", -1, "Staroye"],
	["Town_Msta", -1, "Msta"],
	["Town_Orlovets", -1, "Orlovets"],
	["Town_Mogilevka", -1, "Mogilevka"],
	["Town_Vyshnoye", -1, "Vyshnoye"],
	["Town_NovySobor", -1, "NovySobor"],
	["Town_Guglovo", -1, "Guglovo"],
	["Town_StarySobor", -1, "StarySobor"],
	["Town_Kabanino", -1, "Kabanino"],
	["Town_Kozlovka", -1, "Kozlovka"],
	["Town_Balota", -1, "Balota"],
	["Town_Komarovo", -1, "Komarovo"],
	["Town_Kamenka", -1, "Kamenka"],
	["Town_Pavlovo", -1, "Pavlovo"],
	["Town_Tulga", -1, "Tulga"],
	["Town_Pusta", -1, "Pusta"],
	["Town_Pulkovo", -1, "Pulkovo"],
	["Town_Rogovo", -1, "Rogovo"],
	["Town_Pogorevka", -1, "Pogorevka"],
	["Town_Bor", -1, "Bor"],
	["Town_Dubrovka", -1, "Dubrovka"],
	["Town_Gvozdno", -1, "Gvozdno"],
	["Town_Nadezhdino", -1, "Nadezhdino"],
	["Town_Kamyshovo", -1, "Kamyshovo"],
	["Town_Petrovka", -1, "Petrovka"],
	["Town_Drozhino", -1, "Drozhino"]
	*/

	["Town_Kavala", -1, "Kavala"],
	["Town_AgiosDionysios", -1, "Agios Dionysios"],
	["Town_Abdera", -1, "Abdera"],
	["Town_Athira", -1, "Athira"],
	["Town_Telos", -1, "Telos"],
	["Town_Sofia", -1, "Sofia"],
	["Town_Paros", -1, "Paros"],
	["Town_Pyrgos", -1, "Pyrgos"],
	["Town_Selakano", -1, "Selakano"],
	["Town_Vikos", -1, "Vikos"],
	["Town_Zaros", -1, "Zaros"],
	["Town_Neochori", -1, "Neochori"],
	["Town_Aggelochori", -1, "Aggelochori"],
	["Town_Panochori", -1, "Panochori"],
	["Town_Charkia", -1, "Charkia"],
	["Town_Chalkeia", -1, "Chalkeia"],
	["Town_Oreokastro", -1, "Oreokastro"],
	["Town_Negades", -1, "Negades"],
	["Town_Frini", -1, "Frini"],
	["Town_Poliakko", -1, "Poliakko"],
	["Town_Kore", -1, "Kore"],
	["Town_Syrta", -1, "Syrta"],
	["Town_Lakka", -1, "Lakka"],
	["Town_Dorida", -1, "Dorida"],
	["Town_Panagia", -1, "Panagia"],
	["Town_Kalochori", -1, "Kalochori"],
	["Town_Feres", -1, "Feres"],
	["Town_Molos", -1, "Molos"],
	["Town_Rodopoli", -1, "Rodopoli"]


];

//copyToClipboard str ((allMapMarkers select {_x select [0,5] == "Town_"}) apply {[_x, -1, markerText _x]})

private "_size";
 
{
	_x params ["_marker"];

	if (markerShape _marker == "ELLIPSE") then
	{
		_size = markerSize _marker;
		_x set [1, (_size select 0) min (_size select 1)];
	};
} forEach _towns;

_towns