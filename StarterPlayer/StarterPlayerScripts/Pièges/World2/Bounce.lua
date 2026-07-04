-- Ruta Original: StarterPlayer.StarterPlayerScripts.Pièges.World2.Bounce
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local JumpHeightManager = require(ReplicatedStorage:WaitForChild("Utilities"):WaitForChild("JumpHeightManager"));
local Candys = workspace:FindFirstChild("Candys");
local LocalPlayer = Players.LocalPlayer;

if not Candys then
    Candys = Instance.new("Folder");
    Candys.Name = "Candys";
    Candys.Parent = workspace;
end;

local u1 = OverlapParams.new();
u1:AddToFilter(Candys);
u1.FilterType = Enum.RaycastFilterType.Include;
local Folder = Instance.new("Folder");
Folder.Name = "JellySounds";
Folder.Parent = SoundService;
local u2 = {};
local u3 = {
    BASE_DETECTION_SIZE = Vector3.new(2.5, 5, 2.5),
    LERP_SPEED_DOWN = 20,
    LERP_SPEED_UP = 8,
    HOLD_TIME = 0.15,
    VELOCITY_PADDING = 1.2,
    SOUND_COOLDOWN = 0.03,
    MAX_PLAYABLE_SOUNDS = 5,
    SOUND_ID = "rbxassetid://97921748945256",
    PITCH_MIN = 0.85,
    PITCH_MAX = 1.15,
    MIN_SCALE = 0.3,
    BOUNCE_POWER = 80,
    BOUNCE_COOLDOWN = 0.3
};

for i = 1, 5 do
    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://97921748945256";
    Sound.Parent = Folder;
    u2[i] = Sound;
end;

local u4 = 0;
local u5 = 0;

local function playSound() -- Line: 53
    -- upvalues: u5 (ref), u4 (ref), u2 (copy)
    if u5 > 0 then
        return;
    end;

    u5 = 0.03;
    u4 = u4 % 5 + 1;
    local v6 = u2[u4];
    v6.PlaybackSpeed = 0.85 + math.random() * 0.29999999999999993;
    v6:Play();
end;

local u7 = {};
local u8 = 0;
local u9 = nil;
RunService.RenderStepped:Connect(function(p10) -- Line: 75
    -- upvalues: LocalPlayer (copy), u9 (ref), JumpHeightManager (copy), u5 (ref), u8 (ref), u1 (copy), u7 (copy), u3 (copy), u4 (ref), u2 (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local v11 = Character:FindFirstChildOfClass("Humanoid");

    if not (HumanoidRootPart and v11) then
        return;
    end;

    if v11 ~= u9 then
        u9 = v11;
        JumpHeightManager.setHumanoid(v11);
    end;

    u5 = math.max(0, u5 - p10);
    u8 = math.max(0, u8 - p10);
    local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity;
    local v12 = math.abs(AssemblyLinearVelocity.X) * p10 * 1.2;
    local v13 = math.abs(AssemblyLinearVelocity.Z) * p10 * 1.2;
    local v14 = Vector3.new(2.5, 5, 2.5) + Vector3.new(v12, 0, v13);
    local v15 = HumanoidRootPart.CFrame * CFrame.new(0, -(v11.HipHeight + HumanoidRootPart.Size.Y / 2) - 1, 0);

    for _, v in workspace:GetPartBoundsInBox(v15, v14, u1) do
        if not u7[v] then
            u7[v] = {
                scaleY = 1,
                state = "SQUISHING",
                holdTimer = 0,
                originalSize = v.Size,
                originalCFrame = v.CFrame
            };
        end;
    end;

    local v16 = {};
    local v17 = {};

    for i, v in u7 do
        if i.Parent then
            local v18, v19, v20;

            if v.state == "SQUISHING" then
                v.scaleY = 0.3 + (v.scaleY - 0.3) * math.exp(-20 * p10);

                if v.scaleY <= 0.32 then
                    v.scaleY = 0.3;
                    v.state = "HOLDING";
                    v.holdTimer = 0.15;

                    if u8 <= 0 then
                        u8 = 0.3;
                        JumpHeightManager.set("Bounce", 80, 100);
                        v11:ChangeState(Enum.HumanoidStateType.Jumping);
                        task.delay(0.1, function() -- Line: 142
                            -- upvalues: JumpHeightManager (ref)
                            JumpHeightManager.release("Bounce");
                        end);

                        if u5 <= 0 then
                            u5 = u3.SOUND_COOLDOWN;
                            u4 = u4 % u3.MAX_PLAYABLE_SOUNDS + 1;
                            local v21 = u2[u4];
                            v21.PlaybackSpeed = u3.PITCH_MIN + math.random() * (u3.PITCH_MAX - u3.PITCH_MIN);
                            v21:Play();
                        end;
                    end;
                end;

                v18 = v.originalSize.Y;
                v19 = v18 / 2 * (v.scaleY - 1);
                i.Size = Vector3.new(v.originalSize.X, v18 * v.scaleY, v.originalSize.Z);
                table.insert(v16, i);
                v20 = v.originalCFrame + Vector3.new(0, v19, 0);
                table.insert(v17, v20);
            else
                if v.state == "HOLDING" then
                    v.holdTimer = v.holdTimer - p10;

                    if v.holdTimer <= 0 then
                        v.state = "RESTORING";
                    end;

                    v18 = v.originalSize.Y;
                    v19 = v18 / 2 * (v.scaleY - 1);
                    i.Size = Vector3.new(v.originalSize.X, v18 * v.scaleY, v.originalSize.Z);
                    table.insert(v16, i);
                    v20 = v.originalCFrame + Vector3.new(0, v19, 0);
                    table.insert(v17, v20);
                end;

                if v.state ~= "RESTORING" then
                    v18 = v.originalSize.Y;
                    v19 = v18 / 2 * (v.scaleY - 1);
                    i.Size = Vector3.new(v.originalSize.X, v18 * v.scaleY, v.originalSize.Z);
                    table.insert(v16, i);
                    v20 = v.originalCFrame + Vector3.new(0, v19, 0);
                    table.insert(v17, v20);
                end;

                v.scaleY = (v.scaleY - 1) * math.exp(-8 * p10) + 1;

                if v.scaleY < 0.99 then
                    v18 = v.originalSize.Y;
                    v19 = v18 / 2 * (v.scaleY - 1);
                    i.Size = Vector3.new(v.originalSize.X, v18 * v.scaleY, v.originalSize.Z);
                    table.insert(v16, i);
                    v20 = v.originalCFrame + Vector3.new(0, v19, 0);
                    table.insert(v17, v20);
                end;

                i.Size = v.originalSize;
                table.insert(v16, i);
                table.insert(v17, v.originalCFrame);
                u7[i] = nil;
            end;
        else
            u7[i] = nil;
        end;
    end;

    if #v16 > 0 then
        workspace:BulkMoveTo(v16, v17, Enum.BulkMoveMode.FireCFrameChanged);
    end;
end);