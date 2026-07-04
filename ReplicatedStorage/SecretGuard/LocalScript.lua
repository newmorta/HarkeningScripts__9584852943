-- Ruta Original: ReplicatedStorage.SecretGuard.LocalScript
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Parent = script.Parent;
local v1 = nil;

for _, v in ipairs(CollectionService:GetTagged("SecretTalk")) do
    if v:IsDescendantOf(Parent) then
        v1 = v;
        break;
    end;
end;

local v2 = v1 or Parent:FindFirstChild("SecretTalk", true);

if not v2 then
    task.wait(5);
    Parent:Destroy();

    return;
end;

v2.Text = "";

for i = 1, 56 do
    v2.Text = string.sub("Hey mate ! Don\'t cheat at this game, alright? Have fun !", 1, i);
    task.wait(0.017857142857142856);
end;

task.wait(4);
Parent:Destroy();