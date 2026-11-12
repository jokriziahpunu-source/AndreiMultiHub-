--[[
    PAUL HUB (Throw a Food for Animals)
    Layout: Sidebar + Safe Hide (Walang Destroy)
]]

-- ============ CONFIG ============
local CFG = {
    Name    = "PAUL HUB",
    Version = "v3.2",
    Accent  = Color3.fromRGB(255, 100, 0), 
    BG      = Color3.fromRGB(15, 15, 20),
    Panel   = Color3.fromRGB(0, 0, 0), 
    Button  = Color3.fromRGB(30, 30, 35),
    Hover   = Color3.fromRGB(50, 50, 60),
    Text    = Color3.fromRGB(235, 235, 245),
    SubText = Color3.fromRGB(150, 150, 165),
    Good    = Color3.fromRGB(120, 220, 140),
    Bad     = Color3.fromRGB(230, 110, 110),
}

-- ============ ENV ============
local UIS     = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Camera  = workspace.CurrentCamera
local LP      = Players.LocalPlayer
local RS      = game:GetService("ReplicatedStorage")

-- ============ REMOTES ============
local Remotes = RS:WaitForChild("Remotes")
local SellRemote = Remotes:WaitForChild("Plot_SellAnimal")
local TrainRemote = Remotes:WaitForChild("Training_Start")
local UpgradeRemote = Remotes:WaitForChild("Shop_Buy")
local EquipRemote = Remotes:WaitForChild("Plot_EquipBest")
local ThrowRemote = Remotes:WaitForChild("Throw_Start")

-- ============ STATE ============
local State = {
    AutoThrow  = false,
    EquipBest  = false,
    AutoTrain  = false,
    AutoUpgrade= false,
    AutoBuy    = false,
}

-- ============ GUI ============
local function getParent()
    if gethui then return gethui() end
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
if parent:FindFirstChild("PaulThrowHub") then
    parent.PaulThrowHub:Destroy()
end

local gui = create("ScreenGui", { Name = "PaulThrowHub", ResetOnSpawn = false, Parent = parent })
if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end

local viewport = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
local winWidth  = math.min(500, math.max(350, viewport.X - 40))
local winHeight = math.min(380, math.max(300, viewport.Y - 80))

-- ============ OPEN BUTTON (Lalabas pag naka-hide) ============
local openBtn = create("TextButton", {
    Parent = gui,
    Size = UDim2.new(0, 100, 0, 35),
    Position = UDim2.new(0, 20, 0.5, 0),
    BackgroundColor3 = CFG.Accent,
    Text = "PAUL HUB",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    Visible = false, 
    ZIndex = 20
})
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = openBtn })

openBtn.MouseButton1Click:Connect(function()
    openBtn.Visible = false
    main.Visible = true
end)

-- ============ MAIN GUI ============
local main = create("Frame", {
    Name = "Main", Parent = gui, Size = UDim2.new(0, winWidth, 0, winHeight),
    Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = CFG.BG, BorderSizePixel = 0, Active = true,
})
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = main })
create("UIStroke", { Color = CFG.Accent, Thickness = 1.5, Transparency = 0.5, Parent = main })

-- Header
local header = create("Frame", { Parent = main, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = header })
create("Frame", { Parent = header, Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })

create("ImageLabel", {
    Parent = header, Position = UDim2.new(0, 10, 0, 8), Size = UDim2.new(0, 20, 0, 20),
    BackgroundTransparency = 1, Image = "https://raw.githubusercontent.com/jokriziahpunu-source/AndreiMultiHub-/main/logo.png",
})

create("TextLabel", {
    Parent = header, Position = UDim2.new(0, 38, 0, 0), Size = UDim2.new(1, -140, 1, 0),
    BackgroundTransparency = 1, Text = CFG.Name .. "  " .. CFG.Version, TextColor3 = CFG.Text,
    Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
})

-- MINIMIZE BUTTON (-)
local minBtn = create("TextButton", { 
    Parent = header, Position = UDim2.new(1, -70, 0, 8), Size = UDim2.new(0, 30, 0, 20), 
    BackgroundColor3 = CFG.Button, Text = "-", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 20, BorderSizePixel = 0 
})
create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = minBtn })
minBtn.MouseButton1Click:Connect(function() 
    main.Visible = false
    openBtn.Visible = true
end)

-- CLOSE BUTTON (X) - Hindi na kinikill ang script
local closeBtn = create("TextButton", { 
    Parent = header, Position = UDim2.new(1, -35, 0, 8), Size = UDim2.new(0, 30, 0, 20), 
    BackgroundColor3 = CFG.Button, Text = "X", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 14, BorderSizePixel = 0 
})
create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = closeBtn })
closeBtn.MouseButton1Click:Connect(function() 
    main.Visible = false
    openBtn.Visible = true
end)

-- Drag
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, main.Position
    end
end)
header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- SIDEBAR
local sidebarWidth = 120
local sidebar = create("Frame", { Parent = main, Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(0, sidebarWidth, 1, -36), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = sidebar })
create("Frame", { Parent = sidebar, Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0), BackgroundColor3 = CFG.Panel, BorderSizePixel = 0 })

local contentFrame = create("Frame", { Parent = main, Position = UDim2.new(0, sidebarWidth, 0, 36), Size = UDim2.new(1, -sidebarWidth, 1, -36), BackgroundTransparency = 1 })

local TAB_NAMES = { "Auto Farm", "Misc" }
local tabButtons = {}
for i, name in ipairs(TAB_NAMES) do
    local btn = create("TextButton", {
        Parent = sidebar, Size = UDim2.new(1, -16, 0, 32), Position = UDim2.new(0, 8, 0, 10 + ((i-1) * 36)),
        BackgroundColor3 = CFG.Button, Text = name, TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    tabButtons[i] = btn
end

-- Discord Button
local discordBtn = create("TextButton", {
    Parent = sidebar, Size = UDim2.new(1, -16, 0, 34), Position = UDim2.new(0, 8, 1, -44), 
    BackgroundColor3 = CFG.Button, Text = "Join Discord", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0,
})
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = discordBtn })
discordBtn.MouseButton1Click:Connect(function()
    local link = "https://discord.gg/Ukw8abnmH"
    if setclipboard then setclipboard(link) end
end)

-- CONTENT AREA
local content = create("ScrollingFrame", {
    Parent = contentFrame, Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(1, -20, 1, -20),
    BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4, ScrollBarImageColor3 = CFG.Accent, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
})
create("UIListLayout", { Parent = content, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })

local function clearContent()
    for _, c in ipairs(content:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextLabel") then c:Destroy() end end
end

local function makeButton(label, onClick)
    local btn = create("TextButton", {
        Parent = content, Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = CFG.Button, Text = "  " .. label,
        TextColor3 = CFG.Text, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    btn.MouseButton1Click:Connect(onClick)
    return btn
end

local function makeHeader(text)
    create("TextLabel", { Parent = content, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = text, TextColor3 = CFG.Accent, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left })
end

-- TAB RENDERERS
local function renderAutoFarm()
    clearContent()
    makeHeader("Auto Features")
    
    local throwBtn = makeButton("Auto Throw: " .. (State.AutoThrow and "ON" or "OFF"), function() end)
    throwBtn.MouseButton1Click:Connect(function()
        State.AutoThrow = not State.AutoThrow
        throwBtn.Text = "  Auto Throw: " .. (State.AutoThrow and "ON" or "OFF")
        throwBtn.TextColor3 = State.AutoThrow and CFG.Good or CFG.Text
    end)
    throwBtn.TextColor3 = State.AutoThrow and CFG.Good or CFG.Text

    local equipBtn = makeButton("Auto Equip Best: " .. (State.EquipBest and "ON" or "OFF"), function() end)
    equipBtn.MouseButton1Click:Connect(function()
        State.EquipBest = not State.EquipBest
        equipBtn.Text = "  Auto Equip Best: " .. (State.EquipBest and "ON" or "OFF")
        equipBtn.TextColor3 = State.EquipBest and CFG.Good or CFG.Text
    end)
    equipBtn.TextColor3 = State.EquipBest and CFG.Good or CFG.Text

    local trainBtn = makeButton("Auto Train: " .. (State.AutoTrain and "ON" or "OFF"), function() end)
    trainBtn.MouseButton1Click:Connect(function()
        State.AutoTrain = not State.AutoTrain
        trainBtn.Text = "  Auto Train: " .. (State.AutoTrain and "ON" or "OFF")
        trainBtn.TextColor3 = State.AutoTrain and CFG.Good or CFG.Text
    end)
    trainBtn.TextColor3 = State.AutoTrain and CFG.Good or CFG.Text

    local upgBtn = makeButton("Auto Upgrade: " .. (State.AutoUpgrade and "ON" or "OFF"), function() end)
    upgBtn.MouseButton1Click:Connect(function()
        State.AutoUpgrade = not State.AutoUpgrade
        upgBtn.Text = "  Auto Upgrade: " .. (State.AutoUpgrade and "ON" or "OFF")
        upgBtn.TextColor3 = State.AutoUpgrade and CFG.Good or CFG.Text
    end)
    upgBtn.TextColor3 = State.AutoUpgrade and CFG.Good or CFG.Text

    local buyBtn = makeButton("Auto Buy: " .. (State.AutoBuy and "ON" or "OFF"), function() end)
    buyBtn.MouseButton1Click:Connect(function()
        State.AutoBuy = not State.AutoBuy
        buyBtn.Text = "  Auto Buy: " .. (State.AutoBuy and "ON" or "OFF")
        buyBtn.TextColor3 = State.AutoBuy and CFG.Good or CFG.Text
    end)
    buyBtn.TextColor3 = State.AutoBuy and CFG.Good or CFG.Text

    makeHeader("Actions")
    makeButton("Auto Sell (Instant)", function()
        local success, err = pcall(function()
            local args = { [1] = "a154" } -- Palitan mo ng tamang Plot ID mo kung iba
            SellRemote:InvokeServer(unpack(args))
        end)
        if success then
            game.StarterGui:SetCore("SendNotification", {Title="Paul Hub"; Text="Sold All Animals!"; Duration=2})
        end
    end)
end

local function renderMisc()
    clearContent()
    makeHeader("Server Hop")
    makeButton("Server Hop (Low Players)", function()
        local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
        table.sort(servers, function(a,b) return a.playing < b.playing end)
        for _, s in ipairs(servers) do
            if s.id ~= game.JobId and s.playing < s.maxPlayers then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, LP)
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
    if TAB_NAMES[idx] == "Auto Farm" then renderAutoFarm() else renderMisc() end
end

for i, btn in ipairs(tabButtons) do btn.MouseButton1Click:Connect(function() showTab(i) end) end

-- LOGIC LOOP (Patuloy na tumatakbo kahit naka-hide)
task.spawn(function()
    while task.wait(0.5) do
        if State.AutoTrain then pcall(function() TrainRemote:InvokeServer() end) end
        if State.AutoUpgrade then pcall(function() UpgradeRemote:InvokeServer(25) end) end
        if State.EquipBest then pcall(function() EquipRemote:InvokeServer() end) end
        if State.AutoThrow then pcall(function() ThrowRemote:InvokeServer() end) end
        
        if State.AutoBuy then 
            pcall(function() 
                UpgradeRemote:InvokeServer(25) 
            end) 
        end
    end
end)

showTab(1)