-- Ruta Original: ReplicatedStorage.SoundPackUISystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local MarketplaceService = game:GetService("MarketplaceService");
local SoundService = game:GetService("SoundService");
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local Config = require(ReplicatedStorage:WaitForChild("Config"));
local u1 = {};
local u2 = {
    ATTRIBUTE_NAME = "EquippedSoundPack",
    COLOR_DEFAULT = Color3.fromHex("361400"),
    COLOR_EQUIPPED = Color3.fromHex("ffffff")
};
local LocalPlayer = Players.LocalPlayer;
local u3 = false;
local u4 = false;

if LocalPlayer:GetAttribute(u2.ATTRIBUTE_NAME) == nil then
    LocalPlayer:SetAttribute(u2.ATTRIBUTE_NAME, "Default");
end;

local function isPremiumButton(p5) -- Line: 34
    -- upvalues: CollectionService (copy)
    return CollectionService:HasTag(p5, "Sounds2") or CollectionService:HasTag(p5, "Sounds3");
end;

local function hideLocks() -- Line: 39
    -- upvalues: CollectionService (copy)
    for _, v in ipairs(CollectionService:GetTagged("LockSound")) do
        v.Visible = false;
    end;
end;

local function updateButtonVisual(p6) -- Line: 45
    -- upvalues: CollectionService (copy), u4 (ref), LocalPlayer (copy), u2 (copy)
    local v7 = (CollectionService:HasTag(p6, "Sounds2") or CollectionService:HasTag(p6, "Sounds3")) and not u4;
    local v8 = LocalPlayer:GetAttribute(u2.ATTRIBUTE_NAME);
    p6.Active = not v7;
    p6.ImageTransparency = v7 and 0.6 or 0;
    local v9 = p6:FindFirstChildOfClass("UIStroke");

    if v9 then
        v9.Color = p6.Name == v8 and u2.COLOR_EQUIPPED or u2.COLOR_DEFAULT;
    end;
end;

local function promptGamepass() -- Line: 58
    -- upvalues: Config (copy), MarketplaceService (copy), LocalPlayer (copy)
    local SOUNDPACK_ACCESS = Config.GAMEPASS_IDS.SOUNDPACK_ACCESS;

    if SOUNDPACK_ACCESS and SOUNDPACK_ACCESS ~= 0 then
        MarketplaceService:PromptGamePassPurchase(LocalPlayer, SOUNDPACK_ACCESS);
    end;
end;

local SoundBank = SoundService:FindFirstChild("SoundBank");

if not SoundBank then
    task.spawn(function() -- Line: 67
        -- upvalues: SoundBank (ref), SoundService (copy)
        SoundBank = SoundService:WaitForChild("SoundBank", 10);
    end);
end;

local u10 = {};
local u11 = 0;

local function getSoundList(p12) -- Line: 76
    -- upvalues: u10 (copy), SoundBank (ref)
    if u10[p12] then
        return u10[p12];
    end;

    local v13 = {};

    if SoundBank then
        local v14 = SoundBank:FindFirstChild(p12);

        if v14 then
            for _, child in ipairs(v14:GetChildren()) do
                if child:IsA("Sound") and child.SoundId ~= "" then
                    table.insert(v13, child.SoundId);
                end;
            end;
        end;
    end;

    local v15 = #v13 == 0 and { "rbxassetid://123413227426138" } or v13;
    u10[p12] = v15;

    return v15;
end;

local function previewSound(p16) -- Line: 94
    -- upvalues: u11 (ref), getSoundList (copy), SoundService (copy)
    local v17 = tick();

    if v17 - u11 < 0.2 then
        return;
    end;

    u11 = v17;
    local v18 = getSoundList(p16);
    local v19 = v18[math.random(1, #v18)];
    local Sound = Instance.new("Sound");
    Sound.SoundId = v19;
    Sound.Volume = 0.6;
    Sound.RollOffMaxDistance = 0;
    Sound.Parent = SoundService;
    Sound:Play();
    Sound.Ended:Connect(function() -- Line: 108
        -- upvalues: Sound (copy)
        Sound:Destroy();
    end);
    task.delay(3, function() -- Line: 109
        -- upvalues: Sound (copy)
        if Sound then
            Sound:Destroy();
        end;
    end);
end;

local function connectSoundButton(u20) -- Line: 112
    -- upvalues: CollectionService (copy), u4 (ref), Config (copy), MarketplaceService (copy), LocalPlayer (copy), u2 (copy), previewSound (copy), updateButtonVisual (copy)
    if not u20:IsA("ImageButton") then
        return;
    end;

    u20.MouseButton1Click:Connect(function() -- Line: 115
        -- upvalues: u20 (copy), CollectionService (ref), u4 (ref), Config (ref), MarketplaceService (ref), LocalPlayer (ref), u2 (ref), previewSound (ref)
        local v21 = u20;

        if (CollectionService:HasTag(v21, "Sounds2") or CollectionService:HasTag(v21, "Sounds3")) and not u4 then
            local SOUNDPACK_ACCESS = Config.GAMEPASS_IDS.SOUNDPACK_ACCESS;

            if SOUNDPACK_ACCESS and SOUNDPACK_ACCESS ~= 0 then
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, SOUNDPACK_ACCESS);
            end;

            return;
        end;

        LocalPlayer:SetAttribute(u2.ATTRIBUTE_NAME, u20.Name);
        previewSound(u20.Name);
    end);
    u20.MouseEnter:Connect(function() -- Line: 124
        -- upvalues: previewSound (ref), u20 (copy)
        previewSound(u20.Name);
    end);
    updateButtonVisual(u20);
end;

function u1.UpdateDisplay(p22) -- Line: 131
    -- upvalues: CollectionService (copy), updateButtonVisual (copy)
    for _, v in ipairs(CollectionService:GetTagged("SoundButton")) do
        if v:IsA("ImageButton") then
            updateButtonVisual(v);
        end;
    end;
end;

local function checkGamepass() -- Line: 140
    -- upvalues: Config (copy), MarketplaceService (copy), LocalPlayer (copy), u4 (ref), CollectionService (copy), u1 (copy)
    local SOUNDPACK_ACCESS = Config.GAMEPASS_IDS.SOUNDPACK_ACCESS;

    if not SOUNDPACK_ACCESS or SOUNDPACK_ACCESS == 0 then
        return;
    end;

    local success, result = pcall(function() -- Line: 144
        -- upvalues: MarketplaceService (ref), LocalPlayer (ref), SOUNDPACK_ACCESS (copy)
        return MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, SOUNDPACK_ACCESS);
    end);

    if success and result then
        u4 = true;

        for _, v in ipairs(CollectionService:GetTagged("LockSound")) do
            v.Visible = false;
        end;

        u1:UpdateDisplay();
    end;
end;

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p23, p24, p25) -- Line: 155
    -- upvalues: LocalPlayer (copy), Config (copy), u4 (ref), CollectionService (copy), u1 (copy)
    if p23 ~= LocalPlayer then
        return;
    end;

    if p24 ~= Config.GAMEPASS_IDS.SOUNDPACK_ACCESS then
        return;
    end;

    if not p25 then
        return;
    end;

    u4 = true;

    for _, v in ipairs(CollectionService:GetTagged("LockSound")) do
        v.Visible = false;
    end;

    u1:UpdateDisplay();
end);
task.spawn(checkGamepass);

function u1.InitLogic(u26) -- Line: 170
    -- upvalues: LocalPlayer (copy), u2 (copy), u4 (ref), CollectionService (copy), u3 (ref), ClientState (copy), promptGamepass (copy), connectSoundButton (copy)
    if LocalPlayer:GetAttribute(u2.ATTRIBUTE_NAME) == nil then
        LocalPlayer:SetAttribute(u2.ATTRIBUTE_NAME, "Default");
    end;

    if u4 then
        for _, v in ipairs(CollectionService:GetTagged("LockSound")) do
            v.Visible = false;
        end;
    end;

    if u3 then
        u26:UpdateDisplay();

        return;
    end;

    local function setupClose(p27) -- Line: 185
        -- upvalues: ClientState (ref)
        p27.MouseButton1Click:Connect(function() -- Line: 186
            -- upvalues: ClientState (ref)
            ClientState:CloseCurrentModal();
        end);
    end;

    for _, v in ipairs(CollectionService:GetTagged("SoundPackCloseBtn")) do
        v.MouseButton1Click:Connect(function() -- Line: 186
            -- upvalues: ClientState (ref)
            ClientState:CloseCurrentModal();
        end);
    end;

    CollectionService:GetInstanceAddedSignal("SoundPackCloseBtn"):Connect(setupClose);

    local function setupBuyBtn(p28) -- Line: 194
        -- upvalues: promptGamepass (ref)
        if not p28:IsA("GuiButton") then
            return;
        end;

        p28.MouseButton1Click:Connect(promptGamepass);
    end;

    for _, v in ipairs(CollectionService:GetTagged("BuySoundpackGamepass")) do
        if v:IsA("GuiButton") then
            v.MouseButton1Click:Connect(promptGamepass);
        end;
    end;

    CollectionService:GetInstanceAddedSignal("BuySoundpackGamepass"):Connect(setupBuyBtn);

    for _, v in ipairs(CollectionService:GetTagged("SoundButton")) do
        connectSoundButton(v);
    end;

    CollectionService:GetInstanceAddedSignal("SoundButton"):Connect(connectSoundButton);
    CollectionService:GetInstanceAddedSignal("LockSound"):Connect(function(p29) -- Line: 208
        -- upvalues: u4 (ref)
        p29.Visible = not u4;
    end);
    LocalPlayer:GetAttributeChangedSignal(u2.ATTRIBUTE_NAME):Connect(function() -- Line: 213
        -- upvalues: u26 (copy)
        u26:UpdateDisplay();
    end);
    u3 = true;
end;

return u1;