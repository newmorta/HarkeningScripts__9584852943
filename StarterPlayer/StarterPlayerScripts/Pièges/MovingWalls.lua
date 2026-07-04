-- Ruta Original: StarterPlayer.StarterPlayerScripts.Pièges.MovingWalls
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local u1 = {
    Tag = "MovingWallModel",
    WallPrefix = "MovingWall",
    WallCount = 12,
    MoveDistance = -24,
    MoveAxis = Vector3.new(1, 0, 0),
    DelayBetweenWalls = 0.13,
    ReturnTime = 1.35,
    TweenTime = 0.2
};
local u2 = {};
local u3 = {};

local function getWallAlpha(p4) -- Line: 43
    if p4 < 0.2 then
        return p4 / 0.2;
    end;

    return p4 < 1.55 and 1 or (p4 >= 1.75 and 0 or 1 - (p4 - 0.2 - 1.35) / 0.2);
end;

local function setupModel(u5) -- Line: 59
    -- upvalues: u2 (copy), u3 (copy), setupModel (copy)
    if u2[u5] then
        return;
    end;

    local v6 = u5:GetAttribute("CycleStartTime");

    if v6 then
        local v7 = Vector3.new(1, 0, 0) * (u5:GetAttribute("MoveDistance") or -24);
        local v8 = {};

        for i = 1, 12 do
            local v9 = u5:FindFirstChild("MovingWall" .. i);

            if v9 and v9:IsA("BasePart") then
                local v10 = v9.CFrame:VectorToWorldSpace(v7);
                table.insert(v8, {
                    part = v9,
                    originCF = v9.CFrame,
                    offset = v10,
                    timeOffset = (i - 1) * 0.13
                });
            end;
        end;

        u2[u5] = {
            walls = v8,
            startTime = v6
        };

        return;
    end;

    if u3[u5] then
        return;
    end;

    local u11 = nil;
    u11 = u5:GetAttributeChangedSignal("CycleStartTime"):Connect(function() -- Line: 67
        -- upvalues: u3 (ref), u5 (copy), u11 (ref), setupModel (ref)
        u3[u5] = nil;

        if u11 then
            u11:Disconnect();
        end;

        setupModel(u5);
    end);
    u3[u5] = u11;
end;

local function cleanupModel(p12) -- Line: 102
    -- upvalues: u2 (copy), u3 (copy)
    u2[p12] = nil;
    local v13 = u3[p12];

    if v13 then
        v13:Disconnect();
        u3[p12] = nil;
    end;
end;

game:GetService("RunService").PreRender:Connect(function() -- Line: 115
    -- upvalues: u2 (copy), u1 (copy)
    local v14 = workspace:GetServerTimeNow();

    for _, v in u2 do
        for _, v2 in ipairs(v.walls) do
            if v2.part and v2.part.Parent then
                local v15 = (v14 - v.startTime - v2.timeOffset) % 3.1;

                if v15 < 0 then
                    v15 = v15 + 3.1;
                end;

                local v16;

                if v15 < u1.TweenTime then
                    v16 = v15 / u1.TweenTime;
                else
                    v16 = v15 < u1.TweenTime + u1.ReturnTime and 1 or (v15 >= u1.TweenTime * 2 + u1.ReturnTime and 0 or 1 - (v15 - u1.TweenTime - u1.ReturnTime) / u1.TweenTime);
                end;

                v2.part.CFrame = v2.originCF + v2.offset * v16;
            end;
        end;
    end;
end);

for _, v in ipairs(CollectionService:GetTagged("MovingWallModel")) do
    setupModel(v);
end;

CollectionService:GetInstanceAddedSignal("MovingWallModel"):Connect(function(p17) -- Line: 138
    -- upvalues: setupModel (copy)
    setupModel(p17);
end);
CollectionService:GetInstanceRemovedSignal("MovingWallModel"):Connect(function(p18) -- Line: 142
    -- upvalues: u2 (copy), u3 (copy)
    u2[p18] = nil;
    local v19 = u3[p18];

    if v19 then
        v19:Disconnect();
        u3[p18] = nil;
    end;
end);