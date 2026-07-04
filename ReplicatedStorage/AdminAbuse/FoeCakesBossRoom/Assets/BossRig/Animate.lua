-- Ruta Original: ReplicatedStorage.AdminAbuse.FoeCakesBossRoom.Assets.BossRig.Animate
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Parent = script.Parent;
local Humanoid = Parent:WaitForChild("Humanoid");
local u1 = "Standing";

local function getRigScale() -- Line: 7
    -- upvalues: Parent (copy)
    return Parent:GetScale();
end;

local ScaleDampeningPercent = script:FindFirstChild("ScaleDampeningPercent");
local u2 = "";
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = 1;
local u7 = nil;
local u8 = nil;
local u9 = {};
local u10 = {};
local u11 = {
    idle = { {
            id = "http://www.roblox.com/asset/?id=507766666",
            weight = 1
        }, {
            id = "http://www.roblox.com/asset/?id=507766951",
            weight = 1
        }, {
            id = "http://www.roblox.com/asset/?id=507766388",
            weight = 9
        } },
    walk = { {
            id = "http://www.roblox.com/asset/?id=507777826",
            weight = 10
        } },
    run = { {
            id = "http://www.roblox.com/asset/?id=507767714",
            weight = 10
        } },
    swim = { {
            id = "http://www.roblox.com/asset/?id=507784897",
            weight = 10
        } },
    swimidle = { {
            id = "http://www.roblox.com/asset/?id=507785072",
            weight = 10
        } },
    jump = { {
            id = "http://www.roblox.com/asset/?id=507765000",
            weight = 10
        } },
    fall = { {
            id = "http://www.roblox.com/asset/?id=507767968",
            weight = 10
        } },
    climb = { {
            id = "http://www.roblox.com/asset/?id=507765644",
            weight = 10
        } },
    sit = { {
            id = "http://www.roblox.com/asset/?id=2506281703",
            weight = 10
        } },
    toolnone = { {
            id = "http://www.roblox.com/asset/?id=507768375",
            weight = 10
        } },
    toolslash = { {
            id = "http://www.roblox.com/asset/?id=522635514",
            weight = 10
        } },
    toollunge = { {
            id = "http://www.roblox.com/asset/?id=522638767",
            weight = 10
        } },
    wave = { {
            id = "http://www.roblox.com/asset/?id=507770239",
            weight = 10
        } },
    point = { {
            id = "http://www.roblox.com/asset/?id=507770453",
            weight = 10
        } },
    dance = { {
            id = "http://www.roblox.com/asset/?id=507771019",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507771955",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507772104",
            weight = 10
        } },
    dance2 = { {
            id = "http://www.roblox.com/asset/?id=507776043",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507776720",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507776879",
            weight = 10
        } },
    dance3 = { {
            id = "http://www.roblox.com/asset/?id=507777268",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507777451",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507777623",
            weight = 10
        } },
    laugh = { {
            id = "http://www.roblox.com/asset/?id=507770818",
            weight = 10
        } },
    cheer = { {
            id = "http://www.roblox.com/asset/?id=507770677",
            weight = 10
        } }
};
local u12 = {
    wave = false,
    point = false,
    dance = true,
    dance2 = true,
    dance3 = true,
    laugh = false,
    cheer = false
};
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;

function resetManagerListeners()
    -- upvalues: u13 (ref), u14 (ref), u15 (ref)
    if u13 then
        u13:Disconnect();
        u13 = nil;
    end;

    if u14 then
        u14:Disconnect();
        u14 = nil;
    end;

    if u15 then
        u15:Disconnect();
        u15 = nil;
    end;
end;

function processIfManagerBelongsToCharacter(u18)
    -- upvalues: Parent (copy), u17 (ref), u16 (ref), u13 (ref), u14 (ref), u15 (ref)
    if u18.RootPart ~= Parent.PrimaryPart then
        return false;
    end;

    if u17 ~= u18 then
        resetManagerListeners();
        u16 = u18.GroundSensor;
        u13 = u18:GetPropertyChangedSignal("GroundSensor"):Connect(function() -- Line: 137
            -- upvalues: u18 (copy), u13 (ref)
            if processIfManagerBelongsToCharacter(u18) then
                u13:Disconnect();
                u13 = nil;
            end;
        end);
        u14 = u18:GetPropertyChangedSignal("RootPart"):Connect(function() -- Line: 143
            -- upvalues: u18 (copy), u14 (ref)
            if processIfManagerBelongsToCharacter(u18) then
                u14:Disconnect();
                u14 = nil;
            end;
        end);
        u15 = u18.AncestryChanged:Connect(function(p19, p20) -- Line: 149
            if p20 == nil then
                resetManagerListeners();
                lookForControllerManager();
            end;
        end);
        u17 = u18;
    end;

    return true;
end;

function lookForControllerManager()
    -- upvalues: u16 (ref), u17 (ref), Parent (copy)
    u16 = nil;
    u17 = nil;
    local v21 = Parent:FindFirstChildOfClass("ControllerManager");

    if v21 then
        processIfManagerBelongsToCharacter(v21);
    end;

    if u17 == nil then
        local u22 = nil;
        u22 = Parent.ChildAdded:Connect(function(p23) -- Line: 177
            -- upvalues: u22 (ref)
            if p23:IsA("ControllerManager") and processIfManagerBelongsToCharacter(p23) then
                u22:Disconnect();
                u22 = nil;
            end;
        end);
    end;
end;

lookForControllerManager();
math.randomseed(tick());

function findExistingAnimationInSet(p24, p25)
    if p24 == nil or p25 == nil then
        return 0;
    end;

    for i = 1, p24.count do
        if p24[i].anim.AnimationId == p25.AnimationId then
            return i;
        end;
    end;

    return 0;
end;

function configureAnimationSet(u26, u27)
    -- upvalues: u10 (copy), u9 (copy), Humanoid (copy)
    if u10[u26] ~= nil then
        for _, v in pairs(u10[u26].connections) do
            v:disconnect();
        end;
    end;

    u10[u26] = {};
    u10[u26].count = 0;
    u10[u26].totalWeight = 0;
    u10[u26].connections = {};
    local u28 = true;
    local success, _ = pcall(function() -- Line: 218
        -- upvalues: u28 (ref)
        u28 = game:GetService("StarterPlayer").AllowCustomAnimations;
    end);
    u28 = not success and true or u28;
    local v29 = script:FindFirstChild(u26);

    if u28 and v29 ~= nil then
        table.insert(u10[u26].connections, v29.ChildAdded:connect(function(p30) -- Line: 226
            -- upvalues: u26 (copy), u27 (copy)
            configureAnimationSet(u26, u27);
        end));
        table.insert(u10[u26].connections, v29.ChildRemoved:connect(function(p31) -- Line: 227
            -- upvalues: u26 (copy), u27 (copy)
            configureAnimationSet(u26, u27);
        end));

        for _, child in pairs(v29:GetChildren()) do
            if child:IsA("Animation") then
                local Weight = child:FindFirstChild("Weight");
                local v32 = Weight == nil and 1 or Weight.Value;
                u10[u26].count = u10[u26].count + 1;
                local count = u10[u26].count;
                u10[u26][count] = {};
                u10[u26][count].anim = child;
                u10[u26][count].weight = v32;
                u10[u26].totalWeight = u10[u26].totalWeight + u10[u26][count].weight;
                table.insert(u10[u26].connections, child.Changed:connect(function(p33) -- Line: 243
                    -- upvalues: u26 (copy), u27 (copy)
                    configureAnimationSet(u26, u27);
                end));
                table.insert(u10[u26].connections, child.ChildAdded:connect(function(p34) -- Line: 244
                    -- upvalues: u26 (copy), u27 (copy)
                    configureAnimationSet(u26, u27);
                end));
                table.insert(u10[u26].connections, child.ChildRemoved:connect(function(p35) -- Line: 245
                    -- upvalues: u26 (copy), u27 (copy)
                    configureAnimationSet(u26, u27);
                end));
            end;
        end;
    end;

    if u10[u26].count <= 0 then
        for i, v in pairs(u27) do
            u10[u26][i] = {};
            u10[u26][i].anim = Instance.new("Animation");
            u10[u26][i].anim.Name = u26;
            u10[u26][i].anim.AnimationId = v.id;
            u10[u26][i].weight = v.weight;
            u10[u26].count = u10[u26].count + 1;
            u10[u26].totalWeight = u10[u26].totalWeight + v.weight;
        end;
    end;

    for _, v in pairs(u10) do
        for i = 1, v.count do
            if u9[v[i].anim.AnimationId] == nil then
                Humanoid:LoadAnimation(v[i].anim);
                u9[v[i].anim.AnimationId] = true;
            end;
        end;
    end;
end;

function configureAnimationSetOld(u36, u37)
    -- upvalues: u10 (copy), Humanoid (copy)
    if u10[u36] ~= nil then
        for _, v in pairs(u10[u36].connections) do
            v:disconnect();
        end;
    end;

    u10[u36] = {};
    u10[u36].count = 0;
    u10[u36].totalWeight = 0;
    u10[u36].connections = {};
    local u38 = true;
    local success, _ = pcall(function() -- Line: 289
        -- upvalues: u38 (ref)
        u38 = game:GetService("StarterPlayer").AllowCustomAnimations;
    end);
    u38 = not success and true or u38;
    local v39 = script:FindFirstChild(u36);

    if u38 and v39 ~= nil then
        table.insert(u10[u36].connections, v39.ChildAdded:connect(function(p40) -- Line: 297
            -- upvalues: u36 (copy), u37 (copy)
            configureAnimationSet(u36, u37);
        end));
        table.insert(u10[u36].connections, v39.ChildRemoved:connect(function(p41) -- Line: 298
            -- upvalues: u36 (copy), u37 (copy)
            configureAnimationSet(u36, u37);
        end));
        local v42 = 1;

        for _, child in pairs(v39:GetChildren()) do
            if child:IsA("Animation") then
                table.insert(u10[u36].connections, child.Changed:connect(function(p43) -- Line: 302
                    -- upvalues: u36 (copy), u37 (copy)
                    configureAnimationSet(u36, u37);
                end));
                u10[u36][v42] = {};
                u10[u36][v42].anim = child;
                local Weight = child:FindFirstChild("Weight");

                if Weight == nil then
                    u10[u36][v42].weight = 1;
                else
                    u10[u36][v42].weight = Weight.Value;
                end;

                u10[u36].count = u10[u36].count + 1;
                u10[u36].totalWeight = u10[u36].totalWeight + u10[u36][v42].weight;
                v42 = v42 + 1;
            end;
        end;
    end;

    if u10[u36].count <= 0 then
        for i, v in pairs(u37) do
            u10[u36][i] = {};
            u10[u36][i].anim = Instance.new("Animation");
            u10[u36][i].anim.Name = u36;
            u10[u36][i].anim.AnimationId = v.id;
            u10[u36][i].weight = v.weight;
            u10[u36].count = u10[u36].count + 1;
            u10[u36].totalWeight = u10[u36].totalWeight + v.weight;
        end;
    end;

    for _, v in pairs(u10) do
        for i = 1, v.count do
            Humanoid:LoadAnimation(v[i].anim);
        end;
    end;
end;

function scriptChildModified(p44)
    -- upvalues: u11 (copy)
    local v45 = u11[p44.Name];

    if v45 ~= nil then
        configureAnimationSet(p44.Name, v45);
    end;
end;

script.ChildAdded:connect(scriptChildModified);
script.ChildRemoved:connect(scriptChildModified);
local v46;

if Humanoid then
    v46 = Humanoid:FindFirstChildOfClass("Animator");
else
    v46 = nil;
end;

if v46 then
    local v47 = v46:GetPlayingAnimationTracks();

    for _, v in ipairs(v47) do
        v:Stop(0);
        v:Destroy();
    end;
end;

for i, v in pairs(u11) do
    configureAnimationSet(i, v);
end;

local u48 = "None";
local u49 = 0;
local u50 = 0;
local u51 = false;

function stopAllAnimations()
    -- upvalues: u2 (ref), u12 (copy), u51 (ref), u3 (ref), u5 (ref), u4 (ref), u8 (ref), u7 (ref)
    local v52 = u2;
    local v53 = u12[v52] ~= nil and u12[v52] == false and "idle" or v52;

    if u51 then
        v53 = "idle";
        u51 = false;
    end;

    u2 = "";
    u3 = nil;

    if u5 ~= nil then
        u5:disconnect();
    end;

    if u4 ~= nil then
        u4:Stop();
        u4:Destroy();
        u4 = nil;
    end;

    if u8 ~= nil then
        u8:disconnect();
    end;

    if u7 ~= nil then
        u7:Stop();
        u7:Destroy();
        u7 = nil;
    end;

    return v53;
end;

function getHeightScale()
    -- upvalues: Humanoid (copy), getRigScale (copy), ScaleDampeningPercent (ref)
    if not Humanoid then
        return getRigScale();
    end;

    if not Humanoid.AutomaticScalingEnabled then
        return getRigScale();
    end;

    local v54 = Humanoid.HipHeight / 2;

    if ScaleDampeningPercent == nil then
        ScaleDampeningPercent = script:FindFirstChild("ScaleDampeningPercent");
    end;

    if ScaleDampeningPercent ~= nil then
        v54 = 1 + (Humanoid.HipHeight - 2) * ScaleDampeningPercent.Value / 2;
    end;

    return v54;
end;

local function rootMotionCompensation(p55) -- Line: 441
    return p55 * 1.25 / getHeightScale();
end;

local function setRunSpeed(p56) -- Line: 449
    -- upvalues: u4 (ref), u7 (ref)
    local v57 = p56 * 1.25 / getHeightScale();
    local v58 = 0.0001;
    local v59 = 0.0001;
    local v60 = 1;

    if v57 <= 0.5 then
        v60 = v57 / 0.5;
        v58 = 1;
    elseif v57 < 1 then
        v59 = (v57 - 0.5) / 0.5;
        v58 = 1 - v59;
    else
        v60 = v57 / 1;
        v59 = 1;
    end;

    u4:AdjustWeight(v58);
    u7:AdjustWeight(v59);
    u4:AdjustSpeed(v60);
    u7:AdjustSpeed(v60);
end;

function setAnimationSpeed(p61)
    -- upvalues: u2 (ref), setRunSpeed (copy), u6 (ref), u4 (ref)
    if u2 == "walk" then
        setRunSpeed(p61);

        return;
    end;

    if p61 ~= u6 then
        u6 = p61;
        u4:AdjustSpeed(u6);
    end;
end;

function keyFrameReachedFunc(p62)
    -- upvalues: u2 (ref), u7 (ref), u4 (ref), u12 (copy), u51 (ref), u6 (ref), Humanoid (copy)
    if p62 == "End" then
        if u2 == "walk" then
            if u7.Looped ~= true then
                u7.TimePosition = 0;
            end;

            if u4.Looped ~= true then
                u4.TimePosition = 0;
            end;
        else
            local v63 = u2;
            local v64 = u12[v63] ~= nil and u12[v63] == false and "idle" or v63;

            if u51 then
                if u4.Looped then
                    return;
                end;

                v64 = "idle";
                u51 = false;
            end;

            playAnimation(v64, 0.15, Humanoid);
            setAnimationSpeed(u6);
        end;
    end;
end;

function rollAnimation(p65)
    -- upvalues: u10 (copy)
    local v66 = math.random(1, u10[p65].totalWeight);
    local v67 = 1;

    while u10[p65][v67].weight < v66 do
        v66 = v66 - u10[p65][v67].weight;
        v67 = v67 + 1;
    end;

    return v67;
end;

local function switchToAnim(p68, p69, p70, p71) -- Line: 530
    -- upvalues: u3 (ref), u4 (ref), u7 (ref), u6 (ref), u2 (ref), u5 (ref), u10 (copy), u8 (ref)
    if p68 ~= u3 then
        if u4 ~= nil then
            u4:Stop(p70);
            u4:Destroy();
        end;

        if u7 ~= nil then
            u7:Stop(p70);
            u7:Destroy();
            u7 = nil;
        end;

        u6 = 1;
        u4 = p71:LoadAnimation(p68);
        u4.Priority = Enum.AnimationPriority.Core;
        u4:Play(p70);
        u2 = p69;
        u3 = p68;

        if u5 ~= nil then
            u5:disconnect();
        end;

        u5 = u4.KeyframeReached:connect(keyFrameReachedFunc);

        if p69 == "walk" then
            local v72 = rollAnimation("run");
            u7 = p71:LoadAnimation(u10.run[v72].anim);
            u7.Priority = Enum.AnimationPriority.Core;
            u7:Play(p70);

            if u8 ~= nil then
                u8:disconnect();
            end;

            u8 = u7.KeyframeReached:connect(keyFrameReachedFunc);
        end;
    end;
end;

function playAnimation(p73, p74, p75)
    -- upvalues: u10 (copy), switchToAnim (copy), u51 (ref)
    local v76 = rollAnimation(p73);
    switchToAnim(u10[p73][v76].anim, p73, p74, p75);
    u51 = false;
end;

function playEmote(p77, p78, p79)
    -- upvalues: switchToAnim (copy), u51 (ref)
    switchToAnim(p77, p77.Name, p78, p79);
    u51 = true;
end;

local u80 = "";
local u81 = nil;
local u82 = nil;
local u83 = nil;

function toolKeyFrameReachedFunc(p84)
    -- upvalues: u80 (ref), Humanoid (copy)
    if p84 == "End" then
        playToolAnimation(u80, 0, Humanoid);
    end;
end;

function playToolAnimation(p85, p86, p87, p88)
    -- upvalues: u10 (copy), u82 (ref), u81 (ref), u80 (ref), u83 (ref)
    local v89 = rollAnimation(p85);
    local anim = u10[p85][v89].anim;

    if u82 ~= anim then
        if u81 ~= nil then
            u81:Stop();
            u81:Destroy();
            p86 = 0;
        end;

        u81 = p87:LoadAnimation(anim);

        if p88 then
            u81.Priority = p88;
        end;

        u81:Play(p86);
        u80 = p85;
        u82 = anim;
        u83 = u81.KeyframeReached:connect(toolKeyFrameReachedFunc);
    end;
end;

function stopToolAnimations()
    -- upvalues: u80 (ref), u83 (ref), u82 (ref), u81 (ref)
    local v90 = u80;

    if u83 ~= nil then
        u83:disconnect();
    end;

    u80 = "";
    u82 = nil;

    if u81 ~= nil then
        u81:Stop();
        u81:Destroy();
        u81 = nil;
    end;

    return v90;
end;

function onRunning(p91)
    -- upvalues: u16 (ref), Humanoid (copy), u17 (ref), u51 (ref), u1 (ref), u12 (copy), u2 (ref)
    local v92 = getHeightScale();

    if u16 ~= nil and Humanoid.EvaluateStateMachine == false then
        local RootPart = Humanoid.RootPart;
        local SensedPart = u16.SensedPart;

        if SensedPart then
            local v93 = SensedPart:GetVelocityAtPosition(u16.HitFrame.Position);
            local AssemblyLinearVelocity = RootPart.AssemblyLinearVelocity;
            local Magnitude = Vector3.new(AssemblyLinearVelocity.X - v93.X, 0, AssemblyLinearVelocity.Z - v93.Z).Magnitude;
            local Magnitude2 = u17.MovingDirection.Magnitude;

            if Magnitude2 < 0.1 then
                Magnitude = 0;
                Magnitude2 = 0;
            elseif Magnitude2 > 1 then
                Magnitude2 = 1;
            end;

            p91 = Magnitude * Magnitude2;
        end;
    end;

    if (u51 and Humanoid.MoveDirection == Vector3.new(0, 0, 0) and (Humanoid.WalkSpeed / v92 or 0.75) or 0.75) * v92 >= p91 then
        if u12[u2] == nil and not u51 then
            playAnimation("idle", 0.2, Humanoid);
            u1 = "Standing";
        end;

        return;
    end;

    playAnimation("walk", 0.2, Humanoid);
    setAnimationSpeed(p91 / 16);
    u1 = "Running";
end;

function onDied()
    -- upvalues: u1 (ref)
    u1 = "Dead";
end;

function onJumping()
    -- upvalues: Humanoid (copy), u50 (ref), u1 (ref)
    playAnimation("jump", 0.1, Humanoid);
    u50 = 0.31;
    u1 = "Jumping";
end;

function onClimbing(p94)
    -- upvalues: Humanoid (copy), u1 (ref)
    local v95 = p94 / getHeightScale();
    playAnimation("climb", 0.1, Humanoid);
    setAnimationSpeed(v95 / 5);
    u1 = "Climbing";
end;

function onGettingUp()
    -- upvalues: u1 (ref)
    u1 = "GettingUp";
end;

function onFreeFall()
    -- upvalues: u50 (ref), Humanoid (copy), u1 (ref)
    if u50 <= 0 then
        playAnimation("fall", 0.2, Humanoid);
    end;

    u1 = "FreeFall";
end;

function onFallingDown()
    -- upvalues: u1 (ref)
    u1 = "FallingDown";
end;

function onSeated()
    -- upvalues: u1 (ref)
    u1 = "Seated";
end;

function onPlatformStanding()
    -- upvalues: u1 (ref)
    u1 = "PlatformStanding";
end;

function onSwimming(p96)
    -- upvalues: Humanoid (copy), u1 (ref)
    local v97 = p96 / getHeightScale();

    if v97 <= 1 then
        playAnimation("swimidle", 0.4, Humanoid);
        u1 = "Standing";

        return;
    end;

    playAnimation("swim", 0.4, Humanoid);
    setAnimationSpeed(v97 / 10);
    u1 = "Swimming";
end;

function animateTool()
    -- upvalues: u48 (ref), Humanoid (copy)
    if u48 == "None" then
        playToolAnimation("toolnone", 0.1, Humanoid, Enum.AnimationPriority.Idle);

        return;
    end;

    if u48 == "Slash" then
        playToolAnimation("toolslash", 0, Humanoid, Enum.AnimationPriority.Action);

        return;
    end;

    if u48 ~= "Lunge" then
        return;
    end;

    playToolAnimation("toollunge", 0, Humanoid, Enum.AnimationPriority.Action);
end;

function getToolAnim(p98)
    for _, child in ipairs(p98:GetChildren()) do
        if child.Name == "toolanim" and child.className == "StringValue" then
            return child;
        end;
    end;

    return nil;
end;

local u99 = 0;

function stepAnimate(p100)
    -- upvalues: u99 (ref), u50 (ref), u1 (ref), Humanoid (copy), Parent (copy), u48 (ref), u49 (ref), u82 (ref)
    local v101 = p100 - u99;
    u99 = p100;

    if u50 > 0 then
        u50 = u50 - v101;
    end;

    if u1 == "FreeFall" and u50 <= 0 then
        playAnimation("fall", 0.2, Humanoid);
    else
        if u1 == "Seated" then
            playAnimation("sit", 0.5, Humanoid);

            return;
        end;

        if u1 == "Running" then
            playAnimation("walk", 0.2, Humanoid);
        elseif u1 == "Dead" or (u1 == "GettingUp" or (u1 == "FallingDown" or (u1 == "Seated" or u1 == "PlatformStanding"))) then
            stopAllAnimations();
        end;
    end;

    local v102 = Parent:FindFirstChildOfClass("Tool");

    if v102 and v102:FindFirstChild("Handle") then
        local v103 = getToolAnim(v102);

        if v103 then
            u48 = v103.Value;
            v103.Parent = nil;
            u49 = p100 + 0.3;
        end;

        if u49 < p100 then
            u49 = 0;
            u48 = "None";
        end;

        animateTool();

        return;
    end;

    stopToolAnimations();
    u48 = "None";
    u82 = nil;
    u49 = 0;
end;

Humanoid.Died:connect(onDied);
Humanoid.Running:connect(onRunning);
Humanoid.Jumping:connect(onJumping);
Humanoid.Climbing:connect(onClimbing);
Humanoid.GettingUp:connect(onGettingUp);
Humanoid.FreeFalling:connect(onFreeFall);
Humanoid.FallingDown:connect(onFallingDown);
Humanoid.Seated:connect(onSeated);
Humanoid.PlatformStanding:connect(onPlatformStanding);
Humanoid.Swimming:connect(onSwimming);
game:GetService("Players").LocalPlayer.Chatted:connect(function(p104) -- Line: 850
    -- upvalues: u1 (ref), u12 (copy), Humanoid (copy)
    local v105 = "";

    if string.sub(p104, 1, 3) == "/e " then
        v105 = string.sub(p104, 4);
    elseif string.sub(p104, 1, 7) == "/emote " then
        v105 = string.sub(p104, 8);
    end;

    if u1 == "Standing" and u12[v105] ~= nil then
        playAnimation(v105, 0.1, Humanoid);
    end;
end);

script:WaitForChild("PlayEmote").OnInvoke = function(p106) -- Line: 864
    -- upvalues: u1 (ref), u12 (copy), Humanoid (copy), u4 (ref)
    if u1 == "Standing" then
        if u12[p106] ~= nil then
            playAnimation(p106, 0.1, Humanoid);

            return true, u4;
        end;

        if typeof(p106) ~= "Instance" or not p106:IsA("Animation") then
            return false;
        end;

        playEmote(p106, 0.1, Humanoid);

        return true, u4;
    end;
end;

if Parent.Parent ~= nil then
    playAnimation("idle", 0.1, Humanoid);
    u1 = "Standing";
end;

while Parent.Parent ~= nil do
    local _, v107 = wait(0.1);
    stepAnimate(v107);
end;