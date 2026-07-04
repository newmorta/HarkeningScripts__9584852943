-- Ruta Original: StarterPlayer.StarterPlayerScripts.Pièges.LocalNPC9_AI
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
local NPC9 = ReplicatedStorage:WaitForChild("NPC9");
local u1 = NPC9:GetPivot();
local Animation = Instance.new("Animation");
Animation.AnimationId = "rbxassetid://90717240038055";
local Animation2 = Instance.new("Animation");
Animation2.AnimationId = "rbxassetid://78010228363636";
task.spawn(function() -- Line: 38
    -- upvalues: ContentProvider (copy), Animation (copy), Animation2 (copy), NPC9 (copy)
    ContentProvider:PreloadAsync({ Animation, Animation2, NPC9 });
end);
local u2 = {};
local u3 = {
    AgentRadius = 1,
    AgentHeight = 5,
    AgentCanJump = false,
    AgentCanClimb = false,
    WaypointSpacing = 4
};

local function isInZone(p4, p5) -- Line: 58
    local v6 = p4.CFrame:PointToObjectSpace(p5);
    local v7;

    if math.abs(v6.X) <= p4.Size.X / 2 and math.abs(v6.Y) <= math.max(p4.Size.Y / 2, 30) then
        v7 = math.abs(v6.Z) <= p4.Size.Z / 2;
    else
        v7 = false;
    end;

    return v7;
end;

local function startNPC(u8) -- Line: 70
    -- upvalues: u2 (copy), NPC9 (copy), u1 (copy), PathfindingService (copy), u3 (copy), Animation (copy), Animation2 (copy), LocalPlayer (copy), TweenService (copy), RunService (copy), isInZone (copy)
    if u2[u8] then
        return;
    end;

    u2[u8] = true;
    local u9 = NPC9:Clone();
    u9:PivotTo(u1);
    u9.Parent = workspace;
    local HumanoidRootPart = u9:WaitForChild("HumanoidRootPart");
    local Animator = u9:WaitForChild("Humanoid"):WaitForChild("Animator");
    local ChaseMusic = HumanoidRootPart:WaitForChild("ChaseMusic");
    local Footstep = HumanoidRootPart:WaitForChild("Footstep");
    local u10 = 0;
    HumanoidRootPart.Anchored = true;
    local Y = u1.Y;
    task.spawn(function() -- Line: 94
        -- upvalues: PathfindingService (ref), u3 (ref), u1 (ref)
        local u11 = PathfindingService:CreatePath(u3);
        pcall(function() -- Line: 96
            -- upvalues: u11 (copy), u1 (ref)
            u11:ComputeAsync(u1.Position, u1.Position + Vector3.new(10, 0, 10));
        end);
    end);
    local u12 = Animator:LoadAnimation(Animation);
    local u13 = Animator:LoadAnimation(Animation2);
    u13:Play();
    local u14 = "Idle";
    local u15 = false;
    local u16 = true;
    local u17 = 0;
    local u18 = {};
    local u19 = 0;
    local u20 = false;
    local u21 = 0;

    local function requestPath(u22, u23) -- Line: 115
        -- upvalues: u20 (ref), PathfindingService (ref), u3 (ref), HumanoidRootPart (copy), u18 (ref), u19 (ref)
        if u20 then
            return;
        end;

        u20 = true;
        task.spawn(function() -- Line: 118
            -- upvalues: PathfindingService (ref), u3 (ref), u22 (copy), u23 (copy), HumanoidRootPart (ref), u18 (ref), u19 (ref), u20 (ref)
            local u24 = PathfindingService:CreatePath(u3);

            if pcall(function() -- Line: 120
                -- upvalues: u24 (copy), u22 (ref), u23 (ref)
                u24:ComputeAsync(u22, u23);
            end) and u24.Status == Enum.PathStatus.Success then
                local v25 = u24:GetWaypoints();

                if #v25 >= 2 then
                    local Position = HumanoidRootPart.Position;
                    local v26 = (1 / 0);
                    local v27 = 1;

                    for i = 1, #v25 do
                        local v28 = Position.X - v25[i].Position.X;
                        local v29 = Position.Z - v25[i].Position.Z;
                        local v30 = v28 * v28 + v29 * v29;

                        if v30 < v26 then
                            v27 = i;
                            v26 = v30;
                        end;
                    end;

                    u18 = v25;
                    u19 = math.min(v27 + 1, #v25);
                end;
            end;

            u20 = false;
        end);
    end;

    local function goIdle() -- Line: 148
        -- upvalues: u14 (ref), u15 (ref), u12 (copy), u13 (copy), ChaseMusic (copy), Footstep (copy), u18 (ref), u19 (ref)
        u14 = "Idle";
        u15 = false;
        u12:Stop(0.1);
        u13:Play();

        if ChaseMusic.IsPlaying then
            ChaseMusic:Stop();
        end;

        Footstep:Stop();
        u18 = {};
        u19 = 0;
    end;

    local function goChase() -- Line: 160
        -- upvalues: u14 (ref), u17 (ref), u12 (copy), u13 (copy), ChaseMusic (copy), u18 (ref), u21 (ref)
        u14 = "Chasing";
        u17 = os.clock();
        u12:Play();
        u13:Stop();

        if not ChaseMusic.IsPlaying then
            ChaseMusic:Play();
        end;

        if #u18 == 0 then
            u21 = 0;
        end;
    end;

    local function goReturn() -- Line: 172
        -- upvalues: u14 (ref), u18 (ref), u19 (ref), u21 (ref)
        u14 = "Returning";
        u18 = {};
        u19 = 0;
        u21 = 0;
    end;

    local u31 = {
        [3] = Color3.fromRGB(255, 160, 0),
        [2] = Color3.fromRGB(255, 80, 0),
        [1] = Color3.fromRGB(255, 20, 0)
    };

    local function showBossUI(p32, p33) -- Line: 186
        -- upvalues: LocalPlayer (ref), u31 (copy), TweenService (ref)
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
        TextLabel.Text = p33 and "💀 BOSS IS CHASING 💀" or "⚠️ BOSS INCOMING ⚠️";
        local v34;

        if p33 then
            v34 = Color3.fromRGB(255, 80, 80);
        else
            v34 = Color3.fromRGB(255, 160, 0);
        end;

        TextLabel.TextColor3 = v34;
        TextLabel.TextScaled = true;
        TextLabel.Font = Enum.Font.GothamBlack;
        local UIStroke = Instance.new("UIStroke", TextLabel);
        UIStroke.Thickness = 4;
        UIStroke.Color = Color3.fromRGB(0, 0, 0);
        local TextLabel2 = Instance.new("TextLabel", Frame);
        TextLabel2.Size = UDim2.new(1, 0, 0.45, 0);
        TextLabel2.BackgroundTransparency = 1;
        TextLabel2.Text = p33 and "RUN !" or tostring(p32);
        local v35;

        if p33 then
            v35 = Color3.fromRGB(255, 255, 255);
        else
            v35 = u31[p32] or Color3.fromRGB(255, 30, 30);
        end;

        TextLabel2.TextColor3 = v35;
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
        task.delay(p33 and 2.2 or 0.9, function() -- Line: 243
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
            local v36 = TweenInfo.new(0.5);

            for _, descendant in ipairs(Frame:GetDescendants()) do
                if descendant:IsA("TextLabel") then
                    TweenService:Create(descendant, v36, {
                        TextTransparency = 1
                    }):Play();
                elseif descendant:IsA("UIStroke") then
                    TweenService:Create(descendant, v36, {
                        Transparency = 1
                    }):Play();
                end;
            end;

            task.delay(0.65, function() -- Line: 252
                -- upvalues: ScreenGui (ref)
                if ScreenGui.Parent then
                    ScreenGui:Destroy();
                end;
            end);
        end);
    end;

    local function startCountdown() -- Line: 256
        -- upvalues: u14 (ref), u15 (ref), LocalPlayer (ref), u1 (ref), u20 (ref), PathfindingService (ref), u3 (ref), HumanoidRootPart (copy), u18 (ref), u19 (ref), u16 (ref), showBossUI (copy), u17 (ref), u12 (copy), u13 (copy), ChaseMusic (copy), u21 (ref)
        u14 = "Countdown";
        u15 = true;
        local v37 = LocalPlayer.Character and v37:FindFirstChild("HumanoidRootPart");

        if v37 then
            local Position = u1.Position;
            local Position2 = v37.Position;

            if not u20 then
                u20 = true;
                task.spawn(function() -- Line: 118
                    -- upvalues: PathfindingService (ref), u3 (ref), Position (copy), Position2 (copy), HumanoidRootPart (ref), u18 (ref), u19 (ref), u20 (ref)
                    local u38 = PathfindingService:CreatePath(u3);

                    if pcall(function() -- Line: 120
                        -- upvalues: u38 (copy), Position (ref), Position2 (ref)
                        u38:ComputeAsync(Position, Position2);
                    end) and u38.Status == Enum.PathStatus.Success then
                        local v39 = u38:GetWaypoints();

                        if #v39 >= 2 then
                            local Position3 = HumanoidRootPart.Position;
                            local v40 = (1 / 0);
                            local v41 = 1;

                            for i = 1, #v39 do
                                local v42 = Position3.X - v39[i].Position.X;
                                local v43 = Position3.Z - v39[i].Position.Z;
                                local v44 = v42 * v42 + v43 * v43;

                                if v44 < v40 then
                                    v41 = i;
                                    v40 = v44;
                                end;
                            end;

                            u18 = v39;
                            u19 = math.min(v41 + 1, #v39);
                        end;
                    end;

                    u20 = false;
                end);
            end;
        end;

        task.spawn(function() -- Line: 265
            -- upvalues: u15 (ref), u16 (ref), LocalPlayer (ref), showBossUI (ref), u14 (ref), u17 (ref), u12 (ref), u13 (ref), ChaseMusic (ref), u18 (ref), u21 (ref)
            for i = 5, 1, -1 do
                if not (u15 and u16) then
                    local BossCountdownGui = LocalPlayer.PlayerGui:FindFirstChild("BossCountdownGui");

                    if BossCountdownGui then
                        BossCountdownGui:Destroy();
                    end;

                    return;
                end;

                showBossUI(i, false);
                task.wait(1);
            end;

            if not (u15 and u16) then
                local BossCountdownGui = LocalPlayer.PlayerGui:FindFirstChild("BossCountdownGui");

                if BossCountdownGui then
                    BossCountdownGui:Destroy();
                end;

                return;
            end;

            showBossUI(nil, true);
            u14 = "Chasing";
            u17 = os.clock();
            u12:Play();
            u13:Stop();

            if not ChaseMusic.IsPlaying then
                ChaseMusic:Play();
            end;

            if #u18 == 0 then
                u21 = 0;
            end;
        end);
    end;

    local u45 = RaycastParams.new();
    u45.FilterType = Enum.RaycastFilterType.Exclude;
    u45.FilterDescendantsInstances = { u9 };

    local function hasLineOfSight(p46, p47) -- Line: 290
        -- upvalues: LocalPlayer (ref), u45 (copy), u9 (copy)
        local Character = LocalPlayer.Character;
        local v48;

        if Character then
            v48 = { u9, Character };
        else
            v48 = { u9 };
        end;

        u45.FilterDescendantsInstances = v48;
        local v49 = Vector3.new(p47.X - p46.X, 0, p47.Z - p46.Z);

        return workspace:Raycast(p46, v49, u45) == nil;
    end;

    local function moveToward(p50, u51, p52) -- Line: 300
        -- upvalues: HumanoidRootPart (copy), u21 (ref), u20 (ref), PathfindingService (ref), u3 (ref), u18 (ref), u19 (ref), hasLineOfSight (copy), u10 (ref), Footstep (copy), Y (copy), u9 (copy)
        local Position = HumanoidRootPart.Position;
        local v53 = os.clock();

        if v53 - u21 > 0.3 then
            u21 = v53;

            if not u20 then
                u20 = true;
                task.spawn(function() -- Line: 118
                    -- upvalues: PathfindingService (ref), u3 (ref), Position (copy), u51 (copy), HumanoidRootPart (ref), u18 (ref), u19 (ref), u20 (ref)
                    local u54 = PathfindingService:CreatePath(u3);

                    if pcall(function() -- Line: 120
                        -- upvalues: u54 (copy), Position (ref), u51 (ref)
                        u54:ComputeAsync(Position, u51);
                    end) and u54.Status == Enum.PathStatus.Success then
                        local v55 = u54:GetWaypoints();

                        if #v55 >= 2 then
                            local Position2 = HumanoidRootPart.Position;
                            local v56 = (1 / 0);
                            local v57 = 1;

                            for i = 1, #v55 do
                                local v58 = Position2.X - v55[i].Position.X;
                                local v59 = Position2.Z - v55[i].Position.Z;
                                local v60 = v58 * v58 + v59 * v59;

                                if v60 < v56 then
                                    v57 = i;
                                    v56 = v60;
                                end;
                            end;

                            u18 = v55;
                            u19 = math.min(v57 + 1, #v55);
                        end;
                    end;

                    u20 = false;
                end);
            end;
        end;

        local v61 = nil;

        if hasLineOfSight(Position, u51) then
            v61 = u51;
        elseif u19 > 0 and u19 <= #u18 then
            v61 = u18[u19].Position;
            local v62 = Position.X - v61.X;
            local v63 = Position.Z - v61.Z;

            if math.sqrt(v62 * v62 + v63 * v63) < 3 then
                u19 = u19 + 1;

                if u19 <= #u18 then
                    v61 = u18[u19].Position;
                else
                    v61 = nil;
                end;
            end;
        end;

        if not v61 then
            return;
        end;

        local v64 = v61.X - Position.X;
        local v65 = v61.Z - Position.Z;
        local v66 = math.sqrt(v64 * v64 + v65 * v65);

        if v66 > 0.5 then
            local v67 = os.clock();

            if v67 - u10 >= 0.5 then
                u10 = v67;
                Footstep:Play();
            end;

            local v68 = p52 * math.min(p50, 0.1);
            local v69 = math.min(v68, v66) / v66;
            local v70 = Position.X + v64 * v69;
            local v71 = Position.Z + v65 * v69;
            local v72 = Vector3.new(v70, Y, v71);
            local v73 = Vector3.new(v70 + v64 / v66, Y, v71 + v65 / v66);
            u9:PivotTo(CFrame.lookAt(v72, v73));
        end;
    end;

    local function checkKill() -- Line: 360
        -- upvalues: LocalPlayer (ref), HumanoidRootPart (copy)
        local Character = LocalPlayer.Character;

        if not Character then
            return;
        end;

        local HumanoidRootPart2 = Character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart2 then
            return;
        end;

        local v74 = HumanoidRootPart.Position.X - HumanoidRootPart2.Position.X;
        local v75 = HumanoidRootPart.Position.Z - HumanoidRootPart2.Position.Z;

        if math.sqrt(v74 * v74 + v75 * v75) < 13 then
            local v76 = Character:FindFirstChildOfClass("Humanoid");

            if v76 and v76.Health > 0 then
                v76.Health = 0;
            end;
        end;
    end;

    local u77 = nil;
    u77 = RunService.RenderStepped:Connect(function(p78) -- Line: 378
        -- upvalues: u9 (copy), u8 (copy), u77 (ref), u2 (ref), u16 (ref), LocalPlayer (ref), HumanoidRootPart (copy), isInZone (ref), u14 (ref), u15 (ref), u18 (ref), u19 (ref), u21 (ref), Y (copy), startCountdown (copy), goIdle (copy), u17 (ref), moveToward (copy), checkKill (copy), u1 (ref)
        if not (u9.Parent and u8.Parent) then
            u77:Disconnect();
            u2[u8] = nil;
            u16 = false;
            u9:Destroy();

            return;
        end;

        local Character = LocalPlayer.Character;
        local v79;

        if Character then
            v79 = Character:FindFirstChild("HumanoidRootPart");
        else
            v79 = Character;
        end;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        local v80;

        if v79 == nil or Character == nil then
            v80 = false;
        else
            v80 = Character.Health > 0;
        end;

        local v81 = v80 and v79.Position or nil;
        local Position = HumanoidRootPart.Position;
        local v82;

        if v81 == nil then
            v82 = false;
        else
            v82 = isInZone(u8, v81) or false;
        end;

        if not v80 and (u14 == "Chasing" or u14 == "Countdown") then
            u15 = false;
            u14 = "Returning";
            u18 = {};
            u19 = 0;
            u21 = 0;
        end;

        if Position.Y < Y - 50 then
            local v83 = Vector3.new(Position.X, Y, Position.Z);
            u9:PivotTo(CFrame.new(v83));
        end;

        if u14 == "Idle" then
            if v82 then
                startCountdown();
            end;
        elseif u14 == "Countdown" then
            if not v82 then
                u15 = false;
                goIdle();
            end;
        elseif u14 == "Chasing" then
            if not v82 and os.clock() - u17 > 0.2 then
                u14 = "Returning";
                u18 = {};
                u19 = 0;
                u21 = 0;

                return;
            end;

            if v81 then
                moveToward(p78, v81, 165);
                checkKill();
            end;
        elseif u14 == "Returning" then
            if ((Position - u1.Position) * Vector3.new(1, 0, 1)).Magnitude < 6 then
                goIdle();
                u9:PivotTo(u1);

                return;
            end;

            moveToward(p78, u1.Position, 250);
        end;
    end);
end;

local function onZone(p84) -- Line: 448
    -- upvalues: startNPC (copy)
    startNPC(p84);
end;

CollectionService:GetInstanceAddedSignal("NPC9_Zone"):Connect(onZone);

for _, v in ipairs(CollectionService:GetTagged("NPC9_Zone")) do
    task.spawn(onZone, v);
end;