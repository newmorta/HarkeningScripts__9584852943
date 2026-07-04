-- Ruta Original: ReplicatedStorage.RadarSystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local MarketplaceService = game:GetService("MarketplaceService");
local SoundService = game:GetService("SoundService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local EventsConfig = require(ReplicatedStorage:WaitForChild("EventsConfig"));
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local v1 = {};
local LocalPlayer = Players.LocalPlayer;

local function getCoinPosition(p2) -- Line: 37
    if p2:IsA("Model") then
        return p2:GetPivot().Position;
    end;

    return p2.Position;
end;

local function getTagged(p3) -- Line: 44
    -- upvalues: CollectionService (copy)
    return CollectionService:GetTagged(p3);
end;

local function setRadarVisible(p4) -- Line: 48
    -- upvalues: getTagged (copy)
    for _, v in ipairs(getTagged("GoldenEggRadar")) do
        v.Visible = p4;
    end;
end;

local function setArrowState(p5) -- Line: 54
    -- upvalues: getTagged (copy)
    for _, v in ipairs(getTagged("GoldenEggRadarArrow")) do
        v.Image = p5 and "rbxassetid://123139547868771" or "rbxassetid://84022142264855";

        if not p5 then
            v.Rotation = 0;
        end;
    end;

    for _, v in ipairs(getTagged("GoldenEggRadarDist")) do
        if not p5 then
            v.Text = "No egg...";
        end;
    end;
end;

local function playSound(p6) -- Line: 68
    -- upvalues: SoundService (copy)
    local Sound = Instance.new("Sound");
    Sound.SoundId = p6;
    Sound.RollOffMaxDistance = 0;
    Sound.Parent = SoundService;
    Sound:Play();
    Sound.Ended:Connect(function() -- Line: 74
        -- upvalues: Sound (copy)
        Sound:Destroy();
    end);
end;

local function getActiveRadarConfig() -- Line: 81
    -- upvalues: EventsConfig (copy)
    local v7 = os.time();

    for _, v in ipairs(EventsConfig.Events) do
        if v.Start <= v7 and v7 < v.End then
            for _, v2 in ipairs(EventsConfig.CurrenciesRadar or {}) do
                if v2.Event == v.Name then
                    return v2;
                end;
            end;
        end;
    end;

    return nil;
end;

local u8 = false;
local u9 = false;

local function stopRadar() -- Line: 98
    -- upvalues: u9 (ref), u8 (ref), getTagged (copy)
    u9 = false;
    u8 = false;

    for _, v in ipairs(getTagged("GoldenEggRadar")) do
        v.Visible = false;
    end;

    for _, v in ipairs(getTagged("GoldenEggRadarArrow")) do
        v.Image = "rbxassetid://84022142264855";
        v.Rotation = 0;
    end;

    for _, v in ipairs(getTagged("GoldenEggRadarDist")) do
        v.Text = "No egg...";
    end;
end;

local function startRadar() -- Line: 105
    -- upvalues: u8 (ref), u9 (ref), getTagged (copy), ClientState (copy), CollectionService (copy), playSound (copy), RunService (copy), LocalPlayer (copy)
    if u8 then
        return;
    end;

    u8 = true;
    u9 = true;
    local u10 = nil;

    for _, v in ipairs(getTagged("GoldenEggRadar")) do
        v.Visible = true;
    end;

    ClientState:RegisterModalListener(function(p11) -- Line: 115
        -- upvalues: u9 (ref), getTagged (ref)
        if u9 then
            local v12 = not p11;

            for _, v in ipairs(getTagged("GoldenEggRadar")) do
                v.Visible = v12;
            end;
        end;
    end);
    CollectionService:GetInstanceAddedSignal("GoldenEggRadar"):Connect(function(p13) -- Line: 121
        -- upvalues: ClientState (ref)
        p13.Visible = ClientState.ActiveModal == nil;
    end);
    CollectionService:GetInstanceAddedSignal("Rarity1Coin"):Connect(function(p14) -- Line: 125
        -- upvalues: u10 (ref), getTagged (ref), playSound (ref)
        u10 = p14;

        for _, v in ipairs(getTagged("GoldenEggRadarArrow")) do
            v.Image = "rbxassetid://123139547868771";
        end;

        for _, _ in ipairs(getTagged("GoldenEggRadarDist")) do

        end;

        playSound("rbxassetid://105044658147672");
    end);
    CollectionService:GetInstanceRemovedSignal("Rarity1Coin"):Connect(function(p15) -- Line: 131
        -- upvalues: u10 (ref), getTagged (ref), playSound (ref)
        if u10 == p15 then
            u10 = nil;

            for _, v in ipairs(getTagged("GoldenEggRadarArrow")) do
                v.Image = "rbxassetid://84022142264855";
                v.Rotation = 0;
            end;

            for _, v in ipairs(getTagged("GoldenEggRadarDist")) do
                v.Text = "No egg...";
            end;

            playSound("rbxassetid://130842421411875");
        end;
    end);
    local v16 = CollectionService:GetTagged("Rarity1Coin");

    if #v16 > 0 then
        u10 = v16[1];

        for _, v in ipairs(getTagged("GoldenEggRadarArrow")) do
            v.Image = "rbxassetid://123139547868771";
        end;

        for _, _ in ipairs(getTagged("GoldenEggRadarDist")) do

        end;
    else
        for _, v in ipairs(getTagged("GoldenEggRadarArrow")) do
            v.Image = "rbxassetid://84022142264855";
            v.Rotation = 0;
        end;

        for _, v in ipairs(getTagged("GoldenEggRadarDist")) do
            v.Text = "No egg...";
        end;
    end;

    RunService.Heartbeat:Connect(function() -- Line: 147
        -- upvalues: u9 (ref), u10 (ref), getTagged (ref), LocalPlayer (ref)
        if not u9 then
            return;
        end;

        if u10 and not u10.Parent then
            u10 = nil;

            for _, v in ipairs(getTagged("GoldenEggRadarArrow")) do
                v.Image = "rbxassetid://84022142264855";
                v.Rotation = 0;
            end;

            for _, v in ipairs(getTagged("GoldenEggRadarDist")) do
                v.Text = "No egg...";
            end;
        end;

        if not u10 then
            return;
        end;

        local Character = LocalPlayer.Character;

        if not Character then
            return;
        end;

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        local v17 = u10;
        local v18;

        if v17:IsA("Model") then
            v18 = v17:GetPivot().Position;
        else
            v18 = v17.Position;
        end;

        local Position = HumanoidRootPart.Position;
        local CFrame = workspace.CurrentCamera.CFrame;
        local Unit = Vector3.new(CFrame.LookVector.X, 0, CFrame.LookVector.Z).Unit;
        local Unit2 = Vector3.new(CFrame.RightVector.X, 0, CFrame.RightVector.Z).Unit;
        local Unit3 = Vector3.new(v18.X - Position.X, 0, v18.Z - Position.Z).Unit;
        local v19 = Unit3:Dot(Unit2);
        local v20 = Unit3:Dot(Unit);
        local v21 = math.atan2(v19, v20);
        local v22 = math.deg(v21);

        for _, v in ipairs(getTagged("GoldenEggRadarArrow")) do
            v.Rotation = v22;
        end;

        local v23 = math.floor((v18 - Position).Magnitude);

        for _, v in ipairs(getTagged("GoldenEggRadarDist")) do
            v.Text = v23 .. " studs";
        end;
    end);
end;

local function tryStartWithConfig(p24) -- Line: 180
    -- upvalues: startRadar (copy), MarketplaceService (copy), LocalPlayer (copy)
    local u25 = p24.Gamepass or 0;

    if u25 == 0 then
        startRadar();

        return;
    end;

    local success, result = pcall(function() -- Line: 186
        -- upvalues: MarketplaceService (ref), LocalPlayer (ref), u25 (copy)
        return MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, u25);
    end);

    if success and result then
        startRadar();
    end;
end;

function v1.Init(p26) -- Line: 194
    -- upvalues: getActiveRadarConfig (copy), startRadar (copy), MarketplaceService (copy), LocalPlayer (copy), EventsConfig (copy), stopRadar (copy)
    local v27 = getActiveRadarConfig();

    if v27 then
        local u28 = v27.Gamepass or 0;

        if u28 == 0 then
            startRadar();
        else
            local success, result = pcall(function() -- Line: 186
                -- upvalues: MarketplaceService (ref), LocalPlayer (ref), u28 (copy)
                return MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, u28);
            end);

            if success and result then
                startRadar();
            end;
        end;
    end;

    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p29, p30, p31) -- Line: 202
        -- upvalues: getActiveRadarConfig (ref), startRadar (ref)
        if not p31 then
            return;
        end;

        local v32 = getActiveRadarConfig();

        if v32 and (v32.Gamepass == 0 or v32.Gamepass == p30) then
            startRadar();
        end;
    end);
    local v33 = os.time();

    for _, v in ipairs(EventsConfig.Events) do
        for _, v2 in ipairs(EventsConfig.CurrenciesRadar or {}) do
            if v2.Event == v.Name then
                if v.Start <= v33 and v33 < v.End then
                    task.delay(v.End - v33, stopRadar);
                elseif v33 < v.Start then
                    task.delay(v.Start - v33, function() -- Line: 220
                        -- upvalues: v2 (copy), startRadar (ref), MarketplaceService (ref), LocalPlayer (ref)
                        local u34 = v2.Gamepass or 0;

                        if u34 == 0 then
                            startRadar();

                            return;
                        end;

                        local success, result = pcall(function() -- Line: 186
                            -- upvalues: MarketplaceService (ref), LocalPlayer (ref), u34 (copy)
                            return MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, u34);
                        end);

                        if success and result then
                            startRadar();
                        end;
                    end);
                    task.delay(v.End - v33, stopRadar);
                end;

                break;
            end;
        end;
    end;
end;

return v1;