-- Ruta Original: ReplicatedStorage.UISystems.BoomboxShopPreview
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local BoomboxShopPreview = game:GetService("ReplicatedStorage").Assets.BoomboxShopPreview;

return {
    mount = function(p1) -- Line: 8, Name: mount
        -- upvalues: BoomboxShopPreview (copy), RunService (copy)
        if p1:GetAttribute("Mounted") then
            return;
        end;

        p1:SetAttribute("Mounted", true);
        local u2 = BoomboxShopPreview:Clone();

        for _, descendant in u2:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
            end;
        end;

        u2:PivotTo(CFrame.new());
        u2.Parent = p1;
        local v3, v4 = u2:GetBoundingBox();
        local Position = v3.Position;
        local v5 = math.max(v4.X, v4.Y, v4.Z) * 1.5;
        local Camera = Instance.new("Camera");
        Camera.FieldOfView = 50;
        Camera.CFrame = CFrame.lookAt(Position + Vector3.new(0, v4.Y * 0.1, v5), Position);
        Camera.Parent = p1;
        p1.CurrentCamera = Camera;
        local u6 = RunService.Heartbeat:Connect(function() -- Line: 33
            -- upvalues: u2 (copy)
            u2:PivotTo(CFrame.Angles(0, os.clock(), 0));
        end);
        p1.Destroying:Once(function() -- Line: 37
            -- upvalues: u6 (copy)
            u6:Disconnect();
        end);
    end
};