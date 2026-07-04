-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.IndependenceDay.FireworksController
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local IndependenceDayConfig = require(script.Parent.IndependenceDayConfig);
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};

local function easeOutQuad(p7) -- Line: 28
    return 1 - (1 - p7) ^ 2;
end;

local function quadBezier(p8, p9, p10, p11) -- Line: 32
    return p8:Lerp(p9, p11):Lerp(p9:Lerp(p10, p11), p11);
end;

local function cubicBezier(p12, p13, p14, p15, p16) -- Line: 36
    return p12:Lerp(p13, p16):Lerp(p13:Lerp(p14, p16), p16):Lerp(p13:Lerp(p14, p16):Lerp(p14:Lerp(p15, p16), p16), p16);
end;

local function sidewaysOffset(p17, p18, p19) -- Line: 41
    local v20 = p17 + math.random() * (p18 - p17);
    local v21 = math.cos(p19) * v20;
    local v22 = math.sin(p19) * v20;

    return Vector3.new(v21, 0, v22);
end;

local function orientToDirection(p23, p24, p25) -- Line: 52
    if p24.Magnitude < 0.001 then
        return CFrame.new(p23) * (p25 - p25.Position);
    end;

    local Unit = p24.Unit;
    local v26 = Unit:Dot(Vector3.new(0, 1, 0));
    local v27 = (math.abs(v26) <= 0.98 and Vector3.new(0, 1, 0) or p25.RightVector):Cross(Unit);

    if v27.Magnitude < 0.0001 then
        v27 = p25.RightVector;
    end;

    return CFrame.fromMatrix(p23, v27.Unit, Unit);
end;

local function setFireEnabled(p28, p29) -- Line: 71
    local FireAttach = p28:FindFirstChild("FireAttach");

    if FireAttach then
        for _, child in FireAttach:GetChildren() do
            if child:IsA("Fire") or child:IsA("ParticleEmitter") then
                child.Enabled = p29;
            end;
        end;

        return;
    end;

    warn("[FireworksController - missing FireAttach on]", p28:GetFullName());
end;

local function burstVfx(p30) -- Line: 85
    -- upvalues: IndependenceDayConfig (copy)
    local Explosion = p30:FindFirstChild("Explosion");

    if Explosion then
        for _, child in Explosion:GetChildren() do
            if child:IsA("ParticleEmitter") then
                child:Emit(child:GetAttribute("EmitCount") or IndependenceDayConfig.FIREWORK_DEFAULT_EMIT_COUNT);
            end;
        end;

        return;
    end;

    warn("[FireworksController - missing Explosion attachment on]", p30:GetFullName());
end;

local function getSfxSubfolder(p31) -- Line: 103
    -- upvalues: u6 (copy), ReplicatedStorage (copy)
    local v32 = u6[p31];

    if v32 and v32.Parent then
        return v32;
    end;

    local v33 = ReplicatedStorage:FindFirstChild("AdminAbuse") and v33:FindFirstChild("IndependenceDay") and v33:FindFirstChild("SFX") and v33:FindFirstChild(p31);

    if v33 then
        u6[p31] = v33;

        return v33;
    end;

    warn("[FireworksController - missing ReplicatedStorage.AdminAbuse.IndependenceDay.SFX." .. p31 .. "]");

    return nil;
end;

local function playRandomSfxAt(p34, p35) -- Line: 126
    -- upvalues: Debris (copy)
    if not p34 then
        return;
    end;

    local v36 = {};

    for _, child in p34:GetChildren() do
        if child:IsA("Sound") then
            table.insert(v36, child);
        end;
    end;

    if #v36 == 0 then
        warn("[FireworksController - no Sound children in]", p34:GetFullName());

        return;
    end;

    local v37 = v36[math.random(1, #v36)];
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.Transparency = 1;
    Part.Size = Vector3.new(1, 1, 1);
    Part.CFrame = CFrame.new(p35);
    Part.Parent = workspace;
    local v38 = v37:Clone();
    v38.Parent = Part;
    v38:Play();
    v38.Ended:Once(function() -- Line: 154
        -- upvalues: Part (copy)
        pcall(function() -- Line: 155
            -- upvalues: Part (ref)
            Part:Destroy();
        end);
    end);
    Debris:AddItem(Part, 12);
end;

local function getBasicFolder(p39) -- Line: 161
    local v40 = p39:FindFirstChild("Scriptables") and v40:FindFirstChild("Fireworks") and v40:FindFirstChild("Basic");

    if v40 then
        return v40;
    end;

    warn("[FireworksController - Scriptables/Fireworks/Basic not found]");

    return nil;
end;

local function getSparklesEmitter(p41) -- Line: 175
    local v42 = p41:FindFirstChild("Explosion") and v42:FindFirstChild("Sparkles");

    if v42 and v42:IsA("ParticleEmitter") then
        return v42;
    end;

    return nil;
end;

local function getSmokeEmitter(p43) -- Line: 184
    local v44 = p43:FindFirstChild("Explosion") and v44:FindFirstChild("SmokeParticle");

    if v44 and v44:IsA("ParticleEmitter") then
        return v44;
    end;

    return nil;
end;

local function getRigs(p45) -- Line: 197
    -- upvalues: u3 (copy), u4 (copy), u5 (copy)
    local v46 = {};

    for _, child in p45:GetChildren() do
        if child:IsA("BasePart") then
            if not u3[child] then
                u3[child] = child.CFrame;
            end;

            local v47 = child:FindFirstChild("Explosion") and v47:FindFirstChild("Sparkles");

            if not (v47 and v47:IsA("ParticleEmitter")) then
                v47 = nil;
            end;

            local v48 = child:FindFirstChild("Explosion") and v48:FindFirstChild("SmokeParticle");

            if not (v48 and v48:IsA("ParticleEmitter")) then
                v48 = nil;
            end;

            if v47 and not u4[v47] then
                u4[v47] = v47.Color;
            end;

            if v48 and not u5[v48] then
                u5[v48] = v48.Color;
            end;

            table.insert(v46, child);
        end;
    end;

    return v46;
end;

local function applyFireworkColor(p49, p50) -- Line: 221
    -- upvalues: u4 (copy)
    if not p50 then
        return nil;
    end;

    local v51 = p49:FindFirstChild("Explosion") and v51:FindFirstChild("Sparkles");

    if not (v51 and v51:IsA("ParticleEmitter")) then
        v51 = nil;
    end;

    if not v51 then
        warn("[FireworksController - missing Explosion.Sparkles on]", p49:GetFullName());

        return nil;
    end;

    if not u4[v51] then
        u4[v51] = v51.Color;
    end;

    v51.Color = ColorSequence.new(p50);

    return v51;
end;

local function applySmokeColor(p52, p53) -- Line: 237
    -- upvalues: u5 (copy)
    if not p53 then
        return nil;
    end;

    local v54 = p52:FindFirstChild("Explosion") and v54:FindFirstChild("SmokeParticle");

    if not (v54 and v54:IsA("ParticleEmitter")) then
        v54 = nil;
    end;

    if not v54 then
        warn("[FireworksController - missing Explosion.SmokeParticles on]", p52:GetFullName());

        return nil;
    end;

    if not u5[v54] then
        u5[v54] = v54.Color;
    end;

    v54.Color = ColorSequence.new(p53);

    return v54;
end;

local function getOrCreateDebrisFolder(p55) -- Line: 252
    local Scriptables = p55:FindFirstChild("Scriptables");
    local Debris2 = Scriptables:FindFirstChild("Debris");

    if Debris2 and Debris2:IsA("Folder") then
        return Debris2;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "Debris";
    Folder.Parent = Scriptables;

    return Folder;
end;

function u1.LaunchFirework(u56, u57) -- Line: 265
    -- upvalues: u2 (copy), setFireEnabled (copy), playRandomSfxAt (copy), getSfxSubfolder (copy), IndependenceDayConfig (copy), RunService (copy), orientToDirection (copy), applyFireworkColor (copy), applySmokeColor (copy), burstVfx (copy), u3 (copy), u4 (copy), u5 (copy)
    if not (u56 and u56:IsA("BasePart")) then
        warn("[FireworksController.LaunchFirework - Incorrect part arg]");

        return;
    end;

    if u2[u56] then
        return;
    end;

    u2[u56] = true;
    local CFrame2 = u56.CFrame;
    local Position = CFrame2.Position;
    setFireEnabled(u56, true);
    playRandomSfxAt(getSfxSubfolder("LaunchSounds"), Position);
    local v58 = math.random(IndependenceDayConfig.MIN_FIREWORK_HEIGHT, IndependenceDayConfig.MAX_FIREWORK_HEIGHT);
    local u59 = math.random() * 3.141592653589793 * 2;
    local u60 = math.rad(IndependenceDayConfig.FIREWORK_CURVE_ANGLE_JITTER_DEG);

    local function jitteredAngle() -- Line: 288
        -- upvalues: u59 (copy), u60 (copy)
        return u59 + (math.random() * 2 - 1) * u60;
    end;

    local v61 = v58 * (0.25 + math.random() * 0.15);
    local v62 = Position + Vector3.new(0, v61, 0);
    local FIREWORK_CURVE1_MIN_OFFSET = IndependenceDayConfig.FIREWORK_CURVE1_MIN_OFFSET;
    local FIREWORK_CURVE1_MAX_OFFSET = IndependenceDayConfig.FIREWORK_CURVE1_MAX_OFFSET;
    local v63 = u59 + (math.random() * 2 - 1) * u60;
    local v64 = FIREWORK_CURVE1_MIN_OFFSET + math.random() * (FIREWORK_CURVE1_MAX_OFFSET - FIREWORK_CURVE1_MIN_OFFSET);
    local v65 = math.cos(v63) * v64;
    local v66 = math.sin(v63) * v64;
    local u67 = v62 + Vector3.new(v65, 0, v66);
    local v68 = v58 * (0.6 + math.random() * 0.2);
    local v69 = Position + Vector3.new(0, v68, 0);
    local FIREWORK_CURVE2_MIN_OFFSET = IndependenceDayConfig.FIREWORK_CURVE2_MIN_OFFSET;
    local FIREWORK_CURVE2_MAX_OFFSET = IndependenceDayConfig.FIREWORK_CURVE2_MAX_OFFSET;
    local v70 = u59 + (math.random() * 2 - 1) * u60;
    local v71 = FIREWORK_CURVE2_MIN_OFFSET + math.random() * (FIREWORK_CURVE2_MAX_OFFSET - FIREWORK_CURVE2_MIN_OFFSET);
    local v72 = math.cos(v70) * v71;
    local v73 = math.sin(v70) * v71;
    local u74 = v69 + Vector3.new(v72, 0, v73);
    local v75 = Position + Vector3.new(0, v58, 0);
    local FIREWORK_END_DRIFT_MIN = IndependenceDayConfig.FIREWORK_END_DRIFT_MIN;
    local FIREWORK_END_DRIFT_MAX = IndependenceDayConfig.FIREWORK_END_DRIFT_MAX;
    local v76 = u59 + (math.random() * 2 - 1) * u60;
    local v77 = FIREWORK_END_DRIFT_MIN + math.random() * (FIREWORK_END_DRIFT_MAX - FIREWORK_END_DRIFT_MIN);
    local v78 = math.cos(v76) * v77;
    local v79 = math.sin(v76) * v77;
    local u80 = v75 + Vector3.new(v78, 0, v79);
    local FIREWORK_ASCEND_DURATION = IndependenceDayConfig.FIREWORK_ASCEND_DURATION;
    local u81 = 0;
    local u82 = nil;
    u82 = RunService.Heartbeat:Connect(function(p83) -- Line: 308
        -- upvalues: u81 (ref), FIREWORK_ASCEND_DURATION (copy), Position (copy), u67 (copy), u74 (copy), u80 (copy), u56 (copy), orientToDirection (ref), CFrame2 (copy), u82 (ref), setFireEnabled (ref), applyFireworkColor (ref), u57 (copy), applySmokeColor (ref), burstVfx (ref), playRandomSfxAt (ref), getSfxSubfolder (ref), IndependenceDayConfig (ref), u2 (ref), u3 (ref), u4 (ref), u5 (ref)
        u81 = u81 + p83;
        local v84 = math.clamp(u81 / FIREWORK_ASCEND_DURATION, 0, 1);
        local v85 = u67;
        local v86 = u74;
        local v87 = 1 - (1 - v84) ^ 2;
        local v88 = Position:Lerp(v85, v87):Lerp(v85:Lerp(v86, v87), v87):Lerp(v85:Lerp(v86, v87):Lerp(v86:Lerp(u80, v87), v87), v87);
        local v89 = u67;
        local v90 = u74;
        local v91 = 1 - (1 - math.clamp(v84 + 0.02, 0, 1)) ^ 2;
        u56.CFrame = orientToDirection(v88, Position:Lerp(v89, v91):Lerp(v89:Lerp(v90, v91), v91):Lerp(v89:Lerp(v90, v91):Lerp(v90:Lerp(u80, v91), v91), v91) - v88, CFrame2);

        if v84 < 1 then
            return;
        end;

        u82:Disconnect();
        u56.Transparency = 1;
        setFireEnabled(u56, false);
        local u92 = applyFireworkColor(u56, u57 and u57.color);
        local u93 = applySmokeColor(u56, u57 and u57.color);
        burstVfx(u56);
        playRandomSfxAt(getSfxSubfolder("PopSounds"), v88);
        task.delay(IndependenceDayConfig.FIREWORK_RESET_DELAY, function() -- Line: 331
            -- upvalues: u2 (ref), u56 (ref), u57 (ref), u3 (ref), u92 (copy), u4 (ref), u93 (copy), u5 (ref), CFrame2 (ref)
            u2[u56] = nil;

            if u57 and u57.isClone then
                u3[u56] = nil;

                if u92 then
                    u4[u92] = nil;
                end;

                if u93 then
                    u5[u93] = nil;
                end;

                u56:Destroy();

                return;
            end;

            u56.CFrame = CFrame2;
            u56.Transparency = 0;

            if u92 then
                u92.Color = u4[u92];
            end;

            if u93 then
                u93.Color = u5[u93];
            end;
        end);
    end);
end;

function u1.FireRandom(p94) -- Line: 356
    -- upvalues: getRigs (copy), u2 (copy), u1 (copy)
    if not p94 then
        warn("[FireworksController.FireRandom - Missing mapClone arg]");

        return;
    end;

    local v95 = p94:FindFirstChild("Scriptables") and v95:FindFirstChild("Fireworks") and v95:FindFirstChild("Basic");

    if not v95 then
        warn("[FireworksController - Scriptables/Fireworks/Basic not found]");
        v95 = nil;
    end;

    if not v95 then
        return;
    end;

    local v96 = {};

    for _, v in getRigs(v95) do
        if not u2[v] then
            table.insert(v96, v);
        end;
    end;

    if #v96 == 0 then
        warn("[FireworksController.FireRandom - No available firework rigs]");

        return;
    end;

    u1.LaunchFirework(v96[math.random(1, #v96)]);
end;

function u1.FireMany(p97, p98, p99) -- Line: 387
    -- upvalues: getRigs (copy), IndependenceDayConfig (copy), u2 (copy), u1 (copy), u3 (copy), setFireEnabled (copy), u4 (copy), u5 (copy)
    if not p97 then
        warn("[FireworksController.FireMany - Missing mapClone arg]");

        return;
    end;

    local v100 = p97:FindFirstChild("Scriptables") and v100:FindFirstChild("Fireworks") and v100:FindFirstChild("Basic");

    if not v100 then
        warn("[FireworksController - Scriptables/Fireworks/Basic not found]");
        v100 = nil;
    end;

    if not v100 then
        return;
    end;

    local v101 = getRigs(v100);

    if #v101 == 0 then
        warn("[FireworksController.FireMany - No firework rigs placed]");

        return;
    end;

    local v102;

    if p99 == nil then
        v102 = false;
    else
        v102 = #p99 > 0;
    end;

    for _ = 1, p98 do
        local v103;

        if v102 then
            local v104 = p99[math.random(1, #p99)];
            v103 = IndependenceDayConfig.FIREWORK_COLORS[v104];
        else
            v103 = nil;
        end;

        local v105 = {};

        for _, v in v101 do
            if not u2[v] then
                table.insert(v105, v);
            end;
        end;

        if #v105 > 0 then
            u1.LaunchFirework(v105[math.random(1, #v105)], {
                color = v103
            });
        else
            local v106 = v101[math.random(1, #v101)];
            local v107 = v106:Clone();
            v107.CFrame = u3[v106] or v106.CFrame;
            v107.Transparency = 0;
            setFireEnabled(v107, false);
            local v108 = v106:FindFirstChild("Explosion") and v108:FindFirstChild("Sparkles");

            if not (v108 and v108:IsA("ParticleEmitter")) then
                v108 = nil;
            end;

            local v109 = v107:FindFirstChild("Explosion") and v109:FindFirstChild("Sparkles");

            if not (v109 and v109:IsA("ParticleEmitter")) then
                v109 = nil;
            end;

            if v108 and (v109 and u4[v108]) then
                v109.Color = u4[v108];
            end;

            local v110 = v106:FindFirstChild("Explosion") and v110:FindFirstChild("SmokeParticle");

            if not (v110 and v110:IsA("ParticleEmitter")) then
                v110 = nil;
            end;

            local v111 = v107:FindFirstChild("Explosion") and v111:FindFirstChild("SmokeParticle");

            if not (v111 and v111:IsA("ParticleEmitter")) then
                v111 = nil;
            end;

            if v110 and (v111 and u5[v110]) then
                v111.Color = u5[v110];
            end;

            local Scriptables = p97:FindFirstChild("Scriptables");
            local Debris2 = Scriptables:FindFirstChild("Debris");

            if not (Debris2 and Debris2:IsA("Folder")) then
                Debris2 = Instance.new("Folder");
                Debris2.Name = "Debris";
                Debris2.Parent = Scriptables;
            end;

            v107.Parent = Debris2;
            u3[v107] = v107.CFrame;
            u1.LaunchFirework(v107, {
                isClone = true,
                color = v103
            });
        end;
    end;
end;

return u1;