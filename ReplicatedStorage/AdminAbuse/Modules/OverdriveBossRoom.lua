-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.OverdriveBossRoom
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local OverdriveBossRoom = ReplicatedStorage.AdminAbuse.OverdriveBossRoom;
local Assets = OverdriveBossRoom.Assets;
local VFX = OverdriveBossRoom.VFX;
local SFX = OverdriveBossRoom.SFX;
local OverdriveConfig = require(script.OverdriveConfig);
local BossClientBase = require(ReplicatedStorage.AdminAbuse.Modules.Shared.BossClientBase);
local OverdriveOrbController = require(script.OverdriveOrbController);
local OverdriveCutscenes = require(script.OverdriveCutscenes);
local OverdriveSoundIds = require(script.OverdriveSoundIds);
local u1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = OverdriveOrbController.new();
local u8 = nil;

local function findLiveMap() -- Line: 50
    local v9 = workspace:FindFirstChild("AdminAbuse") and v9:FindFirstChild("Map");

    if not v9 then
        return nil;
    end;

    for _, child in v9:GetChildren() do
        if child:GetAttribute("AdminAbuseLiveMap") then
            return child;
        end;
    end;

    return nil;
end;

local function playExplosionSFX(p10, p11) -- Line: 60
    -- upvalues: SFX (copy), Debris (copy)
    local ExplosionSFX = SFX:FindFirstChild("ExplosionSFX");

    if ExplosionSFX then
        local Part = Instance.new("Part");
        Part.Size = Vector3.new(1, 1, 1);
        Part.CFrame = CFrame.new(p10);
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.Transparency = 1;
        Part.CastShadow = false;
        Part.Parent = p11;
        local v12 = ExplosionSFX:Clone();
        v12.Parent = Part;
        v12.Volume = 10;
        v12.RollOffMaxDistance = 500;
        v12:Play();
        Debris:AddItem(Part, (math.max(v12.TimeLength, 4)));
    end;
end;

local function _tweenModelPivot(u13, u14, u15, p16, p17) -- Line: 83
    -- upvalues: RunService (copy), TweenService (copy)
    local u18 = u13:GetPivot();
    local u19 = p16 or Enum.EasingStyle.Linear;
    local u20 = p17 or Enum.EasingDirection.Out;
    local u21 = os.clock();
    local u22 = nil;
    u22 = RunService.Heartbeat:Connect(function() -- Line: 95
        -- upvalues: u13 (copy), u22 (ref), u21 (copy), u15 (copy), TweenService (ref), u19 (copy), u20 (copy), u18 (copy), u14 (copy)
        if not u13.Parent then
            u22:Disconnect();

            return;
        end;

        local v23 = (os.clock() - u21) / u15;
        local v24 = math.min(v23, 1);
        u13:PivotTo(u18:Lerp(u14, (TweenService:GetValue(v24, u19, u20))));

        if v24 >= 1 then
            u22:Disconnect();
        end;
    end);
end;

local u25 = {};
local u26 = nil;

local function _gfAddRotJob(p27, p28, p29) -- Line: 110
    -- upvalues: u25 (copy), u26 (ref), RunService (copy)
    local v30 = {
        angle = 0,
        clone = p27,
        baseCF = p28,
        deadline = os.clock() + p29
    };
    table.insert(u25, v30);

    if u26 then
        return;
    end;

    u26 = RunService.Heartbeat:Connect(function(p31) -- Line: 118
        -- upvalues: u25 (ref), u26 (ref)
        local v32 = os.clock();
        local v33 = 1;

        while v33 <= #u25 do
            local v34 = u25[v33];

            if v34.deadline <= v32 or not v34.clone.Parent then
                table.remove(u25, v33);
            else
                v34.angle = v34.angle + 3.7699111843077517 * p31;
                v34.clone:PivotTo(v34.baseCF * CFrame.Angles(0, v34.angle, 0));
                v33 = v33 + 1;
            end;
        end;

        if #u25 == 0 then
            u26:Disconnect();
            u26 = nil;
        end;
    end);
end;

local function _clearGradient() -- Line: 138
    -- upvalues: u6 (ref), u5 (ref)
    if u6 then
        u6:Cancel();
        u6:Destroy();
        u6 = nil;
    end;

    if u5 then
        u5:Destroy();
        u5 = nil;
    end;
end;

local u138 = BossClientBase.new({
    sseChannelName = "OverdriveBossRoom",
    bossDisplayName = "0V3RDRIVE",
    bossIcon = OverdriveConfig.BossIcon,
    barTweenDurationSec = OverdriveConfig.BarTweenDurationSec,
    phaseThresholds = OverdriveConfig.PhaseThresholds,
    colorHpFill = Color3.fromRGB(0, 160, 180),

    onFx = function(p35, u36, u37) -- Line: 155, Name: onFx
        -- upvalues: findLiveMap (copy), Assets (copy), OverdriveConfig (copy), TweenService (copy), Players (copy), RunService (copy), VFX (copy), OverdriveBossRoom (copy), playExplosionSFX (copy), _gfAddRotJob (copy), Debris (copy), u3 (ref), _tweenModelPivot (copy), u4 (ref), u7 (copy), u1 (copy), OverdriveCutscenes (copy), OverdriveSoundIds (copy)
        assert(p35, "Constructor - onFx missing cmd arg");
        assert(u36, "Constructor - onFx missing val arg");

        if p35 == "SwordTango" then
            task.spawn(function() -- Line: 160
                -- upvalues: findLiveMap (ref), Assets (ref), OverdriveConfig (ref), u36 (copy), TweenService (ref), Players (ref), RunService (ref)
                local v38 = findLiveMap();

                if not v38 then
                    return;
                end;

                local WindforceTango = Assets:FindFirstChild("WindforceTango", true);

                if not WindforceTango then
                    warn("SwordTango client - WindforceTango template not found");

                    return;
                end;

                local u39 = WindforceTango:Clone();
                local v40 = OverdriveConfig.SwordTangoScaleMax or 2.5;
                u39:ScaleTo(1 + math.random() * (v40 - 1));

                for _, descendant in u39:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.Transparency = 1;
                    end;
                end;

                local v41 = v38:FindFirstChild("Scriptables") and v41:FindFirstChild("Debris");
                u39.Parent = v41 or v38;
                local v42 = Vector3.new(u36.x, u36.y, u36.z);
                u39:PivotTo(CFrame.new(v42 + Vector3.new(0, 50, 0)));
                local PrimaryPart = u39.PrimaryPart;

                if not PrimaryPart then
                    warn("SwordTango client - WindforceTango has no PrimaryPart");
                    u39:Destroy();

                    return;
                end;

                local v43 = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

                for _, descendant in u39:GetDescendants() do
                    if descendant:IsA("BasePart") and descendant ~= PrimaryPart then
                        TweenService:Create(descendant, v43, {
                            Transparency = 0
                        }):Play();
                    end;
                end;

                task.wait(0.8);
                local u44 = CFrame.new(v42);
                TweenService:Create(PrimaryPart, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    CFrame = u44
                }):Play();
                task.wait(1.5);
                local v45 = {};

                for _, descendant in u39:GetDescendants() do
                    if descendant:IsA("BasePart") and descendant.Name == "Windforce" then
                        local v49 = descendant.Touched:Connect(function(p46) -- Line: 222
                            -- upvalues: Players (ref)
                            local v47 = Players.LocalPlayer and v47.Character;

                            if not (v47 and p46:IsDescendantOf(v47)) then
                                return;
                            end;

                            local v48 = v47:FindFirstChildOfClass("Humanoid");

                            if v48 then
                                v48:TakeDamage(25);
                            end;
                        end);
                        table.insert(v45, v49);
                    end;
                end;

                local u50 = type(u36.duration) ~= "number" and 5 or u36.duration;
                local v51;

                if type(u36.phase) == "number" then
                    local v52 = math.floor(u36.phase);
                    v51 = math.clamp(v52, 1, 5);
                else
                    v51 = 1;
                end;

                local u53 = (OverdriveConfig.SwordTangoRotSpeedByPhase or {})[v51] or 1;
                local u54 = 0;
                local u55 = 0;
                local u56 = nil;
                u56 = RunService.Heartbeat:Connect(function(p57) -- Line: 245
                    -- upvalues: u55 (ref), u39 (copy), u50 (copy), u56 (ref), u54 (ref), u53 (copy), PrimaryPart (copy), u44 (copy)
                    u55 = u55 + p57;

                    if not u39.Parent or u50 <= u55 then
                        u56:Disconnect();

                        return;
                    end;

                    u54 = u54 + u53 * p57;
                    PrimaryPart.CFrame = u44 * CFrame.Angles(0, u54, 0);
                end);
                task.wait(u50);
                pcall(function() -- Line: 257
                    -- upvalues: u56 (ref)
                    u56:Disconnect();
                end);

                for _, v in v45 do
                    v:Disconnect();
                end;

                table.clear(v45);

                if not u39.Parent then
                    return;
                end;

                local v58 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

                for _, descendant in u39:GetDescendants() do
                    if descendant:IsA("BasePart") and descendant ~= PrimaryPart then
                        TweenService:Create(descendant, v58, {
                            Transparency = 1
                        }):Play();
                    end;
                end;

                task.wait(1);

                if u39.Parent then
                    u39:Destroy();
                end;
            end);

            return;
        end;

        if p35 == "GFWarn" then
            task.spawn(function() -- Line: 275
                -- upvalues: findLiveMap (ref), u36 (copy), TweenService (ref)
                local v59 = findLiveMap();

                if not v59 then
                    return;
                end;

                local v60 = Vector3.new(u36.x, u36.y, u36.z);
                local v61 = type(u36.t) ~= "number" and 2.5 or u36.t;
                local v62 = type(u36.r) ~= "number" and 18 or u36.r;
                local Part = Instance.new("Part");
                Part.Shape = Enum.PartType.Cylinder;
                Part.Size = Vector3.new(0.35, v62 * 2, v62 * 2);
                Part.CFrame = CFrame.new(v60) * CFrame.Angles(0, 0, 1.5707963267948966);
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CastShadow = false;
                Part.Material = Enum.Material.Neon;
                Part.Color = Color3.fromRGB(255, 90, 10);
                Part.Transparency = 0.45;
                Part.Parent = v59;
                task.wait(v61);
                TweenService:Create(Part, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Transparency = 1
                }):Play();
                task.wait(0.3);

                if Part.Parent then
                    Part:Destroy();
                end;
            end);

            return;
        end;

        if p35 == "GFAttack" then
            task.spawn(function() -- Line: 306
                -- upvalues: findLiveMap (ref), u36 (copy), VFX (ref), TweenService (ref)
                local v63 = findLiveMap();

                if not v63 then
                    return;
                end;

                local v64 = Vector3.new(u36.x, u36.y, u36.z);
                local v65 = type(u36.upSec) ~= "number" and 1.2 or u36.upSec;
                local v66 = type(u36.downSec) ~= "number" and 0.8 or u36.downSec;
                local InitialExplosionBall = VFX:FindFirstChild("InitialExplosionBall");

                if not InitialExplosionBall then
                    warn("OverdrivebossRoom.SSE.GFAttack - templateBall not found");

                    return;
                end;

                local v67 = InitialExplosionBall:Clone();
                v67.Size = Vector3.new(18, 42, 18);
                v67.CFrame = CFrame.new(v64);
                v67.Anchored = true;
                v67.CanCollide = false;
                v67.CastShadow = false;
                v67.Material = Enum.Material.Neon;
                v67.Color = Color3.fromRGB(255, 128, 60);
                v67.Transparency = 0;
                v67.Parent = v63.Scriptables.Debris;
                local PointLight = Instance.new("PointLight", v67);
                PointLight.Brightness = 10;
                PointLight.Color = Color3.fromRGB(255, 140, 40);
                PointLight.Range = 48;
                local Part = Instance.new("Part");
                Part.Shape = Enum.PartType.Ball;
                Part.Size = Vector3.new(7, 7, 7);
                Part.CFrame = CFrame.new(v64);
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CastShadow = false;
                Part.Material = Enum.Material.Neon;
                Part.Color = Color3.fromRGB(255, 100, 20);
                Part.Transparency = 0.1;
                Part.Parent = v63;
                local PointLight2 = Instance.new("PointLight", Part);
                PointLight2.Brightness = 5;
                PointLight2.Color = Color3.fromRGB(255, 80, 10);
                PointLight2.Range = 30;
                local Fire = Instance.new("Fire");
                Fire.Size = 15;
                Fire.Parent = Part;
                local v68 = CFrame.new(v64 + Vector3.new(0, 20, 0));
                TweenService:Create(Part, TweenInfo.new(v65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    CFrame = v68
                }):Play();
                local v69 = v65 * 0.55;
                TweenService:Create(v67, TweenInfo.new(v69, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Transparency = 1,
                    Size = Vector3.new(28, 65, 28)
                }):Play();
                task.wait(v69);
                v67:Destroy();
                task.wait(v65 - v69);
                task.wait(0.08);
                TweenService:Create(Part, TweenInfo.new(v66, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    CFrame = CFrame.new(v64)
                }):Play();
                task.wait(v66);

                if Part.Parent then
                    Part:Destroy();
                end;
            end);

            return;
        end;

        if p35 == "GFImpact" then
            task.spawn(function() -- Line: 388
                -- upvalues: findLiveMap (ref), u36 (copy), OverdriveBossRoom (ref), playExplosionSFX (ref), TweenService (ref), _gfAddRotJob (ref)
                local v70 = findLiveMap();

                if not v70 then
                    return;
                end;

                local v71 = Vector3.new(u36.x, u36.y, u36.z);
                local v72 = OverdriveBossRoom:FindFirstChild("VFX") and v72:FindFirstChild("FireballExplosion");

                if not v72 then
                    warn("[GroundFireball client] FireballExplosion VFX not found");

                    return;
                end;

                local v73 = v72:Clone();
                v73:ScaleTo(5);
                v73:PivotTo(CFrame.new(v71));
                v73.Parent = v70;
                playExplosionSFX(v71, v70.Scriptables.Debris);
                local v74 = {};
                local v75 = {};

                for _, descendant in v73:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        table.insert(v74, descendant);
                        table.insert(v75, descendant.Size);
                    end;
                end;

                local v76 = TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

                for i, v in v74 do
                    TweenService:Create(v, v76, {
                        Transparency = 1,
                        Size = v75[i] * 4
                    }):Play();
                end;

                _gfAddRotJob(v73, CFrame.new(v71), 1.7000000000000002);
                task.wait(1.7000000000000002);

                if v73.Parent then
                    v73:Destroy();
                end;
            end);

            return;
        end;

        if p35 == "HMHover" then
            task.spawn(function() -- Line: 437
                -- upvalues: findLiveMap (ref), Assets (ref), u36 (copy), Debris (ref), OverdriveConfig (ref), u3 (ref), _tweenModelPivot (ref)
                local v77 = findLiveMap();

                if not v77 then
                    return;
                end;

                local Banhammer = Assets:FindFirstChild("Banhammer", true);

                if not Banhammer then
                    warn("[HammerSmash client] Banhammer template not found in Assets");

                    return;
                end;

                local v78 = Banhammer:Clone();

                if not v78.PrimaryPart then
                    warn("[HammerSmash client] Banhammer has no PrimaryPart set");
                    v78:Destroy();

                    return;
                end;

                for _, descendant in v78:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.Anchored = true;
                        descendant.CanCollide = false;
                        descendant.CastShadow = false;
                    end;
                end;

                local v79 = v77:FindFirstChild("Scriptables") and v79:FindFirstChild("Debris");
                v78.Parent = v79 or v77;
                local v80 = u36.cy + u36.height;
                local v81 = type(u36.steps) ~= "number" and 3 or math.max(u36.steps, 1);
                local v82 = type(u36.hoverSec) ~= "number" and 3 or u36.hoverSec;
                local v83 = v82 / (v81 + 1);
                local v84 = CFrame.Angles(1.5707963267948966, 0, 0);
                Debris:AddItem(v78, v82 + OverdriveConfig.HammerSmashWarnSec + OverdriveConfig.HammerSmashPrepareSec + OverdriveConfig.HammerSmashSmashSec + 2);
                local HammerSmashZone = v78:FindFirstChild("HammerSmashZone", true);
                local v85, v86;

                if HammerSmashZone and HammerSmashZone:IsA("BasePart") then
                    local Position = v78:GetPivot():ToObjectSpace(CFrame.new(HammerSmashZone.Position)).Position;
                    v85 = Position.X;
                    v86 = Position.Y;
                else
                    v85 = 0;
                    v86 = 0;
                end;

                v78:PivotTo(CFrame.new(u36.cx - v85, v80, u36.cz - v86) * v84);
                u3 = v78;

                for _ = 1, v81 do
                    if not v78.Parent then
                        return;
                    end;

                    local v87 = u36.cx + (math.random() * 2 - 1) * u36.hx - v85;
                    local v88 = u36.cz + (math.random() * 2 - 1) * u36.hz - v86;
                    _tweenModelPivot(v78, CFrame.new(v87, v80, v88) * v84, v83, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut);
                    task.wait(v83);
                end;

                if not v78.Parent then
                    return;
                end;

                local v89 = math.max(v82 - v83 * v81, 0.1);
                _tweenModelPivot(v78, CFrame.new(u36.tx - v85, u36.ty + u36.height, u36.tz - v86) * v84, v89, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                task.wait(v89);
            end);

            return;
        end;

        if p35 == "HMWarn" then
            task.spawn(function() -- Line: 509
                -- upvalues: findLiveMap (ref), u36 (copy), TweenService (ref)
                local v90 = findLiveMap();

                if not v90 then
                    return;
                end;

                local v91 = type(u36.t) ~= "number" and 2.5 or u36.t;
                local v92 = type(u36.r) ~= "number" and 15 or u36.r;
                local v93 = Vector3.new(u36.x, u36.y, u36.z);
                local Part = Instance.new("Part");
                Part.Shape = Enum.PartType.Cylinder;
                Part.Size = Vector3.new(0.35, v92, v92);
                Part.CFrame = CFrame.new(v93) * CFrame.Angles(0, 0, 1.5707963267948966);
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CastShadow = false;
                Part.Material = Enum.Material.Neon;
                Part.Color = Color3.fromRGB(255, 60, 0);
                Part.Transparency = 0.4;
                Part.Parent = v90;
                task.wait(v91);
                TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Transparency = 1
                }):Play();
                task.wait(0.25);

                if Part.Parent then
                    Part:Destroy();
                end;
            end);

            return;
        end;

        if p35 == "HMSmash" then
            task.spawn(function() -- Line: 541
                -- upvalues: u3 (ref), u36 (copy), _tweenModelPivot (ref)
                local v94 = u3;

                if not (v94 and v94.Parent) then
                    return;
                end;

                if not v94.PrimaryPart then
                    return;
                end;

                local v95 = type(u36.prepareSec) ~= "number" and 0.5 or u36.prepareSec;
                local v96 = type(u36.smashSec) ~= "number" and 0.22 or u36.smashSec;
                local v97 = v94:GetPivot();
                _tweenModelPivot(v94, v97 * CFrame.Angles(-1.5707963267948966, 0, 0), v95, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                task.wait(v95);

                if not v94.Parent then
                    return;
                end;

                _tweenModelPivot(v94, v97, v96, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
                task.wait(v96);
            end);

            return;
        end;

        if p35 == "HMImpact" then
            task.spawn(function() -- Line: 562
                -- upvalues: findLiveMap (ref), u36 (copy), OverdriveBossRoom (ref), playExplosionSFX (ref), TweenService (ref), _gfAddRotJob (ref), u3 (ref)
                local v98 = findLiveMap();

                if not v98 then
                    return;
                end;

                local v99 = Vector3.new(u36.x, u36.y, u36.z);
                local v100 = OverdriveBossRoom:FindFirstChild("VFX") and v100:FindFirstChild("FireballExplosion");

                if v100 then
                    local u101 = v100:Clone();
                    u101:ScaleTo(5);
                    u101:PivotTo(CFrame.new(v99));
                    u101.Parent = v98;
                    playExplosionSFX(v99, v98.Scriptables.Debris);
                    local v102 = {};
                    local v103 = {};

                    for _, descendant in u101:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            table.insert(v102, descendant);
                            table.insert(v103, descendant.Size);
                        end;
                    end;

                    local v104 = TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

                    for i, v in v102 do
                        TweenService:Create(v, v104, {
                            Transparency = 1,
                            Size = v103[i] * 4
                        }):Play();
                    end;

                    _gfAddRotJob(u101, CFrame.new(v99), 1.7000000000000002);
                    task.spawn(function() -- Line: 601
                        -- upvalues: u101 (copy)
                        task.wait(1.7000000000000002);

                        if u101.Parent then
                            u101:Destroy();
                        end;
                    end);
                end;

                if u3 and u3.Parent then
                    u3:Destroy();
                end;

                u3 = nil;
            end);

            return;
        end;

        if p35 == "SHMHover" then
            task.spawn(function() -- Line: 615
                -- upvalues: findLiveMap (ref), Assets (ref), u36 (copy), Debris (ref), OverdriveConfig (ref), u4 (ref), _tweenModelPivot (ref)
                local v105 = findLiveMap();

                if not v105 then
                    return;
                end;

                local Banhammer = Assets:FindFirstChild("Banhammer", true);

                if not Banhammer then
                    warn("[SuperHammerSmash client] Banhammer template not found in Assets");

                    return;
                end;

                local v106 = Banhammer:Clone();
                v106:ScaleTo(3);

                if not v106.PrimaryPart then
                    warn("[SuperHammerSmash client] Banhammer has no PrimaryPart set");
                    v106:Destroy();

                    return;
                end;

                for _, descendant in v106:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.Anchored = true;
                        descendant.CanCollide = false;
                        descendant.CastShadow = false;
                    end;
                end;

                local v107 = v105:FindFirstChild("Scriptables") and v107:FindFirstChild("Debris");
                v106.Parent = v107 or v105;
                local v108 = u36.cy + u36.height;
                local v109 = type(u36.steps) ~= "number" and 3 or math.max(u36.steps, 1);
                local v110 = type(u36.hoverSec) ~= "number" and 3 or u36.hoverSec;
                local v111 = v110 / (v109 + 1);
                local v112 = CFrame.Angles(1.5707963267948966, 0, 0);
                Debris:AddItem(v106, v110 + OverdriveConfig.SuperHammerSmashWarnSec + OverdriveConfig.SuperHammerSmashPrepareSec + OverdriveConfig.SuperHammerSmashSmashSec + 2);
                local HammerSmashZone = v106:FindFirstChild("HammerSmashZone", true);
                local v113, v114;

                if HammerSmashZone and HammerSmashZone:IsA("BasePart") then
                    local Position = v106:GetPivot():ToObjectSpace(CFrame.new(HammerSmashZone.Position)).Position;
                    v113 = Position.X;
                    v114 = Position.Y;
                else
                    v113 = 0;
                    v114 = 0;
                end;

                v106:PivotTo(CFrame.new(u36.cx - v113, v108, u36.cz - v114) * v112);
                u4 = v106;

                for _ = 1, v109 do
                    if not v106.Parent then
                        return;
                    end;

                    local v115 = u36.cx + (math.random() * 2 - 1) * u36.hx - v113;
                    local v116 = u36.cz + (math.random() * 2 - 1) * u36.hz - v114;
                    _tweenModelPivot(v106, CFrame.new(v115, v108, v116) * v112, v111, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut);
                    task.wait(v111);
                end;

                if not v106.Parent then
                    return;
                end;

                local v117 = math.max(v110 - v111 * v109, 0.1);
                _tweenModelPivot(v106, CFrame.new(u36.tx - v113, u36.ty + u36.height, u36.tz - v114) * v112, v117, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                task.wait(v117);
            end);

            return;
        end;

        if p35 == "SHMWarn" then
            task.spawn(function() -- Line: 683
                -- upvalues: findLiveMap (ref), u36 (copy), TweenService (ref)
                local v118 = findLiveMap();

                if not v118 then
                    return;
                end;

                local v119 = type(u36.t) ~= "number" and 2.5 or u36.t;
                local v120 = type(u36.r) ~= "number" and 45 or u36.r;
                local v121 = Vector3.new(u36.x, u36.y, u36.z);
                local Part = Instance.new("Part");
                Part.Shape = Enum.PartType.Cylinder;
                Part.Size = Vector3.new(0.35, v120, v120);
                Part.CFrame = CFrame.new(v121) * CFrame.Angles(0, 0, 1.5707963267948966);
                Part.Anchored = true;
                Part.CanCollide = false;
                Part.CastShadow = false;
                Part.Material = Enum.Material.Neon;
                Part.Color = Color3.fromRGB(255, 60, 0);
                Part.Transparency = 0.4;
                Part.Parent = v118;
                task.wait(v119);
                TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Transparency = 1
                }):Play();
                task.wait(0.25);

                if Part.Parent then
                    Part:Destroy();
                end;
            end);

            return;
        end;

        if p35 == "SHMSmash" then
            task.spawn(function() -- Line: 715
                -- upvalues: u4 (ref), u36 (copy), _tweenModelPivot (ref)
                local v122 = u4;

                if not (v122 and v122.Parent) then
                    return;
                end;

                if not v122.PrimaryPart then
                    return;
                end;

                local v123 = type(u36.prepareSec) ~= "number" and 0.5 or u36.prepareSec;
                local v124 = type(u36.smashSec) ~= "number" and 0.22 or u36.smashSec;
                local v125 = v122:GetPivot();
                _tweenModelPivot(v122, v125 * CFrame.Angles(-1.5707963267948966, 0, 0), v123, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                task.wait(v123);

                if not v122.Parent then
                    return;
                end;

                _tweenModelPivot(v122, v125, v124, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
                task.wait(v124);
            end);

            return;
        end;

        if p35 == "SHMImpact" then
            task.spawn(function() -- Line: 736
                -- upvalues: findLiveMap (ref), u36 (copy), OverdriveBossRoom (ref), TweenService (ref), _gfAddRotJob (ref), u4 (ref)
                local v126 = findLiveMap();

                if not v126 then
                    return;
                end;

                local v127 = Vector3.new(u36.x, u36.y, u36.z);
                local v128 = OverdriveBossRoom:FindFirstChild("VFX") and v128:FindFirstChild("FireballExplosion");

                if v128 then
                    local u129 = v128:Clone();
                    u129:ScaleTo(15);
                    u129:PivotTo(CFrame.new(v127));
                    u129.Parent = v126;
                    local v130 = {};
                    local v131 = {};

                    for _, descendant in u129:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            table.insert(v130, descendant);
                            table.insert(v131, descendant.Size);
                        end;
                    end;

                    local v132 = TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

                    for i, v in v130 do
                        TweenService:Create(v, v132, {
                            Transparency = 1,
                            Size = v131[i] * 4
                        }):Play();
                    end;

                    _gfAddRotJob(u129, CFrame.new(v127), 1.7000000000000002);
                    task.spawn(function() -- Line: 770
                        -- upvalues: u129 (copy)
                        task.wait(1.7000000000000002);

                        if u129.Parent then
                            u129:Destroy();
                        end;
                    end);
                end;

                if u4 and u4.Parent then
                    u4:Destroy();
                end;

                u4 = nil;
            end);

            return;
        end;

        if p35 == "SpawnTixOrbs" then
            task.spawn(function() -- Line: 784
                -- upvalues: findLiveMap (ref), u7 (ref), u36 (copy)
                local v133 = findLiveMap();

                if v133 and not u7:isScanned() then
                    u7:scan(v133);
                end;

                u7:spawnOrbs(type(u36.amount) ~= "number" and 0 or u36.amount);
            end);

            return;
        end;

        if p35 == "SpawnFloatingObject" then
            if u36.chosenChild then
                local chosenChild = u36.chosenChild;
                local u134 = TweenService:Create(chosenChild, TweenInfo.new(5), {
                    Transparency = 0
                });
                u134:Play();
                local v135 = {
                    ax = 0,
                    ay = 0,
                    az = 0,
                    part = chosenChild,
                    baseCF = chosenChild.CFrame,
                    sxMul = (math.random(0, 1) == 0 and -1 or 1) * (0.7 + math.random() * 0.6),
                    syMul = (math.random(0, 1) == 0 and -1 or 1) * (0.7 + math.random() * 0.6),
                    szMul = (math.random(0, 1) == 0 and -1 or 1) * (0.7 + math.random() * 0.6)
                };
                table.insert(u1, v135);
                u134.Completed:Once(function() -- Line: 810
                    -- upvalues: u134 (copy)
                    u134:Destroy();
                end);
            end;
        else
            if p35 == "OpeningCutscene" then
                task.spawn(function() -- Line: 817
                    -- upvalues: u37 (copy), OverdriveCutscenes (ref), u36 (copy)
                    print("[OD] OpeningCutscene — bossClient:", u37, "| _screen:", u37 and u37._screen);

                    if u37 and u37._screen then
                        print("[OD] OpeningCutscene — _screen.Enabled BEFORE:", u37._screen.Enabled, "| Name:", u37._screen.Name);
                        u37._screen.Enabled = false;
                        print("[OD] OpeningCutscene — _screen.Enabled AFTER:", u37._screen.Enabled);
                    else
                        warn("[OD] OpeningCutscene — cannot hide bar: bossClient=", u37, "_screen=", u37 and u37._screen);
                    end;

                    OverdriveCutscenes.playStartCutscene(u36);

                    if u37 and u37._screen then
                        u37._screen.Enabled = true;
                        print("[OD] OpeningCutscene — _screen restored, Enabled:", u37._screen.Enabled);
                    end;
                end);

                return;
            end;

            if p35 == "Phase3Cutscene" then
                task.spawn(function() -- Line: 834
                    -- upvalues: u37 (copy), OverdriveCutscenes (ref), u36 (copy)
                    print("[OD] Phase3Cutscene — bossClient:", u37, "| _screen:", u37 and u37._screen);

                    if u37 and u37._screen then
                        print("[OD] Phase3Cutscene — _screen.Enabled BEFORE:", u37._screen.Enabled, "| Name:", u37._screen.Name);
                        u37._screen.Enabled = false;
                        print("[OD] Phase3Cutscene — _screen.Enabled AFTER:", u37._screen.Enabled);
                    else
                        warn("[OD] Phase3Cutscene — cannot hide bar: bossClient=", u37, "_screen=", u37 and u37._screen);
                    end;

                    OverdriveCutscenes.playPhase3Cutscene(u36);

                    if u37 and u37._screen then
                        u37._screen.Enabled = true;
                        print("[OD] Phase3Cutscene — _screen restored, Enabled:", u37._screen.Enabled);
                    end;
                end);

                return;
            end;

            if p35 == "EndingCutscene" then
                task.spawn(function() -- Line: 851
                    -- upvalues: u37 (copy), TweenService (ref), OverdriveConfig (ref), OverdriveCutscenes (ref), u36 (copy)
                    print("[OD] EndingCutscene — bossClient:", u37, "| _screen:", u37 and u37._screen);

                    if u37 then
                        if u37._hpTween then
                            u37._hpTween:Cancel();
                            u37._hpTween = nil;
                        end;

                        if u37._hpDriver and u37._bossMaxRef then
                            local v136 = TweenService:Create(u37._hpDriver, TweenInfo.new(OverdriveConfig.BarTweenDurationSec, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                Value = u37._bossMaxRef
                            });
                            u37._hpTween = v136;
                            v136:Play();
                            task.wait(OverdriveConfig.BarTweenDurationSec + 0.4);
                        end;

                        if u37._screen then
                            u37._screen.Enabled = false;
                            print("[OD] EndingCutscene — _screen hidden, Enabled:", u37._screen.Enabled);
                        else
                            warn("[OD] EndingCutscene — _screen is nil, cannot hide bar");
                        end;
                    else
                        warn("[OD] EndingCutscene — bossClient is nil");
                    end;

                    OverdriveCutscenes.playEnding(u36);
                end);

                return;
            end;

            local v137 = p35 == "PlayVoiceline" and OverdriveSoundIds.Voicelines[u36.key];

            if v137 then
                local Sound = Instance.new("Sound");
                Sound.SoundId = v137;
                Sound.Volume = 1;
                Sound.Parent = game:GetService("SoundService");
                Sound:Play();
                Sound.Ended:Once(function() -- Line: 885
                    -- upvalues: Sound (copy)
                    Sound:Destroy();
                end);
            end;
        end;
    end
});

local function applyDefaultBossBarStyle() -- Line: 893
    -- upvalues: u138 (copy), TweenService (copy), u6 (ref), u5 (ref)
    local _barFill = u138._barFill;

    if not _barFill then
        return;
    end;

    local u139 = TweenService:Create(_barFill, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(0, 160, 180)
    });
    u139:Play();
    u139.Completed:Once(function() -- Line: 899
        -- upvalues: u139 (copy)
        u139:Destroy();
    end);

    if u6 then
        u6:Cancel();
        u6:Destroy();
        u6 = nil;
    end;

    if u5 then
        u5:Destroy();
        u5 = nil;
    end;

    local UIGradient = Instance.new("UIGradient");
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(5, 5, 5)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(220, 220, 220)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
    });
    UIGradient.Rotation = 0;
    UIGradient.Offset = Vector2.new(-0.6, 0);
    UIGradient.Parent = _barFill;
    u5 = UIGradient;
    u6 = TweenService:Create(UIGradient, TweenInfo.new(4.1887902047863905, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Offset = Vector2.new(0.6, 0)
    });
    u6:Play();
end;

local function applyPhase3BossBarStyle() -- Line: 916
    -- upvalues: u138 (copy), TweenService (copy), u6 (ref), u5 (ref)
    local _barFill = u138._barFill;

    if not _barFill then
        return;
    end;

    local u140 = TweenService:Create(_barFill, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(140, 0, 0)
    });
    u140:Play();
    u140.Completed:Once(function() -- Line: 922
        -- upvalues: u140 (copy)
        u140:Destroy();
    end);

    if u6 then
        u6:Cancel();
        u6:Destroy();
        u6 = nil;
    end;

    if u5 then
        u5:Destroy();
        u5 = nil;
    end;

    local UIGradient = Instance.new("UIGradient");
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(5, 5, 5)),
        ColorSequenceKeypoint.new(0.68, Color3.fromRGB(220, 220, 220)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
    });
    UIGradient.Rotation = 0;
    UIGradient.Offset = Vector2.new(-0.65, 0);
    UIGradient.Parent = _barFill;
    u5 = UIGradient;
    u6 = TweenService:Create(UIGradient, TweenInfo.new(3.6959913571644627, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Offset = Vector2.new(0.65, 0)
    });
    u6:Play();
end;

local _onPhase = BossClientBase._onPhase;

function u138._onPhase(p141, p142) -- Line: 941
    -- upvalues: _onPhase (copy), applyPhase3BossBarStyle (copy)
    _onPhase(p141, p142);
    local v143;

    if type(p142) == "number" then
        local v144 = math.floor(p142);
        v143 = math.clamp(v144, 1, 100) or 1;
    else
        v143 = 1;
    end;

    if v143 >= 3 then
        applyPhase3BossBarStyle();
    end;
end;

return {
    IsAdminAbuse = true,
    NeedsDuration = false,
    SkipDoorCamera = true,

    Fire = function() -- Line: 955, Name: Fire
        -- upvalues: u138 (copy), applyDefaultBossBarStyle (copy), OverdriveCutscenes (copy), u8 (ref), u2 (ref), RunService (copy), u1 (copy)
        u138:fire();
        applyDefaultBossBarStyle();
        OverdriveCutscenes.startIdleAnimations();

        if u8 then
            task.cancel(u8);
            u8 = nil;
        end;

        u8 = task.spawn(function() -- Line: 961
            -- upvalues: OverdriveCutscenes (ref)
            while true do
                task.wait(2);
                OverdriveCutscenes.ensureIdleAnimations();
            end;
        end);

        if not u2 then
            u2 = RunService.Heartbeat:Connect(function(p145) -- Line: 969
                -- upvalues: u1 (ref)
                local v146 = #u1;

                while v146 >= 1 do
                    local v147 = u1[v146];

                    if v147.part.Parent then
                        v147.ax = v147.ax + v147.sxMul * 0.25 * p145;
                        v147.ay = v147.ay + v147.syMul * 0.45 * p145;
                        v147.az = v147.az + v147.szMul * 0.18 * p145;
                        v147.part.CFrame = v147.baseCF * CFrame.Angles(v147.ax, v147.ay, v147.az);
                    else
                        table.remove(u1, v146);
                    end;

                    v146 = v146 - 1;
                end;
            end);
        end;
    end,

    Stop = function() -- Line: 987, Name: Stop
        -- upvalues: u8 (ref), OverdriveCutscenes (copy), u2 (ref), u1 (copy), u6 (ref), u5 (ref), u138 (copy), u7 (copy)
        if u8 then
            task.cancel(u8);
            u8 = nil;
        end;

        OverdriveCutscenes.stopIdleAnimations();
        OverdriveCutscenes.stopAll();

        if u2 then
            u2:Disconnect();
            u2 = nil;
        end;

        table.clear(u1);

        if u6 then
            u6:Cancel();
            u6:Destroy();
            u6 = nil;
        end;

        if u5 then
            u5:Destroy();
            u5 = nil;
        end;

        u138:stop();
        u7:destroy();
    end
};