--[[
    Andrei Multi Hub v2.1
    Steal an Egg script hub — GUI + runner
    Tabs: Keyless / Key System / Animations / Misc / Config
    Misc: Floating Icon (draggable toggle)
    Mobile-friendly
]]

-- ============ CONFIG ============
local CFG = {
    Name    = "Andrei Multi Hub",
    Version = "v2.1",
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

local CONFIG_FILE = "AndreiMultiHub_config.json"

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

-- ============ ANIMATIONS ============
local ANIMS = {
    R6 = {
        { name = "Idle", id = 180435571 }, { name = "Walk", id = 180426354 },
        { name = "Run", id = 180426354 }, { name = "Jump", id = 125750702 },
        { name = "Fall", id = 180436148 }, { name = "Climb", id = 180436334 },
        { name = "Sit", id = 178130996 }, { name = "Tool None", id = 182393478 },
        { name = "Tool Slash", id = 129967390 }, { name = "Tool Lunge", id = 129967478 },
        { name = "Wave", id = 128777973 }, { name = "Point", id = 128853357 },
        { name = "Dance", id = 182435998 }, { name = "Dance2", id = 182436842 },
        { name = "Dance3", id = 182491037 }, { name = "Laugh", id = 128874794 },
        { name = "Cheer", id = 129004052 },
    },
    R15 = {
        { name = "Idle", id = 507766666 }, { name = "Walk", id = 507777826 },
        { name = "Run", id = 507767714 }, { name = "Jump", id = 507765000 },
        { name = "Fall", id = 507767968 }, { name = "Climb", id = 507765644 },
        { name = "Sit", id = 2506281703 }, { name = "Tool None", id = 507768133 },
        { name = "Tool Slash", id = 507768375 }, { name = "Tool Lunge", id = 507768680 },
        { name = "Wave", id = 507770239 }, { name = "Point", id = 507770453 },
        { name = "Dance", id = 507771019 }, { name = "Dance2", id = 507771955 },
        { name = "Dance3", id = 507772104 }, { name = "Laugh", id = 507770818 },
        { name = "Cheer", id = 507770677 },
    },
}

local SLOT_MAP = {
    ["Idle"] = "idle", ["Walk"] = "walk", ["Run"] = "run", ["Jump"] = "jump",
    ["Fall"] = "fall", ["Climb"] = "climb", ["Sit"] = "sit",
    ["Tool None"] = "toolnone", ["Tool Slash"] = "toolslash", ["Tool Lunge"] = "toollunge",
    ["Wave"] = "wave", ["Point"] = "point", ["Dance"] = "dance",
    ["Dance2"] = "dance2", ["Dance3"] = "dance3", ["Laugh"] = "laugh", ["Cheer"] = "cheer",
}
local SLOT_LIST = {}
for k in pairs(SLOT_MAP) do table.insert(SLOT_LIST, k) end
table.sort(SLOT_LIST)

-- ============ ENV ============
local UIS     = game:GetService("UserInputService")
local Players = game:GetService("Players")
local HS      = game:GetService("HttpService")
local Camera  = workspace.CurrentCamera
local LP      = Players.LocalPlayer

local function getParent()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
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
if parent:FindFirstChild("AndreiMultiHub") then
    parent.AndreiMultiHub:Destroy()
end

-- ============ STATE ============
local State = {
    anims      = {},
    iconOn     = true,
    iconPos    = { x = 40, y = 120 },   -- UDim2 offset relative sa bottom-left anchor
    iconSize   = 56,
}

-- ============ GUI ============
local gui = create("ScreenGui", {
    Name = "AndreiMultiHub",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = parent,
})
if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end

local viewport = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
local winWidth  = math.min(460, math.max(300, viewport.X - 40))
local winHeight = math.min(440, math.max(320, viewport.Y - 80))

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
    Size = UDim2.new(1, -110, 1, 0),
    BackgroundTransparency = 1,
    Text = CFG.Name .. "  " .. CFG.Version,
    TextColor3 = CFG.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
})

-- minimize-to-icon button
local minBtn = create("TextButton", {
    Parent = titleBar,
    Position = UDim2.new(1, -58, 0, 8),
    Size = UDim2.new(0, 20, 0, 20),
    BackgroundTransparency = 1,
    Text = "—",
    TextColor3 = CFG.SubText,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    BorderSizePixel = 0,
})
minBtn.MouseEnter:Connect(function() minBtn.TextColor3 = CFG.Accent end)
minBtn.MouseLeave:Connect(function() minBtn.TextColor3 = CFG.SubText end)

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

-- Drag window
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, main.Position
    end
end)
titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- Toast holder
local toastHolder = create("Frame", {
    Parent = gui,
    Position = UDim2.new(1, -20, 0, 20),
    AnchorPoint = Vector2.new(1, 0),
    Size = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
})
create("UIListLayout", {
    Parent = toastHolder,
    Padding = UDim.new(0, 6),
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    SortOrder = Enum.SortOrder.LayoutOrder,
})

local function toast(msg, color)
    local t = create("Frame", {
        Parent = toastHolder,
        Size = UDim2.new(0, 240, 0, 36),
        BackgroundColor3 = CFG.Panel,
        BorderSizePixel = 0,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = t })
    create("UIStroke", { Color = color or CFG.Accent, Thickness = 1, Parent = t })
    create("TextLabel", {
        Parent = t,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        BackgroundTransparency = 1,
        Text = msg,
        TextColor3 = CFG.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    task.delay(3, function()
        if not t.Parent then return end
        for i = 1, 20 do
            if not t.Parent then return end
            t.BackgroundTransparency = i / 20
            task.wait(0.02)
        end
        if t.Parent then t:Destroy() end
    end)
end

-- ============ FLOATING ICON ============
local icon = create("TextButton", {
    Parent = gui,
    Size = UDim2.new(0, State.iconSize, 0, State.iconSize),
    Position = UDim2.new(0, State.iconPos.x, 1, -State.iconPos.y),
    AnchorPoint = Vector2.new(0, 1),  -- anchor bottom-left ng button sa (x, bottom - y)
    BackgroundColor3 = CFG.Panel,
    Text = "AMH",
    TextColor3 = CFG.Accent,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Visible = State.iconOn,
    ZIndex = 10,
})
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = icon })
create("UIStroke", { Color = CFG.Accent, Thickness = 2, Parent = icon })

-- icon drag
local iconDragging, iconDragStart, iconStartPos, iconMoved
icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        iconDragging = true
        iconMoved = false
        iconDragStart = input.Position
        iconStartPos = icon.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if iconDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - iconDragStart
        if math.abs(d.X) > 4 or math.abs(d.Y) > 4 then
            iconMoved = true
        end
        icon.Position = UDim2.new(
            iconStartPos.X.Scale,
            iconStartPos.X.Offset + d.X,
            iconStartPos.Y.Scale,
            iconStartPos.Y.Offset + d.Y
        )
    end
end)
icon.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if iconDragging then
            iconDragging = false
            -- save current offset para hindi na-lost sa toggle
            State.iconPos.x = icon.Position.X.Offset
            State.iconPos.y = -(icon.Position.Y.Offset)
        end
    end
end)

-- tap = toggle main window
icon.MouseButton1Click:Connect(function()
    if iconMoved then return end
    main.Visible = not main.Visible
    toast(main.Visible and "Hub opened" or "Hub hidden",
        main.Visible and CFG.Good or CFG.SubText)
end)

local function setIconVisible(on)
    State.iconOn = on
    icon.Visible = on
end

local function setIconSize(px)
    px = math.clamp(px, 36, 96)
    State.iconSize = px
    icon.Size = UDim2.new(0, px, 0, px)
    icon.TextSize = math.floor(px * 0.28)
    icon.Position = UDim2.new(0, State.iconPos.x, 1, -State.iconPos.y)
end

-- minimize button wires icon on at hides main
minBtn.MouseButton1Click:Connect(function()
    setIconVisible(true)
    main.Visible = false
    toast("Minimized to icon", CFG.SubText)
end)

-- ============ TABS ============
local TAB_NAMES = { "Keyless", "Key System", "Animations", "Misc", "Config" }
local tabRow = create("Frame", {
    Parent = main,
    Position = UDim2.new(0, 10, 0, 44),
    Size = UDim2.new(1, -20, 0, 28),
    BackgroundTransparency = 1,
})
local tabGap   = 4
local tabWidth = math.floor(((winWidth - 20) - (tabGap * (#TAB_NAMES - 1))) / #TAB_NAMES)

local tabButtons = {}
for i, name in ipairs(TAB_NAMES) do
    local btn = create("TextButton", {
        Parent = tabRow,
        Position = UDim2.new(0, (i - 1) * (tabWidth + tabGap), 0, 0),
        Size = UDim2.new(0, tabWidth, 0, 28),
        BackgroundColor3 = CFG.Button,
        Text = name,
        TextColor3 = CFG.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    tabButtons[i] = btn
end

-- Search bar
local searchFrame = create("Frame", {
    Parent = main,
    Position = UDim2.new(0, 10, 0, 78),
    Size = UDim2.new(1, -20, 0, 30),
    BackgroundColor3 = CFG.Button,
    BorderSizePixel = 0,
    Visible = true,
})
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = searchFrame })
create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = searchFrame })

local searchBox = create("TextBox", {
    Parent = searchFrame,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = "Search scripts...",
    PlaceholderColor3 = CFG.SubText,
    TextColor3 = CFG.Text,
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
})

-- Content
local content = create("ScrollingFrame", {
    Parent = main,
    Position = UDim2.new(0, 10, 0, 116),
    Size = UDim2.new(1, -20, 1, -152),
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

local function setStatus(text, color)
    status.Text = text
    status.TextColor3 = color or CFG.SubText
end

-- ============ UI HELPERS ============
local function clearContent()
    for _, c in ipairs(content:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("Frame") or c:IsA("TextBox") or c:IsA("TextLabel") then
            c:Destroy()
        end
    end
end

local function makeButton(label, onClick)
    local btn = create("TextButton", {
        Parent = content,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = CFG.Button,
        Text = "  " .. label,
        TextColor3 = CFG.Text,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = CFG.Hover end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = CFG.Button end)
    btn.MouseButton1Click:Connect(onClick)
    return btn
end

local function makeHeader(text)
    create("TextLabel", {
        Parent = content,
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = CFG.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
end

-- ============ SCRIPT RUNNER ============
local function runScript(name, url)
    task.spawn(function()
        setStatus("Loading " .. name .. "...", CFG.SubText)
        toast("Loading " .. name, CFG.SubText)
        local ok, err = pcall(function()
            local src = game:HttpGet(url)
            local fn = loadstring(src)
            if type(fn) ~= "function" then error("loadstring returned nil") end
            fn()
        end)
        if ok then
            setStatus(name .. " loaded", CFG.Good)
            toast(name .. " loaded", CFG.Good)
        else
            setStatus(name .. " failed", CFG.Bad)
            toast(name .. " failed", CFG.Bad)
            warn("[Andrei Multi Hub] " .. name .. " failed: " .. tostring(err))
        end
    end)
end

-- ============ ANIMATION HELPERS ============
local function applyAnim(slotName, animId)
    local folderName = SLOT_MAP[slotName]
    if not folderName then return false, "unknown slot" end
    local char = LP.Character
    if not char then return false, "no character" end
    local animate = char:FindFirstChild("Animate")
    if not animate then return false, "no Animate folder" end
    local folder = animate:FindFirstChild(folderName)
    if not folder then return false, "no slot: " .. folderName end

    local replaced = false
    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("Animation") then
            obj.AnimationId = "rbxassetid://" .. tostring(animId)
            replaced = true
        end
    end
    if not replaced then
        local a = Instance.new("Animation")
        a.Name = "Animation1"
        a.AnimationId = "rbxassetid://" .. tostring(animId)
        a.Parent = folder
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do
            tr:Stop(0)
        end
    end
    return true
end

local function applyById(slotName, rawId)
    local id = tostring(rawId):gsub("[^%d]", "")
    if id == "" then return false, "invalid id" end
    local ok, err = applyAnim(slotName, id)
    if ok then State.anims[slotName] = id end
    return ok, err
end

-- ============ TAB RENDERERS ============
local searchText = ""
local currentScriptGroup = nil

local function renderScriptList(scripts)
    clearContent()
    local shown = 0
    for _, s in ipairs(scripts) do
        if searchText == "" or s.name:lower():find(searchText:lower(), 1, true) then
            makeButton(s.name, function() runScript(s.name, s.url) end)
            shown = shown + 1
        end
    end
    if shown == 0 then makeButton("No match", function() end) end
    setStatus(currentScriptGroup .. " — " .. shown .. "/" .. #scripts, CFG.SubText)
end

local function renderAnimTab()
    clearContent()
    searchFrame.Visible = false
    content.Position = UDim2.new(0, 10, 0, 78)

    makeHeader("Apply saved anims")
    makeButton("Apply saved to R6 rig", function()
        local char = LP.Character
        if not char or not char:FindFirstChild("Torso") then toast("Not R6 rig", CFG.Bad) return end
        local n = 0
        for slot, id in pairs(State.anims) do if applyAnim(slot, id) then n = n + 1 end end
        toast("Applied " .. n .. " anims (R6)", CFG.Good)
    end)
    makeButton("Apply saved to R15 rig", function()
        local char = LP.Character
        if not char or not char:FindFirstChild("UpperTorso") then toast("Not R15 rig", CFG.Bad) return end
        local n = 0
        for slot, id in pairs(State.anims) do if applyAnim(slot, id) then n = n + 1 end end
        toast("Applied " .. n .. " anims (R15)", CFG.Good)
    end)

    makeHeader("R6 — Built-in")
    for _, a in ipairs(ANIMS.R6) do
        makeButton(a.name .. "  [" .. a.id .. "]", function()
            local ok, err = applyAnim(a.name, a.id)
            toast(ok and ("R6 " .. a.name .. " set") or tostring(err), ok and CFG.Good or CFG.Bad)
        end)
    end

    makeHeader("R15 — Built-in")
    for _, a in ipairs(ANIMS.R15) do
        makeButton(a.name .. "  [" .. a.id .. "]", function()
            local ok, err = applyAnim(a.name, a.id)
            toast(ok and ("R15 " .. a.name .. " set") or tostring(err), ok and CFG.Good or CFG.Bad)
        end)
    end

    makeHeader("Custom")
    local slotIdx = 1
    local slotBtn = create("TextButton", {
        Parent = content, Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = CFG.Button, Text = "  Slot: " .. SLOT_LIST[slotIdx],
        TextColor3 = CFG.Text, Font = Enum.Font.GothamMedium, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0, AutoButtonColor = false,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = slotBtn })
    slotBtn.MouseButton1Click:Connect(function()
        slotIdx = slotIdx % #SLOT_LIST + 1
        slotBtn.Text = "  Slot: " .. SLOT_LIST[slotIdx]
    end)

    local idBox = create("TextBox", {
        Parent = content, Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = CFG.Button, Text = "",
        PlaceholderText = "Animation ID (e.g. 507771019)",
        PlaceholderColor3 = CFG.SubText, TextColor3 = CFG.Text,
        Font = Enum.Font.GothamMedium, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
        ClearTextOnFocus = false,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = idBox })
    create("UIPadding", { PaddingLeft = UDim.new(0, 12), Parent = idBox })

    makeButton("Apply custom ID", function()
        local slot = SLOT_LIST[slotIdx]
        local ok, err = applyById(slot, idBox.Text)
        toast(ok and ("Applied to " .. slot) or ("Failed: " .. tostring(err)), ok and CFG.Good or CFG.Bad)
    end)

    setStatus("Animations", CFG.SubText)
end

local function renderMiscTab()
    clearContent()
    searchFrame.Visible = false
    content.Position = UDim2.new(0, 10, 0, 78)

    makeHeader("Floating Icon")

    local visBtn = makeButton(
        "Icon visible: " .. (State.iconOn and "ON" or "OFF"),
        function() end
    )
    visBtn.MouseButton1Click:Connect(function()
        setIconVisible(not State.iconOn)
        visBtn.Text = "  Icon visible: " .. (State.iconOn and "ON" or "OFF")
        visBtn.TextColor3 = State.iconOn and CFG.Good or CFG.Text
        toast("Icon " .. (State.iconOn and "shown" or "hidden"),
            State.iconOn and CFG.Good or CFG.SubText)
    end)
    visBtn.TextColor3 = State.iconOn and CFG.Good or CFG.Text

    local sizeBtn = makeButton("Icon size: " .. State.iconSize .. "px (tap to cycle)", function() end)
    sizeBtn.MouseButton1Click:Connect(function()
        local sizes = { 44, 56, 72, 88 }
        local cur = State.iconSize
        local nextIdx = 1
        for i, s in ipairs(sizes) do if s == cur then nextIdx = i % #sizes + 1 break end end
        setIconSize(sizes[nextIdx])
        sizeBtn.Text = "  Icon size: " .. State.iconSize .. "px (tap to cycle)"
        toast("Icon size: " .. State.iconSize, CFG.SubText)
    end)

    makeButton("Reset icon position", function()
        State.iconPos.x = 40
        State.iconPos.y = 120
        icon.Position = UDim2.new(0, State.iconPos.x, 1, -State.iconPos.y)
        toast("Icon position reset", CFG.SubText)
    end)

    makeButton("Minimize to icon now", function()
        setIconVisible(true)
        main.Visible = false
        toast("Minimized", CFG.SubText)
    end)

    makeHeader("How to use")
    makeButton("Read tips", function()
        toast("Drag icon anywhere • Tap icon to open/close hub", CFG.SubText)
    end)

    setStatus("Misc — Floating Icon", CFG.SubText)
end

-- ============ CONFIG ============
local function saveConfig()
    if not writefile then toast("writefile not available", CFG.Bad) return false end
    local payload = {
        anims    = State.anims,
        iconOn   = State.iconOn,
        iconPos  = State.iconPos,
        iconSize = State.iconSize,
    }
    local ok, encoded = pcall(function() return HS:JSONEncode(payload) end)
    if not ok then toast("encode failed", CFG.Bad) return false end
    local ok2, err = pcall(writefile, CONFIG_FILE, encoded)
    if not ok2 then toast("save failed: " .. tostring(err), CFG.Bad) return false end
    toast("Config saved", CFG.Good)
    return true
end

local function loadConfig(applyAnims)
    if not (isfile and readfile) then toast("no file API", CFG.Bad) return false end
    if not isfile(CONFIG_FILE) then toast("no saved config", CFG.Bad) return false end
    local ok, content_ = pcall(readfile, CONFIG_FILE)
    if not ok then toast("read failed", CFG.Bad) return false end
    local ok2, decoded = pcall(function() return HS:JSONDecode(content_) end)
    if not ok2 or type(decoded) ~= "table" then toast("bad config file", CFG.Bad) return false end

    State.anims = decoded.anims or {}
    if decoded.iconOn ~= nil then setIconVisible(decoded.iconOn) end
    if decoded.iconPos then
        State.iconPos.x = decoded.iconPos.x or 40
        State.iconPos.y = decoded.iconPos.y or 120
        icon.Position = UDim2.new(0, State.iconPos.x, 1, -State.iconPos.y)
    end
    if decoded.iconSize then setIconSize(decoded.iconSize) end

    toast("Config loaded", CFG.Good)
    if applyAnims then
        local n = 0
        for slot, id in pairs(State.anims) do if applyAnim(slot, id) then n = n + 1 end end
        toast("Applied " .. n .. " anims", CFG.Good)
    end
    return true
end

local function renderConfigTab()
    clearContent()
    searchFrame.Visible = false
    content.Position = UDim2.new(0, 10, 0, 78)

    makeButton("Save config", function() saveConfig() end)
    makeButton("Load config (no apply)", function() loadConfig(false) end)
    makeButton("Load + apply anims", function() loadConfig(true) end)
    makeButton("Reset anim memory", function()
        State.anims = {}
        toast("Cleared anim memory", CFG.SubText)
    end)
    makeButton("Delete config file", function()
        if delfile then pcall(delfile, CONFIG_FILE); toast("Deleted", CFG.SubText)
        else toast("delfile not available", CFG.Bad) end
    end)

    setStatus("Config — " .. CONFIG_FILE, CFG.SubText)
end

-- ============ TAB SWITCH ============
local function showTab(idx)
    for i, btn in ipairs(tabButtons) do
        btn.BackgroundColor3 = (i == idx) and CFG.Accent or CFG.Button
    end

    local name = TAB_NAMES[idx]
    if name == "Keyless" then
        currentScriptGroup = "Keyless"
        searchFrame.Visible = true
        content.Position = UDim2.new(0, 10, 0, 116)
        renderScriptList(HUB_SCRIPTS[1].scripts)
    elseif name == "Key System" then
        currentScriptGroup = "Key System"
        searchFrame.Visible = true
        content.Position = UDim2.new(0, 10, 0, 116)
        renderScriptList(HUB_SCRIPTS[2].scripts)
    elseif name == "Animations" then
        renderAnimTab()
    elseif name == "Misc" then
        renderMiscTab()
    elseif name == "Config" then
        renderConfigTab()
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    searchText = searchBox.Text
    if currentScriptGroup == "Keyless" then
        renderScriptList(HUB_SCRIPTS[1].scripts)
    elseif currentScriptGroup == "Key System" then
        renderScriptList(HUB_SCRIPTS[2].scripts)
    end
end)

for i, btn in ipairs(tabButtons) do
    btn.MouseButton1Click:Connect(function() showTab(i) end)
end

-- Auto-load config on startup
pcall(loadConfig, false)

showTab(1)
toast("Andrei Multi Hub v2.1 ready", CFG.Accent)
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
