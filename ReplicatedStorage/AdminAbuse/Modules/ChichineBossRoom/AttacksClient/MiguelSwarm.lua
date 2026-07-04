-- Ruta Original: ReplicatedStorage.AdminAbuse.Modules.ChichineBossRoom.AttacksClient.MiguelSwarm
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
local u1 = TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u2 = {};
local u3 = false;

local function tweenOutBillboard(p4) -- Line: 12
    -- upvalues: TweenService (copy), u1 (copy)
    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("BillboardGui") then
            for _, child in descendant:GetChildren() do
                if child:IsA("TextLabel") then
                    TweenService:Create(child, u1, {
                        TextTransparency = 1,
                        TextStrokeTransparency = 1
                    }):Play();
                elseif child:IsA("ImageLabel") then
                    TweenService:Create(child, u1, {
                        ImageTransparency = 1
                    }):Play();
                elseif child:IsA("Frame") then
                    TweenService:Create(child, u1, {
                        BackgroundTransparency = 1
                    }):Play();
                end;
            end;
        end;
    end;
end;

local function isMiguelNpc(p5) -- Line: 31
    if p5:IsA("Model") then
        return p5:GetAttribute("ArchetypeId") == "Miguel" and true or p5.Name:sub(1, 7) == "Miguel_";
    end;

    return false;
end;

local function watchNpc(u6) -- Line: 38
    -- upvalues: tweenOutBillboard (copy)
    local v7;

    if u6:IsA("Model") then
        v7 = u6:GetAttribute("ArchetypeId") == "Miguel" and true or u6.Name:sub(1, 7) == "Miguel_";
    else
        v7 = false;
    end;

    if not v7 then
        return;
    end;

    local v8 = u6:FindFirstChildOfClass("Humanoid");

    if not v8 then
        return;
    end;

    v8.Died:Once(function() -- Line: 43
        -- upvalues: u6 (copy), tweenOutBillboard (ref)
        if u6.Parent then
            tweenOutBillboard(u6);
        end;
    end);
end;

return {
    init = function() -- Line: 52, Name: init
        -- upvalues: u3 (ref), CollectionService (copy), watchNpc (copy), u2 (copy)
        if u3 then
            return;
        end;

        u3 = true;

        for _, v in CollectionService:GetTagged("AABossNpc") do
            task.spawn(watchNpc, v);
        end;

        local v10 = CollectionService:GetInstanceAddedSignal("AABossNpc"):Connect(function(p9) -- Line: 60
            -- upvalues: watchNpc (ref)
            task.spawn(watchNpc, p9);
        end);
        table.insert(u2, v10);
    end,

    cleanup = function() -- Line: 66, Name: cleanup
        -- upvalues: u3 (ref), u2 (copy)
        u3 = false;

        for _, v in u2 do
            pcall(function() -- Line: 69
                -- upvalues: v (copy)
                v:Disconnect();
            end);
        end;

        table.clear(u2);
    end
};