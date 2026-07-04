-- Ruta Original: ReplicatedStorage.ClientState
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {};
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
require(game:GetService("ReplicatedStorage"):WaitForChild("Config"));
local CurrentCamera = workspace.CurrentCamera;
u1.Data = {
    Level = 0,
    XP = 0,
    XPRequired = 100,
    TotalXP = 0,
    Wins = 0,
    Rebirths = 0,
    Multiplier = 1,
    StepBonus = 1,
    onTreadmill = false,
    GiftClaimed = false,
    GoldTreadmillActive = false,
    DiamondTreadmillActive = false,
    CandyTreadmillActive = false,
    AdminTreadmillActive = false,
    SpeedBoostActive = false,
    WinsBoostActive = false,
    CurrentSpeedTier = 0,
    SpeedBoostMultiplier = 1,
    CustomWalkSpeed = nil,
    BonusXPMultiplier = 1,
    BonusWinsMultiplier = 1,
    EquippedTrail = "None",
    EquippedTreadmillSkin = "Default",
    OwnedTrails = {},
    Items = {},
    EquippedItems = {},
    OwnedTreadmillSkins = {}
};
u1.ActiveModal = nil;
u1.ActiveSystem = nil;
u1.ModalListeners = {};

function u1.RegisterModalListener(p2, p3) -- Line: 38
    table.insert(p2.ModalListeners, p3);
end;

local function fireModalListeners(p4) -- Line: 42
    -- upvalues: u1 (copy)
    for _, v in ipairs(u1.ModalListeners) do
        v(p4);
    end;
end;

local u5 = Lighting:FindFirstChild("MenuBlur") or Instance.new("BlurEffect");
u5.Name = "MenuBlur";
u5.Size = 0;
u5.Parent = Lighting;

function u1.Get(p6) -- Line: 58
    return p6.Data;
end;

function u1.Update(p7, p8) -- Line: 60
    for i, v in pairs(p8) do
        p7.Data[i] = v;
    end;
end;

local u9 = UDim2.new(0.5, 0, 1.5, 0);
local u10 = UDim2.new(0.5, 0, 0.5, 0);

function u1.ToggleModal(p11, p12, p13) -- Line: 73
    -- upvalues: u9 (copy), TweenService (copy), u10 (copy), u5 (copy), CurrentCamera (copy), u1 (copy)
    if p11.ActiveModal == p12 then
        p11:CloseCurrentModal();

        return;
    end;

    if p11.ActiveModal ~= nil then
        p11:CloseCurrentModal();
    end;

    p11.ActiveModal = p12;
    p11.ActiveSystem = p13;
    p12.AnchorPoint = Vector2.new(0.5, 0.5);
    p12.Position = u9;
    p12.Visible = true;
    TweenService:Create(p12, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = u10
    }):Play();
    TweenService:Create(u5, TweenInfo.new(0.4), {
        Size = 20
    }):Play();
    TweenService:Create(CurrentCamera, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
        FieldOfView = 50
    }):Play();

    for _, v in ipairs(u1.ModalListeners) do
        v(true);
    end;
end;

function u1.CloseCurrentModal(p14) -- Line: 105
    -- upvalues: u1 (copy), TweenService (copy), u9 (copy), u5 (copy), CurrentCamera (copy)
    local ActiveModal = p14.ActiveModal;

    if not ActiveModal then
        return;
    end;

    if p14.ActiveSystem and p14.ActiveSystem.OnClose then
        p14.ActiveSystem:OnClose();
    end;

    p14.ActiveModal = nil;
    p14.ActiveSystem = nil;

    for _, v in ipairs(u1.ModalListeners) do
        v(false);
    end;

    local v15 = TweenService:Create(ActiveModal, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Position = u9
    });
    v15:Play();
    TweenService:Create(u5, TweenInfo.new(0.3), {
        Size = 0
    }):Play();
    TweenService:Create(CurrentCamera, TweenInfo.new(0.3), {
        FieldOfView = 70
    }):Play();
    v15.Completed:Connect(function(p16) -- Line: 129
        -- upvalues: ActiveModal (copy)
        if p16 == Enum.PlaybackState.Completed then
            ActiveModal.Visible = false;
        end;
    end);
end;

function u1.ForceResetModal(p17) -- Line: 137
    -- upvalues: u9 (copy), u5 (copy), CurrentCamera (copy), u1 (copy)
    if p17.ActiveSystem and p17.ActiveSystem.OnClose then
        p17.ActiveSystem:OnClose();
    end;

    if p17.ActiveModal then
        p17.ActiveModal.Visible = false;
        p17.ActiveModal.Position = u9;
    end;

    p17.ActiveModal = nil;
    p17.ActiveSystem = nil;
    u5.Size = 0;
    CurrentCamera.FieldOfView = 70;

    for _, v in ipairs(u1.ModalListeners) do
        v(false);
    end;
end;

return u1;