/*
	Author: Exonical
	Description: Intro
	Version: 0.3
	Updated: 02.11.2019
*/

//   RUS / ENG
private _messages = [
    ["The Player Menu button - '~'", "Кнопка 'Меню игрока' - '~'", 3],
    ["You can read more info about this server in the player menu (~) or 'HELP' tab on the wheel", "В меню игрока (~) или вкладке 'HELP' на колесе вы найдете более подробную информацию об этом сервере", 8],
    ["For disable these messages press button 'Help message On/Off' in player Menu (~)", "Чтобы выключить эти подсказки, нажмите кнопку 'Help message On/Off' в меню игрока (~)", 8],
    ["The main features of this server include a hunger and thirst system, shops for buying/selling weapons and equipment, completing quests to find better equipment and equipment, and the ability to build a base and earn money by killing opponents or completing missions.", "Основные особенности этого сервера включают систему голода и жажды, магазины для покупки/продажи оружия и техники, выполнение заданий для поиска лучшей экипировки и техники, а также возможность строить базу и зарабатывать деньги, убивая противников или выполняя миссии.", 12],
    ["This is a PVP server, so be prepared to fight other players. Depending on your side, allied players will have an icon of the corresponding color above them.", "Это PVP-сервер, так что будьте готовы сражаться с другими игроками. В зависимости от вашей стороны, над союзными игроками будет значок соответствующего цвета", 8],
    ["Blue and Red can only attack opposite sides. Green can attack everyone.", "Синие и красные могут атаковать только противоположную сторону. Зеленые могут атаковать всех", 6],
    ["Regardless of your side, you can team up with other players - the 'GROUP MANAGEMENT' section in the player menu", "Независимо от вашей стороны, вы можете объединяться с другими игроками — раздел 'GROUP MANAGEMENT' в меню игрока", 6],
    ["You can find starting weapons and loot in vehicles and on the ground. Vehicles can also spawn in cities.", "Вы можете найти стартовое оружие и лут в машинах и на земле. Также техника может спавниться в городах", 6],
    ["Upon first spawn after restart, you have a defibrillator (which can be used if you pass out - ENTER button), a small helicopter, some money and starting weapons.", "После первого спавна после рестарта у вас есть дефибриллятор (который можно использовать, если вы потеряли сознание — кнопка ENTER), маленький вертолет, немного денег и стартовое оружие", 8],
    ["Don't forget to eat and drink (in the player menu). Hunger and thirst are displayed at the bottom right", "Не забывайте есть и пить (в меню игрока). Голод и жажда отображаются в правом нижнем углу", 6],
    ["The map shows shops where you can buy and sell items. Each shop has different contents (for example, airplanes are available at airports). Shop types are listed on the map under the 'LEGEND' section.", "На карте отмечены магазины, где вы можете покупать и продавать. Все магазины различаются по наполнению (например, самолеты доступны в аэропортах). Типы магазинов указаны на карте в разделе 'LEGEND'", 10],
    ["The ATM is marked on the map with a small yellow 'A' icon.", "Банкомат на карте отмечен маленькой желтой иконкой 'A'", 5],
    ["You can be a gunner in a vehicle and drive at the same time. (check scroll)", "Вы можете быть стрелком в технике и одновременно управлять ей (через колесо мыши)", 5],
    ["Here you can play in 3rd view person", "Здесь вы можете играть от третьего лица", 4],
    ["THERE MAY BE FOOT PATROLS WITH WEAPONS IN CITIES! Also, always be wary of patrol missions (they're visible on the map), especially air patrols. Air patrols often attack while you're in a vehicle.", "БУДЬТЕ ОСТОРОЖНЫ! В ГОРОДАХ МОГУТ БЫТЬ ПЕШИЕ ПАТРУЛИ С ОРУЖИЕМ! Также всегда опасайтесь миссий с патрулем (они видны на карте), особенно воздушных патрулей. Воздушные патрули часто атакуют, когда вы находитесь в технике", 10]
];

private _displayTime = 12;
private _fadeTime = 1.5;

sleep 30;

private _count = 0;
private _sleep = 60;

private _help = profileNamespace getVariable ["userHelpMessages", true];

while {true} do {

_help = profileNamespace getVariable ["userHelpMessages", true];

if(_help) then {

{

	_help = profileNamespace getVariable ["userHelpMessages", true];

	if(_help) then {

    uiSleep 2;
    
    private _textOne = _x select 0;
    private _textTwo = _x select 1;
    private _time = _x select 2;
    
    private _text = format[
        "<t size='1.0' color='#ffffffff' align='center' shadow='1' shadowColor='#000000'>%1</t><br />
        <t size='1.0' color='#FFFFFF' align='center' shadow='1' shadowColor='#000000'>%2</t>", 
        _textOne, _textTwo
    ];
    
    // Создаем контрол для плавных эффектов
    private _ctrl = (findDisplay 46) ctrlCreate ["RscStructuredText", -1];
    _ctrl ctrlSetPosition [
        safeZoneX + safeZoneW * 0.1, 
        safeZoneY + safeZoneH * 0.85,
        safeZoneW * 0.8, 
        safeZoneH * 0.15
    ];
    _ctrl ctrlSetStructuredText parseText _text;
    _ctrl ctrlSetBackgroundColor [0, 0, 0, 0];
    _ctrl ctrlCommit 0;
    
    // Плавное появление
    _ctrl ctrlSetFade 1;
    _ctrl ctrlCommit 0;
    _ctrl ctrlSetFade 0;
    _ctrl ctrlCommit _fadeTime;
    
    uiSleep (_time + _fadeTime);
    
    // Плавное исчезновение
    _ctrl ctrlSetFade 1;
    _ctrl ctrlCommit _fadeTime;
    
    uiSleep _fadeTime;
    
    // Удаление контрола
    ctrlDelete _ctrl;
	};
    
} forEach _messages;

};

sleep _sleep;
_count = _count + 1;

if (_count >= 3) then {
    _sleep = 2700;
};

};