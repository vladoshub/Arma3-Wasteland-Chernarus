
private ["_formattedTextChat"];

while {!isServer} do
{

	sleep 120;
	_formattedTextChat = format ["SERVER MESSAGE: %1", "YOU WILL BE BANED FOR INSULTS AND POLITICS."];
	player globalChat _formattedTextChat;
	sleep 5;
	_formattedTextChat = format ["SERVER MESSAGE: %1", "REMEMBER THE SERVER NAME - THE IP ADDRESS MAY CHANGE AND THE SERVER CAN BE REMOVED FROM YOUR FAVORITES."];
	player globalChat _formattedTextChat;

	sleep 10;

	_formattedTextChat = format ["SERVER MESSAGE: %1", "ВЫ ПОЛУЧИТЕ БАН ЗА ОСКОРБЛЕНИЯ И ПОЛИТИКУ."];
	player globalChat _formattedTextChat;
	sleep 5;
	_formattedTextChat = format ["SERVER MESSAGE: %1", "ЗАПОМНИТЕ ИМЯ СЕРВЕРА - IP АДРЕС МОЖЕТ ПОМЕНЯТЬСЯ И СЕРВЕР УДАЛИТЬСЯ ИЗ ИЗБРАННОГО."];
	player globalChat _formattedTextChat;
	
	
	sleep 1200;
};