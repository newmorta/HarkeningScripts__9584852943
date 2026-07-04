-- Ruta Original: StarterPlayer.StarterPlayerScripts.Pièges.World2.NoJump
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local JumpHeightManager = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("JumpHeightManager"));
local u1 = {};

local function addPart(p2) -- Line: 13
    -- upvalues: u1 (copy)
    if p2:IsA("BasePart") then
        table.insert(u1, p2);
    end;
end;

local function removePart(p3) -- Line: 19
    -- upvalues: u1 (copy)
    local v4 = table.find(u1, p3);

    if v4 then
        table.remove(u1, v4);
    end;
end;

local function setupModel(p5) -- Line: 26
    -- upvalues: u1 (copy), addPart (copy), removePart (copy)
    for _, descendant in ipairs(p5:GetDescendants()) do
        if descendant:IsA("BasePart") then
            table.insert(u1, descendant);
        end;
    end;

    p5.DescendantAdded:Connect(addPart);
    p5.DescendantRemoving:Connect(removePart);
end;

for _, v in ipairs(CollectionService:GetTagged("NoJump")) do
    setupModel(v);
end;

CollectionService:GetInstanceAddedSignal("NoJump"):Connect(setupModel);
local LocalPlayer = Players.LocalPlayer;
local u6 = nil;
local u7 = nil;
local u8 = nil;
LocalPlayer.CharacterAdded:Connect(function(p9) -- Line: 45, Name: onCharacterAdded
    -- upvalues: u6 (ref), u7 (ref), u8 (ref), JumpHeightManager (copy)
    u6 = p9;
    u7 = p9:WaitForChild("Humanoid");
    u8 = p9:WaitForChild("HumanoidRootPart");
    JumpHeightManager.setHumanoid(u7);
    JumpHeightManager.release("NoJump");
end);

if LocalPlayer.Character then
    local Character = LocalPlayer.Character;
    u6 = Character;
    u7 = Character:WaitForChild("Humanoid");
    u8 = Character:WaitForChild("HumanoidRootPart");
    JumpHeightManager.setHumanoid(u7);
    JumpHeightManager.release("NoJump");
end;

local function isPointInsidePart(p10, p11) -- Line: 59
    local v12 = p11.CFrame:PointToObjectSpace(p10);
    local v13 = p11.Size / 2;
    local v14;

    if math.abs(v12.X) <= v13.X and math.abs(v12.Y) <= v13.Y then
        v14 = math.abs(v12.Z) <= v13.Z;
    else
        v14 = false;
    end;

    return v14;
end;

RunService.RenderStepped:Connect(function() -- Line: 67
    -- upvalues: u6 (ref), u7 (ref), u8 (ref), u1 (copy), JumpHeightManager (copy)
    if not (u6 and (u7 and u8)) then
        return;
    end;

    if not u8.Parent then
        return;
    end;

    local v15 = false;

    for _, v in ipairs(u1) do
        if v and v.Parent then
            local v16 = v.CFrame:PointToObjectSpace(u8.Position);
            local v17 = v.Size / 2;
            local v18;

            if math.abs(v16.X) <= v17.X and math.abs(v16.Y) <= v17.Y then
                v18 = math.abs(v16.Z) <= v17.Z;
            else
                v18 = false;
            end;

            if v18 then
                v15 = true;
                break;
            end;
        end;
    end;

    if v15 then
        JumpHeightManager.set("NoJump", 0, 50);

        return;
    end;

    JumpHeightManager.release("NoJump");
end);