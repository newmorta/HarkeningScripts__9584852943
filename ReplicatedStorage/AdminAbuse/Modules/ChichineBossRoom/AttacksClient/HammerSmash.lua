-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.ChichineBossRoom.AttacksClient.HammerSmash
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Assets = game:GetService("ReplicatedStorage").AdminAbuse.ChichineBossRoom.Assets;
local ClientDebris = require(script.Parent.ClientDebris);
local ImpactFx = require(script.Parent.ImpactFx);
local u1 = nil;

local function tweenModelPivot(u2, u3, u4, u5, u6) -- Line: 17
    -- upvalues: RunService (copy), TweenService (copy)
    local u7 = u2:GetPivot();
    local u8 = 0;
    local u9 = coroutine.running();
    local u10 = nil;
    u10 = RunService.Heartbeat:Connect(function(p11) -- Line: 28
        -- upvalues: u2 (copy), u10 (ref), u9 (copy), u8 (ref), u4 (copy), TweenService (ref), u5 (copy), u6 (copy), u7 (copy), u3 (copy)
        if not u2.Parent then
            u10:Disconnect();
            task.spawn(u9);

            return;
        end;

        u8 = math.min(u8 + p11, u4);
        u2:PivotTo(u7:Lerp(u3, (TweenService:GetValue(u8 / u4, u5, u6))));

        if u4 <= u8 then
            u10:Disconnect();
            task.spawn(u9);
        end;
    end);
    coroutine.yield();
end;

local u12 = {};

function u12.hover(p13) -- Line: 48
    -- upvalues: u12 (copy), Assets (copy), ClientDebris (copy), u1 (ref), tweenModelPivot (copy)
    u12.cleanup();
    local Banhammer = Assets:FindFirstChild("Banhammer");

    if not Banhammer then
        warn("[ChichineBossRoom] HammerSmash: Banhammer model not found in Assets");

        return;
    end;

    local u14 = Banhammer:Clone();

    for _, descendant in u14:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CastShadow = false;
        end;
    end;

    local u15 = p13.cx or 0;
    local u16 = p13.cy or 0;
    local u17 = p13.cz or 0;
    local u18 = p13.hx or 20;
    local u19 = p13.hz or 20;
    local u20 = p13.tx or u15;
    local u21 = p13.ty or u16;
    local u22 = p13.tz or u17;
    local u23 = p13.height or 50;
    local u24 = p13.hoverSec or 3;
    local u25 = p13.steps or 3;
    local u26 = CFrame.Angles(1.5707963267948966, 0, 0);
    u14:ScaleTo(2);
    u14:PivotTo(CFrame.new(u15, u16 + u23, u17) * u26);
    u14.Parent = ClientDebris();
    u1 = u14;
    task.spawn(function() -- Line: 86
        -- upvalues: u24 (copy), u25 (copy), u1 (ref), u18 (copy), u19 (copy), tweenModelPivot (ref), u14 (copy), u15 (copy), u16 (copy), u23 (copy), u17 (copy), u26 (copy), u20 (copy), u21 (copy), u22 (copy)
        local v27 = u24 * 0.6 / math.max(u25, 1);

        for _ = 1, u25 do
            if not (u1 and u1.Parent) then
                return;
            end;

            local v28 = (math.random() * 2 - 1) * u18;
            local v29 = (math.random() * 2 - 1) * u19;
            tweenModelPivot(u14, CFrame.new(u15 + v28, u16 + u23, u17 + v29) * u26, v27, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut);
        end;

        if not (u1 and u1.Parent) then
            return;
        end;

        tweenModelPivot(u14, CFrame.new(u20, u21 + u23, u22) * u26, u24 * 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    end);
end;

function u12.warn(p30) -- Line: 114
    -- upvalues: u1 (ref), ClientDebris (copy), TweenService (copy)
    local v31 = p30.r or 50;
    local v32 = p30.t or 2.5;
    local v33 = p30.x or 0;
    local v34 = p30.y or 0;
    local v35 = p30.z or 0;

    if u1 then
        local HammerSmashZone = u1:FindFirstChild("HammerSmashZone", true);

        if HammerSmashZone and HammerSmashZone:IsA("BasePart") then
            local Position = HammerSmashZone.Position;
            v33 = Position.X;
            v34 = Position.Y - 2;
            v35 = Position.Z;
        end;
    end;

    local Part = Instance.new("Part");
    Part.Name = "ChichineHMWarnDisc";
    Part.Shape = Enum.PartType.Cylinder;
    Part.Size = Vector3.new(0.35, v31 * 2, v31 * 2);
    Part.CFrame = CFrame.new(v33, v34 - 25, v35) * CFrame.Angles(0, 0, 1.5707963267948966);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CastShadow = false;
    Part.Material = Enum.Material.Neon;
    Part.Color = Color3.fromRGB(255, 0, 0);
    Part.Transparency = 0.4;
    Part.Parent = ClientDebris();
    task.delay(math.max(0, v32 - 0.2), function() -- Line: 146
        -- upvalues: Part (copy), TweenService (ref)
        if not Part.Parent then
            return;
        end;

        local u36 = TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Transparency = 1
        });
        u36.Completed:Once(function() -- Line: 151
            -- upvalues: u36 (copy), Part (ref)
            u36:Destroy();
            pcall(function() -- Line: 153
                -- upvalues: Part (ref)
                Part:Destroy();
            end);
        end);
        u36:Play();
    end);
end;

function u12.smash(p37) -- Line: 159
    -- upvalues: u1 (ref), tweenModelPivot (copy)
    local u38 = u1;

    if not (u38 and u38.Parent) then
        return;
    end;

    local u39 = p37.prepareSec or 0.5;
    local u40 = p37.smashSec or 0.5;
    task.spawn(function() -- Line: 166
        -- upvalues: u38 (copy), tweenModelPivot (ref), u39 (copy), u40 (copy)
        local v41 = u38:GetPivot();
        tweenModelPivot(u38, v41 * CFrame.Angles(-1.5707963267948966, 0, 0), u39, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

        if not (u38 and u38.Parent) then
            return;
        end;

        tweenModelPivot(u38, v41, u40, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
    end);
end;

function u12.impact(p42) -- Line: 186
    -- upvalues: u1 (ref), ImpactFx (copy), u12 (copy)
    local v43 = p42.x or 0;
    local v44 = p42.y or 0;
    local v45 = p42.z or 0;
    local v46 = p42.r or 50;

    if u1 then
        local HammerSmashZone = u1:FindFirstChild("HammerSmashZone", true);

        if HammerSmashZone and HammerSmashZone:IsA("BasePart") then
            local Position = HammerSmashZone.Position;
            v43 = Position.X;
            v44 = Position.Y;
            v45 = Position.Z;
        end;
    end;

    ImpactFx.explosion(v43, v44, v45, v46 * 2);
    u12.cleanup();
end;

function u12.cleanup() -- Line: 206
    -- upvalues: u1 (ref)
    if u1 then
        pcall(function() -- Line: 208
            -- upvalues: u1 (ref)
            u1:Destroy();
        end);
        u1 = nil;
    end;
end;

return u12;