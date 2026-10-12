--[[
    Andrei Multi Hub
    Steal an Egg script hub — GUI + runner
    Tabs: Keyless / Key System
    Mobile-friendly (Delta, Halaga, Wave, etc.)
]]

-- ============ CONFIG ============
local CFG = {
    Name    = "Andrei Multi Hub",
    Version = "v1.0",
    Accent  = Color3.fromRGB(120, 140, 255),
    BG      = Color3.fromRGB(18, 18, 24),
    Panel   = Color3.fromRGB(26, 26, 34),
    Button  = Color3.fromRGB(38, 38, 50),
    Hover   = Color3.fromRGB(52, 52, 68),
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
            { name = "Rene Hub",   url = "https://raw.githubusercontent.com/sabscrip-arch/srver/refs/heads/main/Stealanegg" },
            { name = "Pulse Hub",  url = "https://raw.githubusercontent.com/PulseZax/Loader/refs/heads/main/.lua" },
            { name = "UB Hub",     url = "https://raw.githubusercontent.com/TeamUBHub/UBLoader/refs/heads/main/Loader.lua" },
            { name = "Ouroboros",  url = "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua" },
            { name = "Cat Hub",    url = "https://raw.githubusercontent.com/showscript-hub/Script/refs/heads/main/Cat-hub" },
            { name = "Khay v6",    url = "https://api.obscuravm.com/scripts/7982111783414007510" },
            { name = "Leon",       url = "https://raw.githubusercontent.com/n01771542-cmd/faluahub/main/main.lua" },
            { name = "Nexora Hub", url = "https://raw.githubusercontent.com/Dayvinksthik/Script/refs/heads/main/Games/JoshBNS-Crack.lua" },
        },
    },
    {
        tab = "Key System",
        scripts = {
            { name = "Big Froot",     url = "https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua" },
            { name = "Ajjans",        url = "https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua" },
            { name = "Chilli Hub V3", url = "https://raw.githubusercontent.com/napun87/stealanegg/refs/heads/main/chilli.otcaydodaiNoKey3.7.lua" },
            { name = "Clover",        url = "https://cloverhub.app/clover.lua" },
            { name = "Speed Hub",     url = "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua" },
            { name = "Nasi Rendang",  url = "https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua" },
        },
    },
}

-- ============ ENV ============
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera

local function getParent()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return Players.LocalPlayer:WaitForChild("PlayerGui")
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
if parent:FindFirstChild("AndreiMultiHub") then
    parent.AndreiMultiHub:Destroy()
end

-- ============ GUI ============
local gui = create("ScreenGui", {
    Name = "AndreiMultiHub",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = parent,
})
if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end

-- Mobile adaptive sizing
local viewport = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
local winWidth  = math.min(420, math.max(280, viewport.X - 40))
local winHeight = math.min(340, math.max(240, viewport.Y - 80))

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
create("UIStroke", { Color = CFG.Accent, Thickness = 1.5, Transparency = 0.6, Parent = main })

-- Title bar
local titleBar = create("Frame", {
    Parent = main,
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = CFG.Panel,
    BorderSizePixel = 0,
})
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = titleBar })
create("Frame", {
    Parent = titleBar,
    Size = UDim2.new(1, 0, 0, 10),
    Position = UDim2.new(0, 0, 1, -10),
    BackgroundColor3 = CFG.Panel,
    BorderSizePixel = 0,
})

create("TextLabel", {
    Parent = titleBar,
    Position = UDim2.new(0, 14, 0, 0),
    Size = UDim2.new(1, -60, 1, 0),
    BackgroundTransparency = 1,
    Text = CFG.Name .. "  " .. CFG.Version,
    TextColor3 = CFG.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local closeBtn = create("TextButton", {
    Parent = titleBar,
    Position = UDim2.new(1, -32, 0, 8),
    Size = UDim2.new(0, 20, 0, 20),
    BackgroundTransparency = 1,
    Text = "X",
    TextColor3 = CFG.SubText,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BorderSizePixel = 0,
})
closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = CFG.Bad end)
closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = CFG.SubText end)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Drag (mouse + touch)
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- Tab row
local tabRow = create("Frame", {
    Parent = main,
    Position = UDim2.new(0, 10, 0, 44),
    Size = UDim2.new(1, -20, 0, 30),
    BackgroundTransparency = 1,
})

local tabCount  = #HUB_SCRIPTS
local tabGap    = 6
local tabWidth  = math.floor(((winWidth - 20) - (tabGap * (tabCount - 1))) / tabCount)

local tabButtons = {}
for i, group in ipairs(HUB_SCRIPTS) do
    local btn = create("TextButton", {
        Parent = tabRow,
        Position = UDim2.new(0, (i - 1) * (tabWidth + tabGap), 0, 0),
        Size = UDim2.new(0, tabWidth, 0, 30),
        BackgroundColor3 = CFG.Button,
        Text = group.tab,
        TextColor3 = CFG.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    table.insert(tabButtons, btn)
end

-- Content
local content = create("ScrollingFrame", {
    Parent = main,
    Position = UDim2.new(0, 10, 0, 84),
    Size = UDim2.new(1, -20, 1, -120),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = CFG.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
})
create("UIListLayout", {
    Parent = content,
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
})

-- Status bar
local status = create("TextLabel", {
    Parent = main,
    Position = UDim2.new(0, 14, 1, -26),
    Size = UDim2.new(1, -28, 0, 16),
    BackgroundTransparency = 1,
    Text = "Ready",
    TextColor3 = CFG.SubText,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
})

-- ============ LOGIC ============
local function setStatus(text, color)
    status.Text = text
    status.TextColor3 = color or CFG.SubText
end

local function runScript(name, url)
    task.spawn(function()
        setStatus("Loading " .. name .. "...", CFG.SubText)
        local ok, err = pcall(function()
            local src = game:HttpGet(url)
            local fn = loadstring(src)
            if type(fn) ~= "function" then
                error("loadstring returned nil")
            end
            fn()
        end)
        if ok then
            setStatus(name .. " loaded", CFG.Good)
        else
            setStatus(name .. " failed: " .. tostring(err), CFG.Bad)
            warn("[Andrei Multi Hub] " .. name .. " failed: " .. tostring(err))
        end
    end)
end

local currentTab = nil
local function showTab(idx)
    if currentTab == idx then return end
    currentTab = idx

    for _, c in ipairs(content:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("Frame") then
            c:Destroy()
        end
    end

    for i, btn in ipairs(tabButtons) do
        btn.BackgroundColor3 = (i == idx) and CFG.Accent or CFG.Button
    end

    local group = HUB_SCRIPTS[idx]
    for _, s in ipairs(group.scripts) do
        local btn = create("TextButton", {
            Parent = content,
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundColor3 = CFG.Button,
            Text = "  " .. s.name,
            TextColor3 = CFG.Text,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutoButtonColor = false,
        })
        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
        btn.MouseEnter:Connect(function() btn.BackgroundColor3 = CFG.Hover end)
        btn.MouseLeave:Connect(function() btn.BackgroundColor3 = CFG.Button end)
        btn.MouseButton1Click:Connect(function() runScript(s.name, s.url) end)
    end

    setStatus("Tab: " .. group.tab .. " (" .. #group.scripts .. " scripts)", CFG.SubText)
end

for i, btn in ipairs(tabButtons) do
    btn.MouseButton1Click:Connect(function() showTab(i) end)
end

showTab(1)
