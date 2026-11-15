--[[
    PAUL HUB [RIVALS]
    Version: v3.0
    Theme: Rainbow
]]

if getgenv().PaulHubRunning then
    getgenv().PaulHubRunning = false
    task.wait(0.2) 
end
getgenv().PaulHubRunning = true

local CFG = {
    Name    = "PAUL HUB",
    Version = "v3.0",
    BG      = Color3.fromRGB(15, 15, 20),
    Panel   = Color3.fromRGB(10, 10, 15), 
    Button  = Color3.fromRGB(25, 25, 35),
    Text    = Color3.fromRGB(235, 235, 245),
    Good    = Color3.fromRGB(120, 220, 140),
}

-- ============ EXTERNAL SCRIPTS ============
local HUB_SCRIPTS = {
    {
        tab = "Keyless",
        scripts = {
            { name = "[Keyless] AHTer Hub", url = "https://scriptblox.com/raw/RIVALS-Atherhub-Wallbang-Desync-Anti-Hit-LegitBot-RageBot-76091" },
            { name = "[Keyless] Korax", url = "https://scriptblox.com/raw/RIVALS-Korax-226484" },
            { name = "[Keyless] Soluna", url = "https://soluna-script.vercel.app/main.lua" },
            { name = "[Keyless] KiciaHook V2", url = "https://rawscripts.net/raw/RIVALS-KiciaHook-V2-185835" },
        },
    },
}

-- ============ ENV ============
local UIS     = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Camera  = workspace.CurrentCamera
local LP      = Players.LocalPlayer
local HS      = game:GetService("HttpService")
local TS      = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local State = { SpeedEnabled = false, JumpEnabled = false, SpeedValue = 16, JumpValue = 50 }

local function getParent() if gethui then return gethui() end return LP:WaitForChild("PlayerGui") end
local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do if k ~= "Parent" then inst[k] = v end end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local parent = getParent()
for _, name in ipairs({"PaulHubPro", "PaulHubRivals"}) do
    local old = parent:FindFirstChild(name)
    if old then old:Destroy() end
end

local gui = create("ScreenGui", { Name = "PaulHubRivals", ResetOnSpawn = false, Parent = parent })
if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end

local viewport = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
local winWidth  = math.min(420, math.max(320, viewport.X - 40))
local winHeight = math.min(380, math.max(280, viewport.Y - 80))

-- RAINBOW GRADIENT FUNCTION
local function applyRainbow(instance)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
    })
    gradient.Parent = instance
    
    -- Animate rainbow
    task.spawn(function()
        while gui.Parent do
            gradient.Rotation = (gradient.Rotation + 1) % 360
            task.wait(0.03)
        end
    end)
    return gradient
end

local main = create("Frame", {
    Name = "Main", Parent = gui, Size = UDim2.new(0, winWidth, 0, winHeight),
    Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = CFG.BG, BorderSizePixel = 0, Active = true,
})
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = main })
local mainStroke = create("UIStroke", { Thickness = 2, Parent = main })
applyRainbow(mainStroke)

-- Header
local header = create("Frame", { Parent = main, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = header })
create("Frame", { Parent = header, Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })

local headerLogo = create("TextLabel", {
    Parent = header, Position = UDim2.new(0, 10, 0, 8), Size = UDim2.new(0, 24, 0, 24),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), Text = "PH",
    TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0,
})
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = headerLogo })
local logoStroke = create("UIStroke", { Thickness = 1.5, Parent = headerLogo })
applyRainbow(logoStroke)

create("TextLabel", {
    Parent = header, Position = UDim2.new(0, 42, 0, 0), Size = UDim2.new(1, -70, 1, 0),
    BackgroundTransparency = 1, Text = CFG.Name .. "  " .. CFG.Version, TextColor3 = CFG.Text,
    Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
})

-- MINIMIZE BUTTON (-)
local minBtn = create("TextButton", { Parent = header, Position = UDim2.new(1, -70, 0, 8), Size = UDim2.new(0, 30, 0, 20), BackgroundColor3 = CFG.Button, Text = "-", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 20, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = minBtn })
minBtn.MouseButton1Click:Connect(function() main.Visible = false end)

-- CLOSE BUTTON (X)
local closeBtn = create("TextButton", { Parent = header, Position = UDim2.new(1, -35, 0, 8), Size = UDim2.new(0, 30, 0, 20), BackgroundColor3 = CFG.Button, Text = "X", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 14, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = closeBtn })
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

-- Drag Main Window
local dragMain, startMain, posMain
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragMain, startMain, posMain = true, input.Position, main.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragMain and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - startMain
        main.Position = UDim2.new(posMain.X.Scale, posMain.X.Offset + d.X, posMain.Y.Scale, posMain.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragMain = false end end)

-- FLOATING ICON (DRAGGABLE & READABLE TEXT)
local icon = create("TextButton", {
    Parent = gui, Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(0, 20, 0.5, -30), 
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), Text = "PAUL\nHUB", TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold, TextSize = 12, TextWrapped = true, BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 100, Active = true
})
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = icon }) 
local iconStroke = create("UIStroke", { Thickness = 2.5, Parent = icon })
applyRainbow(iconStroke)

local dragIcon, startIcon, posIcon, iconMoved
icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragIcon, iconMoved, startIcon, posIcon = true, false, input.Position, icon.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragIcon and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - startIcon
        if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then iconMoved = true end
        icon.Position = UDim2.new(posIcon.X.Scale, posIcon.X.Offset + d.X, posIcon.Y.Scale, posIcon.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragIcon = false end end)

icon.MouseButton1Click:Connect(function()
    if iconMoved then return end 
    main.Visible = not main.Visible 
end)

-- SIDEBAR
local sidebarWidth = 110
local sidebar = create("Frame", { Parent = main, Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(0, sidebarWidth, 1, -36), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = sidebar })
create("Frame", { Parent = sidebar, Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })

local contentFrame = create("Frame", { Parent = main, Position = UDim2.new(0, sidebarWidth, 0, 36), Size = UDim2.new(1, -sidebarWidth, 1, -36), BackgroundTransparency = 1 })
local TAB_NAMES = { "Keyless", "Misc", "Discord" }
local tabButtons = {}
for i, name in ipairs(TAB_NAMES) do
    local btn = create("TextButton", { Parent = sidebar, Size = UDim2.new(1, -16, 0, 32), Position = UDim2.new(0, 8, 0, 10 + ((i-1) * 36)), BackgroundColor3 = CFG.Button, Text = name, TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    tabButtons[i] = btn
end

local content = create("ScrollingFrame", { Parent = contentFrame, Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(1, -20, 1, -20), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y })
create("UIListLayout", { Parent = content, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })

local function clearContent() for _, c in ipairs(content:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextLabel") or c:IsA("Frame") or c:IsA("TextBox") then c:Destroy() end end end
local function makeButton(label, onClick)
    local btn = create("TextButton", { Parent = content, Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = CFG.Button, Text = "  " .. label, TextColor3 = CFG.Text, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    btn.MouseButton1Click:Connect(onClick)
    return btn
end
local function makeHeader(text) create("TextLabel", { Parent = content, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = text, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left }) end

local function runScript(name, url)
    game.StarterGui:SetCore("SendNotification", {Title="Paul Hub"; Text="Loading " .. name .. "..."; Duration=2})
    task.spawn(function()
        local ok, err = pcall(function()
            local src = game:HttpGet(url)
            local fn = loadstring(src)
            if type(fn) ~= "function" then error("loadstring returned nil") end
            fn()
        end)
        if not ok then
            game.StarterGui:SetCore("SendNotification", {Title="Paul Hub"; Text="Failed to load " .. name; Duration=3})
        end
    end)
end

-- RENDERERS
local function renderKeyless()
    clearContent()
    makeHeader("Available Scripts")
    for _, s in ipairs(HUB_SCRIPTS[1].scripts) do
        makeButton(s.name, function() runScript(s.name, s.url) end)
    end
end

local function renderMisc()
    clearContent()
    makeHeader("Character Mods")
    
    local spdFrame = create("Frame", { Parent = content, Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1 })
    local spdLabel = create("TextLabel", { Parent = spdFrame, Size = UDim2.new(0.25, 0, 1, 0), BackgroundColor3 = CFG.Button, Text = "Speed", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = spdLabel })
    local spdBox = create("TextBox", { Parent = spdFrame, Position = UDim2.new(0.27, 0, 0, 0), Size = UDim2.new(0.35, 0, 1, 0), BackgroundColor3 = CFG.Button, Text = tostring(State.SpeedValue), TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = spdBox })
    spdBox.FocusLost:Connect(function()
        local val = tonumber(spdBox.Text)
        if val and val >= 1 and val <= 1000 then State.SpeedValue = val else spdBox.Text = tostring(State.SpeedValue) end
    end)
    local spdBtn = create("TextButton", { Parent = spdFrame, Position = UDim2.new(0.64, 0, 0, 0), Size = UDim2.new(0.36, 0, 1, 0), BackgroundColor3 = State.SpeedEnabled and CFG.Good or CFG.Button, Text = (State.SpeedEnabled and "ON" or "OFF"), TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = spdBtn })
    spdBtn.MouseButton1Click:Connect(function()
        State.SpeedEnabled = not State.SpeedEnabled
        spdBtn.Text = (State.SpeedEnabled and "ON" or "OFF")
        spdBtn.BackgroundColor3 = State.SpeedEnabled and CFG.Good or CFG.Button
    end)

    local jmpFrame = create("Frame", { Parent = content, Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1 })
    local jmpLabel = create("TextLabel", { Parent = jmpFrame, Size = UDim2.new(0.25, 0, 1, 0), BackgroundColor3 = CFG.Button, Text = "Jump", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = jmpLabel })
    local jmpBox = create("TextBox", { Parent = jmpFrame, Position = UDim2.new(0.27, 0, 0, 0), Size = UDim2.new(0.35, 0, 1, 0), BackgroundColor3 = CFG.Button, Text = tostring(State.JumpValue), TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = jmpBox })
    jmpBox.FocusLost:Connect(function()
        local val = tonumber(jmpBox.Text)
        if val and val >= 1 and val <= 1000 then State.JumpValue = val else jmpBox.Text = tostring(State.JumpValue) end
    end)
    local jmpBtn = create("TextButton", { Parent = jmpFrame, Position = UDim2.new(0.64, 0, 0, 0), Size = UDim2.new(0.36, 0, 1, 0), BackgroundColor3 = State.JumpEnabled and CFG.Good or CFG.Button, Text = (State.JumpEnabled and "ON" or "OFF"), TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = jmpBtn })
    jmpBtn.MouseButton1Click:Connect(function()
        State.JumpEnabled = not State.JumpEnabled
        jmpBtn.Text = (State.JumpEnabled and "ON" or "OFF")
        jmpBtn.BackgroundColor3 = State.JumpEnabled and CFG.Good or CFG.Button
    end)
end

local function renderDiscord()
    clearContent()
    makeHeader("Join our Community")
    
    local linkLabel = create("TextBox", { 
        Parent = content, 
        Size = UDim2.new(1, 0, 0, 40), 
        BackgroundColor3 = CFG.Button, 
        Text = "https://discord.gg/Ukw8abnmH", 
        TextColor3 = Color3.fromRGB(100, 200, 255), 
        Font = Enum.Font.GothamBold, 
        TextSize = 14, 
        TextWrapped = true,
        ClearTextOnFocus = false,
        BorderSizePixel = 0 
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = linkLabel })
    
    local copyBtn = create("TextButton", { Parent = content, Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = CFG.Good, Text = "Copy Link", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = copyBtn })
    copyBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard("https://discord.gg/Ukw8abnmH") end
        copyBtn.Text = "Copied!"
        task.wait(2)
        copyBtn.Text = "Copy Link"
    end)
end

local function showTab(idx)
    for i, btn in ipairs(tabButtons) do 
        btn.BackgroundColor3 = (i == idx) and CFG.Button or CFG.Panel
        btn.TextColor3 = (i == idx) and Color3.new(1,1,1) or CFG.Text
    end
    if TAB_NAMES[idx] == "Keyless" then renderKeyless()
    elseif TAB_NAMES[idx] == "Misc" then renderMisc()
    elseif TAB_NAMES[idx] == "Discord" then renderDiscord() end
end
for i, btn in ipairs(tabButtons) do btn.MouseButton1Click:Connect(function() showTab(i) end) end

-- LOGIC LOOP
RunService.Heartbeat:Connect(function()
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if State.SpeedEnabled and hum.WalkSpeed ~= State.SpeedValue then hum.WalkSpeed = State.SpeedValue end
            if State.JumpEnabled then hum.UseJumpPower = true; if hum.JumpPower ~= State.JumpValue then hum.JumpPower = State.JumpValue end end
        end
    end
end)

showTab(1)