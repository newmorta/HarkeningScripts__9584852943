-- Ruta Original: ReplicatedStorage.Utilities.Events.Spotlight
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 10
    -- upvalues: u1 (copy)
    local v3 = setmetatable({}, u1);
    v3._colorSpeed = p2.colorSpeed or 0.12;
    v3._cameraOffset = p2.cameraOffset or CFrame.new(0, 20, -50);
    v3._range = p2.range or 30;
    v3._speed = p2.speed or 1.5;
    v3._ccSpeed = p2.ccSpeed;

    return v3;
end;

function u1.setup(p4, p5, p6, p7) -- Line: 23
    -- upvalues: ReplicatedStorage (copy)
    local Spotlight = ReplicatedStorage:FindFirstChild("Spotlight");

    if not (Spotlight and Spotlight:IsA("Model")) then
        warn("[Spotlight] Modèle \"Spotlight\" introuvable dans ReplicatedStorage");
        p5._spotlight = {
            entries = {},
            beams = {}
        };

        return;
    end;

    local v8 = p7:Add(Spotlight:Clone());

    for _, descendant in v8:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.Massless = true;
        end;
    end;

    v8.Parent = p6;
    local v9 = v8:GetPivot();
    local v10 = {};
    local v11 = {};

    for _, descendant in v8:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Name == "Part" then
            local v12 = descendant:FindFirstChildOfClass("Attachment");

            if v12 then
                local v13 = {
                    part = descendant,
                    partOffset = v9:ToObjectSpace(descendant.CFrame),
                    attachment = v12,
                    attachmentBasePosition = v12.Position,
                    randomOffset = math.random() * 100,
                    speed = math.random(80, 140) / 100
                };
                table.insert(v11, v13);
            end;
        elseif descendant:IsA("Beam") then
            local v14 = {
                beam = descendant,
                colorOffset = math.random()
            };
            table.insert(v10, v14);
        end;
    end;

    p5._spotlight = {
        model = v8,
        entries = v11,
        beams = v10
    };
end;

function u1.update(p15, p16, p17, p18) -- Line: 70
    local _spotlight = p16._spotlight;

    if not _spotlight then
        return;
    end;

    local model = _spotlight.model;

    if model then
        if model.Parent ~= p18 then
            model.Parent = p18;
        end;

        local v19 = CFrame.new(p18.CFrame.Position) * p15._cameraOffset;

        for _, v in _spotlight.entries do
            v.part.CFrame = v19 * v.partOffset;
            local v20 = (p17 + v.randomOffset) * p15._speed * v.speed;
            local attachment = v.attachment;
            local attachmentBasePosition = v.attachmentBasePosition;
            local v21 = math.sin(v20) * p15._range;
            local v22 = math.sin(v20 * 0.7) * p15._range;
            attachment.Position = attachmentBasePosition + Vector3.new(v21, 0, v22);
        end;
    end;

    for _, v in _spotlight.beams do
        if v.beam.Parent then
            v.beam.Color = ColorSequence.new(Color3.fromHSV((p17 * p15._colorSpeed + v.colorOffset) % 1, 1, 1));
        end;
    end;

    if p15._ccSpeed and (p16._cc and p16._cc.Parent) then
        p16._cc.TintColor = Color3.fromHSV(p17 * p15._ccSpeed % 1, 0.25, 1);
    end;
end;

return u1;