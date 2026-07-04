-- Ruta Original: StarterPlayer.StarterPlayerScripts.Pièges.LocalNPC15_World2_AI
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
task.spawn(function() -- Line: 42
    -- upvalues: ContentProvider (copy), Animation (copy), Animation2 (copy), NPC15_World2 (copy)
    ContentProvider:PreloadAsync({ Animation, Animation2, NPC15_World2 });
end);

local function loadWaypoints() -- Line: 54
    -- upvalues: CollectionService (copy)
    local v2 = {};

    for _, v in ipairs(CollectionService:GetTagged("NPC15_World2_Waypoint")) do
        if v:IsA("BasePart") then
            table.insert(v2, v);
        end;
    end;

    table.sort(v2, function(p3, p4) -- Line: 61
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

local function isInAnyZonePart(p6) -- Line: 82
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

local function isInSpeedZone(p8) -- Line: 96
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

local function startNPC() -- Line: 115
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

    CollectionService:GetInstanceAddedSignal("NPC15_World2_Waypoint"):Connect(function() -- Line: 166
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
    local Y = u1.Y;

    local function getGroundY(p16) -- Line: 198
        -- upvalues: Y (ref), u15 (copy)
        local v17 = Vector3.new(p16.X, Y + 10, p16.Z);
        local v18 = workspace:Raycast(v17, Vector3.new(0, -200, 0), u15);

        if v18 then
            Y = v18.Position.Y + 3;

            return Y;
        end;

        local v19 = Vector3.new(p16.X, Y + 50, p16.Z);
        local v20 = workspace:Raycast(v19, Vector3.new(0, -200, 0), u15);

        if not v20 then
            return Y;
        end;

        Y = v20.Position.Y + 3;

        return Y;
    end;

    task.spawn(function() -- Line: 218
        -- upvalues: PathfindingService (ref), u5 (ref), u1 (ref)
        local u21 = PathfindingService:CreatePath(u5);
        pcall(function() -- Line: 220
            -- upvalues: u21 (copy), u1 (ref)
            u21:ComputeAsync(u1.Position, u1.Position + Vector3.new(10, 0, 10));
        end);
    end);
    local u22 = Animator:LoadAnimation(Animation);
    local u23 = Animator:LoadAnimation(Animation2);
    u23:Play();
    local u24 = "Idle";
    local u25 = false;
    local u26 = true;
    local u27 = 0;
    local u28 = 1;
    local u29 = Vector3.new(0, 0, 1);
    local u30 = 230;
    local u31 = 230;
    local u32 = nil;
    local u33 = false;

    local function findClosestWaypointIndex() -- Line: 242
        -- upvalues: HumanoidRootPart (copy), u11 (ref)
        local Position = HumanoidRootPart.Position;
        local v34 = (1 / 0);
        local v35 = 1;

        for i, v in ipairs(u11) do
            local v36 = Position.X - v.Position.X;
            local v37 = Position.Z - v.Position.Z;
            local v38 = v36 * v36 + v37 * v37;

            if v38 < v34 then
                v35 = i;
                v34 = v38;
            end;
        end;

        return v35;
    end;

    local u39 = {};
    local u40 = 0;
    local u41 = false;
    local u42 = 0;

    local function requestPath(u43, u44) -- Line: 264
        -- upvalues: u41 (ref), PathfindingService (ref), u5 (ref), HumanoidRootPart (copy), u39 (ref), u40 (ref)
        if u41 then
            return;
        end;

        u41 = true;
        task.spawn(function() -- Line: 267
            -- upvalues: PathfindingService (ref), u5 (ref), u43 (copy), u44 (copy), HumanoidRootPart (ref), u39 (ref), u40 (ref), u41 (ref)
            local u45 = PathfindingService:CreatePath(u5);

            if pcall(function() -- Line: 269
                -- upvalues: u45 (copy), u43 (ref), u44 (ref)
                u45:ComputeAsync(u43, u44);
            end) and u45.Status == Enum.PathStatus.Success then
                local v46 = u45:GetWaypoints();

                if #v46 >= 2 then
                    local Position = HumanoidRootPart.Position;
                    local v47 = (1 / 0);
                    local v48 = 1;

                    for i = 1, #v46 do
                        local v49 = Position.X - v46[i].Position.X;
                        local v50 = Position.Z - v46[i].Position.Z;
                        local v51 = v49 * v49 + v50 * v50;

                        if v51 < v47 then
                            v48 = i;
                            v47 = v51;
                        end;
                    end;

                    u39 = v46;
                    u40 = math.min(v48 + 1, #v46);
                end;
            end;

            u41 = false;
        end);
    end;

    local function goIdle() -- Line: 294
        -- upvalues: u24 (ref), u25 (ref), u22 (copy), u23 (copy), ChaseMusic (copy), Footstep (copy), u39 (ref), u40 (ref), u28 (ref), Y (ref), u1 (ref)
        u24 = "Idle";
        u25 = false;
        u22:Stop(0.1);
        u23:Play();

        if ChaseMusic.IsPlaying then
            ChaseMusic:Stop();
        end;

        Footstep:Stop();
        u39 = {};
        u40 = 0;
        u28 = 1;
        Y = u1.Y;
    end;

    local function goChasingWaypoints() -- Line: 307
        -- upvalues: u24 (ref), u27 (ref), u28 (ref), u22 (copy), u23 (copy), ChaseMusic (copy)
        u24 = "ChasingWaypoints";
        u27 = os.clock();
        u28 = 1;
        u22:Play();
        u23:Stop();

        if not ChaseMusic.IsPlaying then
            ChaseMusic:Play();
        end;
    end;

    local function goChasingPathfind() -- Line: 316
        -- upvalues: u24 (ref), u39 (ref), u40 (ref), u42 (ref), Y (ref), HumanoidRootPart (copy)
        u24 = "ChasingPathfind";
        u39 = {};
        u40 = 0;
        u42 = 0;
        Y = HumanoidRootPart.Position.Y;
    end;

    local function goReturn() -- Line: 326
        -- upvalues: u24 (ref), u39 (ref), u40 (ref), u42 (ref), u28 (ref)
        u24 = "Returning";
        u39 = {};
        u40 = 0;
        u42 = 0;
        u28 = 1;
    end;

    local u52 = {
        [3] = Color3.fromRGB(255, 160, 0),
        [2] = Color3.fromRGB(255, 80, 0),
        [1] = Color3.fromRGB(255, 20, 0)
    };

    local function showBossUI(p53, p54) -- Line: 341
        -- upvalues: LocalPlayer (ref), u52 (copy), TweenService (ref)
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
        TextLabel.Text = p54 and "💀 BOSS IS CHASING 💀" or "⚠️ BOSS INCOMING ⚠️";
        local v55;

        if p54 then
            v55 = Color3.fromRGB(255, 80, 80);
        else
            v55 = Color3.fromRGB(255, 160, 0);
        end;

        TextLabel.TextColor3 = v55;
        TextLabel.TextScaled = true;
        TextLabel.Font = Enum.Font.GothamBlack;
        local UIStroke = Instance.new("UIStroke", TextLabel);
        UIStroke.Thickness = 4;
        UIStroke.Color = Color3.fromRGB(0, 0, 0);
        local TextLabel2 = Instance.new("TextLabel", Frame);
        TextLabel2.Size = UDim2.new(1, 0, 0.45, 0);
        TextLabel2.BackgroundTransparency = 1;
        TextLabel2.Text = p54 and "RUN !" or tostring(p53);
        local v56;

        if p54 then
            v56 = Color3.fromRGB(255, 255, 255);
        else
            v56 = u52[p53] or Color3.fromRGB(255, 30, 30);
        end;

        TextLabel2.TextColor3 = v56;
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
        task.delay(p54 and 2.2 or 0.9, function() -- Line: 393
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
            local v57 = TweenInfo.new(0.5);

            for _, descendant in ipairs(Frame:GetDescendants()) do
                if descendant:IsA("TextLabel") then
                    TweenService:Create(descendant, v57, {
                        TextTransparency = 1
                    }):Play();
                elseif descendant:IsA("UIStroke") then
                    TweenService:Create(descendant, v57, {
                        Transparency = 1
                    }):Play();
                end;
            end;

            task.delay(0.65, function() -- Line: 402
                -- upvalues: ScreenGui (ref)
                if ScreenGui.Parent then
                    ScreenGui:Destroy();
                end;
            end);
        end);
    end;

    local function startCountdown() -- Line: 406
        -- upvalues: u24 (ref), u25 (ref), u26 (ref), LocalPlayer (ref), showBossUI (copy), u27 (ref), u28 (ref), u22 (copy), u23 (copy), ChaseMusic (copy)
        u24 = "Countdown";
        u25 = true;
        task.spawn(function() -- Line: 409
            -- upvalues: u25 (ref), u26 (ref), LocalPlayer (ref), showBossUI (ref), u24 (ref), u27 (ref), u28 (ref), u22 (ref), u23 (ref), ChaseMusic (ref)
            for i = 3, 1, -1 do
                if not (u25 and u26) then
                    local BossCountdownGui = LocalPlayer.PlayerGui:FindFirstChild("BossCountdownGui");

                    if BossCountdownGui then
                        BossCountdownGui:Destroy();
                    end;

                    return;
                end;

                showBossUI(i, false);
                task.wait(1);
            end;

            if not (u25 and u26) then
                local BossCountdownGui = LocalPlayer.PlayerGui:FindFirstChild("BossCountdownGui");

                if BossCountdownGui then
                    BossCountdownGui:Destroy();
                end;

                return;
            end;

            showBossUI(nil, true);
            u24 = "ChasingWaypoints";
            u27 = os.clock();
            u28 = 1;
            u22:Play();
            u23:Stop();

            if not ChaseMusic.IsPlaying then
                ChaseMusic:Play();
            end;
        end);
    end;

    local u58 = RaycastParams.new();
    u58.FilterType = Enum.RaycastFilterType.Exclude;
    u58.FilterDescendantsInstances = { u13 };

    local function hasLineOfSight(p59, p60) -- Line: 434
        -- upvalues: LocalPlayer (ref), u58 (copy), u13 (copy)
        local Character = LocalPlayer.Character;
        local v61;

        if Character then
            v61 = { u13, Character };
        else
            v61 = { u13 };
        end;

        u58.FilterDescendantsInstances = v61;
        local v62 = Vector3.new(p60.X - p59.X, 0, p60.Z - p59.Z);

        return workspace:Raycast(p59, v62, u58) == nil;
    end;

    local function moveWaypoints(p63) -- Line: 443
        -- upvalues: u28 (ref), u11 (ref), HumanoidRootPart (copy), u24 (ref), u39 (ref), u40 (ref), u42 (ref), Y (ref), u29 (ref), u14 (ref), Footstep (copy), u30 (ref), u13 (copy)
        while u28 <= #u11 do
            local v64 = u11[u28];
            local Position = HumanoidRootPart.Position;
            local v65 = v64.Position.X - Position.X;
            local v66 = v64.Position.Z - Position.Z;

            if math.sqrt(v65 * v65 + v66 * v66) >= 5 then
                break;
            end;

            u28 = u28 + 1;
        end;

        if u28 > #u11 then
            u24 = "ChasingPathfind";
            u39 = {};
            u40 = 0;
            u42 = 0;
            Y = HumanoidRootPart.Position.Y;

            return;
        end;

        local Position = u11[u28].Position;
        local Position2 = HumanoidRootPart.Position;
        local v67 = Position.X - Position2.X;
        local v68 = Position.Z - Position2.Z;
        local v69 = math.sqrt(v67 * v67 + v68 * v68);

        if v69 > 0.1 then
            u29 = Vector3.new(v67 / v69, 0, v68 / v69);
        end;

        local v70 = os.clock();

        if v70 - u14 >= 0.5 then
            u14 = v70;
            Footstep:Play();
        end;

        local v71 = u30 * math.min(p63, 0.1);
        local v72 = math.min(v71, v69) / v69;
        local v73 = Position2.X + v67 * v72;
        local v74 = Position2.Z + v68 * v72;
        local v75 = Position2.Y + (Position.Y - Position2.Y) * v72;
        local v76 = Vector3.new(v73, v75, v74);
        local v77 = Vector3.new(v73 + v67 / v69, v75, v74 + v68 / v69);
        u13:PivotTo(CFrame.lookAt(v76, v77));
    end;

    local function moveDirectToPlayer(p78, p79) -- Line: 501
        -- upvalues: HumanoidRootPart (copy), u14 (ref), Footstep (copy), u30 (ref), u29 (ref), u13 (copy)
        local Position = HumanoidRootPart.Position;
        local v80 = p79 - Position;
        local Magnitude = v80.Magnitude;

        if Magnitude < 0.5 then
            return;
        end;

        local v81 = os.clock();

        if v81 - u14 >= 0.5 then
            u14 = v81;
            Footstep:Play();
        end;

        local v82 = u30 * math.min(p78, 0.1);
        local v83 = math.min(v82, Magnitude);
        local v84 = v80 / Magnitude;
        local v85 = Position + v84 * v83;
        u29 = Vector3.new(v84.X, 0, v84.Z).Unit;
        local v86 = Vector3.new(v85.X + v84.X, v85.Y, v85.Z + v84.Z);
        u13:PivotTo(CFrame.lookAt(v85, v86));
    end;

    local function movePathfind(p87, u88) -- Line: 529
        -- upvalues: HumanoidRootPart (copy), u42 (ref), u41 (ref), PathfindingService (ref), u5 (ref), u39 (ref), u40 (ref), hasLineOfSight (copy), u14 (ref), Footstep (copy), u31 (ref), getGroundY (copy), u13 (copy)
        local Position = HumanoidRootPart.Position;
        local v89 = os.clock();

        if v89 - u42 > 0.3 then
            u42 = v89;

            if not u41 then
                u41 = true;
                task.spawn(function() -- Line: 267
                    -- upvalues: PathfindingService (ref), u5 (ref), Position (copy), u88 (copy), HumanoidRootPart (ref), u39 (ref), u40 (ref), u41 (ref)
                    local u90 = PathfindingService:CreatePath(u5);

                    if pcall(function() -- Line: 269
                        -- upvalues: u90 (copy), Position (ref), u88 (ref)
                        u90:ComputeAsync(Position, u88);
                    end) and u90.Status == Enum.PathStatus.Success then
                        local v91 = u90:GetWaypoints();

                        if #v91 >= 2 then
                            local Position2 = HumanoidRootPart.Position;
                            local v92 = (1 / 0);
                            local v93 = 1;

                            for i = 1, #v91 do
                                local v94 = Position2.X - v91[i].Position.X;
                                local v95 = Position2.Z - v91[i].Position.Z;
                                local v96 = v94 * v94 + v95 * v95;

                                if v96 < v92 then
                                    v93 = i;
                                    v92 = v96;
                                end;
                            end;

                            u39 = v91;
                            u40 = math.min(v93 + 1, #v91);
                        end;
                    end;

                    u41 = false;
                end);
            end;
        end;

        local v97 = nil;

        if hasLineOfSight(Position, u88) then
            v97 = u88;
        elseif u40 > 0 and u40 <= #u39 then
            v97 = u39[u40].Position;
            local v98 = Position.X - v97.X;
            local v99 = Position.Z - v97.Z;

            if math.sqrt(v98 * v98 + v99 * v99) < 5 then
                u40 = u40 + 1;

                if u40 <= #u39 then
                    v97 = u39[u40].Position;
                else
                    v97 = nil;
                end;
            end;
        end;

        if not v97 then
            return;
        end;

        local v100 = v97.X - Position.X;
        local v101 = v97.Z - Position.Z;
        local v102 = math.sqrt(v100 * v100 + v101 * v101);

        if v102 > 0.5 then
            local v103 = os.clock();

            if v103 - u14 >= 0.5 then
                u14 = v103;
                Footstep:Play();
            end;

            local v104 = u31 * math.min(p87, 0.1);
            local v105 = math.min(v104, v102) / v102;
            local v106 = Position.X + v100 * v105;
            local v107 = Position.Z + v101 * v105;
            local v108 = getGroundY((Vector3.new(v106, Position.Y, v107)));
            local v109 = Vector3.new(v106, v108, v107);
            local v110 = Vector3.new(v106 + v100 / v102, v108, v107 + v101 / v102);
            u13:PivotTo(CFrame.lookAt(v109, v110));
        end;
    end;

    local u111 = nil;
    local u112 = nil;
    local u113 = nil;

    local function updateDebugVisuals() -- Line: 588
        -- upvalues: u111 (ref), u112 (ref), u113 (ref)
        if u111 then
            u111:Destroy();
            u111 = nil;
        end;

        if u112 then
            u112:Destroy();
            u112 = nil;
        end;

        if u113 then
            u113:Destroy();
            u113 = nil;
        end;
    end;

    local function checkKillRadius() -- Line: 655
        -- upvalues: LocalPlayer (ref), HumanoidRootPart (copy)
        local Character = LocalPlayer.Character;

        if not Character then
            return;
        end;

        local HumanoidRootPart2 = Character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart2 then
            return;
        end;

        local v114 = HumanoidRootPart.Position.X - HumanoidRootPart2.Position.X;
        local v115 = HumanoidRootPart.Position.Z - HumanoidRootPart2.Position.Z;

        if math.sqrt(v114 * v114 + v115 * v115) < 13 then
            local v116 = Character:FindFirstChildOfClass("Humanoid");

            if v116 and v116.Health > 0 then
                v116.Health = 0;
            end;
        end;
    end;

    local function checkKillWall() -- Line: 676
        -- upvalues: LocalPlayer (ref), HumanoidRootPart (copy), u29 (ref)
        local Character = LocalPlayer.Character;

        if not Character then
            return;
        end;

        local HumanoidRootPart2 = Character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart2 then
            return;
        end;

        local v117 = Character:FindFirstChildOfClass("Humanoid");

        if not v117 or v117.Health <= 0 then
            return;
        end;

        local Position = HumanoidRootPart.Position;
        local Position2 = HumanoidRootPart2.Position;
        local v118 = Position2.X - Position.X;
        local v119 = Position2.Z - Position.Z;
        local v120 = u29.X * v118 + u29.Z * v119;
        local v121 = math.sqrt(v118 * v118 + v119 * v119);

        if v120 < -2 and (v121 < 120 and math.abs(u29.X * v119 - u29.Z * v118) < 100) then
            v117.Health = 0;
        end;
    end;

    local u122 = nil;
    u122 = RunService.RenderStepped:Connect(function(p123) -- Line: 714
        -- upvalues: u13 (copy), u122 (ref), u26 (ref), LocalPlayer (ref), HumanoidRootPart (copy), u32 (ref), isInAnyZonePart (ref), isInSpeedZone (ref), u30 (ref), u31 (ref), u24 (ref), u25 (ref), u39 (ref), u40 (ref), u42 (ref), u28 (ref), u1 (ref), Y (ref), showBossUI (copy), u27 (ref), u22 (copy), u23 (copy), ChaseMusic (copy), goIdle (copy), u33 (ref), moveDirectToPlayer (copy), checkKillWall (copy), checkKillRadius (copy), findClosestWaypointIndex (copy), moveWaypoints (copy), movePathfind (copy), u111 (ref), u112 (ref), u113 (ref)
        if not u13.Parent then
            u122:Disconnect();
            u26 = false;
            u13:Destroy();

            return;
        end;

        local Character = LocalPlayer.Character;
        local v124;

        if Character then
            v124 = Character:FindFirstChild("HumanoidRootPart");
        else
            v124 = Character;
        end;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        local v125;

        if v124 == nil or Character == nil then
            v125 = false;
        else
            v125 = Character.Health > 0;
        end;

        local v126 = v125 and v124.Position or nil;
        local Position = HumanoidRootPart.Position;

        if v126 then
            u32 = v126;
        end;

        local v127;

        if (v126 or u32) == nil then
            v127 = false;
        else
            v127 = isInAnyZonePart(v126 or u32) or false;
        end;

        local v128;

        if (v126 or u32) == nil then
            v128 = false;
        else
            v128 = isInSpeedZone(v126 or u32) or false;
        end;

        u30 = v128 and 280 or 230;
        u31 = v128 and 280 or 230;

        if not v125 and (u24 == "ChasingWaypoints" or (u24 == "ChasingPathfind" or u24 == "Countdown")) then
            u25 = false;
            u24 = "Returning";
            u39 = {};
            u40 = 0;
            u42 = 0;
            u28 = 1;
        end;

        if u24 ~= "ChasingWaypoints" then
            local v129;

            if u24 == "Idle" or u24 == "Returning" then
                v129 = u1.Y;
            else
                v129 = Y;
            end;

            if Position.Y < v129 - 50 then
                local v130 = Vector3.new(Position.X, v129, Position.Z);
                u13:PivotTo(CFrame.new(v130));
            end;
        end;

        if u24 == "Idle" then
            if v127 then
                u24 = "Countdown";
                u25 = true;
                task.spawn(function() -- Line: 409
                    -- upvalues: u25 (ref), u26 (ref), LocalPlayer (ref), showBossUI (ref), u24 (ref), u27 (ref), u28 (ref), u22 (ref), u23 (ref), ChaseMusic (ref)
                    for i = 3, 1, -1 do
                        if not (u25 and u26) then
                            local BossCountdownGui = LocalPlayer.PlayerGui:FindFirstChild("BossCountdownGui");

                            if BossCountdownGui then
                                BossCountdownGui:Destroy();
                            end;

                            return;
                        end;

                        showBossUI(i, false);
                        task.wait(1);
                    end;

                    if not (u25 and u26) then
                        local BossCountdownGui = LocalPlayer.PlayerGui:FindFirstChild("BossCountdownGui");

                        if BossCountdownGui then
                            BossCountdownGui:Destroy();
                        end;

                        return;
                    end;

                    showBossUI(nil, true);
                    u24 = "ChasingWaypoints";
                    u27 = os.clock();
                    u28 = 1;
                    u22:Play();
                    u23:Stop();

                    if not ChaseMusic.IsPlaying then
                        ChaseMusic:Play();
                    end;
                end);
            end;
        elseif u24 == "Countdown" then
            if not v127 then
                u25 = false;
                goIdle();
            end;
        elseif u24 == "ChasingWaypoints" then
            if v127 or os.clock() - u27 <= 2 then
                if v128 then
                    u33 = true;
                    local v131 = v126 or u32;

                    if v131 then
                        moveDirectToPlayer(p123, v131);
                    end;

                    checkKillWall();
                    checkKillRadius();
                else
                    if u33 then
                        u33 = false;
                        u28 = findClosestWaypointIndex();
                    end;

                    moveWaypoints(p123);
                    checkKillWall();
                    checkKillRadius();
                end;
            else
                u24 = "Returning";
                u39 = {};
                u40 = 0;
                u42 = 0;
                u28 = 1;
            end;
        elseif u24 == "ChasingPathfind" then
            if v127 or os.clock() - u27 <= 2 then
                local v132 = v126 or u32;

                if v132 then
                    if v128 then
                        u33 = true;
                        moveDirectToPlayer(p123, v132);
                    else
                        u33 = false;
                        movePathfind(p123, v132);
                    end;

                    checkKillRadius();
                end;
            else
                u24 = "Returning";
                u39 = {};
                u40 = 0;
                u42 = 0;
                u28 = 1;
            end;
        elseif u24 == "Returning" then
            u13:PivotTo(u1);
            goIdle();
        end;

        if u111 then
            u111:Destroy();
            u111 = nil;
        end;

        if u112 then
            u112:Destroy();
            u112 = nil;
        end;

        if u113 then
            u113:Destroy();
            u113 = nil;
        end;
    end);
end;

local function tryStart() -- Line: 827
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