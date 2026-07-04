-- Ruta Original: StarterPlayer.StarterPlayerScripts.Pièges.World2.Stage10_Shapes
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local u1 = { "GreenSquare", "RedTriangle", "YellowCircle" };
local u2 = {
    GreenSquare = "GreenDoorKillPart",
    RedTriangle = "RedDoorKillPart",
    YellowCircle = "YellowDoorKillPart"
};
local LocalPlayer = game:GetService("Players").LocalPlayer;
local u3 = {};

local function pickRandomShape() -- Line: 21
    -- upvalues: u1 (copy)
    return u1[math.random(1, #u1)];
end;

local function updateIndicator(p4, p5) -- Line: 26
    local Indicator = p4:FindFirstChild("Indicator");

    if not Indicator then
        return;
    end;

    for _, child in ipairs(Indicator:GetChildren()) do
        if child.Name ~= "Frame" and (child.Name == "GreenSquare" or (child.Name == "RedTriangle" or child.Name == "YellowCircle")) then
            local v6 = child.Name == p5 and 0 or 1;

            if child:IsA("BasePart") then
                child.Transparency = v6;
            end;

            for _, descendant in ipairs(child:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.Transparency = v6;
                end;
            end;
        end;
    end;
end;

local function updateDoors(p7, p8) -- Line: 52
    -- upvalues: u2 (copy)
    local Doors = p7:FindFirstChild("Doors");

    if not Doors then
        return;
    end;

    local v9 = u2[p8];

    for _, child in ipairs(Doors:GetChildren()) do
        if child.Name == "GreenDoorKillPart" or (child.Name == "RedDoorKillPart" or child.Name == "YellowDoorKillPart") then
            local v10 = child.Name == v9;

            if child:IsA("BasePart") then
                child.CanCollide = not v10;
            end;

            for _, descendant in ipairs(child:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.CanCollide = not v10;
                end;
            end;
        end;
    end;
end;

local function applyRandomShape(p11) -- Line: 75
    -- upvalues: u1 (copy), updateIndicator (copy), updateDoors (copy)
    local v12 = u1[math.random(1, #u1)];
    updateIndicator(p11, v12);
    updateDoors(p11, v12);
end;

local function onSafeDoorTouched(u13) -- Line: 82
    -- upvalues: u3 (copy), u1 (copy), updateIndicator (copy), updateDoors (copy)
    if u3[u13] then
        return;
    end;

    u3[u13] = true;
    task.delay(2, function() -- Line: 86
        -- upvalues: u13 (copy), u1 (ref), updateIndicator (ref), updateDoors (ref), u3 (ref)
        local v14 = u13;
        local v15 = u1[math.random(1, #u1)];
        updateIndicator(v14, v15);
        updateDoors(v14, v15);
        u3[u13] = nil;
    end);
end;

local function connectDoorTouch(u16) -- Line: 93
    -- upvalues: LocalPlayer (copy), u3 (copy), u1 (copy), updateIndicator (copy), updateDoors (copy)
    local Doors = u16:FindFirstChild("Doors");

    if not Doors then
        return;
    end;

    for _, child in ipairs(Doors:GetChildren()) do
        if child.Name == "GreenDoorKillPart" or (child.Name == "RedDoorKillPart" or child.Name == "YellowDoorKillPart") then
            local v17 = {};

            if child:IsA("BasePart") then
                table.insert(v17, child);
            end;

            for _, descendant in ipairs(child:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    table.insert(v17, descendant);
                end;
            end;

            for _, v in ipairs(v17) do
                v.Touched:Connect(function(p18) -- Line: 110
                    -- upvalues: LocalPlayer (ref), v (copy), u16 (copy), u3 (ref), u1 (ref), updateIndicator (ref), updateDoors (ref)
                    if not p18.Parent then
                        return;
                    end;

                    local Character = LocalPlayer.Character;

                    if not Character or p18.Parent ~= Character then
                        return;
                    end;

                    if v.CanCollide == false then
                        local u19 = u16;

                        if u3[u19] then
                            return;
                        end;

                        u3[u19] = true;
                        task.delay(2, function() -- Line: 86
                            -- upvalues: u19 (copy), u1 (ref), updateIndicator (ref), updateDoors (ref), u3 (ref)
                            local v20 = u19;
                            local v21 = u1[math.random(1, #u1)];
                            updateIndicator(v20, v21);
                            updateDoors(v20, v21);
                            u3[u19] = nil;
                        end);
                    end;
                end);
            end;
        end;
    end;
end;

local function setupModel(u22) -- Line: 126
    -- upvalues: u1 (copy), updateIndicator (copy), updateDoors (copy), connectDoorTouch (copy), LocalPlayer (copy), u3 (copy)
    if not u22:IsA("Model") then
        return;
    end;

    local v23 = u1[math.random(1, #u1)];
    updateIndicator(u22, v23);
    updateDoors(u22, v23);
    connectDoorTouch(u22);
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 136
        -- upvalues: u3 (ref), u22 (copy), u1 (ref), updateIndicator (ref), updateDoors (ref)
        task.wait(0.1);
        u3[u22] = nil;
        local v24 = u22;
        local v25 = u1[math.random(1, #u1)];
        updateIndicator(v24, v25);
        updateDoors(v24, v25);
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("DoorWall")) do
    setupModel(v);
end;

CollectionService:GetInstanceAddedSignal("DoorWall"):Connect(setupModel);