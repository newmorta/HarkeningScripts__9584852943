-- Ruta Original: StarterPlayer.StarterPlayerScripts.Key.KeySystem v6
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = require((ReplicatedStorage:WaitForChild("Config"))).WORLD == 3;
local LocalPlayer = Players.LocalPlayer;
local SoundBank = SoundService:WaitForChild("SoundBank", 10);
local u2 = LocalPlayer:GetAttribute("KeyVolume") or 1;
local u3 = LocalPlayer:GetAttribute("EquippedSoundPack") or "Default";
local u4 = Random.new();
local u5 = table.create(40);
local u6 = {
    MusicalKey = {
        PRESS_DEPTH = 1.4
    },
    MusicalKey2 = {
        PRESS_DEPTH = 1
    }
};
local u7 = 0;
local u8 = { "rbxassetid://123413227426138" };
local u9 = 1;
local u10 = {};
local u11 = {};
local u12 = {};

for i = 1, 40 do
    local Sound = Instance.new("Sound");
    Sound.RollOffMaxDistance = 100;
    Sound.RollOffMinDistance = 10;
    u5[i] = Sound;
end;

LocalPlayer:GetAttributeChangedSignal("KeyVolume"):Connect(function() -- Line: 66
    -- upvalues: u2 (ref), LocalPlayer (copy)
    u2 = LocalPlayer:GetAttribute("KeyVolume") or 1;
end);
LocalPlayer:GetAttributeChangedSignal("EquippedSoundPack"):Connect(function() -- Line: 69
    -- upvalues: u3 (ref), LocalPlayer (copy)
    u3 = LocalPlayer:GetAttribute("EquippedSoundPack") or "Default";
end);

local function getSoundList(p13) -- Line: 73
    -- upvalues: u11 (copy), SoundBank (copy), u8 (copy)
    if u11[p13] then
        return u11[p13];
    end;

    local v14 = {};

    if SoundBank then
        local v15 = SoundBank:FindFirstChild(p13);

        if v15 then
            for _, child in ipairs(v15:GetChildren()) do
                if child:IsA("Sound") and child.SoundId ~= "" then
                    table.insert(v14, child.SoundId);
                end;
            end;
        end;
    end;

    if #v14 == 0 then
        v14 = u8;
    end;

    u11[p13] = v14;

    return v14;
end;

local function playKeySound(p16) -- Line: 89
    -- upvalues: u2 (ref), getSoundList (copy), u3 (ref), u5 (copy), u9 (ref), u4 (copy)
    if u2 <= 0 then
        return;
    end;

    local v17 = getSoundList(u3);
    local v18 = u5[u9];
    u9 = u9 % 40 + 1;
    v18.SoundId = v17[u4:NextInteger(1, #v17)];
    v18.Volume = u2;
    v18.Parent = p16;
    v18:Play();
end;

local u19 = OverlapParams.new();
u19.FilterType = Enum.RaycastFilterType.Exclude;
RunService.RenderStepped:Connect(function(p20) -- Line: 106
    -- upvalues: LocalPlayer (copy), u19 (copy), u6 (copy), CollectionService (copy), u10 (copy), u7 (ref), u2 (ref), getSoundList (copy), u3 (ref), u5 (copy), u9 (ref), u4 (copy), u1 (copy), u12 (copy)
    local v21 = os.clock();
    local Character = LocalPlayer.Character;
    local v22;

    if Character then
        v22 = Character:FindFirstChild("HumanoidRootPart");
    else
        v22 = Character;
    end;

    local v23 = nil;
    local v24 = (1 / 0);

    if v22 then
        u19.FilterDescendantsInstances = { Character };
        local AssemblyLinearVelocity = v22.AssemblyLinearVelocity;
        local v25 = math.abs(AssemblyLinearVelocity.X) * p20 * 1.2;
        local v26 = math.abs(AssemblyLinearVelocity.Z) * p20 * 1.2;
        local v27 = Vector3.new(2.5, 5, 2.5) + Vector3.new(v25, 0, v26);
        local v28 = workspace:GetPartBoundsInBox(v22.CFrame * CFrame.new(0, -2.5, 0), v27, u19);

        for _, v in ipairs(v28) do
            local v29 = nil;

            for i, v2 in pairs(u6) do
                if CollectionService:HasTag(v, i) then
                    v29 = v2;
                    break;
                end;
            end;

            if v29 then
                local v30 = u10[v];

                if not v30 then
                    v30 = {
                        currentAlpha = 0,
                        targetAlpha = 0,
                        lastHit = 0,
                        originalCF = v.CFrame,
                        pressDepth = v29.PRESS_DEPTH
                    };
                    u10[v] = v30;
                end;

                if v30.targetAlpha == 0 then
                    if v21 - u7 >= 0.03 then
                        if u2 > 0 then
                            local v31 = getSoundList(u3);
                            local v32 = u5[u9];
                            u9 = u9 % 40 + 1;
                            v32.SoundId = v31[u4:NextInteger(1, #v31)];
                            v32.Volume = u2;
                            v32.Parent = v;
                            v32:Play();
                        end;

                        u7 = v21;
                    end;

                    if u1 and not v:FindFirstChild("KeycapLight") then
                        local PointLight = Instance.new("PointLight");
                        PointLight.Name = "KeycapLight";
                        PointLight.Color = Color3.fromRGB(255, 255, 255);
                        PointLight.Range = 7;
                        PointLight.Brightness = 0;
                        PointLight.Shadows = false;
                        PointLight.Parent = v;
                    end;
                end;

                local v33;

                if u1 then
                    local v34 = v22.Position - v.Position;
                    v33 = v34.X * v34.X + v34.Z * v34.Z;

                    if v33 < v24 then
                        v23 = v;
                    else
                        v33 = v24;
                    end;
                else
                    v33 = v24;
                end;

                v30.targetAlpha = 1;
                v30.lastHit = v21;
                u12[v] = true;
                v24 = v33;
            end;
        end;
    end;

    for i, _ in pairs(u12) do
        local v35 = u10[i];

        if v21 - v35.lastHit > 0.15 then
            v35.targetAlpha = 0;
        end;

        v35.currentAlpha = v35.currentAlpha + (v35.targetAlpha - v35.currentAlpha) * math.clamp(p20 * (v35.targetAlpha == 1 and 20 or 8), 0, 1);
        i.CFrame = v35.originalCF * CFrame.new(0, -v35.currentAlpha * v35.pressDepth, 0);

        if u1 then
            local v36 = i == v23;
            local KeycapLight = i:FindFirstChild("KeycapLight");

            if v36 and not KeycapLight then
                KeycapLight = Instance.new("PointLight");
                KeycapLight.Name = "KeycapLight";
                KeycapLight.Color = Color3.fromRGB(255, 255, 255);
                KeycapLight.Range = 7;
                KeycapLight.Brightness = 0;
                KeycapLight.Shadows = false;
                KeycapLight.Parent = i;
            end;

            if KeycapLight then
                KeycapLight.Brightness = KeycapLight.Brightness + ((v36 and (3 * v35.currentAlpha or 0) or 0) - KeycapLight.Brightness) * math.clamp(p20 * 15, 0, 1);
            end;
        end;

        if v35.targetAlpha == 0 and v35.currentAlpha < 0.01 then
            i.CFrame = v35.originalCF;
            v35.currentAlpha = 0;
            u12[i] = nil;

            if u1 then
                local KeycapLight = i:FindFirstChild("KeycapLight");

                if KeycapLight then
                    KeycapLight:Destroy();
                end;
            end;
        end;
    end;
end);