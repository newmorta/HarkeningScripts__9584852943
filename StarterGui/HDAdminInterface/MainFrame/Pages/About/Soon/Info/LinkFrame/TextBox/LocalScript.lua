-- Ruta Original: StarterGui.HDAdminInterface.MainFrame.Pages.About.Soon.Info.LinkFrame.TextBox.LocalScript
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local PolicyService = game:GetService("PolicyService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local success, result = pcall(function() -- Line: 4
    -- upvalues: PolicyService (copy), LocalPlayer (copy)
    return PolicyService:GetPolicyInfoForPlayerAsync(LocalPlayer);
end);

if success and result then
    local v1 = { "X", "Discord", "YouTube" };
    local v2 = 0;

    for _, v in pairs(result.AllowedExternalLinkReferences) do
        if table.find(v1, v) then
            v2 = v2 + 1;
        end;
    end;

    if v2 < #v1 then
        script.Parent.Text = "See HD Admin\'s description (in Marketplace) for updates";
    end;
end;