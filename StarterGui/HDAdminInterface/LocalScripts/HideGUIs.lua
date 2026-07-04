-- Ruta Original: StarterGui.HDAdminInterface.LocalScripts.HideGUIs
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local v1 = {
    Notices = true
};

for _, child in pairs(script.Parent.Parent:GetChildren()) do
    if child:IsA("Frame") then
        if v1[child.Name] then
            child.Visible = true;
        else
            child.Visible = false;
        end;
    elseif child:IsA("Folder") then
        for _, child2 in pairs(child:GetChildren()) do
            if child2:IsA("Frame") then
                child2.Visible = false;
            end;
        end;
    end;
end;