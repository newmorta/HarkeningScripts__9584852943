-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.Shared.BossClientBase
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local u1;

if RunService:IsClient() then
    u1 = Players.LocalPlayer.PlayerGui;
else
    u1 = nil;
end;

local AdminAbuse = ReplicatedStorage:WaitForChild("AdminAbuse");
local SharedSyncedEvent = require(AdminAbuse:WaitForChild("SharedSyncedEvent"));
local u2 = {};
u2.__index = u2;

function u2.new(p3) -- Line: 31
    -- upvalues: u2 (copy)
    local v4 = type(p3) == "table";
    assert(v4, "BossClientBase.new: opts required");
    local v5 = type(p3.sseChannelName) == "string";
    assert(v5, "opts.sseChannelName required");
    local v6 = type(p3.bossDisplayName) == "string";
    assert(v6, "opts.bossDisplayName required");
    p3.bossIcon = p3.bossIcon or "";
    p3.barTweenDurationSec = p3.barTweenDurationSec or 0.38;
    p3.phaseMarkerCount = p3.phaseMarkerCount or 3;
    p3.screenGuiName = p3.screenGuiName or p3.sseChannelName .. "HUD";
    p3.screenGuiDisplayOrder = p3.screenGuiDisplayOrder or 80;
    p3.colorHpFill = p3.colorHpFill or Color3.fromRGB(148, 8, 8);
    p3.hideCutsceneUi = p3.hideCutsceneUi or false;
    local v7 = setmetatable({}, u2);
    v7._opts = p3;
    v7._sse = nil;
    v7._screen = nil;
    v7._barFill = nil;
    v7._hpLabel = nil;
    v7._phaseLabel = nil;
    v7._hpDriver = nil;
    v7._hpTween = nil;
    v7._bossMaxRef = 1;
    v7._lastRevisionSeen = 0;
    v7._firstSync = false;
    v7._phaseMarkerFrames = {};
    v7._phaseMarkerTexts = {};
    v7._endMarkerFrame = nil;
    v7._endMarkerText = nil;
    v7._savedUiStates = {};
    v7._barGradient = nil;
    v7._barGradientConn = nil;

    return v7;
end;

function u2._buildUi(u8) -- Line: 69
    -- upvalues: u1 (ref)
    if not u1 then
        warn("BossClientBase: PlayerGui not found; cannot build UI.");

        return;
    end;

    if u8._barGradientConn then
        u8._barGradientConn:Disconnect();
        u8._barGradientConn = nil;
    end;

    if u8._barGradient then
        u8._barGradient:Destroy();
        u8._barGradient = nil;
    end;

    if u8._screen then
        u8._screen:Destroy();
    end;

    u8._barFill = nil;
    u8._hpLabel = nil;
    u8._phaseLabel = nil;
    u8._hpDriver = nil;
    u8._endMarkerFrame = nil;
    u8._endMarkerText = nil;
    table.clear(u8._phaseMarkerFrames);
    table.clear(u8._phaseMarkerTexts);
    local _opts = u8._opts;
    local phaseMarkerCount = _opts.phaseMarkerCount;
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = _opts.screenGuiName;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    ScreenGui.DisplayOrder = _opts.screenGuiDisplayOrder;
    ScreenGui.Parent = u1;
    u8._screen = ScreenGui;
    local Frame = Instance.new("Frame");
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.new(0.5, 0, 0, 45);
    Frame.Size = UDim2.new(0.6, 0, 0.08, 0);
    Frame.Parent = ScreenGui;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "ProgressBg";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.fromRGB(20, 20, 30);
    Frame2.BackgroundTransparency = 0.4;
    Frame2.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame2.Size = UDim2.new(1, 0, 0.65, 0);
    Frame2.Parent = Frame;
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0.5, 0);
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Position = UDim2.new(0, -65, 0.5, 0);
    ImageLabel.Size = UDim2.new(0, 60, 0, 60);
    ImageLabel.Image = _opts.bossIcon;
    ImageLabel.Parent = Frame2;
    Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(1, 0);
    local UIStroke = Instance.new("UIStroke", ImageLabel);
    UIStroke.Color = _opts.colorHpFill;
    UIStroke.Thickness = 2;
    local Frame3 = Instance.new("Frame", Frame2);
    Frame3.Name = "Fill";
    Frame3.BackgroundColor3 = _opts.colorHpFill;
    Frame3.Size = UDim2.new(0, 0, 1, 0);
    Frame3.BorderSizePixel = 0;
    Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0.5, 0);
    u8._barFill = Frame3;
    local phaseThresholds = _opts.phaseThresholds;
    local v9;

    if type(phaseThresholds) == "table" then
        v9 = #phaseThresholds > 0;
    else
        v9 = false;
    end;

    local v10 = {};

    if v9 then
        for _, v in ipairs(phaseThresholds) do
            table.insert(v10, v);
        end;
    else
        for i = 1, phaseMarkerCount - 1 do
            table.insert(v10, i / phaseMarkerCount);
        end;
    end;

    for i, v in ipairs(v10) do
        local Frame4 = Instance.new("Frame");
        Frame4.Name = "Phase" .. tostring(i + 1) .. "Marker";
        Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame4.Position = UDim2.new(v, 0, 0.5, 0);
        Frame4.Size = UDim2.new(0, 6, 1, 0);
        Frame4.BorderSizePixel = 0;
        Frame4.ZIndex = Frame3.ZIndex + 2;
        Frame4.Parent = Frame2;
        Instance.new("UIStroke", Frame4).Thickness = 1;
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "Phase" .. tostring(i + 1) .. "Text";
        TextLabel.AnchorPoint = Vector2.new(0.5, 0);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.Position = UDim2.new(v, 0, 0.5, 16);
        TextLabel.Size = UDim2.new(0, 64, 0, 22);
        TextLabel.ZIndex = Frame3.ZIndex + 3;
        TextLabel.Font = Enum.Font.GothamBold;
        TextLabel.Text = "P" .. tostring(i + 1);
        TextLabel.TextScaled = true;
        TextLabel.TextStrokeTransparency = 0.55;
        TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
        TextLabel.TextColor3 = Color3.fromRGB(190, 190, 200);
        TextLabel.Parent = Frame2;
        table.insert(u8._phaseMarkerFrames, Frame4);
        table.insert(u8._phaseMarkerTexts, TextLabel);
    end;

    local Frame4 = Instance.new("Frame");
    Frame4.Name = "EndMarker";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.Position = UDim2.new(1, 0, 0.5, 0);
    Frame4.Size = UDim2.new(0, 6, 1, 0);
    Frame4.BorderSizePixel = 0;
    Frame4.ZIndex = Frame3.ZIndex + 2;
    Frame4.Parent = Frame2;
    Instance.new("UIStroke", Frame4).Thickness = 1;
    u8._endMarkerFrame = Frame4;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "EndText";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Position = UDim2.new(1, 0, 0.5, 16);
    TextLabel.Size = UDim2.new(0, 64, 0, 22);
    TextLabel.ZIndex = Frame3.ZIndex + 3;
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.Text = "???";
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeTransparency = 0.55;
    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
    TextLabel.TextColor3 = Color3.fromRGB(190, 190, 200);
    TextLabel.Parent = Frame2;
    u8._endMarkerText = TextLabel;
    local TextLabel2 = Instance.new("TextLabel", Frame2);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.Size = UDim2.new(0.45, 0, 1, 0);
    TextLabel2.Font = Enum.Font.GothamBold;
    TextLabel2.Text = _opts.bossDisplayName:upper() .. " BOSS EVENT";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    Instance.new("UIPadding", TextLabel2).PaddingLeft = UDim.new(0.04, 0);
    local TextLabel3 = Instance.new("TextLabel", Frame2);
    TextLabel3.AnchorPoint = Vector2.new(1, 0);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.Position = UDim2.new(1, 0, 0, 0);
    TextLabel3.Size = UDim2.new(0.4, 0, 1, 0);
    TextLabel3.Font = Enum.Font.GothamBold;
    TextLabel3.Text = "0 / 0";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Right;
    Instance.new("UIPadding", TextLabel3).PaddingRight = UDim.new(0.04, 0);
    u8._hpLabel = TextLabel3;
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = 0;
    NumberValue.Changed:Connect(function() -- Line: 247
        -- upvalues: u8 (copy)
        u8:_refreshBar();
    end);
    u8._hpDriver = NumberValue;
    local TextLabel4 = Instance.new("TextLabel", ScreenGui);
    TextLabel4.Name = "PhaseLabel";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.Position = UDim2.new(0.5, 0, 0.08, 52);
    TextLabel4.Size = UDim2.new(0.12, 0, 0, 20);
    TextLabel4.Font = Enum.Font.GothamBold;
    TextLabel4.Text = "PHASE 1";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.TextStrokeTransparency = 0.5;
    TextLabel4.TextStrokeColor3 = Color3.new(0, 0, 0);
    u8._phaseLabel = TextLabel4;
    u8:_applyPhaseMarkerStyle(1);

    if _opts.animatedGradient then
        u8:_applyBarGradient();
    end;
end;

function u2._applyBarGradient(u11) -- Line: 274
    -- upvalues: RunService (copy)
    local _barFill = u11._barFill;

    if not _barFill then
        return;
    end;

    _barFill.BackgroundColor3 = Color3.fromRGB(155, 0, 190);

    if u11._barGradientConn then
        u11._barGradientConn:Disconnect();
        u11._barGradientConn = nil;
    end;

    if u11._barGradient then
        u11._barGradient:Destroy();
    end;

    local UIGradient = Instance.new("UIGradient");
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 30, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(20, 8, 30)),
        ColorSequenceKeypoint.new(0.68, Color3.fromRGB(195, 16, 240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 0, 12))
    });
    UIGradient.Rotation = 0;
    UIGradient.Parent = _barFill;
    u11._barGradient = UIGradient;
    u11._barGradientConn = RunService.Heartbeat:Connect(function() -- Line: 294
        -- upvalues: u11 (copy)
        local _barGradient = u11._barGradient;

        if not (_barGradient and _barGradient.Parent) then
            if u11._barGradientConn then
                u11._barGradientConn:Disconnect();
                u11._barGradientConn = nil;
            end;

            return;
        end;

        local new = Vector2.new;
        local v12 = os.clock() * 0.85;
        _barGradient.Offset = new(math.sin(v12) * 0.65, 0);
    end);
end;

local u13 = { { 1e18, "Qi" }, { 1000000000000000, "Qa" }, { 1000000000000, "T" }, { 1000000000, "B" }, { 1000000, "M" }, { 1000, "K" } };

local function _fmtHp(p14, p15, p16) -- Line: 315
    if p15 == 1 then
        local v17 = math.floor(p14 + 0.5);

        return tostring(v17);
    end;

    local v18 = p14 / p15;

    if v18 >= 100 then
        return string.format("%d%s", math.floor(v18 + 0.5), p16);
    end;

    if v18 >= 10 then
        return string.format("%.1f%s", v18, p16);
    end;

    return string.format("%.2f%s", v18, p16);
end;

function u2._refreshBar(p19) -- Line: 323
    -- upvalues: u13 (copy), _fmtHp (copy)
    local _barFill = p19._barFill;
    local _hpLabel = p19._hpLabel;
    local _hpDriver = p19._hpDriver;

    if not _hpDriver or (not _barFill or p19._bossMaxRef <= 0) then
        return;
    end;

    local v20 = math.clamp(_hpDriver.Value, 0, p19._bossMaxRef);
    _barFill.Size = UDim2.new(math.clamp(v20 / p19._bossMaxRef, 0, 1), 0, 1, 0);

    if _hpLabel then
        local v21 = 1;
        local v22 = "";

        for _, v in u13 do
            if p19._bossMaxRef >= v[1] then
                v21 = v[1];
                v22 = v[2];
                break;
            end;
        end;

        _hpLabel.Text = _fmtHp(v20, v21, v22) .. " / " .. _fmtHp(p19._bossMaxRef, v21, v22);
    end;

    local _endMarkerFrame = p19._endMarkerFrame;

    if _endMarkerFrame then
        local v23 = v20 / p19._bossMaxRef >= 0.999;
        local v24;

        if v23 then
            v24 = Color3.fromRGB(255, 30, 80);
        else
            v24 = Color3.fromRGB(95, 95, 105);
        end;

        _endMarkerFrame.BackgroundColor3 = v24;
        _endMarkerFrame.BackgroundTransparency = v23 and 0.05 or 0.35;

        if p19._endMarkerText then
            local _endMarkerText = p19._endMarkerText;
            local v25;

            if v23 then
                v25 = Color3.fromRGB(255, 200, 210);
            else
                v25 = Color3.fromRGB(190, 190, 200);
            end;

            _endMarkerText.TextColor3 = v25;
        end;
    end;
end;

function u2._applyPhaseMarkerStyle(p26, p27) -- Line: 355
    local v28 = math.floor(p27);
    local v29 = math.clamp(v28, 1, 100);

    for i, v in ipairs(p26._phaseMarkerFrames) do
        local v30 = i + 1 <= v29;
        local v31;

        if v30 then
            v31 = Color3.fromRGB(185, 110, 255);
        else
            v31 = Color3.fromRGB(95, 95, 105);
        end;

        v.BackgroundColor3 = v31;
        v.BackgroundTransparency = v30 and 0.05 or 0.35;
        local v32 = p26._phaseMarkerTexts[i];

        if v32 then
            local v33;

            if v30 then
                v33 = Color3.fromRGB(235, 205, 255);
            else
                v33 = Color3.fromRGB(190, 190, 200);
            end;

            v32.TextColor3 = v33;
        end;
    end;

    local _endMarkerFrame = p26._endMarkerFrame;

    if _endMarkerFrame then
        _endMarkerFrame.BackgroundColor3 = Color3.fromRGB(95, 95, 105);
        _endMarkerFrame.BackgroundTransparency = 0.35;

        if p26._endMarkerText then
            p26._endMarkerText.TextColor3 = Color3.fromRGB(190, 190, 200);
        end;
    end;
end;

function u2._onBossHp(p34, p35) -- Line: 378
    -- upvalues: TweenService (copy)
    if type(p35) ~= "table" then
        return;
    end;

    local hp = p35.hp;
    local max = p35.max;

    if type(hp) ~= "number" or (type(max) ~= "number" or max <= 0) then
        return;
    end;

    if type(p35.rev) == "number" and p35.rev < p34._lastRevisionSeen then
        return;
    end;

    if type(p35.rev) == "number" then
        p34._lastRevisionSeen = p35.rev;
    end;

    p34._bossMaxRef = max;

    if p34._hpTween then
        p34._hpTween:Cancel();
        p34._hpTween = nil;
    end;

    local v36 = math.clamp(hp, 0, max);

    if not p34._firstSync then
        p34._firstSync = true;

        if p34._hpDriver then
            p34._hpDriver.Value = v36;
        end;

        p34:_refreshBar();

        return;
    end;

    local _hpDriver = p34._hpDriver;

    if not _hpDriver then
        return;
    end;

    local v37 = TweenService:Create(_hpDriver, TweenInfo.new(p34._opts.barTweenDurationSec, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Value = v36
    });
    p34._hpTween = v37;
    v37:Play();
end;

function u2._onPhase(p38, p39) -- Line: 404
    local v40 = type(p39) ~= "number" and 1 or p39;
    p38:_applyPhaseMarkerStyle(v40);

    if p38._phaseLabel then
        local _phaseLabel = p38._phaseLabel;
        local v41 = math.floor(v40);
        local v42 = math.clamp(v41, 1, 100);
        _phaseLabel.Text = "PHASE " .. tostring(v42);
    end;
end;

function u2._onFxEvent(p43, p44) -- Line: 412
    if type(p44) ~= "table" then
        return;
    end;

    local cmd = p44.cmd;
    local _opts = p43._opts;

    if cmd == "PhaseChange" then
        p43:_onPhase(type(p44.phase) ~= "number" and 1 or p44.phase);
    elseif cmd == "CutsceneBegin" then
        if _opts.hideCutsceneUi then
            p43:hideCutsceneUi();
        end;
    elseif cmd == "CutsceneEnd" and _opts.hideCutsceneUi then
        p43:showCutsceneUi();
    end;

    if _opts.onFx then
        _opts.onFx(cmd, p44, p43);
    end;
end;

function u2.fire(u45) -- Line: 432
    -- upvalues: SharedSyncedEvent (copy)
    if u45._sse then
        u45._sse:destroy();
        u45._sse = nil;
    end;

    u45:_buildUi();
    local v46 = SharedSyncedEvent.new(u45._opts.sseChannelName);
    u45._sse = v46;
    v46:onChange("BossHp", function(p47) -- Line: 443
        -- upvalues: u45 (copy)
        u45:_onBossHp(p47);
    end);
    v46:onChange("Phase", function(p48) -- Line: 444
        -- upvalues: u45 (copy)
        u45:_onPhase(p48);
    end);
    v46:onFire("Fx", function(p49) -- Line: 445
        -- upvalues: u45 (copy)
        u45:_onFxEvent(p49);
    end);
    v46:onChange("StartUnix", function(p50) -- Line: 446
        -- upvalues: u45 (copy)
        u45:_onStartUnix(p50);
    end);
end;

function u2._onStartUnix(p51, p52) -- Line: 449
end;

function u2.stop(p53) -- Line: 453
    if p53._sse then
        p53._sse:destroy();
        p53._sse = nil;
    end;

    if p53._barGradientConn then
        p53._barGradientConn:Disconnect();
        p53._barGradientConn = nil;
    end;

    if p53._barGradient then
        p53._barGradient:Destroy();
        p53._barGradient = nil;
    end;

    if p53._hpTween then
        p53._hpTween:Cancel();
        p53._hpTween:Destroy();
        p53._hpTween = nil;
    end;

    if p53._hpDriver then
        p53._hpDriver:Destroy();
        p53._hpDriver = nil;
    end;

    if p53._opts.hideCutsceneUi then
        p53:showCutsceneUi();
    end;

    if p53._screen then
        p53._screen:Destroy();
        p53._screen = nil;
    end;

    p53._barFill = nil;
    p53._hpLabel = nil;
    p53._phaseLabel = nil;
    p53._bossMaxRef = 1;
    p53._lastRevisionSeen = 0;
    p53._firstSync = false;
    p53._endMarkerFrame = nil;
    p53._endMarkerText = nil;
    table.clear(p53._phaseMarkerFrames);
    table.clear(p53._phaseMarkerTexts);
    table.clear(p53._savedUiStates);
end;

function u2.hideCutsceneUi(p54) -- Line: 491
    -- upvalues: Players (copy), CollectionService (copy)
    local v55 = Players.LocalPlayer and v55:FindFirstChildOfClass("PlayerGui");

    if not v55 then
        return;
    end;

    table.clear(p54._savedUiStates);

    for _, v in ipairs(CollectionService:GetTagged("UI")) do
        if v:IsA("Frame") and v:IsDescendantOf(v55) then
            p54._savedUiStates[v] = v.Visible;
            v.Visible = false;
        end;
    end;
end;

function u2.showCutsceneUi(p56) -- Line: 504
    for i, v in pairs(p56._savedUiStates) do
        if i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(p56._savedUiStates);
end;

return u2;