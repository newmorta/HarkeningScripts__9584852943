-- Ruta Original: StarterPlayer.StarterPlayerScripts.Pièges.LocalNPC10_AI
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContentProvider = game:GetService("ContentProvider");
local LocalPlayer = Players.LocalPlayer;
local NPC10 = ReplicatedStorage:WaitForChild("NPC10");
local Animation = Instance.new("Animation");
Animation.AnimationId = "rbxassetid://104571570562605";
local Animation2 = Instance.new("Animation");
Animation2.AnimationId = "rbxassetid://123873530367173";
local u1 = NPC10:GetPivot();
task.spawn(function() -- Line: 34
    -- upvalues: ContentProvider (copy), Animation (copy), Animation2 (copy), NPC10 (copy)
    ContentProvider:PreloadAsync({ Animation, Animation2, NPC10 });
end);
local u2 = {};

local function startNPCLogic(u3, p4) -- Line: 43
    -- upvalues: u2 (copy), NPC10 (copy), u1 (copy), Animation (copy), Animation2 (copy), LocalPlayer (copy)
    if u2[u3] then
        return;
    end;

    u2[u3] = true;
    local u5 = NPC10:Clone();
    u5:PivotTo(u1);
    u5.Parent = workspace;
    local HumanoidRootPart = u5:WaitForChild("HumanoidRootPart");
    local Humanoid = u5:WaitForChild("Humanoid");
    local Animator = Humanoid:WaitForChild("Animator");
    local Hitbox = u5:WaitForChild("Hitbox");
    local ChaseMusic = HumanoidRootPart:WaitForChild("ChaseMusic");
    HumanoidRootPart.Anchored = true;
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false);
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false);
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false);
    local u6 = Animator:LoadAnimation(Animation);
    local u7 = Animator:LoadAnimation(Animation2);
    local u8 = "Idle";
    u7:Play();
    local u11 = Hitbox.Touched:Connect(function(p9) -- Line: 73
        -- upvalues: LocalPlayer (ref)
        if p9.Parent == LocalPlayer.Character then
            local v10 = p9.Parent:FindFirstChildOfClass("Humanoid");

            if v10 and v10.Health > 0 then
                v10.Health = 0;
            end;
        end;
    end);
    task.spawn(function() -- Line: 80
        -- upvalues: u5 (copy), u3 (copy), LocalPlayer (ref), HumanoidRootPart (copy), u1 (ref), u8 (ref), Humanoid (copy), ChaseMusic (copy), u6 (copy), u7 (copy), u11 (copy), u2 (ref)
        while u5.Parent and u3.Parent do
            local Character = LocalPlayer.Character;
            local v12;

            if Character then
                v12 = Character:FindFirstChild("HumanoidRootPart");
            else
                v12 = nil;
            end;

            local Position = HumanoidRootPart.Position;
            local v13 = v12 and (v12.Position or Vector3.new(0, -5000, 0)) or Vector3.new(0, -5000, 0);
            local v14 = v13 - Position;
            local v15 = v14:Dot(v14);
            local v16 = math.sqrt(v15);
            local v17 = (Position - u1.Position) * Vector3.new(1, 0, 1);
            local v18 = v17:Dot(v17);

            if Position.Y < u1.Y - 50 then
                u5:PivotTo(u1);
            end;

            local v19 = u3.CFrame:PointToObjectSpace(v13);
            local v20;

            if math.abs(v19.X) <= u3.Size.X / 2 then
                v20 = math.abs(v19.Z) <= u3.Size.Z / 2;
            else
                v20 = false;
            end;

            local v21 = v20 and v15 < 4000000 and "Chasing" or (v18 > 144 and "Returning" or "Idle");

            if v21 ~= u8 then
                if v21 == "Chasing" or v21 == "Returning" then
                    HumanoidRootPart.Anchored = false;
                    Humanoid.WalkSpeed = v21 == "Chasing" and 150 or 50;

                    if not ChaseMusic.IsPlaying then
                        ChaseMusic:Play();
                    end;

                    u6:Play();
                    u7:Stop();
                elseif v21 == "Idle" then
                    HumanoidRootPart.Anchored = true;
                    Humanoid:Move(Vector3.new(0, 0, 0));
                    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);

                    if ChaseMusic.IsPlaying then
                        ChaseMusic:Stop();
                    end;

                    u6:Stop(0.1);
                    u7:Play();
                    u5:PivotTo(u1);
                end;

                u8 = v21;
            end;

            if u8 == "Chasing" and v12 then
                if v16 > 350 then
                    HumanoidRootPart.Anchored = true;
                    u5:PivotTo(CFrame.lookAt(Position + (v13 - Position).Unit * 150 * 0.03, v13));
                else
                    HumanoidRootPart.Anchored = false;
                    Humanoid:MoveTo(v12.Position);
                end;
            elseif u8 == "Returning" then
                if v16 > 350 then
                    HumanoidRootPart.Anchored = true;
                    u5:PivotTo(CFrame.lookAt(Position + (u1.Position - Position).Unit * 50 * 0.03, u1.Position));
                else
                    HumanoidRootPart.Anchored = false;
                    Humanoid:MoveTo(u1.Position);
                end;
            end;

            task.wait(0.03);
        end;

        u11:Disconnect();
        u2[u3] = nil;
        u5:Destroy();
    end);
end;

local function onZoneDetected(p22) -- Line: 162
    -- upvalues: startNPCLogic (copy)
    startNPCLogic(p22, p22);
end;

CollectionService:GetInstanceAddedSignal("NPC10_AttackZone"):Connect(onZoneDetected);

for _, v in ipairs(CollectionService:GetTagged("NPC10_AttackZone")) do
    task.spawn(onZoneDetected, v);
end;