// book.sqf
disableSerialization;

// Данные для книги
private _bookData = [
["WHAT TO DO HERE | СМЫСЛ СЕРВЕРА", "Wasteland — это популярный режим-песочница, где игроки выбирают одну из трёх команд (BLUFOR, OPFOR или Independent) и выживают на большой карте. Основные особенности включают систему голода и жажды, магазины для покупки/продажи оружия, выполнение заданий для поиска лучшей экипировки и техники, а также возможность строить базу и зарабатывать деньги, убивая противников или выполняя миссии. Будьте готовы сражаться с другими игроками. В зависимости от вашей стороны над союзными игроками будет значок соответствующего цвета.", "Wasteland is a popular sandbox mode where players choose one of three teams (BLUFOR, OPFOR, or Independent) and survive on a large map. Key features include a hunger and thirst system, shops for buying and selling weapons, completing missions to find better equipment and vehicles, and the ability to build a base and earn money by killing enemies or completing missions. Be prepared to fight other players. Depending on your side, the players you're fighting will have a corresponding icon above them."],
["GROUP MANAGEMENT | СОЮЗ С ДРУГИМИ ИГРОКАМИ", "Независимо от вашей стороны, вы можете объединяться с другими игроками — раздел 'GROUP MANAGEMENT' в меню игрока. Синие и красные могут атаковать только противоположную сторону. Зелёные могут атаковать всех.", "Regardless of your side, you can team up with other players—see the 'GROUP MANAGEMENT' section in the player menu. Blue and Red players can only attack the opposing side. Green players can attack everyone."],
["MISSIONS | МИССИИ", "На миссиях вы можете захватить деньги, лут, строительные блоки, технику (самолёты, танки и т.д.). Все миссии имеют разную сложность (указана в описании справа при старте миссии): LIGHT, MIDDLE, HARD, ULTIMATE. Если у вас дефицит припасов, можете начать с LIGHT и постепенно дойти до ULTIMATE по мере появления денег и вооружения. На миссиях почти всегда есть вражеские боты, которых нужно уничтожить для завершения задания.", "During missions, you can capture money, loot, building blocks, and equipment (planes, tanks, etc.). All missions have varying difficulty levels (marked in the description on the right when you start the mission): LIGHT, MIDDLE, HARD, and ULTIMATE. If you're short on supplies, you can start with LIGHT and gradually work your way up to ULTIMATE as you gain money and weapons. Missions almost always feature enemy bots, which you'll need to eliminate to complete the objective."],
["MAP | КАРТА", "На карте вы найдёте, где находятся текущие миссии (обозначены красным крестом), а также магазины, гаражи для хранения техники и другую информацию. На карте стоят маленькие точки, указывающие на расположение объектов (слева внизу на карте есть надпись 'Legend:').", "On the map, you'll find the current locations of missions (marked with a red cross), as well as shops, vehicle storage garages, and other information. Small dots on the map indicate where things are located (the text 'Legend:' appears at the bottom left of the map)."],
["SPAWN WEAPON AND LOOTS | СПАВН ОРУЖИЯ И ЛУТА", "Оружие и лут вы можете найти в машинах и на земле.\nТакже оружие есть в ящиках, которые появляются на дорогах и на миссиях.", "You can find weapons and loot in cars and on the ground.\nWeapons are also found in crates that spawn on the roads and during missions."],
["STORES | МАГАЗИНЫ", "В магазинах вы можете купить почти всё, что появляется в мире, и не только. Оружие, лут, еда, техника, строения и т.д. Вы также можете продать своё оружие, технику или строения, которыми владеете, и получить за это деньги.\nНе все магазины одинаковы! Например, если вы хотите купить самолёт, вам нужно посетить магазин в аэропорту! На карте в правом нижнем углу вы можете увидеть, как обозначаются (каким значком) магазины и другие объекты на карте.", "You can buy almost everything that spawns in the world in stores, and more. Weapons, loot, food, equipment, buildings, and more. You can also sell your weapons, equipment, or buildings that you own for money.\nNot all stores are the same! For example, if you want to buy a plane, you need to visit the store at the airport! On the map, in the bottom right corner, you can see how stores and other objects are marked (with which icon) on the map."],
["SERVER ECONOMY | ЭКОНОМИКА СЕРВЕРА", "Вы можете хранить деньги в банкомате (ATM) — они отмечены на карте, там ваши средства будут в безопасности. В магазинах можно выбрать тип оплаты. Старайтесь не носить с собой много наличных, так как при смерти они выпадают, и если у вас много наличных, вы будете видны на карте!\nВы можете найти деньги на земле (они могут случайно появиться), у ботов, на миссиях. Не забывайте продавать ненужные вещи в магазинах, чтобы получить деньги! Также при смерти игрока (не считая респавна), если у него на счету было много денег, часть из них появится рядом с ним после смерти.", "You can store your money in an ATM (marked on the map) where it will be safe. In stores, you can choose the payment type. Try not to carry too much cash, as it drops upon death, and if you have a lot of cash, you will be visible on the map!\nYou can find money on the ground (it can spawn randomly), on bots, and during missions. Don't forget to sell items in stores to get cash! Also, when a player dies (not counting respawns) and had a lot of money in their account, some of it will appear next to them after death."],
["VEHICLES AND BUILDING | ТЕХНИКА И СТРОЕНИЯ", "На сервере представлена различная техника: от лёгкой до тяжёлой (танки и самолёты).\nТакже есть различные строения для создания баз и укреплений.", "The server features various vehicles, from light to heavy (tanks and planes).\nThere are also various structures for building bases and fortifications."],
["PLAYER SPAWN. RANDOM | СПАВН ИГРОКА. СЛУЧАЙНОЕ ВОЗРОЖДЕНИЕ", "В меню Respawn Menu вы можете выбрать случайный город или случайный прыжок с парашютом над случайным городом.", "In the Respawn Menu, you can choose a random city or a random parachute jump over a random city."],
["PLAYER SPAWN. SPAWNS | СПАВН ИГРОКА. ТОЧКИ ПОЯВЛЕНИЯ", "В меню в левой части вы можете выбрать точки появления (раздел Spawns), в которых вы всегда можете возрождаться почти без ограничения по времени.", "In the menu on the left side, you can select spawn points (Spawns section), where you can always respawn with almost no time limit."],
["PLAYER SPAWN. TOWNS | СПАВН ИГРОКА. ГОРОДА", "В меню в левой части вы можете выбрать города (раздел Towns), в которых находятся ваши союзники.", "In the menu on the left, you can select cities (the Towns section) where you have friendly players."],
["PLAYER SPAWN AND BEACONS | СПАВН ИГРОКА И МАЯКИ", "В меню в левой части вы можете выбрать спавн на палатке (раздел Beacons). Её можно купить в General Store и использовать как маяк для спавна. Количество ваших палаток ограничено, и через несколько дней они исчезнут.", "In the menu on the left, you can choose to spawn at a tent (the Beacons section). You can purchase one in the General Store and use it as a spawn beacon. The number of tents you can place is limited, and they will disappear after a few days."],
["PLAYER SPAWN AND TERRITORIES | СПАВН ИГРОКА И ТЕРРИТОРИИ", "В меню в левой части вы можете выбрать захваченные территории (раздел Territories). На карте это жёлтые области, которые нужно удерживать около 3 минут для захвата, за что дают деньги. Эти территории могут быть перезахвачены врагами.", "In the menu on the left, you can select captured territories (the Territories section). On the map, these are yellow areas that take about 3 minutes to capture and reward you with money. These territories can be recaptured by enemies."],
["PLAYER SPAWN AND FLAGS | СПАВН ИГРОКА И ФЛАГИ", "В меню в левой части вы можете выбрать возрождение на флаге (раздел Flags). Это часть базы — флаг, который нужно активировать в определённом месте. Его можно получить на миссии Capture the Flag или купить в магазине (очень дорого).", "In the menu on the left, you can choose to respawn at a flag (the Flags section). This is part of the base—a flag that must be activated at a specific location. You can get it during a Capture the Flag mission or buy it in the store (it's very expensive)."],
["PLAYER SPAWN. HQ | СПАВН ИГРОКА. Командный пункт", "В меню в левой части вы можете выбрать Командные пункты (раздел HQ), Это техника в которой можно возрождаться. Для возрождения в технике должны быть союзники.", "In the menu on the left, you can select headquarters (HQ section). These are vehicles you can respawn in. To respawn, you must have allies in the vehicle."],
["PORTALS | ПОРТАЛЫ", "Вы можете телепортироваться на захваченные территории. Для этого на карте есть порталы. Они отмечены маленькой зелёной точкой (см. раздел 'Легенда' на карте).", "You can teleport to captured territories. There are portals on the map for this purpose. They are marked with a small green dot (see the 'Legend' section on the map)."],
["KEY BINDS | Привязка клавиш", "SHIFT + C - рукопашный бой. End - беруши. ~ - Player Menu. M - карта", "SHIFT + C - melee combat. End - earplugs. ~ - Player Menu. M - map"],
["View Distance | Дальность прорисовки", "В меню игрока в разделе View Distance вы можете поменять дальность прорисовки до 4500м. Можно менять для вида от персонажа (ON FOOT), техники (IN CAR) и воздухе (IN AIR). Желательно менять оба ползунка (OBJECT и VIEW) для наилучшего эффекта", "In the player menu, under View Distance, you can change the render distance up to 4500m. This can be adjusted for the character view (ON FOOT), vehicle view (IN CAR), and air view (IN AIR). It's recommended to adjust both sliders (OBJECT and VIEW) for the best effect."],
["RESTART | РЕСТАРТ", "Рестарт каждые 6 часов", "Restart every 6 hours"],
["CLIENT SUPPORT MODS | ПОДДЕРЖКА КЛИЕНТСКИХ МОДОВ", "ArmA 2 Anims To ArmA 3 | A2ATA3 — мод для ArmA 3, который заменяет большую часть анимаций движения из ArmA 3 на анимации из ArmA 2.\nArmA 2 Sounds For ArmA 3 — модификация для ArmA 3, которая заменяет большую часть звуков в ArmA 3 на звуки из ArmA 2 (например, шаги, звуки переключения снаряжения и т.д.).", "ArmA 2 Anims To ArmA 3 | A2ATA3 - a mod for ArmA 3 that replaces most of the movement animations from ArmA 3 with those from ArmA 2.\nArmA 2 Sounds For ArmA 3 - a modification for ArmA 3 that replaces most of the sounds in ArmA 3 with the classic sounds from ArmA 2 (like footsteps, gear switching sounds, etc.)."]
];

// Создаем дисплей
createDialog "nABookDialog";
waitUntil {!isNull (findDisplay 7000)};

// Получаем контролы
private _display = findDisplay 7000;
private _combo = _display displayCtrl 7001;
private _textBoxENG = _display displayCtrl 7002; // Английский текст
private _textBoxRUS = _display displayCtrl 7003; // Русский текст

// Заполняем выпадающий список
{
    private _index = _combo lbAdd (_x select 0);
    _combo lbSetData [_index, str _x];
    _combo lbSetColor [_index, [1,1,1,1]]; // Белый цвет текста
} forEach _bookData;

// Устанавливаем первый элемент по умолчанию
_combo lbSetCurSel 0;

// Функция обновления текста
private _updateText = {
    params ["_combo", "_index"];
    
    private _data = call compile (_combo lbData _index);
    private _textRUS = _data select 1;
    private _textENG = _data select 2;
    
    private _display = findDisplay 7000;
    private _textBoxENG = _display displayCtrl 7002;
    private _textBoxRUS = _display displayCtrl 7003;
    
    _textBoxENG ctrlSetText _textENG; // Английский в первое окно
    _textBoxRUS ctrlSetText _textRUS; // Русский во второе окно
};

// Инициализируем первый элемент
[_combo, 0] call _updateText;

// Обработчик изменения выбора в комбобоксе
_combo ctrlAddEventHandler ["LBSelChanged", _updateText];

// Обработчик закрытия диалога
_display displayAddEventHandler ["Unload", {
    // Можно добавить дополнительную логику при закрытии
}];