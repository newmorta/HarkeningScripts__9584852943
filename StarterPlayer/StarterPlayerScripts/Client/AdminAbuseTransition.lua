-- Ruta Original: StarterPlayer.StarterPlayerScripts.Client.AdminAbuseTransition
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AdminAbuseDoorConfig = require(ReplicatedStorage.Shared:WaitForChild("AdminAbuseDoorConfig"));
local u1 = nil;
local u2 = 0;
local u3 = false;
local v4 = {
    isActive = function() -- Line: 14, Name: isActive
        -- upvalues: u3 (ref)
        return u3;
    end
};

local function easeInOutSine(p5) -- Line: 18
    local v6 = 3.141592653589793 * math.clamp(p5, 0, 1);

    return -(math.cos(v6) - 1) / 2;
end;

local function destroyActiveScreen() -- Line: 23
    -- upvalues: u1 (ref)
    if u1 and u1.Parent then
        u1:Destroy();
    end;

    u1 = nil;
end;

function v4.cancel() -- Line: 30
    -- upvalues: u2 (ref), u1 (ref)
    u2 = u2 + 1;

    if u1 and u1.Parent then
        u1:Destroy();
    end;

    u1 = nil;
end;

local function findLobbyDoorFolder() -- Line: 35
    local AdminAbuse = workspace:FindFirstChild("AdminAbuse");

    if not (AdminAbuse and AdminAbuse:IsA("Folder")) then
        warn("[LobbyDoorServer] workspace.AdminAbuse manquant");

        return nil;
    end;

    local Scriptables = AdminAbuse:FindFirstChild("Scriptables");

    if Scriptables and Scriptables:IsA("Folder") then
        return Scriptables:FindFirstChild("AdminAbuseDoors");
    end;

    warn("[LobbyDoorServer] workspace.AdminAbuse.Scriptables manquant");

    return nil;
end;

local function waitLobbyDoor(p7) -- Line: 54
    -- upvalues: findLobbyDoorFolder (copy)
    local v8 = os.clock() + p7;
    local v9;

    while true do
        v9 = findLobbyDoorFolder();
        print("ayalalalalla this returned:", v9);

        if v9 then
            break;
        end;

        task.wait(0.05);

        if v8 <= os.clock() then
            return nil;
        end;
    end;

    return v9;
end;

local function buildFarNearOffsetsFromPivot(p10) -- Line: 67
    -- upvalues: AdminAbuseDoorConfig (copy)
    return p10.CFrame * AdminAbuseDoorConfig.DoorCameraFarOffset, p10.CFrame * AdminAbuseDoorConfig.DoorCameraNearOffset;
end;

local function buildFarNearFromModelExtents(p11) -- Line: 73
    local v12 = p11:GetPivot();
    local v13 = p11:GetExtentsSize();
    local v14 = math.max(v13.X, v13.Z) * 0.62 + 5.25;
    local v15 = v13.Y * 0.3;
    local v16 = v13.Y * 0.36;
    local v17 = v12.Position + Vector3.new(0, v13.Y * 0.27, 0);
    local LookVector = v12.LookVector;
    local v18 = v12.Position - LookVector * v14 + Vector3.new(0, v15, 0);
    local v19 = v12.Position - LookVector * (v14 * 2.05 + 5) + Vector3.new(0, v16, 0);

    return CFrame.lookAt(v19, v17), CFrame.lookAt(v18, v17);
end;

local function computeCameraFrames(p20) -- Line: 87
    local LeftWall = p20:FindFirstChild("LeftWall");
    local RightWall = p20:FindFirstChild("RightWall");

    if not (LeftWall and (LeftWall:IsA("Model") and (RightWall and RightWall:IsA("Model")))) then
        return nil, nil;
    end;

    local v21 = LeftWall:GetPivot();
    local v22 = RightWall:GetPivot();
    local v23 = CFrame.new((v21.Position + v22.Position) / 2) * CFrame.Angles(v21:ToOrientation());
    local v24 = LeftWall:GetExtentsSize();
    local v25 = RightWall:GetExtentsSize();
    local v26 = math.max(v24.Y, v25.Y);
    local v27 = v24.X + v25.X + (v21.Position - v22.Position).Magnitude;
    local v28 = math.max(v24.Z, v25.Z);
    local v29 = Vector3.new(v27, v26, v28);
    local v30 = v23.Position + Vector3.new(0, v29.Y * 0.27, 0);
    local StartTransitionCamera = p20:FindFirstChild("StartTransitionCamera");

    if StartTransitionCamera and StartTransitionCamera:IsA("BasePart") then
        local CFrame2 = StartTransitionCamera.CFrame;

        return CFrame2, CFrame2 * CFrame.new(0, 0, -25);
    end;

    local v31 = math.max(v29.X, v29.Z) * 0.62 + 5.25;
    local v32 = v29.Y * 0.36;
    local LookVector = v23.LookVector;
    local v33 = v23.Position - LookVector * v31 + Vector3.new(0, v29.Y * 0.3, 0);
    local v34 = v23.Position - LookVector * (v31 * 2.05 + 5) + Vector3.new(0, v32, 0);

    return CFrame.lookAt(v34, v30), CFrame.lookAt(v33, v30);
end;

local function ensureOverlay(p35) -- Line: 124
    -- upvalues: u1 (ref)
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "AdminAbuseTransition";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.DisplayOrder = 1000000;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.Parent = p35;
    u1 = ScreenGui;
    local Frame = Instance.new("Frame");
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    Frame.BorderSizePixel = 0;
    Frame.BackgroundTransparency = 1;
    Frame.Parent = ScreenGui;

    return Frame;
end;

local function deferOnBlack(u36, u37) -- Line: 142
    -- upvalues: u2 (ref)
    if u36 ~= u2 or not u37 then
        return;
    end;

    task.defer(function() -- Line: 146
        -- upvalues: u36 (copy), u2 (ref), u37 (copy)
        if u36 ~= u2 then
            return;
        end;

        local success, result = pcall(u37);

        if not success then
            warn("[AdminAbuse Transition] onBlack: ", result);
        end;
    end);
end;

function v4.play(u38, u39) -- Line: 162
    -- upvalues: u2 (ref), u3 (ref), Workspace (copy), Players (copy), AdminAbuseDoorConfig (copy), ensureOverlay (copy), waitLobbyDoor (copy), computeCameraFrames (copy), RunService (copy), u1 (ref)
    local v40;

    if u39 then
        v40 = u39.skip;
    else
        v40 = u39;
    end;

    local u41 = v40 == true;
    u2 = u2 + 1;
    local u42 = u2;
    u3 = true;
    task.spawn(function() -- Line: 168
        -- upvalues: u41 (copy), u42 (copy), u38 (copy), u2 (ref), u3 (ref), Workspace (ref), Players (ref), AdminAbuseDoorConfig (ref), ensureOverlay (ref), u39 (copy), waitLobbyDoor (ref), computeCameraFrames (ref), RunService (ref), u1 (ref)
        if u41 then
            local u43 = u42;
            local u44 = u38;

            if u43 == u2 and u44 then
                task.defer(function() -- Line: 146
                    -- upvalues: u43 (copy), u2 (ref), u44 (copy)
                    if u43 ~= u2 then
                        return;
                    end;

                    local success, result = pcall(u44);

                    if not success then
                        warn("[AdminAbuse Transition] onBlack: ", result);
                    end;
                end);
            end;

            u3 = false;

            return;
        end;

        local CurrentCamera = Workspace.CurrentCamera;

        if not CurrentCamera then
            local u45 = u42;
            local u46 = u38;

            if u45 == u2 then
                if not u46 then
                    return;
                end;

                task.defer(function() -- Line: 146
                    -- upvalues: u45 (copy), u2 (ref), u46 (copy)
                    if u45 ~= u2 then
                        return;
                    end;

                    local success, result = pcall(u46);

                    if not success then
                        warn("[AdminAbuse Transition] onBlack: ", result);
                    end;
                end);
            end;

            return;
        end;

        local LocalPlayer = Players.LocalPlayer;

        if not LocalPlayer then
            local u47 = u42;
            local u48 = u38;

            if u47 == u2 then
                if not u48 then
                    return;
                end;

                task.defer(function() -- Line: 146
                    -- upvalues: u47 (copy), u2 (ref), u48 (copy)
                    if u47 ~= u2 then
                        return;
                    end;

                    local success, result = pcall(u48);

                    if not success then
                        warn("[AdminAbuse Transition] onBlack: ", result);
                    end;
                end);
            end;

            return;
        end;

        local v49 = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5);

        if not v49 then
            local u50 = u42;
            local u51 = u38;

            if u50 == u2 then
                if not u51 then
                    return;
                end;

                task.defer(function() -- Line: 146
                    -- upvalues: u50 (copy), u2 (ref), u51 (copy)
                    if u50 ~= u2 then
                        return;
                    end;

                    local success, result = pcall(u51);

                    if not success then
                        warn("[AdminAbuse Transition] onBlack: ", result);
                    end;
                end);
            end;

            return;
        end;

        local TransitionBlackIn = AdminAbuseDoorConfig.TransitionBlackIn;
        local TransitionBlackOut = AdminAbuseDoorConfig.TransitionBlackOut;
        local TransitionApproachSeconds = AdminAbuseDoorConfig.TransitionApproachSeconds;
        local TransitionShakeTail = AdminAbuseDoorConfig.TransitionShakeTail;
        local u52 = TransitionBlackIn + AdminAbuseDoorConfig.TransitionBlackHold;
        local u53 = u52 + TransitionBlackOut;
        local u54 = u52 + TransitionApproachSeconds;
        local DoorOpenDuration = AdminAbuseDoorConfig.DoorOpenDuration;
        local CameraType = CurrentCamera.CameraType;
        local CameraSubject = CurrentCamera.CameraSubject;
        local u55 = ensureOverlay(v49);
        local v56;

        if u39 and u39.skipDoor then
            v56 = nil;
        else
            v56 = waitLobbyDoor(6) or nil;
        end;

        local u57, u58;

        if v56 then
            u57, u58 = computeCameraFrames(v56);
        else
            u57 = nil;
            u58 = nil;
        end;

        local u59;

        if u57 == nil then
            u59 = false;
        else
            u59 = u58 ~= nil;
        end;

        local Sound = Instance.new("Sound");
        Sound.SoundId = "rbxassetid://104296862300351";
        Sound.Looped = true;
        Sound.Volume = 1.8;
        Sound.Parent = workspace.CurrentCamera or LocalPlayer:WaitForChild("PlayerGui");
        local u60 = Random.new();
        local u61 = 0;
        local u62 = false;
        local u63 = false;
        local u64 = false;
        local u65 = 0;
        local u66 = "AdminAbuseTransition_" .. tostring(u42);

        local function teardown() -- Line: 231
            -- upvalues: u3 (ref), RunService (ref), u66 (copy), u1 (ref), u59 (copy), CurrentCamera (copy), LocalPlayer (copy), Sound (copy)
            u3 = false;
            RunService:UnbindFromRenderStep(u66);

            if u1 and u1.Parent then
                u1:Destroy();
            end;

            u1 = nil;

            if u59 then
                CurrentCamera.CameraType = Enum.CameraType.Custom;
                local v67 = LocalPlayer.Character and v67:FindFirstChildOfClass("Humanoid");

                if v67 then
                    CurrentCamera.CameraSubject = v67;
                end;
            end;

            if not Sound.Playing then
                Sound:Destroy();

                return;
            end;

            Sound:Stop();
            local Sound2 = Instance.new("Sound");
            Sound2.SoundId = "rbxassetid://126580113174759";
            Sound2.Volume = 2;
            Sound2.Parent = LocalPlayer:WaitForChild("PlayerGui");
            Sound2:Play();
            task.delay(5, function() -- Line: 254
                -- upvalues: Sound2 (copy), Sound (ref)
                Sound2:Destroy();
                Sound:Destroy();
            end);
        end;

        local function finalize() -- Line: 263
            -- upvalues: u42 (ref), u2 (ref), teardown (copy)
            if u42 ~= u2 then
                return;
            end;

            teardown();
        end;

        local u68 = nil;
        RunService:BindToRenderStep(u66, Enum.RenderPriority.Camera.Value + 1, function(p69) -- Line: 271
            -- upvalues: u42 (ref), u2 (ref), CurrentCamera (copy), CameraType (copy), CameraSubject (copy), RunService (ref), u66 (copy), Sound (copy), u59 (copy), u68 (ref), u61 (ref), TransitionBlackIn (copy), TransitionBlackIn (copy), u55 (copy), u52 (copy), u53 (copy), TransitionBlackOut (copy), u57 (ref), u58 (ref), u54 (copy), u52 (copy), TransitionApproachSeconds (copy), u62 (ref), u38 (ref), u65 (ref), DoorOpenDuration (copy), TransitionShakeTail (copy), u60 (copy), teardown (copy), u63 (ref), u64 (ref)
            if u42 ~= u2 then
                CurrentCamera.CameraType = CameraType;
                CurrentCamera.CameraSubject = CameraSubject;
                RunService:UnbindFromRenderStep(u66);

                if Sound then
                    Sound:Destroy();
                end;

                return;
            end;

            if u59 and CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
                CurrentCamera.CameraType = Enum.CameraType.Scriptable;
                CurrentCamera.CameraSubject = nil;

                if u68 then
                    CurrentCamera.CFrame = u68;
                end;
            end;

            u61 = u61 + p69;

            if u61 < TransitionBlackIn then
                local v70 = 3.141592653589793 * math.clamp(u61 / TransitionBlackIn, 0, 1);
                u55.BackgroundTransparency = 1 - -(math.cos(v70) - 1) / 2;
            elseif u61 < u52 then
                u55.BackgroundTransparency = 0;
            elseif u61 < u53 then
                local v71 = 3.141592653589793 * math.clamp((u61 - u52) / TransitionBlackOut, 0, 1);
                u55.BackgroundTransparency = -(math.cos(v71) - 1) / 2;
            else
                u55.BackgroundTransparency = 1;
            end;

            if u59 then
                local v72 = u57;
                local v73 = u58;

                if u61 < TransitionBlackIn then
                    return;
                end;

                if u61 < u52 then
                    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
                    CurrentCamera.CameraSubject = nil;
                    CurrentCamera.CFrame = v72;
                    CurrentCamera.Focus = CFrame.new(v72.Position + v72.LookVector);
                elseif u61 < u54 then
                    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
                    CurrentCamera.CameraSubject = nil;
                    local v74 = 3.141592653589793 * math.clamp((u61 - u52) / TransitionApproachSeconds, 0, 1);
                    local v75 = v72:Lerp(v73, -(math.cos(v74) - 1) / 2);
                    CurrentCamera.CFrame = v75;
                    CurrentCamera.Focus = CFrame.new(v75.Position + v75.LookVector);
                else
                    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
                    CurrentCamera.CameraSubject = nil;

                    if not u62 then
                        u62 = true;
                        Sound:Play();

                        if u38 then
                            local success, result = pcall(u38);

                            if not success then
                                warn("[AdminAbuse Transition] onBlack: ", result);
                            end;
                        end;
                    end;

                    u65 = u65 + p69;
                    local v76 = math.clamp(u65 / DoorOpenDuration, 0, 1);
                    local v77 = (1 - math.clamp((u65 - DoorOpenDuration * 0.08) / (DoorOpenDuration * 0.92 + TransitionShakeTail), 0, 1)) * 0.36 * (math.sin(v76 * 3.141592653589793) * 0.6 + 0.4);
                    local v78 = CFrame.Angles(u60:NextNumber(-0.024, 0.024) * v77 * 3.5, u60:NextNumber(-0.028, 0.028) * v77 * 3.5, u60:NextNumber(-0.016, 0.016) * v77 * 3.5);
                    local v79 = v73 * CFrame.new(u60:NextNumber(-1, 1) * v77 * 0.44, u60:NextNumber(-1, 1) * v77 * 0.36, u60:NextNumber(-1, 1) * v77 * 0.44) * v78;
                    CurrentCamera.CFrame = v79;
                    CurrentCamera.Focus = CFrame.new(v79.Position + v79.LookVector);

                    if u65 >= DoorOpenDuration + TransitionShakeTail + 1 then
                        if u42 == u2 then
                            teardown();
                        end;
                    elseif u65 >= DoorOpenDuration + TransitionShakeTail then
                        CurrentCamera.CFrame = v73;
                        CurrentCamera.Focus = CFrame.new(v73.Position + v73.LookVector);

                        if Sound.Playing then
                            Sound:Stop();
                        end;
                    end;
                end;
            else
                if TransitionBlackIn <= u61 and not u63 then
                    u63 = true;

                    if u38 then
                        local success, result = pcall(u38);

                        if not success then
                            warn("[AdminAbuse Transition] onBlack: ", result);
                        end;
                    end;
                end;

                if u53 <= u61 and not u64 then
                    u64 = true;

                    if u42 == u2 then
                        teardown();
                    end;
                end;
            end;

            u68 = CurrentCamera.CFrame;
        end);
    end);
end;

return v4;