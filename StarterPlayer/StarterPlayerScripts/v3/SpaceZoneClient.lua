-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.SpaceZoneClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local LocalPlayer = Players.LocalPlayer;
local Config = require(ReplicatedStorage:WaitForChild("Config"));
local GravityManager = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("GravityManager"));
local JumpHeightManager = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("JumpHeightManager"));
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local SpaceZoneEnter = Remotes:WaitForChild("SpaceZoneEnter");
local SpaceZoneLeave = Remotes:WaitForChild("SpaceZoneLeave");
local u1 = false;

local function playSound(p2) -- Line: 34
    -- upvalues: Debris (copy)
    if not p2 then
        return;
    end;

    local Sound = Instance.new("Sound");
    Sound.SoundId = p2.ID;
    Sound.Volume = p2.Volume;
    Sound.Parent = workspace;
    Sound:Play();
    Debris:AddItem(Sound, 6);
end;

local function spawnRing(u3, u4, u5, u6, p7) -- Line: 44
    -- upvalues: TweenService (copy)
    task.delay(p7, function() -- Line: 45
        -- upvalues: u3 (copy), u4 (copy), u6 (copy), TweenService (ref), u5 (copy)
        if not (u3 and u3.Parent) then
            return;
        end;

        local BillboardGui = Instance.new("BillboardGui");
        BillboardGui.Size = UDim2.new(u4, 0, u4, 0);
        BillboardGui.StudsOffset = Vector3.new(0, 0, 0);
        BillboardGui.AlwaysOnTop = true;
        BillboardGui.Adornee = u3;
        BillboardGui.Parent = u3;
        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Image = "rbxassetid://9509570418";
        ImageLabel.BackgroundTransparency = 1;
        ImageLabel.Size = UDim2.new(1, 0, 1, 0);
        ImageLabel.ImageTransparency = 0;
        ImageLabel.Parent = BillboardGui;
        local v8 = TweenInfo.new(u6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        TweenService:Create(BillboardGui, v8, {
            Size = UDim2.new(u5, 0, u5, 0)
        }):Play();
        local v9 = TweenService:Create(ImageLabel, v8, {
            ImageTransparency = 1
        });
        v9:Play();
        v9.Completed:Connect(function() -- Line: 66
            -- upvalues: BillboardGui (copy)
            BillboardGui:Destroy();
        end);
    end);
end;

local function playTransformEffect(p10) -- Line: 70
    -- upvalues: LocalPlayer (copy), Debris (copy), TweenService (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    if p10 then
        local Sound = Instance.new("Sound");
        Sound.SoundId = p10.ID;
        Sound.Volume = p10.Volume;
        Sound.Parent = workspace;
        Sound:Play();
        Debris:AddItem(Sound, 6);
    end;

    local u11 = 8;
    local u12 = 0.5;
    local u13 = 45;
    task.delay(0, function() -- Line: 45
        -- upvalues: HumanoidRootPart (copy), u11 (copy), u12 (copy), TweenService (ref), u13 (copy)
        if not (HumanoidRootPart and HumanoidRootPart.Parent) then
            return;
        end;

        local BillboardGui = Instance.new("BillboardGui");
        BillboardGui.Size = UDim2.new(u11, 0, u11, 0);
        BillboardGui.StudsOffset = Vector3.new(0, 0, 0);
        BillboardGui.AlwaysOnTop = true;
        BillboardGui.Adornee = HumanoidRootPart;
        BillboardGui.Parent = HumanoidRootPart;
        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Image = "rbxassetid://9509570418";
        ImageLabel.BackgroundTransparency = 1;
        ImageLabel.Size = UDim2.new(1, 0, 1, 0);
        ImageLabel.ImageTransparency = 0;
        ImageLabel.Parent = BillboardGui;
        local v14 = TweenInfo.new(u12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        TweenService:Create(BillboardGui, v14, {
            Size = UDim2.new(u13, 0, u13, 0)
        }):Play();
        local v15 = TweenService:Create(ImageLabel, v14, {
            ImageTransparency = 1
        });
        v15:Play();
        v15.Completed:Connect(function() -- Line: 66
            -- upvalues: BillboardGui (copy)
            BillboardGui:Destroy();
        end);
    end);
    local u16 = 6;
    local u17 = 0.6;
    local u18 = 35;
    task.delay(0.12, function() -- Line: 45
        -- upvalues: HumanoidRootPart (copy), u16 (copy), u17 (copy), TweenService (ref), u18 (copy)
        if not (HumanoidRootPart and HumanoidRootPart.Parent) then
            return;
        end;

        local BillboardGui = Instance.new("BillboardGui");
        BillboardGui.Size = UDim2.new(u16, 0, u16, 0);
        BillboardGui.StudsOffset = Vector3.new(0, 0, 0);
        BillboardGui.AlwaysOnTop = true;
        BillboardGui.Adornee = HumanoidRootPart;
        BillboardGui.Parent = HumanoidRootPart;
        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Image = "rbxassetid://9509570418";
        ImageLabel.BackgroundTransparency = 1;
        ImageLabel.Size = UDim2.new(1, 0, 1, 0);
        ImageLabel.ImageTransparency = 0;
        ImageLabel.Parent = BillboardGui;
        local v19 = TweenInfo.new(u17, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        TweenService:Create(BillboardGui, v19, {
            Size = UDim2.new(u18, 0, u18, 0)
        }):Play();
        local v20 = TweenService:Create(ImageLabel, v19, {
            ImageTransparency = 1
        });
        v20:Play();
        v20.Completed:Connect(function() -- Line: 66
            -- upvalues: BillboardGui (copy)
            BillboardGui:Destroy();
        end);
    end);
    local u21 = 4;
    local u22 = 0.7;
    local u23 = 25;
    task.delay(0.24, function() -- Line: 45
        -- upvalues: HumanoidRootPart (copy), u21 (copy), u22 (copy), TweenService (ref), u23 (copy)
        if not (HumanoidRootPart and HumanoidRootPart.Parent) then
            return;
        end;

        local BillboardGui = Instance.new("BillboardGui");
        BillboardGui.Size = UDim2.new(u21, 0, u21, 0);
        BillboardGui.StudsOffset = Vector3.new(0, 0, 0);
        BillboardGui.AlwaysOnTop = true;
        BillboardGui.Adornee = HumanoidRootPart;
        BillboardGui.Parent = HumanoidRootPart;
        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Image = "rbxassetid://9509570418";
        ImageLabel.BackgroundTransparency = 1;
        ImageLabel.Size = UDim2.new(1, 0, 1, 0);
        ImageLabel.ImageTransparency = 0;
        ImageLabel.Parent = BillboardGui;
        local v24 = TweenInfo.new(u22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        TweenService:Create(BillboardGui, v24, {
            Size = UDim2.new(u23, 0, u23, 0)
        }):Play();
        local v25 = TweenService:Create(ImageLabel, v24, {
            ImageTransparency = 1
        });
        v25:Play();
        v25.Completed:Connect(function() -- Line: 66
            -- upvalues: BillboardGui (copy)
            BillboardGui:Destroy();
        end);
    end);
end;

local function restoreGravity() -- Line: 98
    -- upvalues: u1 (ref), GravityManager (copy), JumpHeightManager (copy), playTransformEffect (copy), Config (copy), LocalPlayer (copy)
    local v26 = u1;
    u1 = false;
    GravityManager.release("SpaceZone");
    JumpHeightManager.release("SpaceZone");

    if v26 then
        playTransformEffect(Config.SOUNDS.EFFECT2);
    end;

    local v27 = LocalPlayer.Character and v27:FindFirstChildOfClass("Humanoid");

    if v27 then
        v27.JumpPower = 50;
    end;
end;

SpaceZoneEnter.OnClientEvent:Connect(function() -- Line: 86, Name: setSpaceGravity
    -- upvalues: u1 (ref), GravityManager (copy), JumpHeightManager (copy), playTransformEffect (copy), Config (copy), LocalPlayer (copy)
    u1 = true;
    GravityManager.set("SpaceZone", 78.48, 20);
    JumpHeightManager.set("SpaceZone", 30, 20);
    playTransformEffect(Config.SOUNDS.EFFECT1);
    local v28 = LocalPlayer.Character and v28:FindFirstChildOfClass("Humanoid");

    if v28 then
        v28.JumpPower = 125;
    end;
end);
SpaceZoneLeave.OnClientEvent:Connect(restoreGravity);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 117
    -- upvalues: u1 (ref), GravityManager (copy), JumpHeightManager (copy)
    u1 = false;
    GravityManager.release("SpaceZone");
    JumpHeightManager.release("SpaceZone");
end);