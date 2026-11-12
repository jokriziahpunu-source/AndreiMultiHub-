--[[
    PAUL HUB v1.1
    Game: Throw a Food for Animals
    Layout: Black Side Panel
]]

-- ============ CONFIG ============
local CFG = {
    Name    = "PAUL HUB",
    Version = "v1.1",
    Accent  = Color3.fromRGB(255, 165, 0),
    BG      = Color3.fromRGB(18, 18, 24),
    Panel   = Color3.fromRGB(0, 0, 0),     -- Pure Black Sidebar
    Button  = Color3.fromRGB(30, 30, 35),
    Hover   = Color3.fromRGB(45, 45, 50),
    Text    = Color3.fromRGB(235, 235, 245),
    SubText = Color3.fromRGB(150, 150, 165),
    Good    = Color3.fromRGB(120, 220, 140),
    Bad     = Color3.fromRGB(230, 110, 110),
}

-- ============ SCRIPTS ============
local HUB_SCRIPTS = {
    {
        tab = "Keyless",
        scripts = {
            { name = "[Keyless] AQUA", url = "https://scriptblox.com/raw/Throw-Food-For-Animals-AQUA-HUB-or-AUTO-BEST-ANIMAL-AUTOFARM-AUTO-TRAIN-234234" },
            { name = "[Keyless] TORA (Auto Throw)", url = "https://raw.githubusercontent.com/gumanba/Scripts/main/ThrowFoodForAnimals" },
            { name = "[Keyless] AKKIWI", url = "https://akkiwi.com/h" },
            { name = "[Keyless] ANDREAN", url = "https://flowauth.net/v1/loaders/3953ac305b7855bd4108974b01f57bfd.lua" },
            { name = "[Keyless] MATRIX", url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/loader" },
        },
    },
}

-- ============ ENV ============
local UIS     = game:GetService("UserInputService")
local Players = game:GetService("Players")
local HS      = game:GetService("HttpService")
local Camera  = workspace.CurrentCamera
local LP      = Players.LocalPlayer
local TS      = game:GetService("TeleportService")

local function getParent()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return LP:WaitForChild("PlayerGui")
end

local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local parent = getParent()
if parent:FindFirstChild("PaulHub") then
    parent.PaulHub:Destroy()
end

-- ============ STATE ============
local State = {
    iconOn     = true,
    iconPos    = { x = 40, y = 120 },
    iconSize   = 56,
    multiThrow = false,
    throwSpeed = 0.05,
}

-- ============ GUI ============
local gui = create("ScreenGui", {
    Name = "PaulHub",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = parent,
})
if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end

local viewport = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
local winWidth  = math.min(500, math.max(350, viewport.X - 40))
local winHeight = math.min(380, math.max(300, viewport.Y - 80))

local main = create("Frame", {
    Name = "Main",
    Parent = gui,
    Size = UDim2.new(0, winWidth, 0, winHeight),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = CFG.BG,
    BorderSizePixel = 0,
    Active = true,
})
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = main })
create("UIStroke", { Color = CFG.Accent, Thickness = 1.5, Transparency = 0.6, Parent = main })

-- Header
local header = create("Frame", {
    Parent = main,
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = CFG.Panel,
    BorderSizePixel = 0,
})
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = header })
create("Frame", {
    Parent = header,
    Size = UDim2.new(1, 0, 0, 10),
    Position = UDim2.new(0, 0, 1, -10),
    BackgroundColor3 = CFG.Panel,
    BorderSizePixel = 0,
})

-- LOGO
create("ImageLabel", {
    Parent = header,
    Position = UDim2.new(0, 10, 0, 8),
    Size = UDim2.new(0, 20, 0, 20),
    BackgroundTransparency = 1,
    Image = "https://raw.githubusercontent.com/jokriziahpunu-source/AndreiMultiHub-/main/logo.png",
})

create("TextLabel", {
    Parent = header,
    Position = UDim2.new(0, 38, 0, 0),
    Size = UDim2.new(1, -140, 1, 0),
    BackgroundTransparency = 1,
    Text = CFG.Name .. "  " .. CFG.Version,
    TextColor3 = CFG.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
})

-- MINIMIZE BUTTON (-)
local minBtn = create("TextButton", {
    Parent = header,
    Position = UDim2.new(1, -65, 0, 8),
    Size = UDim2.new(0, 25, 0, 20),
    BackgroundColor3 = CFG.Button,
    Text = "-",
    TextColor3 = CFG.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    BorderSizePixel = 0,
})
create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = minBtn })
minBtn.MouseEnter:Connect(function() minBtn.BackgroundColor3 = CFG.Accent end)
minBtn.MouseLeave:Connect(function() minBtn.BackgroundColor3 = CFG.Button end)
minBtn.MouseButton1Click:Connect(function() 
    main.Visible = false
end)

-- CLOSE BUTTON (X)
local closeBtn = create("TextButton", {
    Parent = header,
    Position = UDim2.new(1, -35, 0, 8),
    Size = UDim2.new(0, 25, 0, 20),
    BackgroundColor3 = CFG.Button,
    Text = "X",
    TextColor3 = CFG.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BorderSizePixel = 0,
})
create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = closeBtn })
closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3 = CFG.Bad end)
closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3 = CFG.Button end)
closeBtn.MouseButton1Click:Connect(function() 
    gui:Destroy()
end)

-- Drag
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, main.Position
    end
end)
header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- Toast
local toastHolder = create("Frame", {
    Parent = gui,
    Position = UDim2.new(1, -20, 0, 20),
    AnchorPoint = Vector2.new(1, 0),
    Size = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
})
create("UIListLayout", { Parent = toastHolder, Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Right, SortOrder = Enum.SortOrder.LayoutOrder })

local function toast(msg, color)
    local t = create("Frame", { Parent = toastHolder, Size = UDim2.new(0, 240, 0, 36), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = t })
    create("UIStroke", { Color = color or CFG.Accent, Thickness = 1, Parent = t })
    create("TextLabel", {
        Parent = t, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -20, 1, 0),
        BackgroundTransparency = 1, Text = msg, TextColor3 = CFG.Text, Font = Enum.Font.Gotham, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    })
    task.delay(3, function()
        if not t.Parent then return end
        for i = 1, 20 do if not t.Parent then return end t.BackgroundTransparency = i / 20; task.wait(0.02) end
        if t.Parent then t:Destroy() end
    end)
end

-- Floating Icon
local icon = create("ImageButton", {
    Parent = gui, Size = UDim2.new(0, State.iconSize, 0, State.iconSize),
    Position = UDim2.new(0, State.iconPos.x, 1, -State.iconPos.y), AnchorPoint = Vector2.new(0, 1),
    BackgroundColor3 = CFG.Panel, BackgroundTransparency = 1, 
    Image = "https://raw.githubusercontent.com/jokriziahpunu-source/AndreiMultiHub-/main/logo.png",
    BorderSizePixel = 0, AutoButtonColor = false, Visible = State.iconOn, ZIndex = 10,
})
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = icon })
create("UIStroke", { Color = CFG.Accent, Thickness = 2, Parent = icon })

local iconDragging, iconDragStart, iconStartPos, iconMoved
icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        iconDragging, iconMoved, iconDragStart, iconStartPos = true, false, input.Position, icon.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if iconDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - iconDragStart
        if math.abs(d.X) > 4 or math.abs(d.Y) > 4 then iconMoved = true end
        icon.Position = UDim2.new(iconStartPos.X.Scale, iconStartPos.X.Offset + d.X, iconStartPos.Y.Scale, iconStartPos.Y.Offset + d.Y)
    end
end)
icon.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if iconDragging then
            iconDragging = false
            State.iconPos.x = icon.Position.X.Offset
            State.iconPos.y = -(icon.Position.Y.Offset)
        end
    end
end)

icon.MouseButton1Click:Connect(function()
    if iconMoved then return end
    main.Visible = not main.Visible
end)

-- ============ SIDEBAR & CONTENT ============
local sidebarWidth = 120
local sidebar = create("Frame", { Parent = main, Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(0, sidebarWidth, 1, -36), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = sidebar })
create("Frame", { Parent = sidebar, Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })
create("UIListLayout", { Parent = sidebar, Padding = UDim.new(0, 4), HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Top, SortOrder = Enum.SortOrder.LayoutOrder })
create("UIPadding", { PaddingTop = UDim.new(0, 10), Parent = sidebar })

local contentFrame = create("Frame", { Parent = main, Position = UDim2.new(0, sidebarWidth, 0, 36), Size = UDim2.new(1, -sidebarWidth, 1, -36), BackgroundTransparency = 1 })

local TAB_NAMES = { "Keyless", "Misc" }
local tabButtons = {}
for i, name in ipairs(TAB_NAMES) do
    local btn = create("TextButton", {
        Parent = sidebar, Size = UDim2.new(1, -16, 0, 32), BackgroundColor3 = CFG.Button,
        Text = name, TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0, AutoButtonColor = false, LayoutOrder = i,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    tabButtons[i] = btn
end

local content = create("ScrollingFrame", {
    Parent = contentFrame, Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(1, -20, 1, -32),
    BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4, ScrollBarImageColor3 = CFG.Accent, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
})
create("UIListLayout", { Parent = content, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })

local function clearContent()
    for _, c in ipairs(content:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextLabel") then c:Destroy() end end
end

local function makeButton(label, onClick)
    local btn = create("TextButton", {
        Parent = content, Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = CFG.Button, Text = "  " .. label,
        TextColor3 = CFG.Text, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0, AutoButtonColor = false,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = CFG.Hover end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = CFG.Button end)
    btn.MouseButton1Click:Connect(onClick)
    return btn
end

local function makeHeader(text)
    create("TextLabel", { Parent = content, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = text, TextColor3 = CFG.Accent, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left })
end

local function runScript(name, url)
    task.spawn(function()
        toast("Loading " .. name, CFG.SubText)
        local ok, err = pcall(function()
            local src = game:HttpGet(url)
            local fn = loadstring(src)
            if type(fn) ~= "function" then error("loadstring returned nil") end
            fn()
        end)
        if ok then toast(name .. " loaded", CFG.Good) else toast(name .. " failed", CFG.Bad); warn(err) end
    end)
end

-- ============ CORE LOGIC (Multi-Throw) ============
local lastThrow = 0
task.spawn(function()
    while task.wait() do
        if State.multiThrow then
            if tick() - lastThrow >= State.throwSpeed then
                local char = LP.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then pcall(function() tool:Activate() end) end
                    if mouse1click then pcall(mouse1click) end
                end
                lastThrow = tick()
            end
        end
    end
end)

-- ============ TAB RENDERERS ============
local function renderKeyless()
    clearContent()
    makeHeader("Available Scripts")
    for _, s in ipairs(HUB_SCRIPTS[1].scripts) do
        makeButton(s.name, function() runScript(s.name, s.url) end)
    end
end

local function renderMisc()
    clearContent()
    makeHeader("Auto Features")
    
    local throwBtn = makeButton("Multi Throw: " .. (State.multiThrow and "ON" or "OFF"), function() end)
    throwBtn.MouseButton1Click:Connect(function()
        State.multiThrow = not State.multiThrow
        throwBtn.Text = "  Multi Throw: " .. (State.multiThrow and "ON" or "OFF")
        throwBtn.TextColor3 = State.multiThrow and CFG.Good or CFG.Text
    end)
    throwBtn.TextColor3 = State.multiThrow and CFG.Good or CFG.Text

    local speedBtn = makeButton("Throw Speed: " .. State.throwSpeed .. "s", function() end)
    speedBtn.MouseButton1Click:Connect(function()
        local speeds = { 0.5, 0.2, 0.1, 0.05, 0.01 }
        local idx = 1
        for i, v in ipairs(speeds) do if v == State.throwSpeed then idx = i % #speeds + 1 break end end
        State.throwSpeed = speeds[idx]
        speedBtn.Text = "  Throw Speed: " .. State.throwSpeed .. "s"
    end)

    makeHeader("Server Hop")
    makeButton("Server Hop (Low Players)", function()
        local servers = HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
        table.sort(servers, function(a,b) return a.playing < b.playing end)
        for _, s in ipairs(servers) do
            if s.id ~= game.JobId and s.playing < s.maxPlayers then
                TS:TeleportToPlaceInstance(game.PlaceId, s.id, LP)
                break
            end
        end
    end)

    makeHeader("Community")
    makeButton("Join Discord", function()
        local discordLink = "https://discord.gg/c3WbTW4Hc"
        if setclipboard then
            setclipboard(discordLink)
            toast("Discord link copied!", CFG.Good)
        elseif toclipboard then
            toclipboard(discordLink)
            toast("Discord link copied!", CFG.Good)
        else
            toast("Link: " .. discordLink, CFG.SubText)
        end
    end)
end

local function showTab(idx)
    for i, btn in ipairs(tabButtons) do btn.BackgroundColor3 = (i == idx) and CFG.Accent or CFG.Button end
    if TAB_NAMES[idx] == "Keyless" then renderKeyless() else renderMisc() end
end

for i, btn in ipairs(tabButtons) do btn.MouseButton1Click:Connect(function() showTab(i) end) end

showTab(1)
toast(CFG.Name .. " " .. CFG.Version .. " ready", CFG.Accent)