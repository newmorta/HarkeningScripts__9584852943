-- Ruta Original: ReplicatedStorage.Utilities.Events.MusicNameDiffuserController
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 4
    -- upvalues: u1 (copy)
    local v2 = setmetatable({}, u1);
    v2._gui = nil;
    v2._textLabel = nil;
    v2._part = nil;
    v2._currentText = "";
    v2._scrollX = 0;
    v2._scrollSpeed = 150;

    return v2;
end;

function u1.scan(p3, p4) -- Line: 18
    if not p4 then
        return;
    end;

    if p4.Parent and p4.Parent:IsA("Model") then
        p4 = p4.Parent;
    end;

    local MusicNameDiffuser = p4:WaitForChild("MusicNameDiffuser", 5);

    if not MusicNameDiffuser then
        warn("[MusicNameDiffuserController] Missing model \'MusicNameDiffuser\' in scene.");

        return;
    end;

    local MusicNameDiffuser2 = MusicNameDiffuser:WaitForChild("MusicNameDiffuser", 5);

    if not (MusicNameDiffuser2 and MusicNameDiffuser2:IsA("BasePart")) then
        warn("[MusicNameDiffuserController] Missing part \'MusicNameDiffuser\' inside the model.");

        return;
    end;

    p3._part = MusicNameDiffuser2;
    local SurfaceGui = Instance.new("SurfaceGui");
    SurfaceGui.Name = "MusicNameDiffuserGui";
    SurfaceGui.Face = Enum.NormalId.Front;
    SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud;
    SurfaceGui.PixelsPerStud = 50;
    SurfaceGui.ClipsDescendants = true;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "ScrollingText";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Size = UDim2.new(10, 0, 1, 0);
    TextLabel.Position = UDim2.new(0, 0, 0, 0);
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.TextScaled = false;
    TextLabel.TextSize = 100;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Text = "";
    TextLabel.Parent = SurfaceGui;
    SurfaceGui.Parent = p3._part;
    p3._gui = SurfaceGui;
    p3._textLabel = TextLabel;
end;

function u1.setSongName(p5, p6) -- Line: 67
    if not p5._textLabel then
        return;
    end;

    local v7 = "NOW PLAYING: " .. p6 .. "    ";

    if p5._currentText == v7 then
        return;
    end;

    p5._currentText = v7;
    p5._textLabel.Text = v7;

    if p5._gui then
        p5._scrollX = p5._gui.AbsoluteSize.X;
    end;
end;

function u1.update(p8, p9) -- Line: 82
    if not (p8._textLabel and p8._gui) then
        return;
    end;

    local Y = p8._gui.AbsoluteSize.Y;

    if Y > 0 then
        p8._textLabel.TextSize = Y * 0.8;
    end;

    p8._scrollX = p8._scrollX - p8._scrollSpeed * p9;
    local X = p8._textLabel.TextBounds.X;

    if X > 0 and p8._scrollX < -X then
        p8._scrollX = p8._gui.AbsoluteSize.X;
    end;

    p8._textLabel.Position = UDim2.new(0, p8._scrollX, 0, 0);
end;

function u1.destroy(p10) -- Line: 102
    if p10._gui then
        p10._gui:Destroy();
        p10._gui = nil;
    end;
end;

return u1;