--[[
    PAUL HUB (Bike for Egg)
    Version: v1.0
    Tabs: Speed / Jump / Server Hop
]]

if getgenv().PaulHubRunning then
    getgenv().PaulHubRunning = false
    task.wait(0.2) 
end
getgenv().PaulHubRunning = true

local CFG = {
    Name    = "PAUL HUB [BIKE]",
    Version = "v1.0",
    Accent  = Color3.fromRGB(0, 150, 255),
    BG      = Color3.fromRGB(10, 15, 25),
    Panel   = Color3.fromRGB(5, 10, 20), 
    Button  = Color3.fromRGB(20, 30, 45),
    Text    = Color3.fromRGB(235, 235, 245),
    Good    = Color3.fromRGB(120, 220, 140),
}

local UIS     = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Camera  = workspace.CurrentCamera
local LP      = Players.LocalPlayer
local HS      = game:GetService("HttpService")
local TS      = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local State = { SpeedEnabled = false, JumpEnabled = false, SpeedValue = 16, JumpValue = 50 }

local function getParent() if gethui then return gethui() end return LP:WaitForChild("PlayerGui") end
local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do if k ~= "Parent" then inst[k] = v end end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local parent = getParent()
for _, name in ipairs({"PaulHubPro", "PaulThrowHub", "PaulHubBike"}) do
    local old = parent:FindFirstChild(name)
    if old then old:Destroy() end
end

local gui = create("ScreenGui", { Name = "PaulHubBike", ResetOnSpawn = false, Parent = parent })
if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end

local viewport = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
local winWidth  = math.min(400, math.max(300, viewport.X - 40))
local winHeight = math.min(340, math.max(250, viewport.Y - 80))

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

local headerLogo = create("TextLabel", {
    Parent = header, Position = UDim2.new(0, 10, 0, 8), Size = UDim2.new(0, 24, 0, 24),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), Text = "PH",
    TextColor3 = CFG.Accent, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0,
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
minBtn.MouseButton1Click:Connect(function() main.Visible = false end) -- Hide only

-- CLOSE BUTTON (X)
local closeBtn = create("TextButton", { Parent = header, Position = UDim2.new(1, -35, 0, 8), Size = UDim2.new(0, 30, 0, 20), BackgroundColor3 = CFG.Button, Text = "X", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 14, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = closeBtn })
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end) -- Hide only

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

-- FLOATING ICON (DRAGGABLE)
local icon = create("TextButton", {
    Parent = gui, Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(0, 20, 0.5, -30), 
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), Text = "PAUL\nHUB", TextColor3 = Color3.fromRGB(255, 255, 255),
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

-- SIDEBAR
local sidebarWidth = 110
local sidebar = create("Frame", { Parent = main, Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(0, sidebarWidth, 1, -36), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = sidebar })
create("Frame", { Parent = sidebar, Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })

local contentFrame = create("Frame", { Parent = main, Position = UDim2.new(0, sidebarWidth, 0, 36), Size = UDim2.new(1, -sidebarWidth, 1, -36), BackgroundTransparency = 1 })
local TAB_NAMES = { "Speed", "Jump", "Server Hop" }
local tabButtons = {}
for i, name in ipairs(TAB_NAMES) do
    local btn = create("TextButton", { Parent = sidebar, Size = UDim2.new(1, -16, 0, 32), Position = UDim2.new(0, 8, 0, 10 + ((i-1) * 36)), BackgroundColor3 = CFG.Button, Text = name, TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    tabButtons[i] = btn
end

-- JOIN DISCORD
local discordBtn = create("TextButton", { Parent = sidebar, Size = UDim2.new(1, -16, 0, 34), Position = UDim2.new(0, 8, 1, -44), BackgroundColor3 = CFG.Button, Text = "Join Discord", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 11, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = discordBtn })
discordBtn.MouseButton1Click:Connect(function() 
    if setclipboard then setclipboard("https://discord.gg/Ukw8abnmH") end 
    game.StarterGui:SetCore("SendNotification", {Title="Discord"; Text="Link Copied!"; Duration=2})
end)

local content = create("Frame", { Parent = contentFrame, Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(1, -20, 1, -20), BackgroundTransparency = 1 })
create("UIListLayout", { Parent = content, Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Top })

local function clearContent() for _, c in ipairs(content:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextLabel") or c:IsA("Frame") or c:IsA("TextBox") then c:Destroy() end end end
local function makeHeader(text) create("TextLabel", { Parent = content, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = text, TextColor3 = CFG.Accent, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left }) end

local function renderSpeed()
    clearContent()
    makeHeader("Speed (1 - 1000)")
    
    local spdBox = create("TextBox", { Parent = content, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = CFG.Button, Text = tostring(State.SpeedValue), TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 16, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = spdBox })
    spdBox.FocusLost:Connect(function()
        local val = tonumber(spdBox.Text)
        if val and val >= 1 and val <= 1000 then State.SpeedValue = val else spdBox.Text = tostring(State.SpeedValue) end
    end)
    
    local spdBtn = create("TextButton", { Parent = content, Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = State.SpeedEnabled and CFG.Good or CFG.Button, Text = (State.SpeedEnabled and "ENABLED" or "DISABLED"), TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 15, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = spdBtn })
    spdBtn.MouseButton1Click:Connect(function()
        State.SpeedEnabled = not State.SpeedEnabled
        spdBtn.Text = (State.SpeedEnabled and "ENABLED" or "DISABLED")
        spdBtn.BackgroundColor3 = State.SpeedEnabled and CFG.Good or CFG.Button
        if not State.SpeedEnabled then
            local char = LP.Character
            if char and char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid").WalkSpeed = 16 end
        end
    end)
end

local function renderJump()
    clearContent()
    makeHeader("Jump (1 - 1000)")
    
    local jmpBox = create("TextBox", { Parent = content, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = CFG.Button, Text = tostring(State.JumpValue), TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 16, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = jmpBox })
    jmpBox.FocusLost:Connect(function()
        local val = tonumber(jmpBox.Text)
        if val and val >= 1 and val <= 1000 then State.JumpValue = val else jmpBox.Text = tostring(State.JumpValue) end
    end)
    
    local jmpBtn = create("TextButton", { Parent = content, Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = State.JumpEnabled and CFG.Good or CFG.Button, Text = (State.JumpEnabled and "ENABLED" or "DISABLED"), TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 15, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = jmpBtn })
    jmpBtn.MouseButton1Click:Connect(function()
        State.JumpEnabled = not State.JumpEnabled
        jmpBtn.Text = (State.JumpEnabled and "ENABLED" or "DISABLED")
        jmpBtn.BackgroundColor3 = State.JumpEnabled and CFG.Good or CFG.Button
        if not State.JumpEnabled then
            local char = LP.Character
            if char and char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid").JumpPower = 50 end
        end
    end)
end

local function renderHop()
    clearContent()
    makeHeader("Server Hop")
    
    local hopBtn = create("TextButton", { Parent = content, Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = CFG.Button, Text = "Hop to Lowest Server", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 14, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = hopBtn })
    hopBtn.MouseButton1Click:Connect(function()
        hopBtn.Text = "Finding..."
        hopBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
        local success, response = pcall(function() return HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")) end)
        if success and response and response.data then
            table.sort(response.data, function(a,b) return a.playing < b.playing end)
            for _, s in ipairs(response.data) do 
                if s.id ~= game.JobId and s.playing < s.maxPlayers then 
                    TS:TeleportToPlaceInstance(game.PlaceId, s.id, LP) 
                    break 
                end 
            end
        else
            hopBtn.Text = "Failed"
            task.wait(2)
            hopBtn.Text = "Hop to Lowest Server"
            hopBtn.BackgroundColor3 = CFG.Button
        end
    end)
end

local function showTab(idx)
    for i, btn in ipairs(tabButtons) do 
        btn.BackgroundColor3 = (i == idx) and CFG.Accent or CFG.Button 
        btn.TextColor3 = (i == idx) and Color3.new(1,1,1) or CFG.Text
    end
    if TAB_NAMES[idx] == "Speed" then renderSpeed()
    elseif TAB_NAMES[idx] == "Jump" then renderJump()
    elseif TAB_NAMES[idx] == "Server Hop" then renderHop() end
end

for i, btn in ipairs(tabButtons) do btn.MouseButton1Click:Connect(function() showTab(i) end) end

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