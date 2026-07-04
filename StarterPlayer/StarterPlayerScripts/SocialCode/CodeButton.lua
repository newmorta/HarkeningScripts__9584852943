-- Ruta Original: StarterPlayer.StarterPlayerScripts.SocialCode.CodeButton
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Icon = require(ReplicatedStorage:WaitForChild("TopbarPlus"):WaitForChild("Icon"));
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");

local function getGui() -- Line: 18
    -- upvalues: CollectionService (copy), PlayerGui (copy)
    for _, v in ipairs(CollectionService:GetTagged("SocialVerifyGui")) do
        if v:IsA("ScreenGui") and v:IsDescendantOf(PlayerGui) then
            return v;
        end;
    end;

    return nil;
end;

local function setGuiEnabled(p1) -- Line: 27
    -- upvalues: getGui (copy)
    local v2 = getGui();

    if v2 then
        v2.Enabled = p1;
    end;
end;

local u3 = Icon.new():setName("CodeButton"):setLabel("Code");
u3.selected:Connect(function() -- Line: 42
    -- upvalues: getGui (copy)
    local v4 = getGui();

    if v4 then
        v4.Enabled = true;
    end;
end);
u3.deselected:Connect(function() -- Line: 46
    -- upvalues: getGui (copy)
    local v5 = getGui();

    if v5 then
        v5.Enabled = false;
    end;
end);

local function connectCloseButton(p6) -- Line: 54
    -- upvalues: PlayerGui (copy), getGui (copy), u3 (copy)
    if p6:IsA("GuiButton") and p6:IsDescendantOf(PlayerGui) then
        p6.Activated:Connect(function() -- Line: 56
            -- upvalues: getGui (ref), u3 (ref)
            local v7 = getGui();

            if v7 then
                v7.Enabled = false;
            end;

            u3:deselect();
        end);
    end;
end;

for _, v in ipairs(CollectionService:GetTagged("SocialVerifyButton")) do
    if v:IsA("GuiButton") and v:IsDescendantOf(PlayerGui) then
        v.Activated:Connect(function() -- Line: 56
            -- upvalues: getGui (copy), u3 (copy)
            local v8 = getGui();

            if v8 then
                v8.Enabled = false;
            end;

            u3:deselect();
        end);
    end;
end;

CollectionService:GetInstanceAddedSignal("SocialVerifyButton"):Connect(connectCloseButton);
task.defer(function() -- Line: 70
    -- upvalues: getGui (copy)
    local v9 = getGui();

    if v9 then
        v9.Enabled = false;
    end;
end);