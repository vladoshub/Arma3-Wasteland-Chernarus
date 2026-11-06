// A3W_unlimitedStaminaV2 = 1 enables this system. Values are in real seconds.
#define A3W_STAMINA_FREE_RUN 60
#define A3W_STAMINA_PENALTY_RUN 40
#define A3W_STAMINA_RECOVERY 40
#define A3W_STAMINA_SPEED_PENALTY 0.30
#define A3W_STAMINA_AIM_MULTIPLIER 3
#define A3W_STAMINA_IMPACT_RADIUS 5

// Optional CfgSounds class names or mission-relative sound file paths.
// Heavy breathing repeats whole clips while the second minute is in use.
// On recovery, finish the current clip before playing the recovered sound once.
// Both sounds are local and play only on foot. Vehicle entry stops playback.
// They respect the sound effects volume.
#define A3W_STAMINA_HEAVY_SOUND ""
#define A3W_STAMINA_RECOVERED_SOUND ""

// Optional close-bullet sounds for both impacts and flybys. Empty array disables playback.
// Entries accept CfgSounds class names or mission-relative file paths.
// Example: ["NearHit1", "NearHit2"]
#define A3W_STAMINA_IMPACT_SOUNDS []
#define A3W_STAMINA_IMPACT_SOUND_CHANCE 0.5
// Minimum real seconds after the previous impact clip has finished.
#define A3W_STAMINA_IMPACT_SOUND_GAP 3
