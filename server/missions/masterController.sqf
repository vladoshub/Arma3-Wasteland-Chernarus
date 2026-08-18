// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//  @file Name: masterController.sqf
//  @file Author: AgentRev
//  Dynamic scheduler rework: Vlados / OpenAI

if (!isServer) exitWith {};

private _ctrlTypes =
[
    "mainMission",
    "patrolMission",
    "moneyMission",
    "extraMission",
    "sideMission",
    "ultraMission"
];

private _ctrlQuantity = (["A3W_missionsQuantity", 6] call getPublicVar) max 0 min 6;
if (_ctrlQuantity <= 0) exitWith
{
    diag_log "[DynamicMissions] A3W_missionsQuantity is 0; mission scheduler disabled";
};

// Compile all mission processors once. Dynamic workers will call the per-type controllers
// in one-shot mode, so persistent sequential controllers are no longer started here.
{
    missionNamespace setVariable
    [
        format ["%1Processor", _x],
        (format ["server\missions\%1Processor.sqf", _x]) call mf_compile
    ];
} forEach _ctrlTypes;

// Compile every mission script once at startup for early syntax-error detection.
{
    [_x select 0, _x select 1] call attemptCompileMissions;
} forEach
[
    [MainMissions, "mainMissions"],
    [PatrolMissions, "patrolMissions"],
    [MoneyMissions, "moneyMissions"],
    [ExtraMissions, "extraMissions"],
    [SideMissions, "sideMissions"],
    [UltraMissions, "ultraMissions"]
];

missionNamespace setVariable ["A3W_dynamicMissionControllerTypes", _ctrlTypes];
missionNamespace setVariable ["A3W_dynamicMissionHardCap", _ctrlQuantity];

[] execVM "server\missions\dynamicMissionScheduler.sqf";
