-- Ruta Original: StarterPlayer.StarterPlayerScripts.Tikfinity.TikfinitySystem
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local TikfinityAction = Remotes:WaitForChild("TikfinityAction");
local TikfinitySaveBinds = Remotes:WaitForChild("TikfinitySaveBinds");
local TikfinityLoadBinds = Remotes:WaitForChild("TikfinityLoadBinds");
local TikfinityModules = ReplicatedStorage:FindFirstChild("TikfinityModules");
local u1 = {
    Explode = 7,
    Chicken = 3,
    Jail = 5,
    Ragdoll = 3,
    Turtle = 5,
    Tiny = 5,
    Invisible = 5,
    Disco = 5,
    Blur = 5,
    Earthquake = 4
};
local u2 = false;
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};

local function getUI(p7) -- Line: 53
    -- upvalues: u6 (ref), CollectionService (copy), PlayerGui (copy)
    if not (u6[p7] and u6[p7].Parent) then
        for _, v in ipairs(CollectionService:GetTagged(p7)) do
            if v:IsDescendantOf(PlayerGui) then
                u6[p7] = v;

                return v;
            end;
        end;

        u6[p7] = nil;
    end;

    return u6[p7];
end;

local u8 = false;

local function updateBinds() -- Line: 72
    -- upvalues: u5 (ref), getUI (copy)
    u5 = {};
    local v9 = getUI("TikfinityScroll");

    if not v9 then
        return;
    end;

    for _, child in ipairs(v9:GetChildren()) do
        if child:IsA("Frame") and child:FindFirstChild("TextBox") then
            local v10 = child.TextBox.Text:upper();

            if v10 ~= "" then
                u5[v10] = child.Name;
            end;
        end;
    end;
end;

local function saveBindsToServer() -- Line: 87
    -- upvalues: getUI (copy), TikfinitySaveBinds (copy)
    local v11 = getUI("TikfinityScroll");

    if not v11 then
        return;
    end;

    local v12 = {};

    for _, child in ipairs(v11:GetChildren()) do
        if child:IsA("Frame") and child:FindFirstChild("TextBox") then
            local v13 = child.TextBox.Text:upper();

            if v13 ~= "" then
                v12[child.Name] = v13;
            end;
        end;
    end;

    TikfinitySaveBinds:FireServer(v12);
end;

local function loadBindsFromServer() -- Line: 103
    -- upvalues: getUI (copy), TikfinityLoadBinds (copy), updateBinds (copy)
    local v14 = getUI("TikfinityScroll");

    if not v14 then
        return;
    end;

    local success, result = pcall(function() -- Line: 107
        -- upvalues: TikfinityLoadBinds (ref)
        return TikfinityLoadBinds:InvokeServer();
    end);

    if not success or type(result) ~= "table" then
        return;
    end;

    for _, child in ipairs(v14:GetChildren()) do
        if child:IsA("Frame") and child:FindFirstChild("TextBox") then
            local v15 = result[child.Name];
            child.TextBox.Text = (not v15 or (type(v15) ~= "string" or not v15)) and "" or v15;
        end;
    end;

    updateBinds();
end;

local function connectScrollBinds() -- Line: 119
    -- upvalues: u8 (ref), getUI (copy), loadBindsFromServer (copy), updateBinds (copy), saveBindsToServer (copy)
    if u8 then
        return;
    end;

    local v16 = getUI("TikfinityScroll");

    if not v16 then
        return;
    end;

    u8 = true;
    loadBindsFromServer();

    for _, child in ipairs(v16:GetChildren()) do
        if child:IsA("Frame") and child:FindFirstChild("TextBox") then
            child.TextBox.FocusLost:Connect(function() -- Line: 131
                -- upvalues: updateBinds (ref), saveBindsToServer (ref)
                updateBinds();
                saveBindsToServer();
            end);
        end;
    end;
end;

local function processQueue(p17) -- Line: 143
    -- upvalues: u4 (copy), u3 (copy), u2 (ref), TikfinityModules (copy), LocalPlayer (copy), TikfinityAction (copy), u1 (copy)
    if u4[p17] then
        return;
    end;

    u4[p17] = true;

    while (u3[p17] or 0) > 0 do
        u3[p17] = u3[p17] - 1;

        if u2 then
            local u18 = TikfinityModules and TikfinityModules:FindFirstChild(p17);

            if u18 then
                task.spawn(function() -- Line: 154
                    -- upvalues: u18 (copy), LocalPlayer (ref)
                    local success, result = pcall(function() -- Line: 155
                        -- upvalues: u18 (ref), LocalPlayer (ref)
                        require(u18).Run(LocalPlayer);
                    end);

                    if not success then
                        warn("[Tikfinity] Erreur module local : " .. result);
                    end;
                end);
            else
                TikfinityAction:FireServer(p17);
            end;
        end;

        task.wait(u1[p17] or 3);
    end;

    u4[p17] = false;
end;

UserInputService.InputBegan:Connect(function(p19, p20) -- Line: 175
    -- upvalues: u2 (ref), u5 (ref), u3 (copy), processQueue (copy)
    if p20 or not u2 then
        return;
    end;

    local v21 = p19.UserInputType == Enum.UserInputType.Keyboard and u5[p19.KeyCode.Name:upper()];

    if v21 then
        u3[v21] = (u3[v21] or 0) + 1;
        task.spawn(processQueue, v21);
    end;
end);

local function setupToggle(u22) -- Line: 190
    -- upvalues: u2 (ref)
    u22.MouseButton1Click:Connect(function() -- Line: 191
        -- upvalues: u2 (ref), u22 (copy)
        u2 = not u2;
        u22.BackgroundColor3 = u2 and Color3.fromRGB(85, 255, 127) or Color3.fromRGB(255, 85, 85);
        u22.Text = u2 and "Tikfinity : ON" or "Tikfinity : OFF";
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("TikfinityToggle")) do
    v.MouseButton1Click:Connect(function() -- Line: 191
        -- upvalues: u2 (ref), v (copy)
        u2 = not u2;
        v.BackgroundColor3 = u2 and Color3.fromRGB(85, 255, 127) or Color3.fromRGB(255, 85, 85);
        v.Text = u2 and "Tikfinity : ON" or "Tikfinity : OFF";
    end);
end;

CollectionService:GetInstanceAddedSignal("TikfinityToggle"):Connect(setupToggle);

local function onCloseBtnAdded(p23) -- Line: 207
    -- upvalues: getUI (copy), ClientState (copy)
    p23.MouseButton1Click:Connect(function() -- Line: 208
        -- upvalues: getUI (ref), ClientState (ref)
        local v24 = getUI("TikfinityModal");

        if v24 and ClientState.ActiveModal == v24 then
            ClientState:CloseCurrentModal();
        end;
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("TikfinityCloseBtn")) do
    v.MouseButton1Click:Connect(function() -- Line: 208
        -- upvalues: getUI (copy), ClientState (copy)
        local v25 = getUI("TikfinityModal");

        if v25 and ClientState.ActiveModal == v25 then
            ClientState:CloseCurrentModal();
        end;
    end);
end;

CollectionService:GetInstanceAddedSignal("TikfinityCloseBtn"):Connect(onCloseBtnAdded);
task.spawn(function() -- Line: 223
    -- upvalues: connectScrollBinds (copy)
    task.wait(2);
    connectScrollBinds();
end);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 228
    -- upvalues: u6 (ref), u8 (ref), connectScrollBinds (copy)
    u6 = {};
    u8 = false;
    task.wait(1);
    connectScrollBinds();
end);