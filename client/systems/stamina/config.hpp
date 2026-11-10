// A3W_unlimitedStaminaV2 = 1 enables this system. Values are in real seconds.
#define A3W_STAMINA_FREE_RUN 60
#define A3W_STAMINA_PENALTY_RUN 40
#define A3W_STAMINA_RECOVERY 40
#define A3W_STAMINA_SPEED_PENALTY 0.22
#define A3W_STAMINA_AIM_MULTIPLIER 3
#define A3W_STAMINA_IMPACT_RADIUS 1

// Optional mission-relative sound file paths. Empty arrays disable that stage.
#define A3W_STAMINA_RUN_SOUNDS [ \
    getMissionPath "client\sounds\arma2\breath\zozo-run-breath-01.wav", \
    getMissionPath "client\sounds\arma2\breath\vasa-run-breath-05.wav", \
    getMissionPath "client\sounds\arma2\breath\george-run-breath-03.wav" \
]

#define A3W_STAMINA_SPRINT_SOUNDS [ \
    getMissionPath "client\sounds\arma2\breath\zozo-sprint-breath-05.wav", \
    getMissionPath "client\sounds\arma2\breath\vasa-sprint-breath-05.wav", \
    getMissionPath "client\sounds\arma2\breath\george-sprint-breath-04.wav" \
]