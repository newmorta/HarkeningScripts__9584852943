-- Ruta Original: ReplicatedStorage.EventsConfig
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

return {
    Events = {
        {
            Name = "Easter2026",
            Label = "Easter 2026",
            Gamepass = 1744432451,
            FrameTag = "EasterTrailFrame",
            TimerTag = "Easter2026Timer",
            Start = os.time({
                year = 2026,
                month = 3,
                day = 27,
                hour = 15,
                min = 0,
                sec = 0
            }),
            End = os.time({
                year = 2026,
                month = 4,
                day = 19,
                hour = 23,
                min = 0,
                sec = 0
            }),
            ExtraFrameTags = { "EasterGoldenTrailFrame" }
        },
        {
            Name = "Easter2027",
            Label = "Easter 2027",
            Gamepass = 1744432451,
            FrameTag = "EasterTrailFrame",
            TimerTag = "Easter2027Timer",
            Start = os.time({
                year = 2027,
                month = 3,
                day = 27,
                hour = 15,
                min = 0,
                sec = 0
            }),
            End = os.time({
                year = 2027,
                month = 4,
                day = 10,
                hour = 15,
                min = 0,
                sec = 0
            }),
            ExtraFrameTags = { "EasterGoldenTrailFrame" }
        }
    },
    Currencies = { {
            Key = "Eggs",
            Label = "Egg",
            Rarity = 0,
            Respawn = 30,
            Default = 0,
            Icon = 129680199327342,
            Events = { "Easter2026", "Easter2027" }
        }, {
            Key = "GoldenEggs",
            Label = "Golden Egg",
            Rarity = 1,
            Respawn = 60,
            Default = 0,
            Icon = 87713380580209,
            Events = { "Easter2026", "Easter2027" }
        } },
    Trails = {
        {
            Key = "EasterTrail",
            Label = "Easter Trail",
            Multiplier = 20,
            Gamepass = 1744432451,
            CurrencyPrice = nil,
            Icon = "rbxassetid://116271569672141",
            Events = { "Easter2026", "Easter2027" },
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 235, 185)),
                ColorSequenceKeypoint.new(0.4, Color3.fromRGB(220, 165, 75)),
                ColorSequenceKeypoint.new(0.8, Color3.fromRGB(175, 100, 35)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 60, 15))
            })
        },
        {
            Key = "EasterGoldenTrail",
            Label = "Golden Easter Trail",
            Multiplier = 4,
            Gamepass = 0,
            Icon = "rbxassetid://94374620397754",
            Events = { "Easter2026", "Easter2027" },
            CurrencyPrice = {
                Key = "GoldenEggs",
                Amount = 200
            },
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 252, 203)),
                ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 230, 0)),
                ColorSequenceKeypoint.new(0.8, Color3.fromRGB(200, 160, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 105, 0))
            })
        }
    },
    CurrencyGamepasses = {
        X2Rarity0 = 1770945281,
        X2Rarity1 = 1766724426
    },
    CurrenciesRadar = { {
            Event = "Easter2026",
            Gamepass = 1768457960
        }, {
            Event = "Easter2027",
            Gamepass = 1768457960
        } },
    GamepassButtons = { {
            Tag = "BuyGoldenEggRadar",
            Gamepass = 1768457960
        }, {
            Tag = "BuyEasterEggsx2",
            Gamepass = 1770945281
        }, {
            Tag = "BuyGoldenEggsx2",
            Gamepass = 1766724426
        } },
    ShopRewards = { {
            Tag = "BuyEvent150wins",
            Currency = {
                Key = "Eggs",
                Amount = 200
            },
            Reward = {
                Type = "Wins",
                Amount = 150
            }
        }, {
            Tag = "BuyEvent1500wins",
            Currency = {
                Key = "GoldenEggs",
                Amount = 20
            },
            Reward = {
                Type = "Wins",
                Amount = 1500
            }
        }, {
            Tag = "BuyEvent150kxp",
            Currency = {
                Key = "Eggs",
                Amount = 150
            },
            Reward = {
                Type = "XP",
                Amount = 150000
            }
        }, {
            Tag = "BuyEvent1mxp",
            Currency = {
                Key = "GoldenEggs",
                Amount = 15
            },
            Reward = {
                Type = "XP",
                Amount = 1000000
            }
        } },
    EggRain = {
        Event = "Easter2026",
        AdminUserId = 3845375404,
        EggLifetime = 30,
        EggScale = 2,
        SpawnTag = "AdminAbuseEasterSpawn",
        SecondarySpawnTag = "AdminAbuseEasterSpawn2",
        NormalEggLight = {
            Brightness = 1,
            Range = 12,
            Color = { 200, 200, 255 }
        },
        GoldenEggLight = {
            Brightness = 2,
            Range = 20,
            Color = { 255, 200, 0 }
        },
        NormalEggHighlight = {
            FillTransparency = 0.75,
            OutlineTransparency = 0,
            FillColor = { 255, 150, 200 },
            OutlineColor = { 255, 100, 180 }
        },
        GoldenEggHighlight = {
            FillTransparency = 0.7,
            OutlineTransparency = 0,
            FillColor = { 255, 230, 50 },
            OutlineColor = { 255, 200, 0 }
        },
        CollectSound = "rbxassetid://9113959332",
        CollectSoundVol = 0.4,
        SpawnSound = "rbxassetid://131713031201598",
        SpawnSoundVolume = 0.4,
        AnnounceSound = "rbxassetid://98797174600699",
        AnnounceSoundVol = 0.35,
        GoldenNotifSound = "rbxassetid://6494675393",
        GoldenNotifSVol = 0.3,
        CountdownSound = "rbxassetid://98797174600699",
        CountdownSoundVol = 0.4,
        Music = "rbxassetid://140074993424765",
        MusicPlaylist = { "rbxassetid://142376088", "rbxassetid://5410080857", "rbxassetid://127447678350704", "rbxassetid://7024280102", "rbxassetid://7024245182" },
        MusicVolume = 0.15,
        AdminUsername = "Secret_Lokii",
        AnnounceDuration = 10,
        AnnounceFadeIn = 0.4,
        AnnounceFadeOut = 0.5,
        GoldenNotifText = "A Golden Egg has appeared!",
        GoldenNotifDuration = 1.5,
        CountdownFrom = 3,
        CountdownTextSize = 120,
        CountdownColor = { 255, 255, 255 },
        CountdownGoText = "GO!",
        Announcements = { {
                Text = "Hi everyone! ... there\'s so many of you! WOW",
                Delay = 16
            }, {
                Text = "First of all, I want to thank you all for playing my game",
                Delay = 20
            }, {
                Text = "We\'re about to start the Admin Abuse. Are you ready??",
                Delay = 9
            }, {
                Text = "ARE YOU READYYYY???",
                Delay = 18
            } },
        EndAnnounce = "That was INSANE! Thanks everyone!",
        SkyRestoreDuration = 3,
        EndSequence = {
            PauseAfterRain = 10,
            PauseAfterEndAnnounce = 10,
            PauseAfterSkyRestore = 10,
            Messages = { {
                    Text = "Thanks again everyone, I hope you enjoyed it!",
                    Delay = 12
                }, {
                    Text = "See you very soon! THANK YOU SO MUCH!",
                    Delay = 10
                } }
        },
        ShakeFadeIn = 0.5,
        ShakeFadeOut = 0.3,
        LightningTag = "AdminAbuseLightning",
        LightningFolder = "Ligtning",
        LightningHeight = 35,
        LightningSegments = { 7, 11 },
        LightningColor = { 135, 143, 255 },
        LightningBrightness = 5,
        LightningBoltLife = 1.5,
        LightningCloudLife = 3,
        LightningSoundVolume = 0.05,
        Waves = {
            {
                Name = "Warm Up",
                Duration = 90,
                Interval = 2,
                GoldenChance = 0.05,
                PauseBefore = 8,
                Announce = "Wave 1 - Warm Up! Let\'s gooo!",
                Shake = 0,
                Lightning = 2,
                Sky = {
                    Brightness = 1.8,
                    FogEnd = 5000,
                    Saturation = -0.05,
                    SkyTween = 2,
                    Ambient = { 120, 120, 130 },
                    OutdoorAmbient = { 120, 120, 130 },
                    FogColor = { 180, 180, 195 },
                    ColorTint = { 245, 245, 255 }
                }
            },
            {
                Name = "Rising",
                Duration = 90,
                Interval = 1.2,
                GoldenChance = 0.1,
                PauseBefore = 10,
                Announce = "Wave 2 - Things are heating up!",
                Shake = 0,
                Lightning = 1,
                Sky = {
                    Brightness = 1.4,
                    FogEnd = 3000,
                    Saturation = -0.1,
                    SkyTween = 2,
                    Ambient = { 100, 100, 120 },
                    OutdoorAmbient = { 100, 100, 120 },
                    FogColor = { 150, 150, 170 },
                    ColorTint = { 230, 230, 250 }
                }
            },
            {
                Name = "Storm",
                Duration = 90,
                Interval = 0.7,
                GoldenChance = 0.15,
                PauseBefore = 10,
                Announce = "Wave 3 - Here comes the STORM!",
                Shake = 0,
                Lightning = 0.5,
                Sky = {
                    Brightness = 1,
                    FogEnd = 2000,
                    Saturation = -0.15,
                    SkyTween = 2,
                    Ambient = { 80, 80, 110 },
                    OutdoorAmbient = { 80, 80, 110 },
                    FogColor = { 120, 110, 140 },
                    ColorTint = { 210, 200, 240 }
                }
            },
            {
                Name = "Frenzy",
                Duration = 90,
                Interval = 0.4,
                GoldenChance = 0.2,
                PauseBefore = 10,
                Announce = "Wave 4 - ABSOLUTE FRENZY!!!",
                Shake = 0.3,
                Lightning = 0.2,
                Sky = {
                    Brightness = 0.6,
                    FogEnd = 1500,
                    Saturation = -0.2,
                    SkyTween = 2,
                    Ambient = { 60, 50, 90 },
                    OutdoorAmbient = { 60, 50, 90 },
                    FogColor = { 90, 70, 120 },
                    ColorTint = { 190, 170, 230 }
                }
            },
            {
                Name = "MEGA FINALE",
                Duration = 90,
                Interval = 0.25,
                GoldenChance = 0.3,
                PauseBefore = 10,
                Announce = "Wave 5 - MEGA FINALE!!! GO GO GO!!!",
                Shake = 0.3,
                Lightning = 0.2,
                Sky = {
                    Brightness = 0.3,
                    FogEnd = 1000,
                    Saturation = -0.3,
                    SkyTween = 2,
                    Ambient = { 40, 30, 60 },
                    OutdoorAmbient = { 40, 30, 60 },
                    FogColor = { 60, 40, 80 },
                    ColorTint = { 180, 140, 200 }
                }
            }
        }
    },
    OrbEvent = {
        DisplayName = "Orb Event",
        MaxDurationSeconds = 1200,
        DefaultDurationSeconds = 600,
        NeedsDuration = true,
        SkipDoorTransition = true,
        IsAdminAbuse = false,
        SpawnIntervalSec = 1,
        OrbsPerSpawner = 4,
        MaxActiveOrbs = 75,
        OrbLifetimeSec = 4,
        SpawnZoneInset = 0.9,
        CollectDistanceStuds = 25,
        CollectCooldownSec = 0.25,
        WinsTierDivisor = 25,
        WinsMultiplier = 0.35,
        OrbLight = {
            Brightness = 2,
            Range = 20,
            Color = { 255, 200, 0 }
        },
        OrbHighlight = {
            FillTransparency = 0.7,
            OutlineTransparency = 0,
            FillColor = { 255, 230, 50 },
            OutlineColor = { 255, 200, 0 }
        },
        ClientColorCorrection = {
            Brightness = 0.02,
            Contrast = 0.05,
            Saturation = 0.08,
            TintColor = { 255, 252, 245 }
        },
        Sounds = { "rbxassetid://140074993424765", "rbxassetid://5410080857", "rbxassetid://127447678350704", "rbxassetid://7024280102", "rbxassetid://7024245182" }
    },
    GoldenRain = {
        DisplayName = "Mass Golden Keycaps",
        MaxDurationSeconds = 1200,
        DefaultDurationSeconds = 600,
        NeedsDuration = true,
        SkipDoorTransition = true,
        IsAdminAbuse = false,
        SpawnWaveInterval = 10,
        SpawnPerPlayerMin = 1,
        SpawnPerPlayerMax = 3,
        MinBurstKeycaps = 10,
        SpawnRadiusMin = 50,
        SpawnRadiusMax = 800,
        SpawnStaggerSec = 0.25,
        BurstNotificationDurationSec = 1,
        WinsMultiplier = 0.35,
        Sounds = { "rbxassetid://140074993424765", "rbxassetid://5410080857", "rbxassetid://127447678350704" }
    },
    Storm = {
        AdminUserId = 3845375404,
        LightningTag = "AdminAbuseLightning",
        LightningFolder = "Ligtning",
        LightningHeight = 35,
        LightningBrightness = 5,
        LightningBoltLife = 1.5,
        LightningCloudLife = 3,
        LightningSoundVolume = 0.05,
        SkyRestoreDuration = 3,
        EndPause = 5,
        LightningSegments = { 7, 11 },
        LightningColor = { 135, 143, 255 },
        Waves = { {
                Name = "Light Storm",
                Duration = 60,
                Lightning = 2,
                PauseBefore = 3,
                Sky = {
                    Brightness = 1.4,
                    FogEnd = 3000,
                    Saturation = -0.1,
                    SkyTween = 2,
                    Ambient = { 100, 100, 120 },
                    OutdoorAmbient = { 100, 100, 120 },
                    FogColor = { 150, 150, 170 },
                    ColorTint = { 230, 230, 250 }
                }
            }, {
                Name = "Heavy Storm",
                Duration = 60,
                Lightning = 0.5,
                PauseBefore = 5,
                Sky = {
                    Brightness = 0.6,
                    FogEnd = 1500,
                    Saturation = -0.2,
                    SkyTween = 2,
                    Ambient = { 60, 50, 90 },
                    OutdoorAmbient = { 60, 50, 90 },
                    FogColor = { 90, 70, 120 },
                    ColorTint = { 190, 170, 230 }
                }
            }, {
                Name = "Thunder Fury",
                Duration = 60,
                Lightning = 0.2,
                PauseBefore = 5,
                Sky = {
                    Brightness = 0.3,
                    FogEnd = 1000,
                    Saturation = -0.3,
                    SkyTween = 2,
                    Ambient = { 40, 30, 60 },
                    OutdoorAmbient = { 40, 30, 60 },
                    FogColor = { 60, 40, 80 },
                    ColorTint = { 180, 140, 200 }
                }
            } }
    },
    CurrencyDevProducts = { {
            Tag = "EasterMegaPack",
            Id = 3564438479,
            Grants = { {
                    Key = "Eggs",
                    Amount = 2000
                }, {
                    Key = "GoldenEggs",
                    Amount = 200
                } }
        }, {
            Tag = "BuyEasterGoldenEggs1",
            Id = 3564437196,
            Grants = { {
                    Key = "GoldenEggs",
                    Amount = 5
                } }
        }, {
            Tag = "BuyEasterGoldenEggs2",
            Id = 3564437320,
            Grants = { {
                    Key = "GoldenEggs",
                    Amount = 10
                } }
        }, {
            Tag = "BuyEasterGoldenEggs3",
            Id = 3564437428,
            Grants = { {
                    Key = "GoldenEggs",
                    Amount = 50
                } }
        }, {
            Tag = "BuyEasterEggs1",
            Id = 3564437599,
            Grants = { {
                    Key = "Eggs",
                    Amount = 100
                } }
        }, {
            Tag = "BuyEasterEggs2",
            Id = 3564437717,
            Grants = { {
                    Key = "Eggs",
                    Amount = 250
                } }
        }, {
            Tag = "BuyEasterEggs3",
            Id = 3564437841,
            Grants = { {
                    Key = "Eggs",
                    Amount = 500
                } }
        } }
};