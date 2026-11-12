--[[
    PAUL HUB v1.5 (RIVALS)
    Game: RIVALS
]]

-- ============ CONFIG ============
local CFG = {
    Name    = "PAUL HUB",
    Version = "v1.5",
    Accent  = Color3.fromRGB(255, 100, 0), 
    BG      = Color3.fromRGB(15, 15, 20),
    Panel   = Color3.fromRGB(0, 0, 0), -- Pure Black Sidebar
    Button  = Color3.fromRGB(30, 30, 35),
    Hover   = Color3.fromRGB(50, 50, 60),
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
            { name = "[Keyless] AHTER HUB", url = "https://scriptblox.com/raw/RIVALS-Atherhub-Wallbang-Desync-Anti-Hit-LegitBot-RageBot-76091" },
            { name = "[Keyless] KORAX", url = "https://scriptblox.com/raw/RIVALS-Korax-226484" },
            { name = "[Keyless] SOLUNA", url = "https://soluna-script.vercel.app/main.lua" },
            { name = "[Keyless] KICIA HOOK V2", url = "https://rawscripts.net/raw/RIVALS-KiciaHook-V2-185835" },
        },
    },
}

-- ============ ENV ============
local UIS     = game:GetService("UserInputService")
local Players = game:GetService("Players")
local HS      = game:GetService("HttpService")
local TS      = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local Camera  = workspace.CurrentCamera
local LP      = Players.LocalPlayer

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
if parent:FindFirstChild("PaulHubRivals") then
    parent.PaulHubRivals:Destroy()
end

-- ============ STATE ============
local State = {
    iconOn     = true,
    iconPos    = { x = 40, y = 120 },
    iconSize   = 56,
}

-- ============ GUI ============
local gui = create("ScreenGui", {
    Name = "PaulHubRivals",
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

-- ANIME EFFECT: Pulsing Chakra Border
local mainStroke = create("UIStroke", { Color = CFG.Accent, Thickness = 2, Transparency = 0.2, Parent = main })
task.spawn(function()
    while gui.Parent do
        TweenService:Create(mainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.7, Thickness = 1.5}):Play()
        task.wait(1.5)
        TweenService:Create(mainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1, Thickness = 2.5}):Play()
        task.wait(1.5)
    end
end)

-- Header
local header = create("Frame", {
    Parent = main,
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = CFG.Panel,
    BorderSizePixel = 0,
})
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = header })
create("Frame", { Parent = header, Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })

-- ANIME EFFECT: Flowing Gradient (Chakra)
local headerGradient = create("UIGradient", {
    Parent = header,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)), 
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 0)), 
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 255))
    }),
    Rotation = 0
})
task.spawn(function()
    while gui.Parent do
        headerGradient.Rotation = (headerGradient.Rotation + 1) % 360
        task.wait(0.03)
    end
end)

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
    ZIndex = 2
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
    ZIndex = 2
})
create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = minBtn })
minBtn.MouseEnter:Connect(function() minBtn.BackgroundColor3 = CFG.Accent end)
minBtn.MouseLeave:Connect(function() minBtn.BackgroundColor3 = CFG.Button end)
minBtn.MouseButton1Click:Connect(function() main.Visible = false end)

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
    ZIndex = 2
})
create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = closeBtn })
closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3 = CFG.Bad end)
closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3 = CFG.Button end)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

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

-- ============ DARK DISCORD BUTTON ============
local discordBtn = create("TextButton", {
    Parent = sidebar,
    Size = UDim2.new(1, -16, 0, 34),
    Position = UDim2.new(0, 8, 1, -44), 
    BackgroundColor3 = CFG.Button, -- Dark gray, bagay sa sidebar
    Text = "",
    BorderSizePixel = 0,
    AutoButtonColor = false,
    ZIndex = 2
})
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = discordBtn })

-- Discord Icon (Gamit ang mas standard na ID)
local dcIcon = create("ImageLabel", {
    Parent = discordBtn,
    Position = UDim2.new(0, 8, 0.5, -9),
    Size = UDim2.new(0, 18, 0, 18),
    BackgroundTransparency = 1,
    Image = "rbxassetid://13885149324", 
    ImageColor3 = Color3.fromRGB(150, 150, 165),
})

-- Discord Text
create("TextLabel", {
    Parent = discordBtn,
    Position = UDim2.new(0, 30, 0, 0),
    Size = UDim2.new(1, -30, 1, 0),
    BackgroundTransparency = 1,
    Text = "Discord",
    TextColor3 = CFG.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
})

discordBtn.MouseEnter:Connect(function() 
    discordBtn.BackgroundColor3 = CFG.Hover
    dcIcon.ImageColor3 = Color3.fromRGB(88, 101, 242) -- Nag-blurple pag hover
end)
discordBtn.MouseLeave:Connect(function() 
    discordBtn.BackgroundColor3 = CFG.Button
    dcIcon.ImageColor3 = Color3.fromRGB(150, 150, 165)
end)
discordBtn.MouseButton1Click:Connect(function()
    local link = "https://discord.gg/Ukw8abnmH"
    if setclipboard then setclipboard(link); toast("Discord link copied!", CFG.Good)
    elseif toclipboard then toclipboard(link); toast("Discord link copied!", CFG.Good)
    else toast("Link: " .. link, CFG.SubText) end
end)

-- ============ CONTENT ============
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
    
    local stroke = create("UIStroke", { Color = CFG.Accent, Thickness = 1, Transparency = 1, Parent = btn })
    btn.MouseEnter:Connect(function() 
        btn.BackgroundColor3 = CFG.Hover 
        TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function() 
        btn.BackgroundColor3 = CFG.Button 
        TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
    end)
    
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
end

local function showTab(idx)
    for i, btn in ipairs(tabButtons) do 
        btn.BackgroundColor3 = (i == idx) and CFG.Accent or CFG.Button 
        btn.TextColor3 = (i == idx) and Color3.new(1,1,1) or CFG.Text
    end
    if TAB_NAMES[idx] == "Keyless" then renderKeyless() else renderMisc() end
end

for i, btn in ipairs(tabButtons) do btn.MouseButton1Click:Connect(function() showTab(i) end) end

showTab(1)
toast(CFG.Name .. " " .. CFG.Version .. " ready", CFG.Accent)