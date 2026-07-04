-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.ChichineBossRoom.AttacksClient.BoulderRain
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ClientDebris = require(script.Parent.ClientDebris);
local ImpactFx = require(script.Parent.ImpactFx);
local u1 = {};
local u2 = {};

local function removeBoulder(u3) -- Line: 13
    -- upvalues: u1 (copy)
    local v4 = table.find(u1, u3);

    if v4 then
        table.remove(u1, v4);
    end;

    pcall(function() -- Line: 16
        -- upvalues: u3 (copy)
        u3:Destroy();
    end);
end;

local function getBallPos(p5) -- Line: 19
    if p5:IsA("BasePart") then
        return p5.Position;
    end;

    if not p5:IsA("Model") then
        return nil;
    end;

    if p5.PrimaryPart then
        return p5.PrimaryPart.Position;
    end;

    return p5:GetPivot().Position;
end;

return {
    warn = function(p6) -- Line: 32, Name: warn
        -- upvalues: ClientDebris (copy), u2 (copy), TweenService (copy)
        local v7 = p6.x or 0;
        local v8 = p6.groundY or 0;
        local v9 = p6.z or 0;
        local v10 = p6.warnSec or 1.5;
        local v11 = p6.radius or 5;
        local Part = Instance.new("Part");
        Part.Name = "ChichineBoulderWarnDisc";
        Part.Shape = Enum.PartType.Cylinder;
        Part.Size = Vector3.new(0.3, v11 * 10, v11 * 10);
        Part.CFrame = CFrame.new(v7, v8 + 0.15, v9) * CFrame.Angles(0, 0, 1.5707963267948966);
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CastShadow = false;
        Part.Material = Enum.Material.Neon;
        Part.Color = Color3.fromRGB(255, 80, 0);
        Part.Transparency = 0.35;
        Part.Parent = ClientDebris();
        table.insert(u2, Part);
        task.spawn(function() -- Line: 55
            -- upvalues: Part (copy), TweenService (ref)
            while Part and Part.Parent do
                TweenService:Create(Part, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {
                    Transparency = 0.65
                }):Play();
                task.wait(0.62);
            end;
        end);
        task.delay(math.max(0, v10 - 0.2), function() -- Line: 65
            -- upvalues: Part (copy), TweenService (ref), u2 (ref)
            if not Part.Parent then
                return;
            end;

            local u12 = TweenService:Create(Part, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Transparency = 1
            });
            u12.Completed:Once(function() -- Line: 70
                -- upvalues: u12 (copy), u2 (ref), Part (ref)
                u12:Destroy();
                local v13 = table.find(u2, Part);

                if v13 then
                    table.remove(u2, v13);
                end;

                pcall(function() -- Line: 74
                    -- upvalues: Part (ref)
                    Part:Destroy();
                end);
            end);
            u12:Play();
        end);
    end,

    spawn = function(p14) -- Line: 80, Name: spawn
        -- upvalues: ReplicatedStorage (copy), ClientDebris (copy), u1 (copy), RunService (copy), Players (copy), ImpactFx (copy), removeBoulder (copy)
        local u15 = ReplicatedStorage:FindFirstChild("AdminAbuse") and ReplicatedStorage.AdminAbuse:FindFirstChild("ChichineBossRoom") and ReplicatedStorage.AdminAbuse.ChichineBossRoom:FindFirstChild("Assets") and u15:FindFirstChild("KillBall");

        if not u15 then
            return;
        end;

        local success, result = pcall(function() -- Line: 87
            -- upvalues: u15 (copy)
            return u15:Clone();
        end);

        if not (success and result) then
            return;
        end;

        local v16 = p14.diameter or 6;

        if result:IsA("BasePart") then
            result.Size = Vector3.new(v16, v16, v16);
            result.CFrame = CFrame.new(p14.x or 0, p14.y or 0, p14.z or 0) * CFrame.Angles(1.5707963267948966, 0, 0);
            result.CanCollide = false;
            result.CanTouch = false;
            result.Anchored = true;
            result.CastShadow = false;
        elseif result:IsA("Model") then
            local v17 = result:GetExtentsSize();
            local v18 = math.max(v17.X, v17.Y, v17.Z);

            if v18 > 0 then
                result:ScaleTo(v16 / v18);
            end;

            result:PivotTo(CFrame.new(p14.x or 0, p14.y or 0, p14.z or 0));

            for _, descendant in result:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.CanCollide = false;
                    descendant.CanTouch = false;
                    descendant.Anchored = true;
                    descendant.CastShadow = false;
                end;
            end;
        end;

        result.Parent = ClientDebris();
        table.insert(u1, result);
        local u19;

        if result:IsA("BasePart") then
            u19 = result.CFrame;
        else
            u19 = result:GetPivot();
        end;

        local v20 = math.random() * 3.141592653589793 * 2;
        local v21 = math.random() * 6 + 2;
        local v22 = (p14.fallSpeed or 5) * 2;
        local v23 = math.cos(v20) * v21;
        local v24 = math.sin(v20) * v21;
        local u25 = Vector3.new(v23, -v22, v24);
        local Gravity = workspace.Gravity;
        local u26 = p14.damage or 50;
        local u27 = false;
        local u28 = p14.groundY or 0;
        local u29 = (p14.diameter or 6) * 0.5;
        local u30 = u29 + 2;
        local u31 = 0;
        local u32 = false;
        local u33 = nil;
        u33 = RunService.Heartbeat:Connect(function(p34) -- Line: 145
            -- upvalues: u32 (ref), result (copy), u33 (ref), u31 (ref), u25 (copy), Gravity (copy), u19 (copy), u27 (ref), Players (ref), u30 (copy), u26 (copy), u29 (copy), u28 (copy), ImpactFx (ref), removeBoulder (ref)
            if u32 or not result.Parent then
                u33:Disconnect();

                return;
            end;

            u31 = u31 + p34;
            local v35 = Vector3.new(u25.X * u31, u25.Y * u31 - 0.5 * Gravity * u31 * u31, u25.Z * u31);

            if result:IsA("BasePart") then
                result.CFrame = u19 + v35;
            elseif result:IsA("Model") then
                result:PivotTo(u19 + v35);
            end;

            local v36 = result;
            local v37;

            if v36:IsA("BasePart") then
                v37 = v36.Position;
            elseif v36:IsA("Model") then
                if v36.PrimaryPart then
                    v37 = v36.PrimaryPart.Position;
                else
                    v37 = v36:GetPivot().Position;
                end;
            else
                v37 = nil;
            end;

            if not v37 then
                return;
            end;

            if not u27 then
                local Character = Players.LocalPlayer.Character;
                local v38;

                if Character then
                    v38 = Character:FindFirstChild("HumanoidRootPart");
                else
                    v38 = Character;
                end;

                if v38 then
                    local v39 = v37.X - v38.Position.X;
                    local v40 = v37.Y - v38.Position.Y;
                    local v41 = v37.Z - v38.Position.Z;

                    if v39 * v39 + v40 * v40 + v41 * v41 <= u30 * u30 then
                        u27 = true;
                        local v42 = Character:FindFirstChildOfClass("Humanoid");

                        if v42 and v42.Health > 0 then
                            v42:TakeDamage(u26);
                        end;
                    end;
                end;
            end;

            if v37.Y - u29 <= u28 + 0.5 then
                u32 = true;
                u33:Disconnect();
                ImpactFx.explosion(v37.X, u28, v37.Z, u29 * 6);
                removeBoulder(result);
            end;
        end);
        local v43 = p14.lifeMin or 4;
        local v44 = p14.lifeMax or 9;
        local v45 = v43 + math.random() * (v44 - v43);
        task.delay(v45, function() -- Line: 198
            -- upvalues: u33 (ref), removeBoulder (ref), result (copy)
            u33:Disconnect();
            removeBoulder(result);
        end);
    end,

    cleanup = function() -- Line: 204, Name: cleanup
        -- upvalues: u1 (copy), u2 (copy)
        for _, v in u1 do
            pcall(function() -- Line: 206
                -- upvalues: v (copy)
                v:Destroy();
            end);
        end;

        table.clear(u1);

        for _, v in u2 do
            pcall(function() -- Line: 210
                -- upvalues: v (copy)
                v:Destroy();
            end);
        end;

        table.clear(u2);
    end
};