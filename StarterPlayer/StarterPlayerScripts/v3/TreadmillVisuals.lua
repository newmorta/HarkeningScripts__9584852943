-- Ruta Original: StarterPlayer.StarterPlayerScripts.v3.TreadmillVisuals
-- Tipo: LocalScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");

local function setupCharacterVisuals(u1) -- Line: 4
    local Humanoid = u1:WaitForChild("Humanoid", 10);
    local u2;

    if Humanoid then
        u2 = Humanoid:WaitForChild("Animator", 10);
    else
        u2 = Humanoid;
    end;

    if not u2 then
        return;
    end;

    local u3 = nil;

    local function getRunAnim() -- Line: 11
        -- upvalues: u1 (copy)
        local Animate = u1:FindFirstChild("Animate");

        if not Animate then
            return nil;
        end;

        local v4 = Animate:FindFirstChild("run") and v4:FindFirstChildOfClass("Animation");

        return v4;
    end;

    local function updateAnimation() -- Line: 21
        -- upvalues: u1 (copy), u3 (ref), u2 (copy), Humanoid (copy)
        if u1:GetAttribute("IsOnTreadmill") then
            if not u3 then
                local Animate = u1:FindFirstChild("Animate");
                local v5;

                if Animate then
                    v5 = Animate:FindFirstChild("run") and v5:FindFirstChildOfClass("Animation");
                else
                    v5 = nil;
                end;

                if v5 then
                    u3 = u2:LoadAnimation(v5);
                    u3.Priority = Enum.AnimationPriority.Movement;
                    u3.Looped = true;
                end;
            end;

            if u3 and not u3.IsPlaying then
                u3:Play(0.3);
            end;
        elseif u3 then
            u3:Stop(0.3);
            u3:Destroy();
            u3 = nil;
            task.defer(function() -- Line: 45
                -- upvalues: Humanoid (ref)
                if Humanoid and Humanoid.Parent then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Landed);
                end;
            end);
        end;
    end;

    u1:GetAttributeChangedSignal("IsOnTreadmill"):Connect(updateAnimation);
    updateAnimation();
end;

Players.PlayerAdded:Connect(function(p6) -- Line: 59, Name: onPlayerAdded
    -- upvalues: setupCharacterVisuals (copy)
    if p6.Character then
        task.spawn(setupCharacterVisuals, p6.Character);
    end;

    p6.CharacterAdded:Connect(setupCharacterVisuals);
end);

for _, v in ipairs(Players:GetPlayers()) do
    if v.Character then
        task.spawn(setupCharacterVisuals, v.Character);
    end;

    v.CharacterAdded:Connect(setupCharacterVisuals);
end;