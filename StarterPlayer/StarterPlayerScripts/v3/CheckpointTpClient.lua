-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.CheckpointTpClient
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local MarketplaceService = game:GetService("MarketplaceService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");
local Config = require(ReplicatedStorage:WaitForChild("Config"));
local NotificationSystem = require(ReplicatedStorage:WaitForChild("NotificationSystem"));
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local Numbers = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("Numbers"));
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local RequestCheckpointTp = Remotes:WaitForChild("RequestCheckpointTp");
local PromptCheckpointProduct = Remotes:WaitForChild("PromptCheckpointProduct");
local CheckpointTpSuccess = Remotes:WaitForChild("CheckpointTpSuccess");
local BonusUpdate = ReplicatedStorage:WaitForChild("BonusUpdate");
local u1 = Color3.fromRGB(255, 80, 80);
local u2 = {};

for _, v in ipairs(Config.CHECKPOINTS) do
    if v.RobuxProductId and v.RobuxProductId ~= 0 then
        u2[v.RobuxProductId] = true;
    end;
end;

for _, v in ipairs(Config.SkipCheckpoints) do
    if v.RobuxProductId and v.RobuxProductId ~= 0 then
        u2[v.RobuxProductId] = true;
    end;
end;

local u3 = {};

local function getDisplayWinPrice(p4) -- Line: 48
    -- upvalues: ClientState (copy)
    local v5 = p4 * (ClientState:Get().BonusWinsMultiplier or 1);

    return math.floor(v5);
end;

local function applyWinPriceLabel(p6, p7) -- Line: 53
    -- upvalues: ClientState (copy), Numbers (copy)
    local v8 = p7.WinPrice * (ClientState:Get().BonusWinsMultiplier or 1);
    local v9 = math.floor(v8);
    local Price = p6:FindFirstChild("Price", true);

    if Price and Price:IsA("TextLabel") then
        Price.Text = Numbers.formatNumber(v9);

        return;
    end;

    if p6:IsA("TextButton") then
        p6.Text = Numbers.formatNumber(v9);
    end;
end;

local function refreshWinPriceLabels() -- Line: 63
    -- upvalues: u3 (copy), applyWinPriceLabel (copy)
    for _, v in ipairs(u3) do
        applyWinPriceLabel(v.btn, v.entry);
    end;
end;

for i = 1, #Config.CHECKPOINTS do
    local v10 = "ButtonTpCheckpoint" .. i;
    local u11 = Config.CHECKPOINTS[i];

    local function setupButton(p12) -- Line: 73
        -- upvalues: u3 (copy), u11 (copy), RequestCheckpointTp (copy), i (copy), applyWinPriceLabel (copy)
        if not p12:IsA("GuiButton") then
            return;
        end;

        table.insert(u3, {
            btn = p12,
            entry = u11
        });
        p12.MouseButton1Click:Connect(function() -- Line: 76
            -- upvalues: RequestCheckpointTp (ref), i (ref)
            RequestCheckpointTp:FireServer(i, "wins");
        end);
        applyWinPriceLabel(p12, u11);
    end;

    for _, v in ipairs(CollectionService:GetTagged(v10)) do
        setupButton(v);
    end;

    CollectionService:GetInstanceAddedSignal(v10):Connect(setupButton);
end;

BonusUpdate.OnClientEvent:Connect(function() -- Line: 88
    -- upvalues: u3 (copy), applyWinPriceLabel (copy)
    for _, v in ipairs(u3) do
        applyWinPriceLabel(v.btn, v.entry);
    end;
end);

for i = 1, #Config.CHECKPOINTS do
    local v13 = "DevButtonTpCheckpoint" .. i;
    local u14 = Config.CHECKPOINTS[i];

    local function setupDevButton(u15) -- Line: 96
        -- upvalues: RequestCheckpointTp (copy), i (copy), u14 (copy), MarketplaceService (copy)
        if not u15:IsA("GuiButton") then
            return;
        end;

        u15.MouseButton1Click:Connect(function() -- Line: 98
            -- upvalues: RequestCheckpointTp (ref), i (ref)
            RequestCheckpointTp:FireServer(i, "robux");
        end);

        if u14.RobuxProductId and u14.RobuxProductId ~= 0 then
            task.spawn(function() -- Line: 103
                -- upvalues: MarketplaceService (ref), u14 (ref), u15 (copy)
                local success, result = pcall(function() -- Line: 104
                    -- upvalues: MarketplaceService (ref), u14 (ref)
                    return MarketplaceService:GetProductInfoAsync(u14.RobuxProductId, Enum.InfoType.Product);
                end);

                if success and (result and result.PriceInRobux) then
                    local Price = u15:FindFirstChild("Price", true);

                    if Price and Price:IsA("TextLabel") then
                        Price.Text = tostring(result.PriceInRobux);

                        return;
                    end;

                    if u15:IsA("TextButton") then
                        u15.Text = tostring(result.PriceInRobux);
                    end;
                end;
            end);
        end;
    end;

    for _, v in ipairs(CollectionService:GetTagged(v13)) do
        setupDevButton(v);
    end;

    CollectionService:GetInstanceAddedSignal(v13):Connect(setupDevButton);
end;

PromptCheckpointProduct.OnClientEvent:Connect(function(p16, p17) -- Line: 129
    -- upvalues: NotificationSystem (copy), u1 (copy)
    if p16 == 0 then
        NotificationSystem:ShowMessage("Purchase error", u1);
    end;
end);
MarketplaceService.PromptProductPurchaseFinished:Connect(function(p18, p19, p20) -- Line: 139
    -- upvalues: LocalPlayer (copy), u2 (copy), NotificationSystem (copy), u1 (copy)
    if p18 ~= LocalPlayer.UserId then
        return;
    end;

    if not p20 and u2[p19] then
        NotificationSystem:ShowMessage("Purchase error", u1);
    end;
end);

local function getModalByTag(p21) -- Line: 150
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged(p21)) do
        if v:IsDescendantOf(PlayerGui) then
            return v;
        end;
    end;
end;

CheckpointTpSuccess.OnClientEvent:Connect(function() -- Line: 156
    -- upvalues: getModalByTag (copy), ClientState (copy), Config (copy), SoundService (copy), Debris (copy)
    local v22 = getModalByTag("CheckpointModal");

    if v22 and ClientState.ActiveModal == v22 then
        ClientState:CloseCurrentModal();
    end;

    local BUY = Config.SOUNDS.BUY;
    local Sound = Instance.new("Sound");
    Sound.SoundId = BUY.ID;
    Sound.Volume = BUY.Volume;
    Sound.Parent = SoundService;
    Sound:Play();
    Debris:AddItem(Sound, 5);
end);