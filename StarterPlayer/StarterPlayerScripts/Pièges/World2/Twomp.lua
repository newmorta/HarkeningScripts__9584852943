-- Ruta Original: StarterPlayer.StarterPlayerScripts.Pièges.World2.Twomp
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;

local function smoothstep(p1) -- Line: 11
    return p1 * p1 * (3 - 2 * p1);
end;

local function setupTwomp(u2) -- Line: 15
    -- upvalues: RunService (copy), LocalPlayer (copy)
    local TriggerPart = u2:WaitForChild("TriggerPart", 10);
    local Movement = u2:WaitForChild("Movement", 10);

    if not (TriggerPart and Movement) then
        warn("Twomp (Client): TriggerPart ou Movement introuvable dans", u2.Name);

        return;
    end;

    local _, v3 = Movement:GetBoundingBox();
    local u4 = Movement:GetPivot();
    local u5 = u4 + Vector3.new(0, -(u4.Position.Y - (TriggerPart.Position.Y - TriggerPart.Size.Y / 2)) + v3.Y / 2, 0);
    local u6 = false;

    local function animateTo(u7, u8, p9, u10) -- Line: 33
        -- upvalues: Movement (copy), RunService (ref)
        local u11 = 0;
        local u12 = math.abs((u7.Position - u8.Position).Y) / p9;

        if u12 <= 0 then
            Movement:PivotTo(u8);
            u10();

            return;
        end;

        local u13 = nil;
        u13 = RunService.RenderStepped:Connect(function(p14) -- Line: 45
            -- upvalues: u11 (ref), u12 (copy), Movement (ref), u7 (copy), u8 (copy), u13 (ref), u10 (copy)
            u11 = u11 + p14;
            local v15 = math.min(u11 / u12, 1);
            Movement:PivotTo(u7:Lerp(u8, v15 * v15 * (3 - 2 * v15)));

            if v15 >= 1 then
                u13:Disconnect();
                u10();
            end;
        end);
    end;

    local u17 = TriggerPart.Touched:Connect(function(p16) -- Line: 57
        -- upvalues: u6 (ref), LocalPlayer (ref), TriggerPart (copy), animateTo (copy), Movement (copy), u5 (copy), u4 (copy)
        if u6 then
            return;
        end;

        if not LocalPlayer.Character then
            return;
        end;

        if not p16:IsDescendantOf(LocalPlayer.Character) then
            return;
        end;

        u6 = true;

        if TriggerPart:FindFirstChild("Sound") then
            TriggerPart.Sound:Play();
        end;

        animateTo(Movement:GetPivot(), u5, 88, function() -- Line: 69
            -- upvalues: Movement (ref), u5 (ref), animateTo (ref), u4 (ref), u6 (ref)
            Movement:PivotTo(u5);
            task.wait(0.4);
            animateTo(Movement:GetPivot(), u4, 5, function() -- Line: 72
                -- upvalues: Movement (ref), u4 (ref), u6 (ref)
                Movement:PivotTo(u4);
                u6 = false;
            end);
        end);
    end);
    local u18 = nil;
    u18 = u2.AncestryChanged:Connect(function() -- Line: 80
        -- upvalues: u2 (copy), u17 (copy), u18 (ref)
        if not u2.Parent then
            u17:Disconnect();
            u18:Disconnect();
        end;
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("Twomp")) do
    task.spawn(setupTwomp, v);
end;

CollectionService:GetInstanceAddedSignal("Twomp"):Connect(function(p19) -- Line: 92
    -- upvalues: setupTwomp (copy)
    task.spawn(setupTwomp, p19);
end);