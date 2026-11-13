local RS = game:GetService("ReplicatedStorage")
local RequestCarry = RS:WaitForChild("Network"):WaitForChild("Eggs: RequestAreaEggCarry")
local autoSteal = false

-- GUI
local screen = Instance.new("ScreenGui")
screen.Parent = game:GetService("CoreGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 200, 0, 45)
btn.Position = UDim2.new(0.5, -100, 0, 20)
btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
btn.Text = "Auto Steal: OFF"
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.Parent = screen
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

btn.MouseButton1Click:Connect(function()
    autoSteal = not autoSteal
    btn.Text = "Auto Steal: " .. (autoSteal and "ON" or "OFF")
    btn.BackgroundColor3 = autoSteal and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(30, 30, 45)
end)

-- Function para maghanap ng UID ng egg sa paligid
local function findNearestEggUID()
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local closestUID = nil
    local minDist = 50 -- Maximum na layo (studs) para hanapin ang egg
    
    for _, v in pairs(workspace:GetDescendants()) do
        -- Hahanapin natin yung object na may "AreaEgg" sa pangalan o UID
        if string.find(v.Name, "AreaEgg_") then
            local part = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
            if part then
                local dist = (char.HumanoidRootPart.Position - part.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closestUID = v.Name -- Kunin yung name na naglalaman ng UID
                end
            end
        end
    end
    return closestUID
end

-- Loop
task.spawn(function()
    while task.wait(0.5) do -- 0.5s delay para iwas kick
        if autoSteal then
            local uid = findNearestEggUID()
            
            if uid then
                -- I-format natin yung args base sa screenshot mo
                local args = {
                    [1] = {
                        ["Uid"] = uid
                    }
                }
                
                pcall(function()
                    RequestCarry:FireServer(unpack(args))
                end)
            end
        end
    end
end)