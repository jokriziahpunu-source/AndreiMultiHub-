--[[
    PAUL HUB [RIVALS] - Blue Anime Edition
    Version: v4.3 (Blue Logo Border)
]]

if getgenv().PaulHubRunning then
    getgenv().PaulHubRunning = false
    task.wait(0.2) 
end
getgenv().PaulHubRunning = true

local CFG = {
    Name    = "PAUL HUB",
    Version = "v4.3",
    Accent  = Color3.fromRGB(0, 150, 255),
    BG      = Color3.fromRGB(15, 15, 20),
    Panel   = Color3.fromRGB(10, 10, 15), 
    Card    = Color3.fromRGB(25, 25, 30),
    Text    = Color3.fromRGB(235, 235, 245),
    SubText = Color3.fromRGB(150, 150, 165),
    Good    = Color3.fromRGB(0, 150, 255),
}

-- ============ EXTERNAL SCRIPTS ============
local HUB_SCRIPTS = {
    { name = "AHTer Hub", desc = "Wallbang, Desync, Anti-Hit", url = "https://scriptblox.com/raw/RIVALS-Atherhub-Wallbang-Desync-Anti-Hit-LegitBot-RageBot-76091" },
    { name = "Korax", desc = "Legit Bot, Rage Bot, ESP", url = "https://scriptblox.com/raw/RIVALS-Korax-226484" },
    { name = "Soluna", desc = "Aimbot, Visuals, Teleport", url = "https://soluna-script.vercel.app/main.lua" },
}

-- ============ ENV ============
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
for _, name in ipairs({"PaulHubAnime"}) do
    local old = parent:FindFirstChild(name)
    if old then old:Destroy() end
end

local gui = create("ScreenGui", { Name = "PaulHubAnime", ResetOnSpawn = false, Parent = parent })
if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end

local viewport = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
local winWidth  = math.min(580, math.max(400, viewport.X - 40))
local winHeight = math.min(420, math.max(320, viewport.Y - 80))

local main = create("Frame", {
    Name = "Main", Parent = gui, Size = UDim2.new(0, winWidth, 0, winHeight),
    Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = CFG.BG, BorderSizePixel = 0, Active = true, ClipsDescendants = true,
})
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = main })
create("UIStroke", { Color = CFG.Accent, Thickness = 2, Parent = main })

-- ANIME BACKGROUND EFFECT
local bgImage = create("ImageLabel", {
    Parent = main, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
    Image = "rbxassetid://13676005827", ImageTransparency = 0.4, ImageColor3 = Color3.fromRGB(150, 180, 255), ScaleType = Enum.ScaleType.Crop, ZIndex = 1
})
create("UIGradient", { Parent = bgImage, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.4), NumberSequenceKeypoint.new(1, 1)})})

-- HEADER
local header = create("Frame", { Parent = main, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0, ZIndex = 2 })
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = header })
create("Frame", { Parent = header, Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0, ZIndex = 2 })

local headerLogo = create("TextLabel", {
    Parent = header, Position = UDim2.new(0, 10, 0, 8), Size = UDim2.new(0, 24, 0, 24),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), Text = "PH", TextColor3 = CFG.Accent, Font = Enum.Font.GothamBlack, TextSize = 12, BorderSizePixel = 0, ZIndex = 3
})
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = headerLogo })
create("UIStroke", { Color = CFG.Accent, Thickness = 1.5, Parent = headerLogo })

create("TextLabel", {
    Parent = header, Position = UDim2.new(0, 42, 0, 0), Size = UDim2.new(0, 150, 1, 0),
    BackgroundTransparency = 1, Text = CFG.Name .. " | RIVALS", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3
})

-- Search Bar
local searchBar = create("Frame", { Parent = header, Position = UDim2.new(1, -260, 0, 8), Size = UDim2.new(0, 160, 0, 24), BackgroundColor3 = CFG.Card, ZIndex = 3 })
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = searchBar })
create("TextLabel", { Parent = searchBar, Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "Search...", TextColor3 = CFG.SubText, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left })

-- Min / Close
local minBtn = create("TextButton", { Parent = header, Position = UDim2.new(1, -60, 0, 10), Size = UDim2.new(0, 24, 0, 20), BackgroundTransparency = 1, Text = "-", TextColor3 = CFG.SubText, Font = Enum.Font.GothamBold, TextSize = 20, ZIndex = 3 })
local closeBtn = create("TextButton", { Parent = header, Position = UDim2.new(1, -30, 0, 10), Size = UDim2.new(0, 24, 0, 20), BackgroundTransparency = 1, Text = "X", TextColor3 = CFG.SubText, Font = Enum.Font.GothamBold, TextSize = 14, ZIndex = 3 })

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
local sidebar = create("Frame", { Parent = main, Position = UDim2.new(0, 0, 0, 40), Size = UDim2.new(0, 130, 1, -40), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0, ZIndex = 2 })
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = sidebar })

local function sidebarBtn(text, yPos, active)
    local btn = create("TextButton", { Parent = sidebar, Position = UDim2.new(0, 10, 0, yPos), Size = UDim2.new(1, -20, 0, 32), BackgroundColor3 = active and CFG.Card or CFG.Panel, Text = "   " .. text, TextColor3 = active and CFG.Accent or CFG.SubText, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0, ZIndex = 3 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    return btn
end

local btnScripts = sidebarBtn("Scripts", 10, true)
local btnMisc = sidebarBtn("Misc", 50, false)
local btnDiscord = sidebarBtn("Discord", 90, false)

-- User Info Bottom Left
create("ImageLabel", { Parent = sidebar, Position = UDim2.new(0, 10, 1, -40), Size = UDim2.new(0, 24, 0, 24), BackgroundColor3 = CFG.Card, Image = "rbxassetid://15452173613", ZIndex = 3 })
create("TextLabel", { Parent = sidebar, Position = UDim2.new(0, 40, 1, -40), Size = UDim2.new(1, -50, 0, 24), BackgroundTransparency = 1, Text = "Paul", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3 })

-- CONTENT AREA
local contentArea = create("Frame", { Parent = main, Position = UDim2.new(0, 130, 0, 40), Size = UDim2.new(1, -130, 1, -40), BackgroundTransparency = 1, ZIndex = 2 })

local tabBar = create("Frame", { Parent = contentArea, Position = UDim2.new(0, 15, 0, 10), Size = UDim2.new(1, -30, 0, 30), BackgroundTransparency = 1, ZIndex = 3 })
local tabBtn1 = create("TextButton", { Parent = tabBar, Size = UDim2.new(0, 100, 1, 0), BackgroundColor3 = CFG.Card, Text = "Break & Grab", TextColor3 = CFG.Accent, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0, ZIndex = 3 })
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tabBtn1 })

local scrollingContent = create("ScrollingFrame", { Parent = contentArea, Position = UDim2.new(0, 15, 0, 50), Size = UDim2.new(1, -30, 1, -60), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4, ScrollBarImageColor3 = CFG.Accent, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 3 })
local listLayout = create("UIListLayout", { Parent = scrollingContent, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })

local function clearContent() 
    for _, c in ipairs(scrollingContent:GetChildren()) do 
        if c:IsA("Frame") or c:IsA("TextButton") or c:IsA("TextLabel") or c:IsA("TextBox") then c:Destroy() end 
    end 
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
    tabBtn1.BackgroundColor3 = CFG.Card
    tabBtn1.TextColor3 = CFG.Accent
    
    for _, script in ipairs(HUB_SCRIPTS) do
        local card = create("Frame", { Parent = scrollingContent, Size = UDim2.new(1, 0, 0, 60), BackgroundColor3 = CFG.Card, BorderSizePixel = 0 })
        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = card })
        
        create("TextLabel", { Parent = card, Position = UDim2.new(0, 10, 0, 8), Size = UDim2.new(1, -20, 0, 15), BackgroundTransparency = 1, Text = script.name, TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })
        create("TextLabel", { Parent = card, Position = UDim2.new(0, 10, 0, 24), Size = UDim2.new(1, -20, 0, 15), BackgroundTransparency = 1, Text = script.desc, TextColor3 = CFG.SubText, Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left })
        
        local execBtn = create("TextButton", { Parent = card, Position = UDim2.new(1, -60, 0.5, -10), Size = UDim2.new(0, 50, 0, 20), BackgroundColor3 = CFG.Good, Text = "RUN", TextColor3 = Color3.new(0,0,0), Font = Enum.Font.GothamBold, TextSize = 11 })
        create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = execBtn })
        execBtn.MouseButton1Click:Connect(function() runScript(script.name, script.url) end)
    end
end

local function renderMisc()
    clearContent()
    tabBtn1.BackgroundColor3 = CFG.Card
    tabBtn1.TextColor3 = CFG.Accent
    
    local spdFrame = create("Frame", { Parent = scrollingContent, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = CFG.Card })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = spdFrame })
    create("TextLabel", { Parent = spdFrame, Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(0.3, 0, 0, 20), BackgroundTransparency = 1, Text = "Speed", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })
    local spdBox = create("TextBox", { Parent = spdFrame, Position = UDim2.new(0.3, 0, 0, 10), Size = UDim2.new(0.3, 0, 0, 20), BackgroundColor3 = CFG.Panel, Text = tostring(State.SpeedVal), TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = spdBox })
    spdBox.FocusLost:Connect(function()
        local val = tonumber(spdBox.Text)
        if val and val >= 1 and val <= 1000 then State.SpeedVal = val else spdBox.Text = tostring(State.SpeedVal) end
    end)
    local spdBtn = create("TextButton", { Parent = spdFrame, Position = UDim2.new(0.65, 0, 0, 10), Size = UDim2.new(0.3, 0, 0, 20), BackgroundColor3 = State.SpeedOn and CFG.Good or CFG.Panel, Text = State.SpeedOn and "ON" or "OFF", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = spdBtn })
    spdBtn.MouseButton1Click:Connect(function()
        State.SpeedOn = not State.SpeedOn
        spdBtn.Text = State.SpeedOn and "ON" or "OFF"
        spdBtn.BackgroundColor3 = State.SpeedOn and CFG.Good or CFG.Panel
        if not State.SpeedOn then
            local char = LP.Character
            if char and char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid").WalkSpeed = 16 end
        end
    end)

    local jmpFrame = create("Frame", { Parent = scrollingContent, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = CFG.Card })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = jmpFrame })
    create("TextLabel", { Parent = jmpFrame, Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(0.3, 0, 0, 20), BackgroundTransparency = 1, Text = "Jump", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })
    local jmpBox = create("TextBox", { Parent = jmpFrame, Position = UDim2.new(0.3, 0, 0, 10), Size = UDim2.new(0.3, 0, 0, 20), BackgroundColor3 = CFG.Panel, Text = tostring(State.JumpVal), TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = jmpBox })
    jmpBox.FocusLost:Connect(function()
        local val = tonumber(jmpBox.Text)
        if val and val >= 1 and val <= 1000 then State.JumpVal = val else jmpBox.Text = tostring(State.JumpVal) end
    end)
    local jmpBtn = create("TextButton", { Parent = jmpFrame, Position = UDim2.new(0.65, 0, 0, 10), Size = UDim2.new(0.3, 0, 0, 20), BackgroundColor3 = State.JumpOn and CFG.Good or CFG.Panel, Text = State.JumpOn and "ON" or "OFF", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = jmpBtn })
    jmpBtn.MouseButton1Click:Connect(function()
        State.JumpOn = not State.JumpOn
        jmpBtn.Text = State.JumpOn and "ON" or "OFF"
        jmpBtn.BackgroundColor3 = State.JumpOn and CFG.Good or CFG.Panel
        if not State.JumpOn then
            local char = LP.Character
            if char and char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid").JumpPower = 50 end
        end
    end)

    local hopBtn = create("TextButton", { Parent = scrollingContent, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = CFG.Card, Text = "Server Hop (Lowest Players)", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = hopBtn })
    hopBtn.MouseButton1Click:Connect(function()
        hopBtn.Text = "Searching..."
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
            hopBtn.Text = "Failed to find server"
            task.wait(2)
            hopBtn.Text = "Server Hop (Lowest Players)"
        end
    end)
end

local function renderDiscord()
    clearContent()
    tabBtn1.BackgroundColor3 = CFG.Card
    tabBtn1.TextColor3 = CFG.Accent
    
    local linkLabel = create("TextBox", { Parent = scrollingContent, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = CFG.Card, Text = "https://discord.gg/Ukw8abnmH", TextColor3 = Color3.fromRGB(100, 200, 255), Font = Enum.Font.GothamBold, TextSize = 14, TextWrapped = true, ClearTextOnFocus = false, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = linkLabel })
    
    local copyBtn = create("TextButton", { Parent = scrollingContent, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = CFG.Good, Text = "Copy Link", TextColor3 = Color3.new(0,0,0), Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0 })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = copyBtn })
    copyBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard("https://discord.gg/Ukw8abnmH") end
        copyBtn.Text = "Copied!"
        task.wait(2)
        copyBtn.Text = "Copy Link"
    end)
end

local function showTab(idx)
    btnScripts.BackgroundColor3 = CFG.Panel; btnScripts.TextColor3 = CFG.SubText
    btnMisc.BackgroundColor3 = CFG.Panel; btnMisc.TextColor3 = CFG.SubText
    btnDiscord.BackgroundColor3 = CFG.Panel; btnDiscord.TextColor3 = CFG.SubText

    if idx == 1 then
        btnScripts.BackgroundColor3 = CFG.Card; btnScripts.TextColor3 = CFG.Accent
        renderScripts()
    elseif idx == 2 then
        btnMisc.BackgroundColor3 = CFG.Card; btnMisc.TextColor3 = CFG.Accent
        renderMisc()
    elseif idx == 3 then
        btnDiscord.BackgroundColor3 = CFG.Card; btnDiscord.TextColor3 = CFG.Accent
        renderDiscord()
    end
end

btnScripts.MouseButton1Click:Connect(function() showTab(1) end)
btnMisc.MouseButton1Click:Connect(function() showTab(2) end)
btnDiscord.MouseButton1Click:Connect(function() showTab(3) end)

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

-- FLOATING ICON (BLUE BORDER)
local icon = create("TextButton", {
    Parent = gui, Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(0, 20, 0.5, -30), 
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), Text = "PAUL\nHUB", TextColor3 = CFG.Accent,
    Font = Enum.Font.GothamBlack, TextSize = 13, TextWrapped = true, BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 100, Active = true
})
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = icon }) 
create("UIStroke", { Color = CFG.Accent, Thickness = 2.5, Parent = icon }) -- Solid Blue Border

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