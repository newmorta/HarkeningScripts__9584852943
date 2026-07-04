-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.ChichineBossRoom.AttacksClient.ClientDebris
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

return function() -- Line: 7
    local v1 = workspace:FindFirstChild("AdminAbuseMaps") and v1:FindFirstChild("ChichineBossRoom");

    if not v1 then
        return workspace;
    end;

    local Debris = v1:FindFirstChild("Debris");

    if Debris and Debris:IsA("Folder") then
        return Debris;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "Debris";
    Folder.Parent = v1;

    return Folder;
end;