-- Ruta Original: StarterPlayer.StarterPlayerScripts.FloatController
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local LocalPlayer = Players.LocalPlayer;
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = true;
local u6 = nil;
local u7 = nil;

local function getFloatingObjects(p8) -- Line: 36
    -- upvalues: getFloatingObjects (copy)
    local v9 = {};

    for _, child in ipairs(p8:GetChildren()) do
        if child:IsA("Model") then
            table.insert(v9, child);
        elseif child:IsA("BasePart") then
            table.insert(v9, child);
        elseif child:IsA("Folder") then
            for _, v in ipairs(getFloatingObjects(child)) do
                table.insert(v9, v);
            end;
        end;
    end;

    return v9;
end;

local function getInitialCFrame(p10) -- Line: 54
    -- upvalues: u1 (copy)
    local v11 = u1[p10];

    if v11 then
        return v11;
    end;

    if p10:IsA("Model") then
        v11 = p10:GetPivot();
    elseif p10:IsA("BasePart") then
        v11 = p10.CFrame;
    end;

    if v11 then
        u1[p10] = v11;
    end;

    return v11;
end;

local function cleanupCacheFor(p12) -- Line: 73
    -- upvalues: u1 (copy), u2 (copy), u4 (copy)
    u1[p12] = nil;
    u2[p12] = nil;
    u4[p12] = nil;
end;

local function getCellKey(p13, p14) -- Line: 80
    return tostring(p13) .. "_" .. tostring(p14);
end;

local function buildSpatialGrid(p15) -- Line: 85
    -- upvalues: u3 (copy), getFloatingObjects (copy), u1 (copy), u2 (copy), u4 (copy)
    table.clear(u3);
    local v16 = getFloatingObjects(p15);
    local v17 = {};

    for _, v in ipairs(v16) do
        v17[v] = true;
        local v18 = u1[v];

        if not v18 then
            if v:IsA("Model") then
                v18 = v:GetPivot();
            elseif v:IsA("BasePart") then
                v18 = v.CFrame;
            end;

            if v18 then
                u1[v] = v18;
            end;
        end;

        if v18 then
            local Position = v18.Position;
            local v19 = math.floor(Position.X / 200);
            local v20 = math.floor(Position.Z / 200);
            local v21 = tostring(v19) .. "_" .. tostring(v20);
            local v22 = u3[v21];

            if not v22 then
                v22 = {};
                u3[v21] = v22;
            end;

            table.insert(v22, v);
        end;
    end;

    for i in pairs(u1) do
        if not v17[i] then
            u1[i] = nil;
            u2[i] = nil;
            u4[i] = nil;
        end;
    end;
end;

local function setupFolderListeners(p23) -- Line: 117
    -- upvalues: u6 (ref), u7 (ref), u5 (ref), u1 (copy), u2 (copy), u4 (copy)
    if u6 then
        u6:Disconnect();
    end;

    if u7 then
        u7:Disconnect();
    end;

    u6 = p23.DescendantAdded:Connect(function(p24) -- Line: 121
        -- upvalues: u5 (ref)
        u5 = true;
    end);
    u7 = p23.DescendantRemoving:Connect(function(p25) -- Line: 124
        -- upvalues: u1 (ref), u2 (ref), u4 (ref), u5 (ref)
        u1[p25] = nil;
        u2[p25] = nil;
        u4[p25] = nil;
        u5 = true;
    end);
end;

RunService.RenderStepped:Connect(function(p26) -- Line: 131
    -- upvalues: Workspace (copy), u6 (ref), u7 (ref), u2 (copy), u1 (copy), u3 (copy), u4 (copy), u5 (ref), setupFolderListeners (copy), LocalPlayer (copy), buildSpatialGrid (copy)
    local FloatFolder = Workspace:FindFirstChild("FloatFolder");

    if not (FloatFolder and FloatFolder:IsA("Folder")) then
        if u6 then
            u6:Disconnect();
            u6 = nil;
        end;

        if u7 then
            u7:Disconnect();
            u7 = nil;
        end;

        if next(u2) ~= nil or (next(u1) ~= nil or (next(u3) ~= nil or next(u4) ~= nil)) then
            table.clear(u2);
            table.clear(u1);
            table.clear(u3);
            table.clear(u4);
            u5 = true;
        end;

        return;
    end;

    if not u6 then
        setupFolderListeners(FloatFolder);
        u5 = true;
    end;

    local v27 = LocalPlayer.Character and v27:FindFirstChild("HumanoidRootPart");

    if not v27 then
        return;
    end;

    local Position = v27.Position;

    if u5 then
        buildSpatialGrid(FloatFolder);
        u5 = false;
    end;

    local v28 = math.floor(Position.X / 200);
    local v29 = math.floor(Position.Z / 200);
    local v30 = {};

    for i = -1, 1 do
        for i2 = -1, 1 do
            local v31 = u3[tostring(v28 + i) .. "_" .. tostring(v29 + i2)];

            if v31 then
                for _, v in ipairs(v31) do
                    local v32 = u1[v];

                    if not v32 then
                        if v:IsA("Model") then
                            v32 = v:GetPivot();
                        elseif v:IsA("BasePart") then
                            v32 = v.CFrame;
                        end;

                        if v32 then
                            u1[v] = v32;
                        end;
                    end;

                    if v32 then
                        local v33 = Position - v32.Position;

                        if v33.X * v33.X + v33.Y * v33.Y + v33.Z * v33.Z <= 40000 then
                            v30[v] = true;
                            u4[v] = true;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local v34 = os.clock();

    for i, _ in pairs(u4) do
        if i.Parent then
            local v35 = u2[i];

            if not v35 then
                local v36 = u1[i];

                if not v36 then
                    if i:IsA("Model") then
                        v36 = i:GetPivot();
                    elseif i:IsA("BasePart") then
                        v36 = i.CFrame;
                    end;

                    if v36 then
                        u1[i] = v36;
                    end;
                end;

                if v36 then
                    v35 = {
                        weight = 0,
                        initialCF = v36,
                        phaseOffset = math.random() * 3.141592653589793 * 2
                    };
                    u2[i] = v35;
                    i.Destroying:Connect(function() -- Line: 206
                        -- upvalues: i (copy), u1 (ref), u2 (ref), u4 (ref)
                        local v37 = i;
                        u1[v37] = nil;
                        u2[v37] = nil;
                        u4[v37] = nil;
                    end);
                end;
            end;

            if v35 then
                local v38 = v30[i] and 1 or 0;

                if v35.weight ~= v38 then
                    local v39 = v38 - v35.weight;
                    local v40 = p26 * 2;

                    if math.abs(v39) < v40 then
                        v35.weight = v38;
                    else
                        v35.weight = v35.weight + math.sign(v39) * v40;
                    end;
                end;

                if v35.weight > 0 then
                    local v41 = v34 + v35.phaseOffset;
                    local v42 = math.sin(v41 * 0.6) * 3 * v35.weight;
                    local v43 = math.cos(v41 * 0.4) * 0.10471975511965978 * v35.weight;
                    local v44 = math.sin(v41 * 0.3) * 0.10471975511965978 * v35.weight;
                    local v45 = v35.initialCF * CFrame.new(0, v42, 0) * CFrame.fromEulerAnglesXYZ(v43, 0, v44);

                    if i:IsA("Model") then
                        i:PivotTo(v45);
                    elseif i:IsA("BasePart") then
                        i.CFrame = v45;
                    end;
                else
                    if i:IsA("Model") then
                        i:PivotTo(v35.initialCF);
                    elseif i:IsA("BasePart") then
                        i.CFrame = v35.initialCF;
                    end;

                    u4[i] = nil;
                end;
            end;
        else
            u1[i] = nil;
            u2[i] = nil;
            u4[i] = nil;
        end;
    end;
end);