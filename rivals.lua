--[[
    PAUL HUB [RIVALS] - Simple Edition
    Version: v5.1 (Working Discord Tab)
]]

if getgenv().PaulHubRunning then
    getgenv().PaulHubRunning = false
    task.wait(0.2) 
end
getgenv().PaulHubRunning = true

local CFG = {
    Name    = "PAUL HUB",
    Version = "v5.1",
    Accent  = Color3.fromRGB(0, 150, 255),
    BG      = Color3.fromRGB(15, 15, 20),
    Panel   = Color3.fromRGB(10, 10, 15), 
    Button  = Color3.fromRGB(25, 25, 30),
    Text    = Color3.fromRGB(235, 235, 245),
    SubText = Color3.fromRGB(150, 150, 165),
    Good    = Color3.fromRGB(0, 150, 255),
}

local HUB_SCRIPTS = {
    { name = "AHTer Hub", url = "https://scriptblox.com/raw/RIVALS-Atherhub-Wallbang-Desync-Anti-Hit-LegitBot-RageBot-76091" },
    { name = "Korax", url = "https://scriptblox.com/raw/RIVALS-Korax-226484" },
    { name = "Soluna", url = "https://soluna-script.vercel.app/main.lua" },
}

local UIS     = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Camera  = workspace.CurrentCamera
local LP      = Players.LocalPlayer
local HS      = game:GetService("HttpService")
local TS      = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local State = { SpeedOn = false, SpeedVal = 16, JumpOn = false, JumpVal = 50 }

local function getParent() if gethui then return gethui() end return LP:WaitForChild("PlayerGui") end
local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do if k ~= "Parent" then inst[k] = v end end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local parent = getParent()
for _, name in ipairs({"PaulHubSimple"}) do
    local old = parent:FindFirstChild(name)
    if old then old:Destroy() end
end

local gui = create("ScreenGui", { Name = "PaulHubSimple", ResetOnSpawn = false, Parent = parent })
if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end

local viewport = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
local winWidth  = math.min(450, math.max(320, viewport.X - 40))
local winHeight = math.min(380, math.max(280, viewport.Y - 80))

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
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), Text = "PH", TextColor3 = CFG.Accent, Font = Enum.Font.GothamBlack, TextSize = 12, BorderSizePixel = 0
})
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = headerLogo })
create("UIStroke", { Color = CFG.Accent, Thickness = 1.5, Parent = headerLogo })

create("TextLabel", {
    Parent = header, Position = UDim2.new(0, 42, 0, 0), Size = UDim2.new(1, -70, 1, 0),
    BackgroundTransparency = 1, Text = CFG.Name .. " | RIVALS", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
})

local minBtn = create("TextButton", { Parent = header, Position = UDim2.new(1, -60, 0, 10), Size = UDim2.new(0, 24, 0, 20), BackgroundTransparency = 1, Text = "-", TextColor3 = CFG.SubText, Font = Enum.Font.GothamBold, TextSize = 20 })
local closeBtn = create("TextButton", { Parent = header, Position = UDim2.new(1, -30, 0, 10), Size = UDim2.new(0, 24, 0, 20), BackgroundTransparency = 1, Text = "X", TextColor3 = CFG.SubText, Font = Enum.Font.GothamBold, TextSize = 14 })

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

-- SIDEBAR
local sidebarWidth = 110
local sidebar = create("Frame", { Parent = main, Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(0, sidebarWidth, 1, -36), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = sidebar })
create("Frame", { Parent = sidebar, Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })

local contentFrame = create("Frame", { Parent = main, Position = UDim2.new(0, sidebarWidth, 0, 36), Size = UDim2.new(1, -sidebarWidth, 1, -36), BackgroundTransparency = 1 })
local TAB_NAMES = { "Scripts", "Misc", "Server Hop", "Discord" }
local tabButtons = {}
for i, name in ipairs(TAB_NAMES) do
    local btn = create("TextButton", { Parent = sidebar, Size = UDim2.new(1, -16, 0, 32), Position = UDim2.new(0, 8, 0, 10 + ((i-1) * 36)), BackgroundColor3 = CFG.Button, Text = name, TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    tabButtons[i] = btn
end

local content = create("ScrollingFrame", { Parent = contentFrame, Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(1, -20, 1, -20), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4, ScrollBarImageColor3 = CFG.Accent, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y })
create("UIListLayout", { Parent = content, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })

local function clearContent() for _, c in ipairs(content:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextLabel") or c:IsA("Frame") or c:IsA("TextBox") then c:Destroy() end end end
local function makeButton(label, onClick)
    local btn = create("TextButton", { Parent = content, Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = CFG.Button, Text = "  " .. label, TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    btn.MouseButton1Click:Connect(onClick)
    return btn
end

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

local function renderScripts()
    clearContent()
    for _, script in ipairs(HUB_SCRIPTS) do
        makeButton(script.name, function() runScript(script.name, script.url) end)
    end
end

local function renderMisc()
    clearContent()
    
    -- SPEED
    local spdFrame = create("Frame", { Parent = content, Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1 })
    create("TextLabel", { Parent = spdFrame, Size = UDim2.new(0.3, 0, 1, 0), BackgroundColor3 = CFG.Button, Text = "  Speed", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })
    local spdBox = create("TextBox", { Parent = spdFrame, Position = UDim2.new(0.32, 0, 0, 0), Size = UDim2.new(0.35, 0, 1, 0), BackgroundColor3 = CFG.Button, Text = tostring(State.SpeedVal), TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = spdBox })
    spdBox.FocusLost:Connect(function()
        local val = tonumber(spdBox.Text)
        if val and val >= 1 and val <= 1000 then State.SpeedVal = val else spdBox.Text = tostring(State.SpeedVal) end
    end)
    local spdBtn = create("TextButton", { Parent = spdFrame, Position = UDim2.new(0.68, 0, 0, 0), Size = UDim2.new(0.32, 0, 1, 0), BackgroundColor3 = State.SpeedOn and CFG.Good or CFG.Button, Text = State.SpeedOn and "ON" or "OFF", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = spdBtn })
    spdBtn.MouseButton1Click:Connect(function()
        State.SpeedOn = not State.SpeedOn
        spdBtn.Text = State.SpeedOn and "ON" or "OFF"
        spdBtn.BackgroundColor3 = State.SpeedOn and CFG.Good or CFG.Button
        if not State.SpeedOn then
            local char = LP.Character
            if char and char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid").WalkSpeed = 16 end
        end
    end)

    -- JUMP
    local jmpFrame = create("Frame", { Parent = content, Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1 })
    create("TextLabel", { Parent = jmpFrame, Size = UDim2.new(0.3, 0, 1, 0), BackgroundColor3 = CFG.Button, Text = "  Jump", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })
    local jmpBox = create("TextBox", { Parent = jmpFrame, Position = UDim2.new(0.32, 0, 0, 0), Size = UDim2.new(0.35, 0, 1, 0), BackgroundColor3 = CFG.Button, Text = tostring(State.JumpVal), TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = jmpBox })
    jmpBox.FocusLost:Connect(function()
        local val = tonumber(jmpBox.Text)
        if val and val >= 1 and val <= 1000 then State.JumpVal = val else jmpBox.Text = tostring(State.JumpVal) end
    end)
    local jmpBtn = create("TextButton", { Parent = jmpFrame, Position = UDim2.new(0.68, 0, 0, 0), Size = UDim2.new(0.32, 0, 1, 0), BackgroundColor3 = State.JumpOn and CFG.Good or CFG.Button, Text = State.JumpOn and "ON" or "OFF", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = jmpBtn })
    jmpBtn.MouseButton1Click:Connect(function()
        State.JumpOn = not State.JumpOn
        jmpBtn.Text = State.JumpOn and "ON" or "OFF"
        jmpBtn.BackgroundColor3 = State.JumpOn and CFG.Good or CFG.Button
        if not State.JumpOn then
            local char = LP.Character
            if char and char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid").JumpPower = 50 end
        end
    end)
end

local function renderHop()
    clearContent()
    makeButton("Server Hop (Lowest Players)", function()
        game.StarterGui:SetCore("SendNotification", {Title="Server Hop"; Text="Searching..."; Duration=2})
        local success, response = pcall(function() return HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")) end)
        if success and response and response.data then
            table.sort(response.data, function(a,b) return a.playing < b.playing end)
            for _, s in ipairs(response.data) do 
                if s.id ~= game.JobId and s.playing < s.maxPlayers then 
                    TS:TeleportToPlaceInstance(game.PlaceId, s.id, LP) 
                    break 
                end 
            end
        end
    end)
end

local function renderDiscord()
    clearContent()
    
    create("TextLabel", { Parent = content, Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1, Text = "Join our Discord Server!", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left })
    
    local linkFrame = create("Frame", { Parent = content, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = CFG.Button })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = linkFrame })
    
    create("TextLabel", { Parent = linkFrame, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "https://discord.gg/Ukw8abnmH", TextColor3 = CFG.Good, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left })

    makeButton("Copy Link", function()
        if setclipboard then setclipboard("https://discord.gg/Ukw8abnmH") end
        game.StarterGui:SetCore("SendNotification", {Title="Discord"; Text="Link Copied to Clipboard!"; Duration=3})
    end)
end

local function showTab(idx)
    for i, btn in ipairs(tabButtons) do 
        btn.BackgroundColor3 = (i == idx) and CFG.Accent or CFG.Button 
        btn.TextColor3 = (i == idx) and Color3.new(1,1,1) or CFG.Text
    end
    if TAB_NAMES[idx] == "Scripts" then renderScripts()
    elseif TAB_NAMES[idx] == "Misc" then renderMisc()
    elseif TAB_NAMES[idx] == "Server Hop" then renderHop()
    elseif TAB_NAMES[idx] == "Discord" then renderDiscord() end
end
for i, btn in ipairs(tabButtons) do btn.MouseButton1Click:Connect(function() showTab(i) end) end

-- LOGIC LOOP FOR SPEED/JUMP
RunService.Heartbeat:Connect(function()
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if State.SpeedOn and hum.WalkSpeed ~= State.SpeedVal then hum.WalkSpeed = State.SpeedVal end
            if State.JumpOn then hum.UseJumpPower = true; if hum.JumpPower ~= State.JumpVal then hum.JumpPower = State.JumpVal end end
        end
    end
end)

-- FLOATING ICON
local icon = create("TextButton", {
    Parent = gui, Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(0, 20, 0.5, -30), 
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), Text = "PAUL\nHUB", TextColor3 = CFG.Accent,
    Font = Enum.Font.GothamBlack, TextSize = 13, TextWrapped = true, BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 100, Active = true
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

showTab(1)