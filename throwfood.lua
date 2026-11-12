--[[
    PAUL HUB (Throw a Food for Animals)
    Version: v4.0 (Fixed Drag & Toggle)
]]

local CFG = {
    Name    = "PAUL HUB",
    Version = "v4.0",
    Accent  = Color3.fromRGB(255, 100, 0), 
    BG      = Color3.fromRGB(15, 15, 20),
    Panel   = Color3.fromRGB(0, 0, 0), 
    Button  = Color3.fromRGB(30, 30, 35),
    Text    = Color3.fromRGB(235, 235, 245),
    Good    = Color3.fromRGB(120, 220, 140),
}

local UIS     = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Camera  = workspace.CurrentCamera
local LP      = Players.LocalPlayer
local RS      = game:GetService("ReplicatedStorage")

-- REMOTES
local Remotes = RS:WaitForChild("Remotes")
local SellRemote = Remotes:WaitForChild("Plot_SellAnimal")
local TrainRemote = Remotes:WaitForChild("Training_Start")
local UpgradeRemote = Remotes:WaitForChild("Shop_Buy")
local EquipRemote = Remotes:WaitForChild("Plot_EquipBest")
local ThrowRemote = Remotes:WaitForChild("Throw_Start")

local State = {
    AutoThrow  = false,
    EquipBest  = false,
    AutoTrain  = false,
    AutoUpgrade= false,
    AutoBuy    = false,
}

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

-- ============ MAIN GUI ============
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

create("ImageLabel", {
    Parent = header, Position = UDim2.new(0, 10, 0, 8), Size = UDim2.new(0, 20, 0, 20),
    BackgroundTransparency = 1, Image = "https://raw.githubusercontent.com/jokriziahpunu-source/AndreiMultiHub-/main/logo.png",
})

create("TextLabel", {
    Parent = header, Position = UDim2.new(0, 38, 0, 0), Size = UDim2.new(1, -70, 1, 0),
    BackgroundTransparency = 1, Text = CFG.Name .. "  " .. CFG.Version, TextColor3 = CFG.Text,
    Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
})

-- CLOSE BUTTON (X) -> Magtatago lang, hindi mamamatay
local closeBtn = create("TextButton", { 
    Parent = header, Position = UDim2.new(1, -35, 0, 8), Size = UDim2.new(0, 25, 0, 20), 
    BackgroundColor3 = CFG.Button, Text = "X", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 14, BorderSizePixel = 0 
})
create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = closeBtn })
closeBtn.MouseButton1Click:Connect(function() 
    main.Visible = false 
end)

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
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragMain = false
    end
end)

-- ============ FLOATING ICON (Draggable & Toggle) ============
local icon = create("ImageButton", {
    Parent = gui, Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0, 20, 0.5, -25), 
    BackgroundColor3 = CFG.Panel, BackgroundTransparency = 1, 
    Image = "https://raw.githubusercontent.com/jokriziahpunu-source/AndreiMultiHub-/main/logo.png",
    BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 100, Active = true
})
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = icon })
create("UIStroke", { Color = CFG.Accent, Thickness = 2, Parent = icon })

local dragIcon, startIcon, posIcon, iconMoved
icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragIcon = true
        iconMoved = false
        startIcon = input.Position
        posIcon = icon.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragIcon and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - startIcon
        if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then
            iconMoved = true
        end
        icon.Position = UDim2.new(posIcon.X.Scale, posIcon.X.Offset + d.X, posIcon.Y.Scale, posIcon.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragIcon = false
    end
end)

-- TOGGLE LOGIC
icon.MouseButton1Click:Connect(function()
    if iconMoved then return end 
    main.Visible = not main.Visible
end)

-- ============ SIDEBAR ============
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

local discordBtn = create("TextButton", {
    Parent = sidebar, Size = UDim2.new(1, -16, 0, 34), Position = UDim2.new(0, 8, 1, -44), 
    BackgroundColor3 = CFG.Button, Text = "Join Discord", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0,
})
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = discordBtn })
discordBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard("https://discord.gg/Ukw8abnmH") end
end)

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
            local args = { [1] = "a154" }
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

-- LOGIC LOOP
task.spawn(function()
    while task.wait(0.5) do
        if State.AutoTrain then pcall(function() TrainRemote:InvokeServer() end) end
        if State.AutoUpgrade then pcall(function() UpgradeRemote:InvokeServer(25) end) end
        if State.EquipBest then pcall(function() EquipRemote:InvokeServer() end) end
        if State.AutoThrow then pcall(function() ThrowRemote:InvokeServer() end) end
        if State.AutoBuy then pcall(function() UpgradeRemote:InvokeServer(25) end) end
    end
end)

showTab(1)