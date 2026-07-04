-- Ruta Original: StarterPlayer.StarterPlayerScripts.Key.KeySystem v5
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local CollectionService = game:GetService("CollectionService");
local LocalPlayer = Players.LocalPlayer;
local SoundBank = SoundService:WaitForChild("SoundBank", 10);
local u1 = LocalPlayer:GetAttribute("KeyVolume") or 1;
local u2 = LocalPlayer:GetAttribute("EquippedSoundPack") or "Default";
local u3 = Random.new();
local u4 = table.create(40);
local u5 = {
    MusicalKey = {
        PRESS_DEPTH = 1.4
    },
    MusicalKey2 = {
        PRESS_DEPTH = 1
    }
};
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = { "rbxassetid://123413227426138" };
local u10 = 1;

for i = 1, 40 do
    local Sound = Instance.new("Sound");
    Sound.RollOffMaxDistance = 100;
    Sound.RollOffMinDistance = 10;
    u4[i] = Sound;
end;

LocalPlayer:GetAttributeChangedSignal("KeyVolume"):Connect(function() -- Line: 56
    -- upvalues: u1 (ref), LocalPlayer (copy)
    u1 = LocalPlayer:GetAttribute("KeyVolume") or 1;
end);
LocalPlayer:GetAttributeChangedSignal("EquippedSoundPack"):Connect(function() -- Line: 59
    -- upvalues: u2 (ref), LocalPlayer (copy)
    u2 = LocalPlayer:GetAttribute("EquippedSoundPack") or "Default";
end);

local function getSoundList(p11) -- Line: 63
    -- upvalues: u8 (copy), SoundBank (copy), u9 (copy)
    if u8[p11] then
        return u8[p11];
    end;

    local v12 = {};

    if SoundBank then
        local v13 = SoundBank:FindFirstChild(p11);

        if v13 then
            for _, child in ipairs(v13:GetChildren()) do
                if child:IsA("Sound") and child.SoundId ~= "" then
                    table.insert(v12, child.SoundId);
                end;
            end;
        end;
    end;

    if #v12 == 0 then
        v12 = u9;
    end;

    u8[p11] = v12;

    return v12;
end;

local function playKeySound(p14) -- Line: 79
    -- upvalues: u1 (ref), getSoundList (copy), u2 (ref), u4 (copy), u10 (ref), u3 (copy)
    if u1 <= 0 then
        return;
    end;

    local v15 = getSoundList(u2);
    local v16 = u4[u10];
    u10 = u10 % 40 + 1;
    v16.SoundId = v15[u3:NextInteger(1, #v15)];
    v16.Volume = u1;
    v16.Parent = p14;
    v16:Play();
end;

local u17 = OverlapParams.new();
u17.FilterType = Enum.RaycastFilterType.Exclude;
task.spawn(function() -- Line: 96
    -- upvalues: LocalPlayer (copy), u17 (copy), u5 (copy), CollectionService (copy), u6 (copy), u1 (ref), getSoundList (copy), u2 (ref), u4 (copy), u10 (ref), u3 (copy), u7 (copy)
    while true do
        local v18, v19;

        if true then
            v18 = LocalPlayer.Character;

            if v18 then
                v19 = v18:FindFirstChild("HumanoidRootPart");
            else
                v19 = v18;
            end;
        end;

        if v19 then
            u17.FilterDescendantsInstances = { v18 };
            local v20 = os.clock();
            local v21 = workspace:GetPartBoundsInBox(v19.CFrame * CFrame.new(0, -2.5, 0), Vector3.new(2.5, 5, 2.5), u17);

            for _, v in ipairs(v21) do
                local v22 = nil;

                for i, v2 in pairs(u5) do
                    if CollectionService:HasTag(v, i) then
                        v22 = v2;
                    end;
                end;

                if v22 then
                    local v23 = u6[v];

                    if not v23 then
                        v23 = {
                            currentAlpha = 0,
                            targetAlpha = 0,
                            lastHit = 0,
                            originalCF = v.CFrame,
                            pressDepth = v22.PRESS_DEPTH
                        };
                        u6[v] = v23;
                    end;

                    if v23.targetAlpha == 0 and u1 > 0 then
                        local v24 = getSoundList(u2);
                        local v25 = u4[u10];
                        u10 = u10 % 40 + 1;
                        v25.SoundId = v24[u3:NextInteger(1, #v24)];
                        v25.Volume = u1;
                        v25.Parent = v;
                        v25:Play();
                    end;

                    v23.targetAlpha = 1;
                    v23.lastHit = v20;
                    u7[v] = true;
                end;
            end;
        end;

        task.wait(0.05);
    end;
end);
RunService.RenderStepped:Connect(function(p26) -- Line: 138
    -- upvalues: u7 (copy), u6 (copy)
    local v27 = os.clock();

    for i, _ in pairs(u7) do
        local v28 = u6[i];

        if v27 - v28.lastHit > 0.25 then
            v28.targetAlpha = 0;
        end;

        v28.currentAlpha = v28.currentAlpha + (v28.targetAlpha - v28.currentAlpha) * math.clamp(p26 * 20, 0, 1);
        i.CFrame = v28.originalCF * CFrame.new(0, -v28.currentAlpha * v28.pressDepth, 0);

        if v28.targetAlpha == 0 and v28.currentAlpha < 0.01 then
            i.CFrame = v28.originalCF;
            v28.currentAlpha = 0;
            u7[i] = nil;
        end;
    end;
end);