-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.ChichineBossRoom.AttacksClient.SwordTango
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Assets = game:GetService("ReplicatedStorage").AdminAbuse.ChichineBossRoom.Assets;
local ClientDebris = require(script.Parent.ClientDebris);
local ChichineConfig = require(script.Parent.Parent.ChichineConfig);
local u1 = (-1 / 0);
local u2 = {};

return {
    play = function(p3) -- Line: 27, Name: play
        -- upvalues: Assets (copy), ChichineConfig (copy), Players (copy), u1 (ref), ClientDebris (copy), TweenService (copy), RunService (copy), u2 (copy)
        local v4 = p3.x or 0;
        local v5 = p3.y or 0;
        local v6 = p3.z or 0;
        local v7 = p3.duration or 10;
        local v8 = p3.phase or 1;
        local u9 = math.random(100, 150);
        local SwordTango = Assets:FindFirstChild("SwordTango");

        if not SwordTango then
            warn("[ChichineBossRoom] SwordTango: \'SwordTango\' model not found in Assets");

            return;
        end;

        local SwordTango2 = ChichineConfig.SwordTango;
        local v10 = math.clamp(v8, 1, 5);
        local u11 = Vector3.new(v4, v5 + 3, v6);

        local function onSwordTouched(p12) -- Line: 47
            -- upvalues: Players (ref), u1 (ref), SwordTango2 (copy)
            local Character = Players.LocalPlayer.Character;

            if not Character or p12.Parent ~= Character then
                return;
            end;

            local v13 = tick();

            if v13 - u1 < SwordTango2.damageCooldown then
                return;
            end;

            u1 = v13;
            local v14 = Character:FindFirstChildOfClass("Humanoid");

            if v14 and v14.Health > 0 then
                v14:TakeDamage(SwordTango2.damage);
            end;
        end;

        for i = 1, v10 do
            local u15 = SwordTango:Clone();
            local v16 = {};

            for _, descendant in u15:GetDescendants() do
                if descendant:IsA("BasePart") then
                    v16[descendant] = descendant.Transparency;
                    descendant.Transparency = 1;
                    descendant.Anchored = true;
                    descendant.CanCollide = false;
                    descendant.CanTouch = true;
                    descendant.CastShadow = false;
                    descendant.Touched:Connect(onSwordTouched);
                end;
            end;

            local u17 = (i - 1) / v10 * 6.283185307179586;
            local new = CFrame.new;
            local v18 = math.cos(u17) * u9;
            local v19 = math.sin(u17) * u9;
            u15:PivotTo(new(u11 + Vector3.new(v18, 0, v19)) * CFrame.Angles(0, -u17, 0));
            u15.Parent = ClientDebris();
            local v20 = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

            for i2, v in v16 do
                if i2.Parent then
                    TweenService:Create(i2, v20, {
                        Transparency = v
                    }):Play();
                end;
            end;

            local u21 = 0;
            local u22 = nil;
            u22 = RunService.Heartbeat:Connect(function(p23) -- Line: 97
                -- upvalues: u15 (copy), u22 (ref), u21 (ref), u17 (copy), u9 (copy), u11 (copy)
                if not u15.Parent then
                    u22:Disconnect();

                    return;
                end;

                u21 = u21 + p23;
                local v24 = u17 + u21 * 1.2;
                local v25 = math.cos(v24) * u9;
                local v26 = math.sin(v24) * u9;
                u15:PivotTo(CFrame.new(u11 + Vector3.new(v25, 0, v26)) * CFrame.Angles(0, -v24, 0));
            end);
            table.insert(u2, {
                model = u15,
                conn = u22
            });
            task.delay(v7, function() -- Line: 115
                -- upvalues: u22 (ref), u15 (copy), TweenService (ref), u2 (ref)
                u22:Disconnect();

                if not u15.Parent then
                    return;
                end;

                for _, descendant in u15:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        TweenService:Create(descendant, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Transparency = 1
                        }):Play();
                    end;
                end;

                task.delay(0.5, function() -- Line: 128
                    -- upvalues: u15 (ref), u2 (ref)
                    pcall(function() -- Line: 129
                        -- upvalues: u15 (ref)
                        u15:Destroy();
                    end);

                    for i2, v in u2 do
                        if v.model == u15 then
                            table.remove(u2, i2);

                            return;
                        end;
                    end;
                end);
            end);
        end;
    end,

    cleanup = function() -- Line: 141, Name: cleanup
        -- upvalues: u2 (copy)
        for _, v in u2 do
            pcall(function() -- Line: 143
                -- upvalues: v (copy)
                v.conn:Disconnect();
                v.model:Destroy();
            end);
        end;

        table.clear(u2);
    end
};