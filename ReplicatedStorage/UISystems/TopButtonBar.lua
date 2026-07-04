-- Ruta Original: ReplicatedStorage.UISystems.TopButtonBar
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local SoundService = game:GetService("SoundService");
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ClientState = require(ReplicatedStorage.ClientState);
local RelicsPlayerClient = require(ReplicatedStorage.UISystems.RelicsPlayerClient);
local v1 = {};

local function wireMuteButton(u2, u3) -- Line: 18
    -- upvalues: SoundService (copy)
    local MuteButton = u2.MuteButton;
    local Image = MuteButton.Image;
    local u4 = u3:GetAttribute("AdminAbuseMuted") == true;

    local function applyToSound(p5) -- Line: 23
        -- upvalues: u4 (ref)
        if u4 then
            if p5:GetAttribute("AdminAbuseMuted") ~= true then
                local v6 = p5:GetAttribute("AdminAbusePrevVolume");

                if not v6 or typeof(v6) ~= "number" then
                    p5:SetAttribute("AdminAbusePrevVolume", p5.Volume);
                end;

                p5:SetAttribute("AdminAbuseMuted", true);
                p5.Volume = 0;
            end;
        elseif p5:GetAttribute("AdminAbuseMuted") == true then
            local v7 = p5:GetAttribute("AdminAbusePrevVolume");

            if typeof(v7) == "number" then
                p5.Volume = v7;
            end;

            p5:SetAttribute("AdminAbusePrevVolume", nil);
            p5:SetAttribute("AdminAbuseMuted", false);
        end;
    end;

    local function applyToAll() -- Line: 45
        -- upvalues: SoundService (ref), applyToSound (copy)
        for _, descendant in SoundService:GetDescendants() do
            if descendant:IsA("Sound") and descendant:GetAttribute("IsEventSound") == true then
                applyToSound(descendant);
            end;
        end;
    end;

    local function refresh() -- Line: 53
        -- upvalues: Image (copy), u4 (ref)
        Image.Image = u4 and "rbxassetid://18342833970" or "rbxassetid://12339196416";
    end;

    u2.Visible = u3:GetAttribute("AdminAbuseEventActive") == true;
    u3:GetAttributeChangedSignal("AdminAbuseEventActive"):Connect(function() -- Line: 58
        -- upvalues: u2 (copy), u3 (copy)
        u2.Visible = u3:GetAttribute("AdminAbuseEventActive") == true;
    end);
    SoundService.DescendantAdded:Connect(function(p8) -- Line: 62
        -- upvalues: applyToSound (copy)
        if p8:IsA("Sound") and p8:GetAttribute("IsEventSound") == true then
            applyToSound(p8);
        end;
    end);
    MuteButton.Activated:Connect(function() -- Line: 68
        -- upvalues: u4 (ref), u3 (copy), applyToAll (copy), Image (copy)
        u4 = not u4;
        u3:SetAttribute("AdminAbuseMuted", u4);
        applyToAll();
        Image.Image = u4 and "rbxassetid://18342833970" or "rbxassetid://12339196416";
    end);
    applyToAll();
    Image.Image = u4 and "rbxassetid://18342833970" or "rbxassetid://12339196416";
end;

function v1.Init(p9) -- Line: 79
    -- upvalues: Players (copy), RelicsPlayerClient (copy), wireMuteButton (copy), UserInputService (copy), CollectionService (copy), ClientState (copy)
    local LocalPlayer = Players.LocalPlayer;
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local TopButtons = PlayerGui:WaitForChild("SpeedGameUI").Frames.TopButtons;
    RelicsPlayerClient.Init();
    wireMuteButton(TopButtons.MuteButton, LocalPlayer);

    if UserInputService.KeyboardEnabled then
        TopButtons.TikfinityButton.TikfinityButton.Activated:Connect(function() -- Line: 89
            -- upvalues: CollectionService (ref), PlayerGui (copy), ClientState (ref)
            for _, v in CollectionService:GetTagged("TikfinityModal") do
                if v:IsDescendantOf(PlayerGui) then
                    ClientState:ToggleModal(v);

                    return;
                end;
            end;
        end);
    else
        TopButtons.TikfinityButton.Visible = false;
    end;

    TopButtons.EmotesButton.EmotesButton.MouseButton1Down:Connect(RelicsPlayerClient.ToggleEquipWheel);
    TopButtons.AudioPlayerButton.AudioPlayerButton.MouseButton1Down:Connect(RelicsPlayerClient.ToggleWindowState);
end;

return v1;