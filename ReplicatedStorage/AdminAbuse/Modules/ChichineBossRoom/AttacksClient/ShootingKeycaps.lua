-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.ChichineBossRoom.AttacksClient.ShootingKeycaps
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ClientDebris = require(script.Parent.ClientDebris);
local ImpactFx = require(script.Parent.ImpactFx);
local ChichineConfig = require(script.Parent.Parent.ChichineConfig);
local u1 = (-1 / 0);
local u2 = {};
local u3 = {};
local u4 = Color3.fromRGB(255, 100, 30);

local function removeFromTable(p5, p6) -- Line: 18
    local v7 = table.find(p5, p6);

    if v7 then
        table.remove(p5, v7);
    end;
end;

return {
    spawn = function(p8) -- Line: 25, Name: spawn
        -- upvalues: ReplicatedStorage (copy), ClientDebris (copy), u2 (copy), u4 (copy), u3 (copy), TweenService (copy), ImpactFx (copy), ChichineConfig (copy), Players (copy), u1 (ref)
        local u9 = ReplicatedStorage:FindFirstChild("AdminAbuse") and u9:FindFirstChild("ChichineBossRoom") and u9.Assets:FindFirstChild("FallingKeycap");

        if not u9 then
            warn("[ChichineBossRoom] ShootingKeycaps: FallingKeycap template not found in RS.AdminAbuse.ChichineBossRoom");

            return;
        end;

        local success, result = pcall(function() -- Line: 34
            -- upvalues: u9 (copy)
            return u9:Clone();
        end);

        if not (success and result) then
            return;
        end;

        result.Anchored = true;
        result.CanCollide = false;
        result.CanQuery = false;
        result.CastShadow = false;
        local u10 = p8.lx or 0;
        local u11 = p8.ly or 0;
        local u12 = p8.lz or 0;
        local v13 = p8.t or 1.5;
        local v14 = Vector3.new(p8.sx or 0, p8.sy or 0, p8.sz or 0);
        local v15 = Vector3.new(u10, u11, u12);
        local Unit = (v15 - v14).Unit;
        local FrontFace = result:FindFirstChild("FrontFace");
        local v16 = FrontFace and FrontFace.CFrame.LookVector or Vector3.new(0, 0, -1);
        local v17 = v16:Cross(Unit);
        local v18;

        if v17.Magnitude > 0.00001 then
            local v19 = v16:Dot(Unit);
            local v20 = math.clamp(v19, -1, 1);
            local v21 = math.acos(v20);
            v18 = CFrame.new(v14) * CFrame.fromAxisAngle(v17.Unit, v21);
        elseif v16:Dot(Unit) < 0 then
            local v22 = math.abs(v16.Y) < 0.9 and Vector3.new(0, 1, 0) or Vector3.new(1, 0, 0);
            v18 = CFrame.new(v14) * CFrame.fromAxisAngle(v16:Cross(v22).Unit, 3.141592653589793);
        else
            v18 = CFrame.new(v14);
        end;

        result.CFrame = v18;
        local v23 = v18 + (v15 - v18.Position);
        result.Parent = ClientDebris();
        table.insert(u2, result);
        local Part = Instance.new("Part");
        Part.Name = "ChichineSKWarnDisc";
        Part.Shape = Enum.PartType.Cylinder;
        Part.Size = Vector3.new(0.05, 40, 40);
        Part.CFrame = CFrame.new(u10, u11 + 0.15, u12) * CFrame.Angles(0, 0, 1.5707963267948966);
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CastShadow = false;
        Part.Material = Enum.Material.Neon;
        Part.Color = u4;
        Part.Transparency = 0.35;
        Part.Parent = ClientDebris();
        table.insert(u3, Part);
        TweenService:Create(Part, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = Vector3.new(0.35, 40, 40)
        }):Play();
        local v24 = TweenService:Create(result, TweenInfo.new(v13, Enum.EasingStyle.Linear), {
            CFrame = v23
        });
        v24:Play();
        v24.Completed:Once(function() -- Line: 99
            -- upvalues: ImpactFx (ref), u10 (copy), u11 (copy), u12 (copy), u2 (ref), result (copy), ChichineConfig (ref), Players (ref), u1 (ref)
            ImpactFx.explosion(u10, u11, u12, 45);
            local v25 = u2;
            local v26 = table.find(v25, result);

            if v26 then
                table.remove(v25, v26);
            end;

            pcall(function() -- Line: 104
                -- upvalues: result (ref)
                result:Destroy();
            end);
            local ShootingKeycaps = ChichineConfig.ShootingKeycaps;
            local Character = Players.LocalPlayer.Character;
            local v27;

            if Character then
                v27 = Character:FindFirstChild("HumanoidRootPart");
            else
                v27 = Character;
            end;

            if not v27 then
                return;
            end;

            local v28 = ShootingKeycaps.landingRadius + 2;
            local v29 = v27.Position - Vector3.new(u10, u11, u12);

            if v29:Dot(v29) > v28 * v28 then
                return;
            end;

            local v30 = tick();

            if v30 - u1 < 1.5 then
                return;
            end;

            u1 = v30;
            local v31 = Character:FindFirstChildOfClass("Humanoid");

            if v31 and v31.Health > 0 then
                v31:TakeDamage(ShootingKeycaps.damage);
            end;
        end);
        task.delay(math.max(0, v13 - 0.15), function() -- Line: 124
            -- upvalues: Part (copy), TweenService (ref), u3 (ref)
            if not Part.Parent then
                return;
            end;

            local v32 = TweenService:Create(Part, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Transparency = 1
            });
            v32.Completed:Once(function() -- Line: 129
                -- upvalues: u3 (ref), Part (ref)
                local v33 = u3;
                local v34 = table.find(v33, Part);

                if v34 then
                    table.remove(v33, v34);
                end;

                pcall(function() -- Line: 131
                    -- upvalues: Part (ref)
                    Part:Destroy();
                end);
            end);
            v32:Play();
        end);
    end,

    impactFx = function(p35) -- Line: 137, Name: impactFx
        -- upvalues: ImpactFx (copy)
        ImpactFx.explosion(p35.x or 0, p35.y or 0, p35.z or 0, 45);
    end,

    cleanup = function() -- Line: 141, Name: cleanup
        -- upvalues: u2 (copy), u3 (copy)
        for _, v in u2 do
            pcall(function() -- Line: 143
                -- upvalues: v (copy)
                v:Destroy();
            end);
        end;

        for _, v in u3 do
            pcall(function() -- Line: 146
                -- upvalues: v (copy)
                v:Destroy();
            end);
        end;

        table.clear(u2);
        table.clear(u3);
    end
};