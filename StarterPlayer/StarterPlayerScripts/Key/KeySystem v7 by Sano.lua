-- Ruta Original: StarterPlayer.StarterPlayerScripts.Key.KeySystem v7 by Sano
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = require((ReplicatedStorage:WaitForChild("Config"))).WORLD == 3;
local LocalPlayer = Players.LocalPlayer;
local SoundBank = SoundService:WaitForChild("SoundBank", 10);
local u2 = LocalPlayer:GetAttribute("KeyVolume") or 1;
local u3 = LocalPlayer:GetAttribute("EquippedSoundPack") or "Default";
local u4 = Random.new();
local u5 = table.create(40);
local u6 = {};
local u7 = {};
local u8 = 1;
local u9 = {};
local u10 = {
    MusicalKey = {
        PRESS_DEPTH = 1.4
    },
    MusicalKey2 = {
        PRESS_DEPTH = 1
    }
};
local u11 = 0;
local u12 = { "rbxassetid://123413227426138" };

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
    -- upvalues: u7 (copy), SoundBank (copy), u12 (copy)
    if u7[p13] then
        return u7[p13];
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
        v14 = u12;
    end;

    u7[p13] = v14;

    return v14;
end;

local function playKeySound(p16) -- Line: 89
    -- upvalues: u2 (ref), getSoundList (copy), u3 (ref), u5 (copy), u8 (ref), u4 (copy)
    if u2 <= 0 then
        return;
    end;

    local v17 = getSoundList(u3);
    local v18 = u5[u8];
    u8 = u8 % 40 + 1;
    v18.SoundId = v17[u4:NextInteger(1, #v17)];
    v18.Volume = u2;
    v18.Parent = p16;
    v18:Play();
end;

local u19 = OverlapParams.new();
u19.FilterType = Enum.RaycastFilterType.Include;
u19:AddToFilter(workspace.Keycaps);

local function getMusicType(p20) -- Line: 107
    -- upvalues: u10 (copy)
    return u10[p20:GetAttribute("MusicType")] or u10.MusicalKey;
end;

RunService.RenderStepped:Connect(function(p21) -- Line: 111
    -- upvalues: LocalPlayer (copy), u19 (copy), u10 (copy), u6 (copy), u11 (ref), u2 (ref), getSoundList (copy), u3 (ref), u5 (copy), u8 (ref), u4 (copy), u1 (copy), u9 (copy)
    local v22 = os.clock();
    local v23 = LocalPlayer.Character and v23:FindFirstChild("HumanoidRootPart");
    local v24 = nil;
    local v25 = (1 / 0);

    if v23 then
        local AssemblyLinearVelocity = v23.AssemblyLinearVelocity;
        local v26 = math.abs(AssemblyLinearVelocity.X) * p21 * 1.2;
        local v27 = math.abs(AssemblyLinearVelocity.Z) * p21 * 1.2;
        local v28 = Vector3.new(2.5, 5, 2.5) + Vector3.new(v26, 0, v27);
        local v29 = workspace:GetPartBoundsInBox(v23.CFrame * CFrame.new(0, -2.5, 0), v28, u19);

        for _, v in ipairs(v29) do
            local v30 = u10[v:GetAttribute("MusicType")] or u10.MusicalKey;
            local v31 = u6[v];

            if not v31 then
                v31 = {
                    currentAlpha = 0,
                    targetAlpha = 0,
                    lastHit = 0,
                    originalCF = v.CFrame,
                    pressDepth = v30.PRESS_DEPTH
                };
                u6[v] = v31;
            end;

            if v31.targetAlpha == 0 then
                if v22 - u11 >= 0.03 then
                    if u2 > 0 then
                        local v32 = getSoundList(u3);
                        local v33 = u5[u8];
                        u8 = u8 % 40 + 1;
                        v33.SoundId = v32[u4:NextInteger(1, #v32)];
                        v33.Volume = u2;
                        v33.Parent = v;
                        v33:Play();
                    end;

                    u11 = v22;
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

            local v34;

            if u1 then
                local v35 = v23.Position - v.Position;
                v34 = v35.X * v35.X + v35.Z * v35.Z;

                if v34 < v25 then
                    v24 = v;
                else
                    v34 = v25;
                end;
            else
                v34 = v25;
            end;

            v31.targetAlpha = 1;
            v31.lastHit = v22;
            u9[v] = true;
            v25 = v34;
        end;
    end;

    local v36 = {};
    local v37 = {};

    for i, _ in pairs(u9) do
        local v38 = u6[i];

        if v22 - v38.lastHit > 0.15 then
            v38.targetAlpha = 0;
        end;

        v38.currentAlpha = v38.currentAlpha + (v38.targetAlpha - v38.currentAlpha) * math.clamp(p21 * (v38.targetAlpha == 1 and 20 or 8), 0, 1);
        local v39;

        if v38.targetAlpha == 0 then
            v39 = v38.currentAlpha < 0.01;
        else
            v39 = false;
        end;

        local v40 = v39 and v38.originalCF or v38.originalCF * CFrame.new(0, -v38.currentAlpha * v38.pressDepth, 0);

        if u1 then
            local v41 = i == v24;
            local KeycapLight = i:FindFirstChild("KeycapLight");

            if v41 and not KeycapLight then
                KeycapLight = Instance.new("PointLight");
                KeycapLight.Name = "KeycapLight";
                KeycapLight.Color = Color3.fromRGB(255, 255, 255);
                KeycapLight.Range = 7;
                KeycapLight.Brightness = 0;
                KeycapLight.Shadows = false;
                KeycapLight.Parent = i;
            end;

            if KeycapLight then
                KeycapLight.Brightness = KeycapLight.Brightness + ((v41 and (3 * v38.currentAlpha or 0) or 0) - KeycapLight.Brightness) * math.clamp(p21 * 15, 0, 1);
            end;
        end;

        if v39 then
            v38.currentAlpha = 0;
            u9[i] = nil;
            local v42 = u1 and i:FindFirstChild("KeycapLight");

            if v42 then
                v42:Destroy();
            end;
        end;

        table.insert(v36, i);
        table.insert(v37, v40);
    end;

    workspace:BulkMoveTo(v36, v37);
end);