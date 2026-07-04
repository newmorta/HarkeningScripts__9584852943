-- Ruta Original: ReplicatedStorage.coolTransitions
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local ContentProvider = game:GetService("ContentProvider");
local RunService = game:GetService("RunService");
local u1 = {};

for _, child in script:GetChildren() do
    if child:IsA("ImageLabel") then
        u1[child.Name] = child.Image;
    end;
end;

ContentProvider:PreloadAsync(script:GetChildren());
local u2 = Color3.fromRGB(20, 20, 20);

local function easeInOutSine(p3) -- Line: 38
    return -(math.cos(3.141592653589793 * p3) - 1) / 2;
end;

local function easeOutQuad(p4) -- Line: 42
    return 1 - (1 - p4) * (1 - p4);
end;

local function easeInQuad(p5) -- Line: 46
    return p5 * p5;
end;

local u6 = {};
u6.__index = u6;

function u6.new(p7) -- Line: 55
    -- upvalues: u6 (copy)
    return setmetatable({
        _background = nil,
        _screenWidth = 0,
        _screenHeight = 0,
        _config = p7,
        _cells = {}
    }, u6);
end;

function u6.Build(p8, p9, p10, p11, p12) -- Line: 65
    p8._screenWidth = p10;
    p8._screenHeight = p11;
    local Frame = Instance.new("Frame");
    Frame.Name = "GridBackground";
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundColor3 = p12;
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.ZIndex = 0;
    Frame.Visible = false;
    Frame.Parent = p9;
    p8._background = Frame;
    local v13 = p8._config.cells(p10, p11);
    local v14 = p8._config.content ~= nil;
    local v15 = table.create(#v13);

    for i, v in v13 do
        local v16;

        if v14 then
            v16 = Instance.new("ImageLabel");
            v16.Image = p8._config.content;
            v16.ImageColor3 = p12;
            v16.BackgroundTransparency = 1;
            v16.ScaleType = Enum.ScaleType.Stretch;
            v16.AnchorPoint = Vector2.new(0.5, 0.5);
            v16.Position = UDim2.fromOffset(v.x, v.y);
            v16.Size = UDim2.fromOffset(v.width, v.height);
            v16.Visible = false;

            if v.rotation then
                v16.Rotation = v.rotation;
            end;
        else
            v16 = Instance.new("Frame");
            v16.BackgroundColor3 = p12;
            v16.BorderSizePixel = 0;
            v16.AnchorPoint = Vector2.new(0.5, 0.5);
            v16.Position = UDim2.fromOffset(v.x, v.y);
            v16.Size = UDim2.fromOffset(v.width, v.height);
            v16.Visible = false;
        end;

        v16.ZIndex = 1;
        v16.Parent = p9;
        v15[i] = {
            threshold = 0,
            lastSize = -1,
            element = v16,
            x = v.x,
            y = v.y,
            fullWidth = v.width,
            fullHeight = v.height
        };
    end;

    p8._cells = v15;
end;

function u6.Prepare(p17, p18) -- Line: 128
    if p17._config.randomThreshold then
        for _, v in p17._cells do
            v.threshold = math.random();
        end;

        return;
    end;

    local v19, v20 = p17:_getOriginPoint(p18);
    local v21 = 0;

    for _, v in p17._cells do
        local v22 = v.x - v19;
        local v23 = v.y - v20;
        local v24 = math.sqrt(v22 * v22 + v23 * v23);

        if v21 < v24 then
            v21 = v24;
        end;
    end;

    if v21 == 0 then
        return;
    end;

    local v25 = 1 / v21;

    for _, v in p17._cells do
        local v26 = v.x - v19;
        local v27 = v.y - v20;
        v.threshold = math.sqrt(v26 * v26 + v27 * v27) * v25;
    end;
end;

function u6.Update(p28, p29, p30) -- Line: 155
    local v31 = p30 == "In";

    if not v31 then
        p29 = 1 - p29;
    end;

    local spread = p28._config.spread;
    local v32 = 1 / (1 - spread);
    local scaleUniform = p28._config.scaleUniform;
    local v33 = math.clamp((p29 - 0.95) / 0.050000000000000044, 0, 1);
    p28._background.BackgroundTransparency = 1 - v33;
    p28._background.Visible = v33 > 0;

    for _, v in p28._cells do
        local v34 = math.clamp((p29 - v.threshold * spread) * v32, 0, 1);
        local v35;

        if v31 then
            v35 = 1 - (1 - v34) * (1 - v34);
        else
            local v36 = 1 - v34;
            v35 = 1 - v36 * v36;
        end;

        local v37;

        if scaleUniform then
            v37 = v.fullWidth * v35;
        else
            v37 = v.fullHeight * v35;
        end;

        local v38 = math.floor(v37);

        if v38 ~= v.lastSize then
            v.lastSize = v38;

            if scaleUniform then
                v.element.Size = UDim2.fromOffset(v38, v38);
            else
                v.element.Size = UDim2.fromOffset(v.fullWidth, v38);
            end;
        end;

        v.element.Visible = v35 > 0.01;
    end;
end;

function u6.Show(p39) -- Line: 187
    p39._background.BackgroundTransparency = 0;
    p39._background.Visible = true;

    for _, v in p39._cells do
        v.element.Size = UDim2.fromOffset(v.fullWidth, v.fullHeight);
        v.element.Visible = true;
        v.lastSize = v.fullHeight;
    end;
end;

function u6.Hide(p40) -- Line: 197
    p40._background.BackgroundTransparency = 1;
    p40._background.Visible = false;

    for _, v in p40._cells do
        v.element.Visible = false;
        v.lastSize = -1;
    end;
end;

function u6.Destroy(p41) -- Line: 206
    if p41._background then
        p41._background:Destroy();
        p41._background = nil;
    end;

    for _, v in p41._cells do
        v.element:Destroy();
    end;

    p41._cells = {};
end;

function u6._getOriginPoint(p42, p43) -- Line: 217
    if p43 == "Center" then
        return p42._screenWidth / 2, p42._screenHeight / 2;
    end;

    if p43 == "TopLeft" then
        return 0, 0;
    end;

    return p42._screenWidth, p42._screenHeight;
end;

local function rectGrid(p44, p45, p46, p47, p48, p49, p50) -- Line: 228
    local v51 = p50 or p46;
    local v52 = math.ceil((p44 + p47 * 2) / p46) + 1;
    local v53 = math.ceil((p45 + p47 * 2) / p46) + 1;
    local v54 = v52 * v53;

    if p49 then
        v54 = math.ceil(v54 / 2);
    end;

    local v55 = table.create(v54);
    local v56 = 0;

    for i = 0, v52 - 1 do
        for i2 = 0, v53 - 1 do
            if not p49 or (i + i2) % 2 == 0 then
                v56 = v56 + 1;
                v55[v56] = {
                    x = i * p46 - p47 + ((not p48 or i2 % 2 ~= 1) and 0 or p46 / 2),
                    y = i2 * p46 - p47,
                    width = v51,
                    height = v51
                };
            end;
        end;
    end;

    return v55;
end;

local u82 = {
    HEXAGON = {
        scaleUniform = true,
        spread = 0.65,
        randomThreshold = false,
        content = u1.Hexagon,

        cells = function(p57, p58) -- Line: 276, Name: cells
            local v59 = math.ceil((p57 + 220) / 82.5) + 1;
            local v60 = math.ceil((p58 + 220) / 95.26279441628824) + 1;
            local v61 = table.create(v59 * v60);
            local v62 = 0;

            for i = 0, v59 - 1 do
                for i2 = 0, v60 - 1 do
                    v62 = v62 + 1;
                    v61[v62] = {
                        width = 110,
                        height = 110,
                        x = i * 82.5 - 110,
                        y = i2 * 95.26279441628824 + (i % 2 == 1 and 47.63139720814412 or 0) - 110
                    };
                end;
            end;

            return v61;
        end
    },
    TRIANGLE = {
        scaleUniform = true,
        spread = 0.65,
        randomThreshold = false,
        content = u1.Triangle,

        cells = function(p63, p64) -- Line: 305, Name: cells
            local v65 = math.ceil((p63 + 290) / 43.30127018922193) + 1;
            local v66 = math.ceil((p64 + 290) / 75) + 1;
            local v67 = table.create(v65 * v66);
            local v68 = 0;

            for i = 0, v65 - 1 do
                for i2 = 0, v66 - 1 do
                    v68 = v68 + 1;
                    v67[v68] = {
                        width = 145,
                        height = 145,
                        x = i * 43.30127018922193 - 145,
                        y = i2 * 75 - 145,
                        rotation = (i + i2) % 2 == 1 and 180 or 0
                    };
                end;
            end;

            return v67;
        end
    },
    TILES = {
        scaleUniform = true,
        spread = 0.65,
        randomThreshold = false,

        cells = function(p69, p70) -- Line: 334, Name: cells
            -- upvalues: rectGrid (copy)
            return rectGrid(p69, p70, 80, 80);
        end
    },
    POLKA_DOTS = {
        scaleUniform = true,
        spread = 0.55,
        randomThreshold = false,
        content = u1.Circle,

        cells = function(p71, p72) -- Line: 342, Name: cells
            -- upvalues: rectGrid (copy)
            return rectGrid(p71, p72, 70, 70, true, false, 105);
        end
    },
    BLINDS = {
        scaleUniform = false,
        spread = 0.4,
        randomThreshold = false,

        cells = function(p73, p74) -- Line: 349, Name: cells
            local v75 = p73 + 200;
            local v76 = math.ceil((p74 + 120) / 60) + 1;
            local v77 = table.create(v76);

            for i = 0, v76 - 1 do
                v77[i + 1] = {
                    height = 60,
                    x = p73 / 2,
                    y = i * 60 - 60,
                    width = v75
                };
            end;

            return v77;
        end
    },
    CHECKERBOARD = {
        scaleUniform = true,
        spread = 0.6,
        randomThreshold = false,

        cells = function(p78, p79) -- Line: 369, Name: cells
            -- upvalues: rectGrid (copy)
            return rectGrid(p78, p79, 80, 80, false, true, 160);
        end
    },
    RANDOM_TILES = {
        scaleUniform = true,
        spread = 0.85,
        randomThreshold = true,

        cells = function(p80, p81) -- Line: 376, Name: cells
            -- upvalues: rectGrid (copy)
            return rectGrid(p80, p81, 80, 80);
        end
    }
};
local u83 = {};
u83.__index = u83;

function u83.new() -- Line: 384
    -- upvalues: u83 (copy)
    return setmetatable({
        _frame = nil
    }, u83);
end;

function u83.Build(p84, p85, p86, p87, p88) -- Line: 388
    local Frame = Instance.new("Frame");
    Frame.Name = "Fade";
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundColor3 = p88;
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.Visible = false;
    Frame.Parent = p85;
    p84._frame = Frame;
end;

function u83.Prepare(p89, p90) -- Line: 400
end;

function u83.Update(p91, p92, p93) -- Line: 402
    if p93 ~= "In" then
        p92 = 1 - p92;
    end;

    p91._frame.BackgroundTransparency = 1 - p92;
    p91._frame.Visible = p92 > 0.01;
end;

function u83.Show(p94) -- Line: 408
    p94._frame.BackgroundTransparency = 0;
    p94._frame.Visible = true;
end;

function u83.Hide(p95) -- Line: 413
    p95._frame.BackgroundTransparency = 1;
    p95._frame.Visible = false;
end;

function u83.Destroy(p96) -- Line: 418
    p96._frame:Destroy();
end;

local u97 = {};
u97.__index = u97;

function u97.new(p98) -- Line: 425
    -- upvalues: u97 (copy)
    return setmetatable({
        _element = nil,
        _maxSize = 0,
        _originX = 0,
        _originY = 0,
        _screenWidth = 0,
        _screenHeight = 0,
        _mode = p98
    }, u97);
end;

function u97.Build(p99, p100, p101, p102, p103) -- Line: 437
    -- upvalues: u1 (copy)
    p99._screenWidth = p101;
    p99._screenHeight = p102;
    local v104 = math.sqrt(p101 * p101 + p102 * p102);

    if p99._mode == "box" then
        p99._maxSize = math.max(p101, p102);
        local Frame = Instance.new("Frame");
        Frame.BackgroundColor3 = p103;
        Frame.BorderSizePixel = 0;
        Frame.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame.Visible = false;
        Frame.Parent = p100;
        p99._element = Frame;

        return;
    end;

    if p99._mode == "diamond" then
        p99._maxSize = v104;
        local Frame = Instance.new("Frame");
        Frame.BackgroundColor3 = p103;
        Frame.BorderSizePixel = 0;
        Frame.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame.Rotation = 45;
        Frame.Visible = false;
        Frame.Parent = p100;
        p99._element = Frame;

        return;
    end;

    p99._maxSize = v104;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Image = u1.Circle or "";
    ImageLabel.ImageColor3 = p103;
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.ScaleType = Enum.ScaleType.Stretch;
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.Visible = false;
    ImageLabel.Parent = p100;
    p99._element = ImageLabel;
end;

function u97.Prepare(p105, p106) -- Line: 475
    if p106 == "Center" then
        p105._originX = p105._screenWidth / 2;
        p105._originY = p105._screenHeight / 2;
    elseif p106 == "TopLeft" then
        p105._originX = 0;
        p105._originY = 0;
    else
        p105._originX = p105._screenWidth;
        p105._originY = p105._screenHeight;
    end;

    p105._element.Position = UDim2.fromOffset(p105._originX, p105._originY);
end;

function u97.Update(p107, p108, p109) -- Line: 489
    if p109 ~= "In" then
        p108 = 1 - p108;
    end;

    if p107._mode == "box" then
        p107._element.Size = UDim2.fromOffset(math.floor(p107._screenWidth * p108), (math.floor(p107._screenHeight * p108)));
    else
        local v110 = math.floor(p107._maxSize * p108);
        p107._element.Size = UDim2.fromOffset(v110, v110);
    end;

    p107._element.Visible = p108 > 0.01;
end;

function u97.Show(p111) -- Line: 503
    if p111._mode == "box" then
        p111._element.Size = UDim2.fromOffset(p111._screenWidth, p111._screenHeight);
    else
        p111._element.Size = UDim2.fromOffset(p111._maxSize, p111._maxSize);
    end;

    p111._element.Visible = true;
end;

function u97.Hide(p112) -- Line: 512
    p112._element.Visible = false;
end;

function u97.Destroy(p113) -- Line: 516
    p113._element:Destroy();
end;

local u114 = {};
u114.__index = u114;

function u114.new() -- Line: 523
    -- upvalues: u114 (copy)
    return setmetatable({
        _frame = nil,
        _screenWidth = 0,
        _wipeFromLeft = true
    }, u114);
end;

function u114.Build(p115, p116, p117, p118, p119) -- Line: 531
    p115._screenWidth = p117;
    local Frame = Instance.new("Frame");
    Frame.Name = "LinearWipe";
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundColor3 = p119;
    Frame.BorderSizePixel = 0;
    Frame.AnchorPoint = Vector2.new(0, 0);
    Frame.Visible = false;
    Frame.Parent = p116;
    p115._frame = Frame;
end;

function u114.Prepare(p120, p121) -- Line: 544
    p120._wipeFromLeft = p121 ~= "BottomRight";
end;

function u114.Update(p122, p123, p124) -- Line: 548
    if p124 ~= "In" then
        p123 = 1 - p123;
    end;

    local v125;

    if p122._wipeFromLeft then
        v125 = math.floor(-p122._screenWidth * (1 - p123));
    else
        v125 = math.floor(p122._screenWidth * (1 - p123));
    end;

    p122._frame.Position = UDim2.fromOffset(v125, 0);
    p122._frame.Visible = p123 > 0.01;
end;

function u114.Show(p126) -- Line: 557
    p126._frame.Position = UDim2.fromOffset(0, 0);
    p126._frame.Visible = true;
end;

function u114.Hide(p127) -- Line: 562
    p127._frame.Visible = false;
end;

function u114.Destroy(p128) -- Line: 566
    p128._frame:Destroy();
end;

local u129 = {};
u129.__index = u129;

function u129.new() -- Line: 573
    -- upvalues: u129 (copy)
    return setmetatable({
        _left = nil,
        _right = nil,
        _screenWidth = 0,
        _screenHeight = 0
    }, u129);
end;

function u129.Build(p130, p131, p132, p133, p134) -- Line: 582
    p130._screenWidth = p132;
    p130._screenHeight = p133;
    local Frame = Instance.new("Frame");
    Frame.BackgroundColor3 = p134;
    Frame.BorderSizePixel = 0;
    Frame.AnchorPoint = Vector2.new(1, 0);
    Frame.Size = UDim2.fromOffset(0, p133);
    Frame.Visible = false;
    Frame.Parent = p131;
    p130._left = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.BackgroundColor3 = p134;
    Frame2.BorderSizePixel = 0;
    Frame2.AnchorPoint = Vector2.new(0, 0);
    Frame2.Size = UDim2.fromOffset(0, p133);
    Frame2.Visible = false;
    Frame2.Parent = p131;
    p130._right = Frame2;
end;

function u129.Prepare(p135, p136) -- Line: 605
    local v137 = math.floor(p135._screenWidth / 2);
    p135._left.Position = UDim2.fromOffset(v137, 0);
    p135._right.Position = UDim2.fromOffset(v137, 0);
end;

function u129.Update(p138, p139, p140) -- Line: 611
    if p140 ~= "In" then
        p139 = 1 - p139;
    end;

    local v141 = (math.ceil(p138._screenWidth / 2) + 2) * p139;
    local v142 = math.floor(v141);
    p138._left.Size = UDim2.fromOffset(v142, p138._screenHeight);
    p138._right.Size = UDim2.fromOffset(v142, p138._screenHeight);
    local v143 = p139 > 0.01;
    p138._left.Visible = v143;
    p138._right.Visible = v143;
end;

function u129.Show(p144) -- Line: 622
    local v145 = math.ceil(p144._screenWidth / 2) + 2;
    p144._left.Size = UDim2.fromOffset(v145, p144._screenHeight);
    p144._right.Size = UDim2.fromOffset(v145, p144._screenHeight);
    p144._left.Visible = true;
    p144._right.Visible = true;
end;

function u129.Hide(p146) -- Line: 630
    p146._left.Visible = false;
    p146._right.Visible = false;
end;

function u129.Destroy(p147) -- Line: 635
    p147._left:Destroy();
    p147._right:Destroy();
end;

local u148 = {};
u148.__index = u148;

function u148.new() -- Line: 643
    -- upvalues: u148 (copy)
    return setmetatable({
        _horizontal = nil,
        _vertical = nil,
        _screenWidth = 0,
        _screenHeight = 0
    }, u148);
end;

function u148.Build(p149, p150, p151, p152, p153) -- Line: 652
    p149._screenWidth = p151;
    p149._screenHeight = p152;
    local Frame = Instance.new("Frame");
    Frame.BackgroundColor3 = p153;
    Frame.BorderSizePixel = 0;
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.fromOffset(p151 / 2, p152 / 2);
    Frame.Visible = false;
    Frame.Parent = p150;
    p149._horizontal = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.BackgroundColor3 = p153;
    Frame2.BorderSizePixel = 0;
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.Position = UDim2.fromOffset(p151 / 2, p152 / 2);
    Frame2.Visible = false;
    Frame2.Parent = p150;
    p149._vertical = Frame2;
end;

function u148.Prepare(p154, p155) -- Line: 675
end;

function u148.Update(p156, p157, p158) -- Line: 677
    if p158 ~= "In" then
        p157 = 1 - p157;
    end;

    local v159 = math.floor(p156._screenWidth * p157);
    local v160 = math.floor(p156._screenHeight * p157);
    p156._horizontal.Size = UDim2.fromOffset(p156._screenWidth + 4, v160);
    p156._vertical.Size = UDim2.fromOffset(v159, p156._screenHeight + 4);
    local v161 = p157 > 0.01;
    p156._horizontal.Visible = v161;
    p156._vertical.Visible = v161;
end;

function u148.Show(p162) -- Line: 688
    p162._horizontal.Size = UDim2.fromOffset(p162._screenWidth + 4, p162._screenHeight);
    p162._vertical.Size = UDim2.fromOffset(p162._screenWidth, p162._screenHeight + 4);
    p162._horizontal.Visible = true;
    p162._vertical.Visible = true;
end;

function u148.Hide(p163) -- Line: 695
    p163._horizontal.Visible = false;
    p163._vertical.Visible = false;
end;

function u148.Destroy(p164) -- Line: 700
    p164._horizontal:Destroy();
    p164._vertical:Destroy();
end;

local u165 = {
    Fade = function() -- Line: 708, Name: Fade
        -- upvalues: u83 (copy)
        return u83.new();
    end,

    Iris = function() -- Line: 709, Name: Iris
        -- upvalues: u97 (copy)
        return u97.new("iris");
    end,

    Diamond = function() -- Line: 710, Name: Diamond
        -- upvalues: u97 (copy)
        return u97.new("diamond");
    end,

    Box = function() -- Line: 711, Name: Box
        -- upvalues: u97 (copy)
        return u97.new("box");
    end,

    LinearWipe = function() -- Line: 712, Name: LinearWipe
        -- upvalues: u114 (copy)
        return u114.new();
    end,

    Split = function() -- Line: 713, Name: Split
        -- upvalues: u129 (copy)
        return u129.new();
    end,

    CrossWipe = function() -- Line: 714, Name: CrossWipe
        -- upvalues: u148 (copy)
        return u148.new();
    end,

    Hexagon = function() -- Line: 715, Name: Hexagon
        -- upvalues: u6 (copy), u82 (copy)
        return u6.new(u82.HEXAGON);
    end,

    Triangle = function() -- Line: 716, Name: Triangle
        -- upvalues: u6 (copy), u82 (copy)
        return u6.new(u82.TRIANGLE);
    end,

    Tiles = function() -- Line: 717, Name: Tiles
        -- upvalues: u6 (copy), u82 (copy)
        return u6.new(u82.TILES);
    end,

    PolkaDots = function() -- Line: 718, Name: PolkaDots
        -- upvalues: u6 (copy), u82 (copy)
        return u6.new(u82.POLKA_DOTS);
    end,

    Blinds = function() -- Line: 719, Name: Blinds
        -- upvalues: u6 (copy), u82 (copy)
        return u6.new(u82.BLINDS);
    end,

    Checkerboard = function() -- Line: 720, Name: Checkerboard
        -- upvalues: u6 (copy), u82 (copy)
        return u6.new(u82.CHECKERBOARD);
    end,

    RandomTiles = function() -- Line: 721, Name: RandomTiles
        -- upvalues: u6 (copy), u82 (copy)
        return u6.new(u82.RANDOM_TILES);
    end
};
local v166 = table.freeze({
    Fade = "Fade",
    Iris = "Iris",
    Diamond = "Diamond",
    Box = "Box",
    LinearWipe = "LinearWipe",
    Split = "Split",
    CrossWipe = "CrossWipe",
    Hexagon = "Hexagon",
    Triangle = "Triangle",
    Tiles = "Tiles",
    PolkaDots = "PolkaDots",
    Blinds = "Blinds",
    Checkerboard = "Checkerboard",
    RandomTiles = "RandomTiles"
});
local v167 = table.freeze({
    In = "In",
    Out = "Out"
});
local v168 = table.freeze({
    Center = "Center",
    TopLeft = "TopLeft",
    BottomRight = "BottomRight"
});
local u169 = 0;
local u170 = {};
u170.__index = u170;

function u170.new(p171, p172) -- Line: 757
    -- upvalues: u169 (ref), u2 (copy), u170 (copy), RunService (copy)
    u169 = u169 + 1;
    local v173 = {
        _gui = nil,
        _activeEffect = nil,
        _playing = false,
        _destroyed = false,
        _elapsed = 0,
        _duration = 0,
        _direction = "In",
        _color = p172 and p172.color or u2,
        _effects = {},
        _renderStepName = "coolTransitions_render" .. "_" .. tostring(u169)
    };
    local u174 = setmetatable(v173, u170);
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "TransitionOverlay";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.DisplayOrder = p172 and p172.displayOrder or 99;
    ScreenGui.Enabled = false;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.Parent = p171;
    u174._gui = ScreenGui;
    RunService:BindToRenderStep(u174._renderStepName, Enum.RenderPriority.Camera.Value + 1, function(p175) -- Line: 782
        -- upvalues: u174 (copy)
        u174:_onRender(p175);
    end);

    return u174;
end;

function u170.IsPlaying(p176) -- Line: 789
    return p176._playing;
end;

function u170.Play(p177, p178, p179, p180, p181) -- Line: 793
    if p177._destroyed then
        error("TransitionManager has been destroyed");
    end;

    if p177._playing then
        p177._playing = false;

        if p177._activeEffect then
            p177._activeEffect:Hide();
        end;
    end;

    local v182 = p177:_getOrCreateEffect(p181 or "Hexagon");
    p177._activeEffect = v182;
    p177._gui.Enabled = true;
    v182:Prepare(p180 or "Center");
    p177._elapsed = 0;
    p177._duration = p179;
    p177._direction = p178;
    p177._playing = true;

    repeat
        task.wait();
    until not p177._playing;
end;

function u170.PlayInOut(p183, p184, p185, p186, p187, p188) -- Line: 825
    local v189 = p186 or "Center";
    local v190 = p187 or "Hexagon";
    p183:Play("In", p184 / 2, v189, v190);

    if p185 then
        p185();
    end;

    if p188 and p188 > 0 then
        task.wait(p188);
    end;

    p183:Play("Out", p184 / 2, v189, v190);
end;

function u170.Destroy(p191) -- Line: 844
    -- upvalues: RunService (copy)
    if p191._destroyed then
        return;
    end;

    p191._destroyed = true;
    RunService:UnbindFromRenderStep(p191._renderStepName);

    for _, v in p191._effects do
        v:Destroy();
    end;

    p191._effects = {};
    p191._gui:Destroy();
end;

function u170._onRender(p192, p193) -- Line: 856
    if not (p192._playing and p192._activeEffect) then
        return;
    end;

    p192._elapsed = p192._elapsed + p193;
    local v194 = math.clamp(p192._elapsed / p192._duration, 0, 1);
    local v195 = -(math.cos(3.141592653589793 * v194) - 1) / 2;
    p192._activeEffect:Update(v195, p192._direction);

    if v194 < 1 then
        return;
    end;

    p192._playing = false;

    if p192._direction == "Out" then
        p192._activeEffect:Hide();
        p192._gui.Enabled = false;
    end;
end;

function u170._getScreenSize(p196) -- Line: 875
    local Enabled = p196._gui.Enabled;

    if not Enabled then
        p196._gui.Enabled = true;
        task.wait();
    end;

    local X = p196._gui.AbsoluteSize.X;
    local Y = p196._gui.AbsoluteSize.Y;

    if not Enabled then
        p196._gui.Enabled = false;
    end;

    if X <= 0 or Y <= 0 then
        return 1920, 1080;
    end;

    return X, Y;
end;

function u170._getOrCreateEffect(p197, p198) -- Line: 892
    -- upvalues: u165 (copy)
    local v199 = p197._effects[p198];

    if v199 then
        return v199;
    end;

    local v200 = u165[p198];

    if not v200 then
        error("Unknown transition type: " .. p198);
    end;

    local v201 = v200();
    local v202, v203 = p197:_getScreenSize();
    v201:Build(p197._gui, v202, v203, p197._color);
    p197._effects[p198] = v201;

    return v201;
end;

return table.freeze({
    TransitionManager = u170,
    TransitionType = v166,
    TransitionDirection = v167,
    TransitionWaveOrigin = v168
});