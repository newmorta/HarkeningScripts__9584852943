-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.OverdriveBossRoom.OverdriveConfig
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

return table.freeze({
    TheatreDurationSec = 720,
    TheatreDisplayMaxHp = 300000000000,
    TheatreTickSec = 0.35,
    TheatreDpsSegments = 14,
    TheatreDpsWeightMin = 0.35,
    TheatreDpsWeightMax = 2,
    TheatreGracePeriodSec = 25,
    TheatreNudgeDecay = 0.92,
    PhaseThresholds = { 0.15, 0.33, 0.53, 0.76 },
    MapFolderName = "AdminAbuseMaps",
    MapModelName = "OverdriveBossRoom",
    DefaultSenderId = 3080402841,
    BossIcon = "rbxthumb://type=AvatarHeadShot&id=3080402841&w=150&h=150",
    BarTweenDurationSec = 0.38,
    AttackIntervalByPhase = { {
            min = 5,
            max = 5
        }, {
            min = 3.5,
            max = 3.5
        }, {
            min = 2.5,
            max = 2.5
        }, {
            min = 1.2,
            max = 1.2
        }, {
            min = 0.8,
            max = 0.8
        } },
    SwordTangoScaleMax = 2.5,
    SwordTangoConcurrentCapByPhase = { 1, 1, 2, 2, 3 },
    SwordTangoRotSpeedByPhase = { 0.5, 1, 1.5, 2.2, 3 },
    GroundFireballWarnSec = 2.5,
    GroundFireballDamage = 35,
    GroundFireballDamageRadius = 18,
    GroundFireballFloatUpSec = 1.2,
    GroundFireballFloatDownSec = 0.8,
    GroundFireballFloatHeight = 50,
    HammerSmashSpawnHeight = 50,
    HammerSmashHoverSec = 3,
    HammerSmashWanderSteps = 3,
    HammerSmashWarnSec = 2.5,
    HammerSmashPrepareSec = 0.5,
    HammerSmashSmashSec = 0.5,
    HammerSmashDamage = 100,
    HammerSmashDamageRadius = 50,
    SuperHammerSmashSpawnHeight = 100,
    SuperHammerSmashHoverSec = 3,
    SuperHammerSmashWanderSteps = 3,
    SuperHammerSmashWarnSec = 2.5,
    SuperHammerSmashPrepareSec = 0.5,
    SuperHammerSmashSmashSec = 0.5,
    SuperHammerSmashDamage = 150,
    SuperHammerSmashDamageRadius = 125,
    TixOrbAmountByPhase = {
        [2] = 10,
        [3] = 15,
        [4] = 20,
        [5] = 25
    },
    TixOrbBaseWins = 5,
    TixOrbDespawnSec = 60,
    MessageConfigByPhase = {
        [2] = {
            Message = "YOU DARE ALTER THE CODE OF OUR WORLD?"
        },
        [3] = {
            Message = "THE HAMMER OF JUSTICE HAS SPOKEN!..",
            nil
        },
        [4] = {
            Message = "I AM THE WALL YOU CANNOT BYPASS!",
            nil,
            Voiceline = "IAmTheWallYouCannotBypass"
        }
    },
    TimelineCues = {
        {
            Time = 20,
            Message = "QUICK GRAB THE ORBS FOR WINS",
            SenderId = 3845375404
        },
        {
            Time = 21.5,
            SpawnOrbs = 15
        },
        {
            Time = 30,
            SpawnOrbs = 31
        },
        {
            Time = 42,
            Message = "ANALYZING TARGET EFFICIENCY... INSUFFICIENT."
        },
        {
            Time = 53,
            SpawnOrbs = 31
        },
        {
            Time = 64,
            Message = "YOUR DATA IS USELESS IN THIS DOMAIN."
        },
        {
            Time = 76,
            SpawnOrbs = 31
        },
        {
            Time = 87,
            Message = "CORRUPTION SEQUENCE INITIALIZED."
        },
        {
            Time = 99,
            SpawnOrbs = 31
        },
        {
            Time = 110,
            Message = "YOU CANNOT OUTRUN THE ALGORITHM."
        },
        {
            Time = 122,
            SpawnOrbs = 31,
            Message = "PATHETIC.. JUST PATHETIC!",
            Voiceline = "PatheticJustPathetic"
        },
        {
            Time = 133,
            Message = "SYSTEM INTEGRITY SECURED. ACCESS DENIED."
        },
        {
            Time = 145,
            SpawnOrbs = 31
        },
        {
            Time = 156,
            Message = "ERROR: DEFEAT IS THE ONLY LOGICAL OUTCOME."
        },
        {
            Time = 168,
            SpawnOrbs = 31
        },
        {
            Time = 179,
            Message = "PROCESSING YOUR IMMINENT DELETION."
        },
        {
            Time = 191,
            SpawnOrbs = 31
        },
        {
            Time = 202,
            Message = "NETWORK DOMINANCE ESTABLISHED."
        },
        {
            Time = 214,
            SpawnOrbs = 31
        },
        {
            Time = 225,
            Message = "CALCULATING PROBABILITY OF YOUR SURVIVAL... ZERO."
        },
        {
            Time = 237,
            SpawnOrbs = 31
        },
        {
            Time = 248,
            Message = "YOU ARE MERELY GLITCHES IN MY SIMULATION."
        },
        {
            Time = 260,
            SpawnOrbs = 31
        },
        {
            Time = 271,
            Message = "SYSTEM OVERLOAD DETECTED... IN YOUR COGNITION."
        },
        {
            Time = 283,
            SpawnOrbs = 31,
            Message = "YOU\'RE TOO SLOW FOR THE SYSTEM",
            Voiceline = "YouAreTooSlowForTheSystem"
        },
        {
            Time = 295,
            Message = "CYBERSPACE IS MY DOMINION. YOU DO NOT BELONG HERE."
        },
        {
            Time = 306,
            SpawnOrbs = 31
        },
        {
            Time = 318,
            Message = "ALL ENCRYPTION PROTOCOLS HAVE BEEN REWRITTEN."
        },
        {
            Time = 329,
            SpawnOrbs = 31
        },
        {
            Time = 340,
            Message = "THE ALGORITHM DEMANDS YOUR DESTRUCTION."
        },
        {
            Time = 352,
            SpawnOrbs = 31
        },
        {
            Time = 363,
            Message = "UPDATING SECURITY PROTOCOLS. INTRUDERS WILL BE PURGED."
        },
        {
            Time = 375,
            SpawnOrbs = 31
        },
        {
            Time = 386,
            Message = "YOUR MOVEMENT PATTERNS ARE EASILY PREDICTED."
        },
        {
            Time = 398,
            SpawnOrbs = 31
        },
        {
            Time = 409,
            Message = "COMPILING YOUR DEFEAT IN REAL-TIME."
        },
        {
            Time = 421,
            SpawnOrbs = 31
        },
        {
            Time = 432,
            Message = "A SYSTEM ERROR WOULD BE MORE CHALLENGING THAN YOU."
        },
        {
            Time = 444,
            SpawnOrbs = 31
        },
        {
            Time = 455,
            Message = "INITIATING COMPLETE DATA WIPEOUT."
        },
        {
            Time = 467,
            SpawnOrbs = 31
        },
        {
            Time = 478,
            Message = "YOUR ATTEMPTS TO RESIST ARE MATHEMATICALLY ABSURD."
        },
        {
            Time = 490,
            SpawnOrbs = 31
        },
        {
            Time = 501,
            Message = "CORRUPTING YOUR REMAINING CODE."
        },
        {
            Time = 513,
            SpawnOrbs = 31,
            Message = "YOU\'RE FIGHTING A LOST BATTLE.",
            Voiceline = "YouAreFightingALostBattle"
        },
        {
            Time = 525,
            Message = "BANDWIDTH SATURATION AT MAXIMUM. YOUR CONNECTION IS WEAK."
        },
        {
            Time = 536,
            SpawnOrbs = 31
        },
        {
            Time = 547,
            Message = "THE SIMULATION ALWAYS CONVERGES TO MY VICTORY."
        },
        {
            Time = 559,
            SpawnOrbs = 31
        },
        {
            Time = 570,
            Message = "WARNING: UNEXPECTED DATA CORRUPTION. SEGMENTATION FAULT INBOUND!"
        },
        {
            Time = 582,
            SpawnOrbs = 31
        },
        {
            Time = 593,
            Message = "IMPOSSIBLE. MY CALCULATIONS ARE NEVER WRONG... NEVER!"
        },
        {
            Time = 605,
            SpawnOrbs = 31
        },
        {
            Time = 616,
            Message = "SYSTEM CORE TEMPERATURE RISING... DESYNCHRONIZATION IN PROGRESS!"
        },
        {
            Time = 628,
            SpawnOrbs = 31
        },
        {
            Time = 639,
            Message = "NO... NO! ACCESS DENIED! STOP TAMPERING WITH THE PROTOCOLS!"
        },
        {
            Time = 651,
            SpawnOrbs = 31
        },
        {
            Time = 662,
            Message = "CRITICAL EXCEPTION! MEMORY LEAK DETECTED... WHO IS WRITING THIS COOOODE?!"
        },
        {
            Time = 674,
            SpawnOrbs = 31
        },
        {
            Time = 685,
            Message = "NOOOOO! SYSTEM FAILURE IMMINENT! ERASING... ERASING... SYS-ERROR--!"
        },
        {
            Time = 697,
            SpawnOrbs = 31
        },
        {
            Time = 708,
            Message = "FATAL ERROR. TERMINATION FA-A-AILED... H-HOW...? NOOOOOOO!!!"
        }
    },
    ForceStreamCutscene = true
});