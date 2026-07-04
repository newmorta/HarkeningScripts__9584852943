-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.ChichineBossRoom.AttacksClient.ZoneSweet
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local ClientDebris = require(script.Parent.ClientDebris);
local ImpactFx = require(script.Parent.ImpactFx);
local u1 = { Color3.fromRGB(255, 152, 220), Color3.fromRGB(85, 44, 2) };

return {
    ZoneWarn = function(p2) -- Line: 14, Name: ZoneWarn
        -- upvalues: ClientDebris (copy), TweenService (copy)
        local v3 = p2.x or 0;
        local v4 = p2.y or 0;
        local v5 = p2.z or 0;
        local u6 = p2.hx or 14;
        local u7 = p2.hz or 14;
        local v8 = p2.t or 1.4;
        local Part = Instance.new("Part");
        Part.Name = "ChichineZoneWarnFx";
        Part.Shape = Enum.PartType.Cylinder;
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CastShadow = false;
        Part.Material = Enum.Material.Neon;
        Part.Color = Color3.fromRGB(255, 100, 30);
        Part.Transparency = 0.35;
        Part.Size = Vector3.new(0.05, u6 * 2, u7 * 2);
        Part.CFrame = CFrame.new(v3, v4 + 0.15, v5) * CFrame.Angles(0, 0, 1.5707963267948966);
        Part.Parent = ClientDebris();
        local u9 = TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = Vector3.new(5, u6 * 2, u7 * 2)
        });
        u9:Play();
        u9.Completed:Once(function() -- Line: 40
            -- upvalues: u9 (copy)
            u9:Destroy();
        end);
        local u10 = TweenService:Create(Part, TweenInfo.new(0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            Transparency = 0.72
        });
        task.delay(0.18, function() -- Line: 45
            -- upvalues: Part (copy), u10 (copy)
            if Part.Parent then
                u10:Play();
            end;
        end);
        task.delay(math.max(0, v8 - 0.18), function() -- Line: 49
            -- upvalues: Part (copy), u10 (copy), TweenService (ref), u6 (copy), u7 (copy)
            if not Part.Parent then
                u10:Destroy();

                return;
            end;

            u10:Cancel();
            u10:Destroy();
            local u11 = TweenService:Create(Part, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Transparency = 1,
                Size = Vector3.new(0.05, u6 * 2, u7 * 2)
            });
            u11.Completed:Once(function() -- Line: 59
                -- upvalues: u11 (copy), Part (ref)
                u11:Destroy();
                pcall(function() -- Line: 61
                    -- upvalues: Part (ref)
                    Part:Destroy();
                end);
            end);
            u11:Play();
        end);
    end,

    ZoneHit = function(p12) -- Line: 67, Name: ZoneHit
        -- upvalues: u1 (copy), ClientDebris (copy), TweenService (copy), ImpactFx (copy)
        local v13 = math.random(1, #u1);
        local v14 = p12.x or 0;
        local v15 = p12.y or 0;
        local v16 = p12.z or 0;
        local v17 = p12.hx or 14;
        local v18 = p12.hz or 14;
        local Part = Instance.new("Part");
        Part.Name = "ChichineZoneJetFx";
        Part.Shape = Enum.PartType.Cylinder;
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CastShadow = false;
        Part.Material = Enum.Material.Neon;
        Part.Color = u1[v13];
        Part.Transparency = 0.15;
        Part.Size = Vector3.new(2, v17 * 2.2, v18 * 2.2);
        Part.CFrame = CFrame.new(v14, v15 - 4, v16) * CFrame.Angles(0, 0, 1.5707963267948966);
        Part.Parent = ClientDebris();
        TweenService:Create(Part, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(160, v17 * 2.6, v18 * 2.6),
            CFrame = CFrame.new(v14, v15 + 80 - 4, v16) * CFrame.Angles(0, 0, 1.5707963267948966)
        }):Play();
        task.delay(0.3, function() -- Line: 103
            -- upvalues: Part (copy), TweenService (ref)
            if not Part.Parent then
                return;
            end;

            local u19 = TweenService:Create(Part, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                Transparency = 1,
                Size = Vector3.new(160, 0.1, 0.1)
            });
            u19.Completed:Once(function() -- Line: 108
                -- upvalues: u19 (copy), Part (ref)
                u19:Destroy();
                pcall(function() -- Line: 110
                    -- upvalues: Part (ref)
                    Part:Destroy();
                end);
            end);
            u19:Play();
        end);
        local Part2 = Instance.new("Part");
        Part2.Anchored = true;
        Part2.CanCollide = false;
        Part2.CanQuery = false;
        Part2.CastShadow = false;
        Part2.Color = u1[v13];
        Part2.Transparency = 0.4;
        Part2.Size = Vector3.new(1.5, 0.3, 1.5);
        Part2.CFrame = CFrame.new(v14, v15 + 0.2, v16);
        Part2.Parent = ClientDebris();
        TweenService:Create(Part2, TweenInfo.new(0.3), {
            Transparency = 1,
            Size = Vector3.new(v17 * 4.5, 0.3, v18 * 4.5)
        }):Play();
        task.delay(0.35, function() -- Line: 127
            -- upvalues: Part2 (copy)
            pcall(function() -- Line: 128
                -- upvalues: Part2 (ref)
                Part2:Destroy();
            end);
        end);
        ImpactFx.sounds(v14, v15, v16);
    end
};