-- Ruta Original: ReplicatedStorage.GiftUISystem
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
game:GetService("SocialService");
local GroupService = game:GetService("GroupService");
local SoundManager = require(ReplicatedStorage:WaitForChild("SoundManager"));
local ClientState = require(ReplicatedStorage:WaitForChild("ClientState"));
local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("Config"));
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local VerifyGroup = Remotes:WaitForChild("VerifyGroup");
local ClaimGift = Remotes:WaitForChild("ClaimGift");
local v1 = {};
local u2 = false;
local u3 = {
    modal = nil,
    closeBtn = nil,
    verifyBtn = nil,
    check1 = nil,
    check2 = nil
};

local function findElements() -- Line: 34
    -- upvalues: Players (copy), CollectionService (copy), u3 (copy)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");

    local function getOne(p4) -- Line: 38
        -- upvalues: CollectionService (ref), PlayerGui (copy)
        local v5 = CollectionService:GetTagged(p4);

        for _, v in ipairs(v5) do
            if v:IsDescendantOf(PlayerGui) then
                return v;
            end;
        end;

        return nil;
    end;

    u3.modal = getOne("GiftModal");
    u3.closeBtn = getOne("GiftCloseBtn");
    u3.verifyBtn = getOne("GiftVerifyBtn");
    u3.check1 = getOne("GiftStep1Check");
    u3.check2 = getOne("GiftStep2Check");
    u3.verifyBtnFrame = getOne("VerifyButtonFrame");

    for i, v in pairs(u3) do
        if not v then
            warn("❌ " .. i .. " MANQUANT (Vérifie tes tags)");
        end;
    end;
end;

function v1.UpdateDisplay(p6) -- Line: 67
    -- upvalues: u3 (copy), findElements (copy), ClientState (copy)
    if not u3.modal then
        findElements();
    end;

    if ClientState:Get().GiftClaimed then
        if u3.check1 then
            u3.check1.Visible = true;
        end;

        if u3.check2 then
            u3.check2.Visible = true;
        end;

        if u3.verifyBtn then
            u3.verifyBtn.Text = "Claimed! ✓";
            u3.verifyBtnFrame.BackgroundColor3 = Color3.fromRGB(80, 180, 80);
        end;
    else
        if u3.check1 then
            u3.check1.Visible = false;
        end;

        if u3.check2 then
            u3.check2.Visible = false;
        end;

        if u3.verifyBtn then
            u3.verifyBtn.Text = "Verify & Claim!";
            u3.verifyBtnFrame.BackgroundColor3 = Color3.fromRGB(80, 200, 80);
        end;
    end;
end;

local function initialize() -- Line: 94
    -- upvalues: u2 (ref), u3 (copy), findElements (copy), ClientState (copy), VerifyGroup (copy), ClaimGift (copy), SoundManager (copy), GroupService (copy), Config (copy)
    if u2 then
        return;
    end;

    if not u3.modal then
        findElements();
    end;

    if u3.closeBtn then
        u3.closeBtn.MouseButton1Click:Connect(function() -- Line: 99
            -- upvalues: ClientState (ref)
            ClientState:CloseCurrentModal();
        end);
    end;

    if u3.verifyBtn then
        u3.verifyBtn.MouseButton1Click:Connect(function() -- Line: 106
            -- upvalues: ClientState (ref), u3 (ref), VerifyGroup (ref), ClaimGift (ref), SoundManager (ref), GroupService (ref), Config (ref)
            if ClientState:Get().GiftClaimed then
                return;
            end;

            u3.verifyBtn.Text = "Checking...";
            local success, result = pcall(function() -- Line: 113
                -- upvalues: VerifyGroup (ref)
                return VerifyGroup:InvokeServer();
            end);

            if not (success and result) then
                SoundManager:Play("ERROR");
                u3.verifyBtn.Text = "Join Group First!";
                u3.verifyBtnFrame.BackgroundColor3 = Color3.fromRGB(220, 44, 44);
                task.delay(5, function() -- Line: 141
                    -- upvalues: u3 (ref)
                    u3.verifyBtn.Text = "Verify & Claim!";
                    u3.verifyBtnFrame.BackgroundColor3 = Color3.fromRGB(80, 200, 80);
                end);
                task.wait(1);
                task.spawn(function() -- Line: 148
                    -- upvalues: GroupService (ref), Config (ref)
                    local success2, result2 = pcall(function() -- Line: 150
                        -- upvalues: GroupService (ref), Config (ref)
                        return GroupService:PromptJoinAsync(Config.GROUP_ID);
                    end);

                    if not success2 then
                        warn("❌ Erreur GroupService:PromptJoinAsync :", result2);
                    end;
                end);

                return;
            end;

            if u3.check1 then
                u3.check1.Visible = true;
            end;

            if u3.check2 then
                u3.check2.Visible = true;
            end;

            ClaimGift:FireServer();
            ClientState:Update({
                GiftClaimed = true
            });
            SoundManager:Play("SUCCESS");
            u3.verifyBtn.Text = "Claimed! ✓";
            u3.verifyBtnFrame.BackgroundColor3 = Color3.fromRGB(80, 180, 80);
            task.delay(0.5, function() -- Line: 132
                -- upvalues: ClientState (ref), u3 (ref)
                ClientState:CloseCurrentModal(u3.modal);
            end);
        end);
    end;

    u2 = true;
end;

function v1.InitLogic(p7) -- Line: 170
    -- upvalues: u3 (copy), findElements (copy), initialize (copy)
    if not u3.modal then
        findElements();
    end;

    initialize();
    p7:UpdateDisplay();
end;

function v1.OnClose(p8) -- Line: 176
end;

return v1;