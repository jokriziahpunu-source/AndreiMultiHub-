--[[
    PAUL HUB [SERVER HOP]
    Game: Break and Steal an Egg / Universal Server Picker
]]

if getgenv().PaulHubRunning then
    getgenv().PaulHubRunning = false
    task.wait(0.2) 
end
getgenv().PaulHubRunning = true

local CFG = {
    Name    = "PAUL HUB [SERVER]",
    Version = "v1.0",
    Accent  = Color3.fromRGB(0, 150, 255),
    BG      = Color3.fromRGB(15, 15, 20),
    Panel   = Color3.fromRGB(0, 0, 0), 
    Button  = Color3.fromRGB(25, 30, 40),
    Text    = Color3.fromRGB(235, 235, 245),
    Good    = Color3.fromRGB(120, 220, 140),
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
for _, name in ipairs({"PaulHubServer"}) do
    local old = parent:FindFirstChild(name)
    if old then old:Destroy() end
end

local gui = create("ScreenGui", { Name = "PaulHubServer", ResetOnSpawn = false, Parent = parent })
if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end

local viewport = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
local winWidth  = math.min(300, math.max(250, viewport.X - 40))
local winHeight = math.min(400, math.max(300, viewport.Y - 80))

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
    Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
})

local minBtn = create("TextButton", { Parent = header, Position = UDim2.new(1, -70, 0, 8), Size = UDim2.new(0, 30, 0, 20), BackgroundColor3 = CFG.Button, Text = "-", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 20, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = minBtn })
minBtn.MouseButton1Click:Connect(function() main.Visible = false end)

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

-- FLOATING ICON
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

-- CONTENT
local refreshBtn = create("TextButton", { Parent = main, Position = UDim2.new(0, 10, 0, 45), Size = UDim2.new(1, -20, 0, 35), BackgroundColor3 = CFG.Button, Text = "Refresh Servers", TextColor3 = CFG.Text, Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0 })
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = refreshBtn })

local listFrame = create("ScrollingFrame", { Parent = main, Position = UDim2.new(0, 10, 0, 85), Size = UDim2.new(1, -20, 1, -100), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4, ScrollBarImageColor3 = CFG.Accent, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y })
create("UIListLayout", { Parent = listFrame, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder })

local function clearList()
    for _, c in ipairs(listFrame:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("TextLabel") then c:Destroy() end
    end
end

local function loadServers()
    clearList()
    local loadingTxt = create("TextLabel", { Parent = listFrame, Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "Fetching servers...", TextColor3 = CFG.Accent, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })
    
    task.spawn(function()
        local success, response = pcall(function()
            return HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)
        
        if loadingTxt then loadingTxt:Destroy() end
        
        if success and response and response.data then
            local servers = response.data
            table.sort(servers, function(a,b) return a.playing < b.playing end)
            
            for _, server in ipairs(servers) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    local btn = create("TextButton", { Parent = listFrame, Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = CFG.Button, Text = "  [" .. server.playing .. "/" .. server.maxPlayers .. "] Join Server", TextColor3 = CFG.Text, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0 })
                    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
                    
                    btn.MouseButton1Click:Connect(function()
                        btn.Text = "  Teleporting..."
                        btn.BackgroundColor3 = CFG.Good
                        TS:TeleportToPlaceInstance(game.PlaceId, server.id, LP)
                    end)
                end
            end
        else
            create("TextLabel", { Parent = listFrame, Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "Failed to fetch servers.", TextColor3 = Color3.fromRGB(255, 100, 100), Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })
        end
    end)
end

refreshBtn.MouseButton1Click:Connect(function()
    refreshBtn.Text = "Refreshing..."
    loadServers()
    task.wait(1)
    refreshBtn.Text = "Refresh Servers"
end)

-- Load agad pagka-execute
loadServers()