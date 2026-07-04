-- Ruta Original: StarterPlayer.StarterPlayerScripts.Pièges.World2.LocalNPC15_World2
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PathfindingService = game:GetService("PathfindingService");
local RunService = game:GetService("RunService");
local ContentProvider = game:GetService("ContentProvider");
local TweenService = game:GetService("TweenService");
local LocalPlayer = Players.LocalPlayer;
local NPC15_World2 = ReplicatedStorage:WaitForChild("NPC15_World2");
local u1 = NPC15_World2:GetPivot();
local Animation = Instance.new("Animation");
Animation.AnimationId = "rbxassetid://118196541350091";
local Animation2 = Instance.new("Animation");
Animation2.AnimationId = "rbxassetid://118196541350091";
task.spawn(function() -- Line: 41
    -- upvalues: ContentProvider (copy), Animation (copy), Animation2 (copy), NPC15_World2 (copy)
    ContentProvider:PreloadAsync({ Animation, Animation2, NPC15_World2 });
end);

local function loadWaypoints() -- Line: 53
    -- upvalues: CollectionService (copy)
    local v2 = {};

    for _, v in ipairs(CollectionService:GetTagged("NPC15_World2_Waypoint")) do
        if v:IsA("BasePart") then
            table.insert(v2, v);
        end;
    end;

    table.sort(v2, function(p3, p4) -- Line: 60
        return (p3:GetAttribute("Order") or 0) < (p4:GetAttribute("Order") or 0);
    end);

    return v2;
end;

local u5 = {
    AgentRadius = 1,
    AgentHeight = 5,
    AgentCanJump = false,
    AgentCanClimb = false,
    WaypointSpacing = 4
};

local function isInAnyZonePart(p6) -- Line: 81
    -- upvalues: CollectionService (copy)
    for _, v in ipairs(CollectionService:GetTagged("NPC15_World2_Zone")) do
        if v:IsA("BasePart") then
            local v7 = v.CFrame:PointToObjectSpace(p6);

            if math.abs(v7.X) <= v.Size.X / 2 and (math.abs(v7.Y) <= math.max(v.Size.Y / 2, 30) and math.abs(v7.Z) <= v.Size.Z / 2) then
                return true;
            end;
        end;
    end;

    return false;
end;

local function isInSpeedZone(p8) -- Line: 95
    -- upvalues: CollectionService (copy)
    for _, v in ipairs(CollectionService:GetTagged("NPC15_World2_SpeedZone")) do
        if v:IsA("BasePart") then
            local v9 = v.CFrame:PointToObjectSpace(p8);

            if math.abs(v9.X) <= v.Size.X / 2 and (math.abs(v9.Y) <= math.max(v.Size.Y / 2, 30) and math.abs(v9.Z) <= v.Size.Z / 2) then
                return true;
            end;
        end;
    end;

    return false;
end;

local u10 = false;

local function startNPC() -- Line: 114
    -- upvalues: u10 (ref), loadWaypoints (copy), CollectionService (copy), NPC15_World2 (copy), u1 (copy), PathfindingService (copy), u5 (copy), Animation (copy), Animation2 (copy), LocalPlayer (copy), TweenService (copy), RunService (copy), isInAnyZonePart (copy), isInSpeedZone (copy)
    if u10 then
        return;
    end;

    u10 = true;
    local u11 = loadWaypoints();

    if #u11 == 0 then
        local v12 = 0;

        while #u11 == 0 and v12 < 30 do
            task.wait(0.5);
            u11 = loadWaypoints();
            v12 = v12 + 1;
        end;

        if #u11 == 0 then
            warn("[NPC15_W2] Aucun waypoint trouvé après 15s d\'attente !");
        end;
    end;

    CollectionService:GetInstanceAddedSignal("NPC15_World2_Waypoint"):Connect(function() -- Line: 165
        -- upvalues: u11 (ref), loadWaypoints (ref)
        u11 = loadWaypoints();
    end);
    local u13 = NPC15_World2:Clone();
    u13:PivotTo(u1);
    u13.Parent = workspace;
    local HumanoidRootPart = u13:WaitForChild("HumanoidRootPart");
    local Animator = u13:WaitForChild("Humanoid"):WaitForChild("Animator");
    local ChaseMusic = HumanoidRootPart:WaitForChild("ChaseMusic");
    local Footstep = HumanoidRootPart:WaitForChild("Footstep");
    local u14 = 0;
    HumanoidRootPart.Anchored = true;

    if #u11 > 0 then
        local _ = u11[#u11].Position.Y;
    else
        local _ = u1.Y;
    end;

    local u15 = RaycastParams.new();
    u15.FilterType = Enum.RaycastFilterType.Exclude;
    u15.FilterDescendantsInstances = { u13 };
    local u16 = RaycastParams.new();
    u16.FilterType = Enum.RaycastFilterType.Include;
    u16.FilterDescendantsInstances = CollectionService:GetTagged("Boss15collide");

    local function refreshBossCollide() -- Line: 200
        -- upvalues: u16 (copy), CollectionService (ref)
        u16.FilterDescendantsInstances = CollectionService:GetTagged("Boss15collide");
    end;

    CollectionService:GetInstanceAddedSignal("Boss15collide"):Connect(refreshBossCollide);
    CollectionService:GetInstanceRemovedSignal("Boss15collide"):Connect(refreshBossCollide);
    local Y = u1.Y;

    local function getGroundY(p17) -- Line: 208
        -- upvalues: Y (ref), u15 (copy), u16 (copy)
        local v18 = Vector3.new(p17.X, Y + 10, p17.Z);
        local v19 = workspace:Raycast(v18, Vector3.new(0, -200, 0), u15);
        local v20 = workspace:Raycast(v18, Vector3.new(0, -200, 0), u16);
        local v21 = v19 and v19.Position.Y + 3 or nil;
        local v22 = v20 and v20.Position.Y + 3 or nil;
        local v23 = nil;
        local v24;

        if v21 and v22 then
            v24 = math.max(v21, v22);
        else
            v24 = v21 or (v22 or v23);
        end;

        if v24 then
            Y = v24;

            return Y;
        end;

        local v25 = Vector3.new(p17.X, Y + 50, p17.Z);
        local v26 = workspace:Raycast(v25, Vector3.new(0, -200, 0), u15);
        local v27 = workspace:Raycast(v25, Vector3.new(0, -200, 0), u16);
        local v28 = v26 and v26.Position.Y + 3 or nil;
        local v29 = v27 and v27.Position.Y + 3 or nil;

        if v28 and v29 then
            Y = math.max(v28, v29);

            return Y;
        end;

        if v28 then
            Y = v28;

            return Y;
        end;

        if not v29 then
            return Y;
        end;

        Y = v29;

        return Y;
    end;

    task.spawn(function() -- Line: 258
        -- upvalues: PathfindingService (ref), u5 (ref), u1 (ref)
        local u30 = PathfindingService:CreatePath(u5);
        pcall(function() -- Line: 260
            -- upvalues: u30 (copy), u1 (ref)
            u30:ComputeAsync(u1.Position, u1.Position + Vector3.new(10, 0, 10));
        end);
    end);
    local u31 = Animator:LoadAnimation(Animation);
    local u32 = Animator:LoadAnimation(Animation2);
    u32:Play();
    local u33 = "Idle";
    local u34 = false;
    local u35 = true;
    local u36 = 0;
    local u37 = 1;
    local u38 = Vector3.new(0, 0, 1);
    local u39 = 220;
    local u40 = 220;
    local u41 = nil;
    local u42 = false;

    local function findClosestWaypointIndex() -- Line: 282
        -- upvalues: HumanoidRootPart (copy), u11 (ref)
        local Position = HumanoidRootPart.Position;
        local v43 = (1 / 0);
        local v44 = 1;

        for i, v in ipairs(u11) do
            local v45 = Position.X - v.Position.X;
            local v46 = Position.Z - v.Position.Z;
            local v47 = v45 * v45 + v46 * v46;

            if v47 < v43 then
                v44 = i;
                v43 = v47;
            end;
        end;

        return v44;
    end;

    local u48 = {};
    local u49 = 0;
    local u50 = false;
    local u51 = 0;

    local function requestPath(u52, u53) -- Line: 304
        -- upvalues: u50 (ref), PathfindingService (ref), u5 (ref), HumanoidRootPart (copy), u48 (ref), u49 (ref)
        if u50 then
            return;
        end;

        u50 = true;
        task.spawn(function() -- Line: 307
            -- upvalues: PathfindingService (ref), u5 (ref), u52 (copy), u53 (copy), HumanoidRootPart (ref), u48 (ref), u49 (ref), u50 (ref)
            local u54 = PathfindingService:CreatePath(u5);

            if pcall(function() -- Line: 309
                -- upvalues: u54 (copy), u52 (ref), u53 (ref)
                u54:ComputeAsync(u52, u53);
            end) and u54.Status == Enum.PathStatus.Success then
                local v55 = u54:GetWaypoints();

                if #v55 >= 2 then
                    local Position = HumanoidRootPart.Position;
                    local v56 = (1 / 0);
                    local v57 = 1;

                    for i = 1, #v55 do
                        local v58 = Position.X - v55[i].Position.X;
                        local v59 = Position.Z - v55[i].Position.Z;
                        local v60 = v58 * v58 + v59 * v59;

                        if v60 < v56 then
                            v57 = i;
                            v56 = v60;
                        end;
                    end;

                    u48 = v55;
                    u49 = math.min(v57 + 1, #v55);
                end;
            end;

            u50 = false;
        end);
    end;

    local function goIdle() -- Line: 334
        -- upvalues: u33 (ref), u34 (ref), u31 (copy), u32 (copy), ChaseMusic (copy), Footstep (copy), u48 (ref), u49 (ref), u37 (ref), Y (ref), u1 (ref)
        u33 = "Idle";
        u34 = false;
        u31:Stop(0.1);
        u32:Play();

        if ChaseMusic.IsPlaying then
            ChaseMusic:Stop();
        end;

        Footstep:Stop();
        u48 = {};
        u49 = 0;
        u37 = 1;
        Y = u1.Y;
    end;

    local function goChasingWaypoints() -- Line: 347
        -- upvalues: u33 (ref), u36 (ref), u37 (ref), u31 (copy), u32 (copy), ChaseMusic (copy)
        u33 = "ChasingWaypoints";
        u36 = os.clock();
        u37 = 1;
        u31:Play();
        u32:Stop();

        if not ChaseMusic.IsPlaying then
            ChaseMusic:Play();
        end;
    end;

    local function goChasingPathfind() -- Line: 356
        -- upvalues: u33 (ref), u48 (ref), u49 (ref), u51 (ref), Y (ref), HumanoidRootPart (copy)
        u33 = "ChasingPathfind";
        u48 = {};
        u49 = 0;
        u51 = 0;
        Y = HumanoidRootPart.Position.Y;
    end;

    local function goReturn() -- Line: 366
        -- upvalues: u33 (ref), u48 (ref), u49 (ref), u51 (ref), u37 (ref)
        u33 = "Returning";
        u48 = {};
        u49 = 0;
        u51 = 0;
        u37 = 1;
    end;

    local u61 = {
        [3] = Color3.fromRGB(255, 160, 0),
        [2] = Color3.fromRGB(255, 80, 0),
        [1] = Color3.fromRGB(255, 20, 0)
    };

    local function showBossUI(p62, p63) -- Line: 381
        -- upvalues: LocalPlayer (ref), u61 (copy), TweenService (ref)
        local PlayerGui = LocalPlayer.PlayerGui;
        local BossCountdownGui = PlayerGui:FindFirstChild("BossCountdownGui");

        if BossCountdownGui then
            BossCountdownGui:Destroy();
        end;

        local ScreenGui = Instance.new("ScreenGui");
        ScreenGui.Name = "BossCountdownGui";
        ScreenGui.ResetOnSpawn = false;
        ScreenGui.Parent = PlayerGui;
        local Frame = Instance.new("Frame");
        Frame.Name = "BossNotif";
        Frame.Size = UDim2.new(0.6, 0, 0.2, 0);
        Frame.Position = UDim2.new(0.5, 0, 0.45, 0);
        Frame.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame.BackgroundTransparency = 1;
        Frame.Parent = ScreenGui;
        local UIListLayout = Instance.new("UIListLayout", Frame);
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
        UIListLayout.Padding = UDim.new(0.05, 0);
        local UIScale = Instance.new("UIScale", Frame);
        UIScale.Scale = 0;
        local TextLabel = Instance.new("TextLabel", Frame);
        TextLabel.Size = UDim2.new(1, 0, 0.4, 0);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.Text = p63 and "💀 BOSS IS CHASING 💀" or "⚠️ BOSS INCOMING ⚠️";
        local v64;

        if p63 then
            v64 = Color3.fromRGB(255, 80, 80);
        else
            v64 = Color3.fromRGB(255, 160, 0);
        end;

        TextLabel.TextColor3 = v64;
        TextLabel.TextScaled = true;
        TextLabel.Font = Enum.Font.GothamBlack;
        local UIStroke = Instance.new("UIStroke", TextLabel);
        UIStroke.Thickness = 4;
        UIStroke.Color = Color3.fromRGB(0, 0, 0);
        local TextLabel2 = Instance.new("TextLabel", Frame);
        TextLabel2.Size = UDim2.new(1, 0, 0.45, 0);
        TextLabel2.BackgroundTransparency = 1;
        TextLabel2.Text = p63 and "RUN !" or tostring(p62);
        local v65;

        if p63 then
            v65 = Color3.fromRGB(255, 255, 255);
        else
            v65 = u61[p62] or Color3.fromRGB(255, 30, 30);
        end;

        TextLabel2.TextColor3 = v65;
        TextLabel2.TextScaled = true;
        TextLabel2.Font = Enum.Font.GothamBlack;
        local UIStroke2 = Instance.new("UIStroke", TextLabel2);
        UIStroke2.Thickness = 4;
        UIStroke2.Color = Color3.fromRGB(0, 0, 0);
        TweenService:Create(UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play();
        TweenService:Create(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0.4, 0)
        }):Play();
        task.delay(p63 and 2.2 or 0.9, function() -- Line: 433
            -- upvalues: ScreenGui (copy), TweenService (ref), Frame (copy), UIScale (copy)
            if not ScreenGui.Parent then
                return;
            end;

            TweenService:Create(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, 0, 0.3, 0)
            }):Play();
            TweenService:Create(UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Scale = 0
            }):Play();
            local v66 = TweenInfo.new(0.5);

            for _, descendant in ipairs(Frame:GetDescendants()) do
                if descendant:IsA("TextLabel") then
                    TweenService:Create(descendant, v66, {
                        TextTransparency = 1
                    }):Play();
                elseif descendant:IsA("UIStroke") then
                    TweenService:Create(descendant, v66, {
                        Transparency = 1
                    }):Play();
                end;
            end;

            task.delay(0.65, function() -- Line: 442
                -- upvalues: ScreenGui (ref)
                if ScreenGui.Parent then
                    ScreenGui:Destroy();
                end;
            end);
        end);
    end;

    local function startCountdown() -- Line: 446
        -- upvalues: u33 (ref), u34 (ref), u35 (ref), LocalPlayer (ref), showBossUI (copy), u36 (ref), u37 (ref), u31 (copy), u32 (copy), ChaseMusic (copy)
        u33 = "Countdown";
        u34 = true;
        task.spawn(function() -- Line: 449
            -- upvalues: u34 (ref), u35 (ref), LocalPlayer (ref), showBossUI (ref), u33 (ref), u36 (ref), u37 (ref), u31 (ref), u32 (ref), ChaseMusic (ref)
            for i = 3, 1, -1 do
                if not (u34 and u35) then
                    local BossCountdownGui = LocalPlayer.PlayerGui:FindFirstChild("BossCountdownGui");

                    if BossCountdownGui then
                        BossCountdownGui:Destroy();
                    end;

                    return;
                end;

                showBossUI(i, false);
                task.wait(1);
            end;

            if not (u34 and u35) then
                local BossCountdownGui = LocalPlayer.PlayerGui:FindFirstChild("BossCountdownGui");

                if BossCountdownGui then
                    BossCountdownGui:Destroy();
                end;

                return;
            end;

            showBossUI(nil, true);
            u33 = "ChasingWaypoints";
            u36 = os.clock();
            u37 = 1;
            u31:Play();
            u32:Stop();

            if not ChaseMusic.IsPlaying then
                ChaseMusic:Play();
            end;
        end);
    end;

    local u67 = RaycastParams.new();
    u67.FilterType = Enum.RaycastFilterType.Exclude;
    u67.FilterDescendantsInstances = { u13 };

    local function hasLineOfSight(p68, p69) -- Line: 474
        -- upvalues: LocalPlayer (ref), u67 (copy), u13 (copy)
        local Character = LocalPlayer.Character;
        local v70;

        if Character then
            v70 = { u13, Character };
        else
            v70 = { u13 };
        end;

        u67.FilterDescendantsInstances = v70;
        local v71 = Vector3.new(p69.X - p68.X, 0, p69.Z - p68.Z);

        return workspace:Raycast(p68, v71, u67) == nil;
    end;

    local u72 = 0;

    local function moveWaypoints(p73) -- Line: 485
        -- upvalues: u72 (ref), u31 (copy), u32 (copy), u37 (ref), u11 (ref), HumanoidRootPart (copy), u33 (ref), u48 (ref), u49 (ref), u51 (ref), Y (ref), u38 (ref), u14 (ref), Footstep (copy), u39 (ref), u13 (copy)
        local v74 = os.clock();

        if v74 < u72 then
            u31:Stop(0.1);
            u32:Play();

            return;
        end;

        if u72 > 0 then
            u72 = 0;
            u32:Stop();
            u31:Play();
        end;

        while u37 <= #u11 do
            local v75 = u11[u37];
            local Position = HumanoidRootPart.Position;
            local v76 = v75.Position.X - Position.X;
            local v77 = v75.Position.Y - Position.Y;
            local v78 = v75.Position.Z - Position.Z;

            if math.sqrt(v76 * v76 + v77 * v77 + v78 * v78) >= 5 then
                break;
            end;

            local v79 = v75:GetAttribute("Pause");

            if v79 and (typeof(v79) == "number" and v79 > 0) then
                u72 = os.clock() + v79;
                u37 = u37 + 1;

                return;
            end;

            u37 = u37 + 1;
        end;

        if u37 > #u11 then
            u33 = "ChasingPathfind";
            u48 = {};
            u49 = 0;
            u51 = 0;
            Y = HumanoidRootPart.Position.Y;

            return;
        end;

        local Position = u11[u37].Position;
        local Position2 = HumanoidRootPart.Position;
        local v80 = Position.X - Position2.X;
        local v81 = Position.Z - Position2.Z;
        local v82 = math.sqrt(v80 * v80 + v81 * v81);

        if v82 > 0.1 then
            u38 = Vector3.new(v80 / v82, 0, v81 / v82);
        end;

        if v74 - u14 >= 0.5 then
            u14 = v74;
            Footstep:Play();
        end;

        local v83 = u39 * math.min(p73, 0.1);
        local v84 = math.min(v83, v82) / v82;
        local v85 = Position2.X + v80 * v84;
        local v86 = Position2.Z + v81 * v84;
        local v87 = Position2.Y + (Position.Y - Position2.Y) * v84;
        local v88 = Vector3.new(v85, v87, v86);
        local v89 = Vector3.new(v85 + v80 / v82, v87, v86 + v81 / v82);
        u13:PivotTo(CFrame.lookAt(v88, v89));
    end;

    local function moveDirectToPlayer(p90, p91) -- Line: 563
        -- upvalues: HumanoidRootPart (copy), u14 (ref), Footstep (copy), u39 (ref), u38 (ref), u13 (copy)
        local Position = HumanoidRootPart.Position;
        local v92 = p91 - Position;
        local Magnitude = v92.Magnitude;

        if Magnitude < 0.5 then
            return;
        end;

        local v93 = os.clock();

        if v93 - u14 >= 0.5 then
            u14 = v93;
            Footstep:Play();
        end;

        local v94 = u39 * math.min(p90, 0.1);
        local v95 = math.min(v94, Magnitude);
        local v96 = v92 / Magnitude;
        local v97 = Position + v96 * v95;
        u38 = Vector3.new(v96.X, 0, v96.Z).Unit;
        local v98 = Vector3.new(v97.X + v96.X, v97.Y, v97.Z + v96.Z);
        u13:PivotTo(CFrame.lookAt(v97, v98));
    end;

    local function movePathfind(p99, u100) -- Line: 591
        -- upvalues: HumanoidRootPart (copy), u51 (ref), u50 (ref), PathfindingService (ref), u5 (ref), u48 (ref), u49 (ref), hasLineOfSight (copy), u14 (ref), Footstep (copy), u40 (ref), getGroundY (copy), u13 (copy)
        local Position = HumanoidRootPart.Position;
        local v101 = os.clock();

        if v101 - u51 > 0.3 then
            u51 = v101;

            if not u50 then
                u50 = true;
                task.spawn(function() -- Line: 307
                    -- upvalues: PathfindingService (ref), u5 (ref), Position (copy), u100 (copy), HumanoidRootPart (ref), u48 (ref), u49 (ref), u50 (ref)
                    local u102 = PathfindingService:CreatePath(u5);

                    if pcall(function() -- Line: 309
                        -- upvalues: u102 (copy), Position (ref), u100 (ref)
                        u102:ComputeAsync(Position, u100);
                    end) and u102.Status == Enum.PathStatus.Success then
                        local v103 = u102:GetWaypoints();

                        if #v103 >= 2 then
                            local Position2 = HumanoidRootPart.Position;
                            local v104 = (1 / 0);
                            local v105 = 1;

                            for i = 1, #v103 do
                                local v106 = Position2.X - v103[i].Position.X;
                                local v107 = Position2.Z - v103[i].Position.Z;
                                local v108 = v106 * v106 + v107 * v107;

                                if v108 < v104 then
                                    v105 = i;
                                    v104 = v108;
                                end;
                            end;

                            u48 = v103;
                            u49 = math.min(v105 + 1, #v103);
                        end;
                    end;

                    u50 = false;
                end);
            end;
        end;

        local v109 = nil;

        if hasLineOfSight(Position, u100) then
            v109 = u100;
        elseif u49 > 0 and u49 <= #u48 then
            v109 = u48[u49].Position;
            local v110 = Position.X - v109.X;
            local v111 = Position.Z - v109.Z;

            if math.sqrt(v110 * v110 + v111 * v111) < 5 then
                u49 = u49 + 1;

                if u49 <= #u48 then
                    v109 = u48[u49].Position;
                else
                    v109 = nil;
                end;
            end;
        end;

        if not v109 then
            return;
        end;

        local v112 = v109.X - Position.X;
        local v113 = v109.Z - Position.Z;
        local v114 = math.sqrt(v112 * v112 + v113 * v113);

        if v114 > 0.5 then
            local v115 = os.clock();

            if v115 - u14 >= 0.5 then
                u14 = v115;
                Footstep:Play();
            end;

            local v116 = u40 * math.min(p99, 0.1);
            local v117 = math.min(v116, v114) / v114;
            local v118 = Position.X + v112 * v117;
            local v119 = Position.Z + v113 * v117;
            local v120 = getGroundY((Vector3.new(v118, Position.Y, v119)));
            local v121 = Vector3.new(v118, v120, v119);
            local v122 = Vector3.new(v118 + v112 / v114, v120, v119 + v113 / v114);
            u13:PivotTo(CFrame.lookAt(v121, v122));
        end;
    end;

    local u123 = nil;
    local u124 = nil;
    local u125 = nil;

    local function updateDebugVisuals() -- Line: 650
        -- upvalues: u123 (ref), u124 (ref), u125 (ref)
        if u123 then
            u123:Destroy();
            u123 = nil;
        end;

        if u124 then
            u124:Destroy();
            u124 = nil;
        end;

        if u125 then
            u125:Destroy();
            u125 = nil;
        end;
    end;

    local function checkKillRadius() -- Line: 717
        -- upvalues: LocalPlayer (ref), HumanoidRootPart (copy)
        local Character = LocalPlayer.Character;

        if not Character then
            return;
        end;

        local HumanoidRootPart2 = Character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart2 then
            return;
        end;

        local v126 = HumanoidRootPart.Position.X - HumanoidRootPart2.Position.X;
        local v127 = HumanoidRootPart.Position.Z - HumanoidRootPart2.Position.Z;

        if math.sqrt(v126 * v126 + v127 * v127) < 13 then
            local v128 = Character:FindFirstChildOfClass("Humanoid");

            if v128 and v128.Health > 0 then
                v128.Health = 0;
            end;
        end;
    end;

    local function checkKillWall() -- Line: 738
        -- upvalues: LocalPlayer (ref), HumanoidRootPart (copy), u38 (ref)
        local Character = LocalPlayer.Character;

        if not Character then
            return;
        end;

        local HumanoidRootPart2 = Character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart2 then
            return;
        end;

        local v129 = Character:FindFirstChildOfClass("Humanoid");

        if not v129 or v129.Health <= 0 then
            return;
        end;

        local Position = HumanoidRootPart.Position;
        local Position2 = HumanoidRootPart2.Position;
        local v130 = Position2.X - Position.X;
        local v131 = Position2.Z - Position.Z;
        local v132 = u38.X * v130 + u38.Z * v131;
        local v133 = math.sqrt(v130 * v130 + v131 * v131);

        if v132 < -2 and (v133 < 120 and math.abs(u38.X * v131 - u38.Z * v130) < 100) then
            v129.Health = 0;
        end;
    end;

    local u134 = nil;
    u134 = RunService.RenderStepped:Connect(function(p135) -- Line: 776
        -- upvalues: u13 (copy), u134 (ref), u35 (ref), LocalPlayer (ref), HumanoidRootPart (copy), u41 (ref), isInAnyZonePart (ref), isInSpeedZone (ref), u39 (ref), u40 (ref), u33 (ref), u34 (ref), u48 (ref), u49 (ref), u51 (ref), u37 (ref), u1 (ref), Y (ref), showBossUI (copy), u36 (ref), u31 (copy), u32 (copy), ChaseMusic (copy), goIdle (copy), u42 (ref), moveDirectToPlayer (copy), checkKillWall (copy), checkKillRadius (copy), findClosestWaypointIndex (copy), moveWaypoints (copy), movePathfind (copy), u123 (ref), u124 (ref), u125 (ref)
        if not u13.Parent then
            u134:Disconnect();
            u35 = false;
            u13:Destroy();

            return;
        end;

        local Character = LocalPlayer.Character;
        local v136;

        if Character then
            v136 = Character:FindFirstChild("HumanoidRootPart");
        else
            v136 = Character;
        end;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        local v137;

        if v136 == nil or Character == nil then
            v137 = false;
        else
            v137 = Character.Health > 0;
        end;

        local v138 = v137 and v136.Position or nil;
        local Position = HumanoidRootPart.Position;

        if v138 then
            u41 = v138;
        end;

        local v139;

        if (v138 or u41) == nil then
            v139 = false;
        else
            v139 = isInAnyZonePart(v138 or u41) or false;
        end;

        local v140;

        if (v138 or u41) == nil then
            v140 = false;
        else
            v140 = isInSpeedZone(v138 or u41) or false;
        end;

        u39 = v140 and 280 or 220;
        u40 = v140 and 280 or 220;

        if not v137 and (u33 == "ChasingWaypoints" or (u33 == "ChasingPathfind" or u33 == "Countdown")) then
            u34 = false;
            u33 = "Returning";
            u48 = {};
            u49 = 0;
            u51 = 0;
            u37 = 1;
        end;

        if u33 ~= "ChasingWaypoints" then
            local v141;

            if u33 == "Idle" or u33 == "Returning" then
                v141 = u1.Y;
            else
                v141 = Y;
            end;

            if Position.Y < v141 - 50 then
                local v142 = Vector3.new(Position.X, v141, Position.Z);
                u13:PivotTo(CFrame.new(v142));
            end;
        end;

        if u33 == "Idle" then
            if v139 then
                u33 = "Countdown";
                u34 = true;
                task.spawn(function() -- Line: 449
                    -- upvalues: u34 (ref), u35 (ref), LocalPlayer (ref), showBossUI (ref), u33 (ref), u36 (ref), u37 (ref), u31 (ref), u32 (ref), ChaseMusic (ref)
                    for i = 3, 1, -1 do
                        if not (u34 and u35) then
                            local BossCountdownGui = LocalPlayer.PlayerGui:FindFirstChild("BossCountdownGui");

                            if BossCountdownGui then
                                BossCountdownGui:Destroy();
                            end;

                            return;
                        end;

                        showBossUI(i, false);
                        task.wait(1);
                    end;

                    if not (u34 and u35) then
                        local BossCountdownGui = LocalPlayer.PlayerGui:FindFirstChild("BossCountdownGui");

                        if BossCountdownGui then
                            BossCountdownGui:Destroy();
                        end;

                        return;
                    end;

                    showBossUI(nil, true);
                    u33 = "ChasingWaypoints";
                    u36 = os.clock();
                    u37 = 1;
                    u31:Play();
                    u32:Stop();

                    if not ChaseMusic.IsPlaying then
                        ChaseMusic:Play();
                    end;
                end);
            end;
        elseif u33 == "Countdown" then
            if not v139 then
                u34 = false;
                goIdle();
            end;
        elseif u33 == "ChasingWaypoints" then
            if v139 or os.clock() - u36 <= 2 then
                if v140 then
                    u42 = true;
                    local v143 = v138 or u41;

                    if v143 then
                        moveDirectToPlayer(p135, v143);
                    end;

                    checkKillWall();
                    checkKillRadius();
                else
                    if u42 then
                        u42 = false;
                        u37 = findClosestWaypointIndex();
                    end;

                    moveWaypoints(p135);
                    checkKillWall();
                    checkKillRadius();
                end;
            else
                u33 = "Returning";
                u48 = {};
                u49 = 0;
                u51 = 0;
                u37 = 1;
            end;
        elseif u33 == "ChasingPathfind" then
            if v139 or os.clock() - u36 <= 2 then
                local v144 = v138 or u41;

                if v144 then
                    if v140 then
                        u42 = true;
                        moveDirectToPlayer(p135, v144);
                    else
                        u42 = false;
                        movePathfind(p135, v144);
                    end;

                    checkKillRadius();
                end;
            else
                u33 = "Returning";
                u48 = {};
                u49 = 0;
                u51 = 0;
                u37 = 1;
            end;
        elseif u33 == "Returning" then
            u13:PivotTo(u1);
            goIdle();
        end;

        if u123 then
            u123:Destroy();
            u123 = nil;
        end;

        if u124 then
            u124:Destroy();
            u124 = nil;
        end;

        if u125 then
            u125:Destroy();
            u125 = nil;
        end;
    end);
end;

local function tryStart() -- Line: 889
    -- upvalues: u10 (ref), CollectionService (copy), startNPC (copy)
    if u10 then
        return;
    end;

    if #CollectionService:GetTagged("NPC15_World2_Zone") > 0 then
        task.spawn(startNPC);
    end;
end;

CollectionService:GetInstanceAddedSignal("NPC15_World2_Zone"):Connect(tryStart);

if not u10 and #CollectionService:GetTagged("NPC15_World2_Zone") > 0 then
    task.spawn(startNPC);
end;