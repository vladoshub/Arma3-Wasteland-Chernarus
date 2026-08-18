if (backpack player == "") then {
	player addBackpack "B_Kitbag_Base";
	hint "Successful!";
	playSound "FD_Finish_F";
} else {
	hint "You also have backpack!";
	playSound "FD_CP_Not_Clear_F";
};