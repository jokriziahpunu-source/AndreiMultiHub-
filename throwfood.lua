--[[
    PAUL HUB PRO (Throw a Food for Animals)
    Version: v3.0 (External Scripts + Draggable Toggle)
]]

-- KILL SWITCH: Pinapatay nito yung mga lumang script na tumatakbo sa background
if getgenv().PaulHubRunning then
    getgenv().PaulHubRunning = false
    task.wait(0.2) 
end
getgenv().PaulHubRunning = true

local CFG = {
    Name    = "PAUL HUB PRO",
    Version = "v3.0",
    Accent  = Color3.fromRGB(0, 150, 255), -- Blue Theme
    BG      = Color3.fromRGB(10, 15, 25),
    Panel   = Color3.fromRGB(5, 10, 20), 
    Button  = Color3.fromRGB(20, 30, 45),
    Hover   = Color3.fromRGB(30, 45, 65),
    Text    = Color3.fromRGB(235, 235, 245),
    Good    = Color3.fromRGB(120, 220, 140),
}

-- ============ EXTERNAL SCRIPTS ============
local HUB_SCRIPTS = {
    {
        tab = "Keyless",
        scripts = {
            { name = "[Keyless] TORA (Auto Throw)", url = "https://raw.githubusercontent.com/gumanba/Scripts/main/ThrowFoodForAnimals" },
            { name = "[Keyless] AKKIWI", url = "https://akkiwi.com/h" },
            { name = "[Keyless] ANDREAN", url = "https://flowauth.net/v1/loaders/3953ac305b7855bd4108974b01f57bfd.lua" },
            { name = "[Keyless] MATRIX", url = "https://raw.githubusercontent.com/ummarxfarooq/mystrix-hub/refs/heads/main/loader" },
            { name = "[Keyless] AQUA", url = "https://scriptblox.com/raw/Throw-Food-For-Animals-AQUA-HUB-or-AUTO-BEST-ANIMAL-AUTOFARM-AUTO-TRAIN-234234" },
        },
    },
}

local UIS     = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Camera  = workspace.CurrentCamera
local LP      = Players.LocalPlayer
local HS      = game:GetService("HttpService")
local TS      = game:GetService("TeleportService")

local function getParent() if gethui then return gethui() end return LP:WaitForChild("PlayerGui") end
local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do if k ~= "Parent" then inst[k] = v end end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local parent = getParent()
for _, name in ipairs({"PaulHubPro", "PaulThrowHub", "CustomAndreanHub"}) do
    local old = parent:FindFirstChild(name)
    if old then old:Destroy() end
end

local gui = create("ScreenGui", { Name = "PaulHubPro", ResetOnSpawn = false, Parent = parent })
if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end

local viewport = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
local winWidth  = math.min(500, math.max(350, viewport.X - 40))
local winHeight = math.min(380, math.max(300, viewport.Y - 80))

local main = create("Frame", {
    Name = "Main", Parent = gui, Size = UDim2.new(0, winWidth, 0, winHeight),
    Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = CFG.BG, BorderSizePixel = 0, Active = true,
})
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = main })
create("UIStroke", { Color = CFG.Accent, Thickness = 1.5, Parent = main })

-- Header
local header = create("Frame", { Parent = main, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = header })
create("Frame", { Parent = header, Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })

-- TEXT LOGO (Header)
local headerLogo = create("TextLabel", {
    Parent = header, Position = UDim2.new(0, 10, 0, 8), Size = UDim2.new(0, 24, 0, 24),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), Text = "PH",
    TextColor3 = CFG.Accent, Font = Enum.Font.GothamBlack, TextSize = 10,
    BorderSizePixel = 0,
})
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = headerLogo })
create("UIStroke", { Color = CFG.Accent, Thickness = 1, Parent = headerLogo })

create("TextLabel", {
    Parent = header, Position = UDim2.new(0, 42, 0, 0), Size = UDim2.new(1, -70, 1, 0),
    BackgroundTransparency = 1, Text = CFG.Name .. "  " .. CFG.Version, TextColor3 = CFG.Text,
    Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
})

-- MINIMIZE BUTTON (-)
local minBtn = create("TextButton", { Parent = header, Position = UDim2.new(1, -70, 0, 8), Size = UDim2.new(0, 30, 0, 20), BackgroundColor3 = CFG.Button, Text = "-", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 20, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = minBtn })
minBtn.MouseButton1Click:Connect(function() main.Visible = false end) -- Magtatago lang

-- CLOSE BUTTON (X)
local closeBtn = create("TextButton", { Parent = header, Position = UDim2.new(1, -35, 0, 8), Size = UDim2.new(0, 30, 0, 20), BackgroundColor3 = CFG.Button, Text = "X", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 14, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = closeBtn })
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end) -- Magtatago lang din

-- Drag Main
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

-- ============ FLOATING ICON (TEXT LOGO) ============
local icon = create("TextButton", {
    Parent = gui, Size = UDim2.new(0, 55, 0, 55), 
    Position = UDim2.new(0, 20, 0.5, -27), 
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), 
    Text = "PAUL\nHUB", 
    TextColor3 = CFG.Accent, 
    Font = Enum.Font.GothamBlack,
    TextSize = 11,
    TextWrapped = true,
    BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 100, Active = true
})
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = icon }) 
create("UIStroke", { Color = CFG.Accent, Thickness = 2, Parent = icon })

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
local sidebarWidth = 120
local sidebar = create("Frame", { Parent = main, Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(0, sidebarWidth, 1, -36), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = sidebar })
create("Frame", { Parent = sidebar, Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })

local contentFrame = create("Frame", { Parent = main, Position = UDim2.new(0, sidebarWidth, 0, 36), Size = UDim2.new(1, -sidebarWidth, 1, -36), BackgroundTransparency = 1 })
local TAB_NAMES = { "Keyless", "Misc" }
local tabButtons = {}
for i, name in ipairs(TAB_NAMES) do
    local btn = create("TextButton", { Parent = sidebar, Size = UDim2.new(1, -16, 0, 32), Position = UDim2.new(0, 8, 0, 10 + ((i-1) * 36)), BackgroundColor3 = CFG.Button, Text = name, TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    tabButtons[i] = btn
end

local discordBtn = create("TextButton", { Parent = sidebar, Size = UDim2.new(1, -16, 0, 34), Position = UDim2.new(0, 8, 1, -44), BackgroundColor3 = CFG.Button, Text = "Join Discord", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = discordBtn })
discordBtn.MouseButton1Click:Connect(function() if setclipboard then setclipboard("https://discord.gg/Ukw8abnmH") end game.StarterGui:SetCore("SendNotification", {Title="Discord"; Text="Link Copied!"; Duration=2}) end)

local content = create("ScrollingFrame", { Parent = contentFrame, Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(1, -20, 1, -20), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4, ScrollBarImageColor3 = CFG.Accent, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y })
create("UIListLayout", { Parent = content, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })

local function clearContent() for _, c in ipairs(content:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextLabel") then c:Destroy() end end end
local function makeButton(label, onClick)
    local btn = create("TextButton", { Parent = content, Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = CFG.Button, Text = "  " .. label, TextColor3 = CFG.Text, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    btn.MouseButton1Click:Connect(onClick)
    return btn
end
local function makeHeader(text) create("TextLabel", { Parent = content, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = text, TextColor3 = CFG.Accent, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left }) end

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
            warn("[" .. CFG.Name .. "] " .. name .. " failed: " .. tostring(err))
        end
    end)
end

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
        local success, response = pcall(function() return HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")) end)
        if success and response and response.data then
            table.sort(response.data, function(a,b) return a.playing < b.playing end)
            for _, s in ipairs(response.data) do if s.id ~= game.JobId and s.playing < s.maxPlayers then TS:TeleportToPlaceInstance(game.PlaceId, s.id, LP) break end end
        end
    end)
end

local function showTab(idx)
    for i, btn in ipairs(tabButtons) do btn.BackgroundColor3 = (i == idx) and CFG.Accent or CFG.Button btn.TextColor3 = (i == idx) and Color3.new(1,1,1) or CFG.Text end
    if TAB_NAMES[idx] == "Keyless" then renderKeyless() else renderMisc() end
end
for i, btn in ipairs(tabButtons) do btn.MouseButton1Click:Connect(function() showTab(i) end) end

showTab(1)