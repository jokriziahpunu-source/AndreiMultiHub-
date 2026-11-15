--[[
    PAUL HUB [RIVALS] - Codium Style
    Version: v2.0
    Theme: Blue
]]

if getgenv().PaulHubRunning then
    getgenv().PaulHubRunning = false
    task.wait(0.2) 
end
getgenv().PaulHubRunning = true

local CFG = {
    Name    = "PAUL HUB",
    Version = "v2.0",
    Accent  = Color3.fromRGB(0, 150, 255), -- Blue Theme
    BG      = Color3.fromRGB(15, 15, 20),
    Panel   = Color3.fromRGB(10, 10, 15), 
    Button  = Color3.fromRGB(25, 25, 35),
    Text    = Color3.fromRGB(235, 235, 245),
    SubText = Color3.fromRGB(150, 150, 165),
    Good    = Color3.fromRGB(0, 150, 255),
}

-- ============ EXTERNAL SCRIPTS ============
local HUB_SCRIPTS = {
    { name = "AHTer Hub", url = "https://scriptblox.com/raw/RIVALS-Atherhub-Wallbang-Desync-Anti-Hit-LegitBot-RageBot-76091" },
    { name = "Korax", url = "https://scriptblox.com/raw/RIVALS-Korax-226484" },
    { name = "Soluna", url = "https://soluna-script.vercel.app/main.lua" },
    { name = "KiciaHook V2", url = "https://rawscripts.net/raw/RIVALS-KiciaHook-V2-185835" },
}

-- ============ ENV ============
local UIS     = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Camera  = workspace.CurrentCamera
local LP      = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

local function getParent() if gethui then return gethui() end return LP:WaitForChild("PlayerGui") end
local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do if k ~= "Parent" then inst[k] = v end end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local parent = getParent()
for _, name in ipairs({"PaulHubCodium"}) do
    local old = parent:FindFirstChild(name)
    if old then old:Destroy() end
end

local gui = create("ScreenGui", { Name = "PaulHubCodium", ResetOnSpawn = false, Parent = parent })
if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end

local main = create("Frame", {
    Name = "Main", Parent = gui, Size = UDim2.new(0, 520, 0, 380),
    Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = CFG.BG, BorderSizePixel = 0, Active = true,
})
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = main })
create("UIStroke", { Color = CFG.Panel, Thickness = 1, Parent = main })

-- ============ HEADER ============
local header = create("Frame", { Parent = main, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = header })
create("Frame", { Parent = header, Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })

-- Blue Logo at Name
create("ImageLabel", {
    Parent = header, Position = UDim2.new(0, 10, 0, 8), Size = UDim2.new(0, 24, 0, 24),
    BackgroundTransparency = 1, Image = "https://raw.githubusercontent.com/jokriziahpunu-source/AndreiMultiHub-/main/logo.png", -- Papalitan natin ito ng blue sa susunod kung gusto mo
    ImageColor3 = CFG.Accent, -- Naka-tint ng blue
})
create("TextLabel", {
    Parent = header, Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(0, 150, 1, 0),
    BackgroundTransparency = 1, Text = CFG.Name, TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left,
})

-- Search Bar
local searchBar = create("Frame", { Parent = header, Position = UDim2.new(1, -310, 0, 8), Size = UDim2.new(0, 180, 0, 24), BackgroundColor3 = CFG.Button })
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = searchBar })
create("TextLabel", { Parent = searchBar, Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "🔍 Search...", TextColor3 = CFG.SubText, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left })

-- Minimize & Close
local minBtn = create("TextButton", { Parent = header, Position = UDim2.new(1, -70, 0, 10), Size = UDim2.new(0, 24, 0, 20), BackgroundTransparency = 1, Text = "-", TextColor3 = CFG.SubText, Font = Enum.Font.GothamBold, TextSize = 20 })
local closeBtn = create("TextButton", { Parent = header, Position = UDim2.new(1, -35, 0, 10), Size = UDim2.new(0, 24, 0, 20), BackgroundTransparency = 1, Text = "X", TextColor3 = CFG.SubText, Font = Enum.Font.GothamBold, TextSize = 14 })

minBtn.MouseButton1Click:Connect(function() main.Visible = false end)
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

-- ============ SIDEBAR ============
local sidebar = create("Frame", { Parent = main, Position = UDim2.new(0, 0, 0, 40), Size = UDim2.new(0, 130, 1, -40), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = sidebar })

local function sidebarBtn(text, yPos, active)
    local btn = create("TextButton", { Parent = sidebar, Position = UDim2.new(0, 10, 0, yPos), Size = UDim2.new(1, -20, 0, 32), BackgroundColor3 = active and CFG.Button or CFG.Panel, Text = "   " .. text, TextColor3 = active and CFG.Accent or CFG.SubText, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    return btn
end

local btnScripts = sidebarBtn("Keyless", 10, true)
local btnMisc = sidebarBtn("Misc", 50, false)

-- ============ CONTENT AREA ============
local contentArea = create("Frame", { Parent = main, Position = UDim2.new(0, 130, 0, 40), Size = UDim2.new(1, -130, 1, -40), BackgroundTransparency = 1 })

-- Top Tabs
local tabBar = create("Frame", { Parent = contentArea, Position = UDim2.new(0, 15, 0, 10), Size = UDim2.new(1, -30, 0, 30), BackgroundTransparency = 1 })
local tabBtn1 = create("TextButton", { Parent = tabBar, Size = UDim2.new(0, 90, 1, 0), BackgroundColor3 = CFG.Button, Text = "Scripts", TextColor3 = CFG.Accent, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tabBtn1 })

local tabBtn2 = create("TextButton", { Parent = tabBar, Position = UDim2.new(0, 95, 0, 0), Size = UDim2.new(0, 90, 1, 0), BackgroundColor3 = CFG.Panel, Text = "Settings", TextColor3 = CFG.SubText, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tabBtn2 })

local scrollingContent = create("ScrollingFrame", { Parent = contentArea, Position = UDim2.new(0, 15, 0, 50), Size = UDim2.new(1, -30, 1, -60), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4, ScrollBarImageColor3 = CFG.Accent, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y })
create("UIListLayout", { Parent = scrollingContent, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })

local function clearContent() for _, c in ipairs(scrollingContent:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextLabel") or c:IsA("Frame") then c:Destroy() end end end

-- Function para sa Toggles (Kamukha ng sa Codium)
local function createToggle(name, desc, callback)
    local frame = create("Frame", { Parent = scrollingContent, Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = CFG.Panel })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = frame })
    
    create("TextLabel", { Parent = frame, Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -60, 0, 15), BackgroundTransparency = 1, Text = name, TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })
    create("TextLabel", { Parent = frame, Position = UDim2.new(0, 10, 0, 22), Size = UDim2.new(1, -60, 0, 15), BackgroundTransparency = 1, Text = desc, TextColor3 = CFG.SubText, Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left })

    local toggleBg = create("Frame", { Parent = frame, Position = UDim2.new(1, -45, 0.5, -9), Size = UDim2.new(0, 32, 0, 18), BackgroundColor3 = CFG.Button })
    create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = toggleBg })
    local circle = create("Frame", { Parent = toggleBg, Position = UDim2.new(0, 2, 0, 2), Size = UDim2.new(0, 14, 0, 14), BackgroundColor3 = CFG.Text })
    create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = circle })
    
    local btnClick = create("TextButton", { Parent = frame, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "" })
    local state = false
    
    btnClick.MouseButton1Click:Connect(function()
        state = not state
        if state then
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = CFG.Good}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -16, 0, 2)}):Play()
        else
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = CFG.Button}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
        end
        if callback then callback(state) end
    end)
end

-- Render Scripts Tab
local function renderScripts()
    clearContent()
    tabBtn1.BackgroundColor3 = CFG.Button; tabBtn1.TextColor3 = CFG.Accent
    tabBtn2.BackgroundColor3 = CFG.Panel; tabBtn2.TextColor3 = CFG.SubText
    
    for _, script in ipairs(HUB_SCRIPTS) do
        local btn = create("TextButton", { Parent = scrollingContent, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = CFG.Panel, Text = "  " .. script.name, TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0 })
        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
        btn.MouseButton1Click:Connect(function()
            btn.Text = "  Loading..."
            task.spawn(function()
                pcall(function() loadstring(game:HttpGet(script.url))() end)
                btn.Text = "  " .. script.name
            end)
        end)
    end
end

-- Render Settings Tab
local function renderSettings()
    clearContent()
    tabBtn1.BackgroundColor3 = CFG.Panel; tabBtn1.TextColor3 = CFG.SubText
    tabBtn2.BackgroundColor3 = CFG.Button; tabBtn2.TextColor3 = CFG.Accent
    
    -- Mga Demo Toggles para kamukha ng Codium
    createToggle("Auto Parry", "Automatically parries incoming attacks.", function(state) print("Parry:", state) end)
    createToggle("Silent Aim", "Locks aim to the nearest target.", function(state) print("SilentAim:", state) end)
    createToggle("ESP Players", "Shows boxes around enemies.", function(state) print("ESP:", state) end)
    createToggle("Infinite Jump", "Jump as many times as you want.", function(state) 
        if state then
            local jumpConn = UIS.JumpRequest:Connect(function()
                local char = LP.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end)
            getgenv().JumpConn = jumpConn
        else
            if getgenv().JumpConn then getgenv().JumpConn:Disconnect() end
        end
    end)
end

btnScripts.MouseButton1Click:Connect(renderScripts)
btnMisc.MouseButton1Click:Connect(renderSettings)
tabBtn1.MouseButton1Click:Connect(renderScripts)
tabBtn2.MouseButton1Click:Connect(renderSettings)

-- ============ FLOATING ICON ============
local icon = create("TextButton", {
    Parent = gui, Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(0, 20, 0.5, -30), 
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), Text = "PAUL\nHUB", TextColor3 = CFG.Accent,
    Font = Enum.Font.GothamBold, TextSize = 12, TextWrapped = true, BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 100, Active = true
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

renderScripts()