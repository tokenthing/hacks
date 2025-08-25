local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "ExecutorUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 600, 0, 400)
frame.Position = UDim2.new(0.5, -300, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

minimizeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)
local tabContainer = Instance.new("Frame", frame)
tabContainer.Size = UDim2.new(1, -20, 0, 40)
tabContainer.Position = UDim2.new(0, 10, 0, 10)
tabContainer.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 5)

local tabs = {}
local currentTab = nil

local function createTab(name)
    local tabBtn = Instance.new("TextButton", tabContainer)
    tabBtn.Size = UDim2.new(0, 100, 0, 30)
    tabBtn.Text = name
    tabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

    local scriptBox = Instance.new("TextBox", frame)
    scriptBox.Size = UDim2.new(1, -20, 1, -100)
    scriptBox.Position = UDim2.new(0, 10, 0, 60)
    scriptBox.Text = ""
    scriptBox.MultiLine = true
    scriptBox.TextWrapped = true
    scriptBox.TextXAlignment = Enum.TextXAlignment.Left
    scriptBox.TextYAlignment = Enum.TextYAlignment.Top
    scriptBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    scriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    scriptBox.Font = Enum.Font.Code
    scriptBox.TextSize = 14
    Instance.new("UICorner", scriptBox).CornerRadius = UDim.new(0, 6)
    scriptBox.Visible = false

    tabBtn.MouseButton1Click:Connect(function()
        if currentTab then currentTab.Visible = false end
        scriptBox.Visible = true
        currentTab = scriptBox
    end)

    table.insert(tabs, scriptBox)
end

createTab("Main")
createTab("Alt")
local executeBtn = Instance.new("TextButton", frame)
executeBtn.Size = UDim2.new(0, 100, 0, 30)
executeBtn.Position = UDim2.new(0, 10, 1, -30)
executeBtn.Text = "Execute"
executeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", executeBtn).CornerRadius = UDim.new(0, 6)

executeBtn.MouseButton1Click:Connect(function()
    if currentTab then
        local code = currentTab.Text
        local func, err = loadstring(code)
        if func then
            func()
        else
            warn("Error: " .. err)
        end
    end
end)
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 85, 255))
}
gradient.Rotation = 90
local settingsPanel = Instance.new("Frame", screenGui)
settingsPanel.Size = UDim2.new(0, 320, 0, 500)
settingsPanel.Position = UDim2.new(0.5, -160, 0.5, -250)
settingsPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
settingsPanel.Visible = false
settingsPanel.Active = true
settingsPanel.Draggable = true
Instance.new("UICorner", settingsPanel).CornerRadius = UDim.new(0, 8)

local layout = Instance.new("UIListLayout", settingsPanel)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
local settingsBtn = Instance.new("TextButton", frame)
settingsBtn.Size = UDim2.new(0, 100, 0, 30)
settingsBtn.Position = UDim2.new(0, 10, 1, -65)
settingsBtn.Text = "⚙ Settings"
settingsBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
settingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsBtn.Font = Enum.Font.SourceSansBold
settingsBtn.TextSize = 16
Instance.new("UICorner", settingsBtn).CornerRadius = UDim.new(0, 6)

settingsBtn.MouseButton1Click:Connect(function()
    settingsPanel.Visible = not settingsPanel.Visible
end)
local function createSettingButton(label, callback)
    local btn = Instance.new("TextButton", settingsPanel)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Text = label
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
end

local function createSettingTextBox(labelText, defaultValue, onApply)
    local label = Instance.new("TextLabel", settingsPanel)
    label.Text = labelText
    label.Size = UDim2.new(1, -20, 0, 20)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14

    local box = Instance.new("TextBox", settingsPanel)
    box.Size = UDim2.new(1, -20, 0, 30)
    box.Text = tostring(defaultValue)
    box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 16
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

    box.FocusLost:Connect(function()
        onApply(box.Text)
    end)
end
-- Brightness
createSettingTextBox("Brightness", game.Lighting.Brightness, function(val)
    local num = tonumber(val)
    if num then game.Lighting.Brightness = num end
end)

-- FogEnd
createSettingTextBox("Fog End", game.Lighting.FogEnd, function(val)
    local num = tonumber(val)
    if num then game.Lighting.FogEnd = num end
end)

-- TimeOfDay
createSettingTextBox("Time of Day (HH:MM:SS)", game.Lighting.TimeOfDay, function(val)
    if string.match(val, "^%d%d:%d%d:%d%d$") then
        game.Lighting.TimeOfDay = val
    end
end)

-- Ambient Color
createSettingTextBox("Ambient (R,G,B)", "100,100,100", function(val)
    local r, g, b = string.match(val, "(%d+),(%d+),(%d+)")
    if r and g and b then
        game.Lighting.Ambient = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
    end
end)
local darkMode = true
createSettingButton("Toggle Theme", function(btn)
    darkMode = not darkMode
    frame.BackgroundColor3 = darkMode and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(240, 240, 240)
    btn.Text = darkMode and "Theme: Dark" or "Theme: Light"
end)
-- Bloom
createSettingButton("Toggle Bloom", function(btn)
    local bloom = game.Lighting:FindFirstChildOfClass("BloomEffect")
    if bloom then
        bloom:Destroy()
        btn.Text = "Bloom: Off"
    else
        local newBloom = Instance.new("BloomEffect", game.Lighting)
        newBloom.Intensity = 1.5
        btn.Text = "Bloom: On"
    end
end)

-- Blur
createSettingButton("Toggle Blur", function(btn)
    local blur = game.Lighting:FindFirstChildOfClass("BlurEffect")
    if blur then
        blur:Destroy()
        btn.Text = "Blur: Off"
    else
        local newBlur = Instance.new("BlurEffect", game.Lighting)
        newBlur.Size = 10
        btn.Text = "Blur: On"
    end
end)
-- Max Zoom
createSettingTextBox("Max Zoom Distance", player.CameraMaxZoomDistance, function(val)
    local num = tonumber(val)
    if num then player.CameraMaxZoomDistance = num end
end)

-- Min Zoom
createSettingTextBox("Min Zoom Distance", player.CameraMinZoomDistance, function(val)
    local num = tonumber(val)
    if num then player.CameraMinZoomDistance = num end
end)

-- WalkSpeed
createSettingTextBox("WalkSpeed", 16, function(val)
    local num = tonumber(val)
    local char = player.Character
    if num and char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = num
    end
end)

-- JumpPower
createSettingTextBox("JumpPower", 50, function(val)
    local num = tonumber(val)
    local char = player.Character
    if num and char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = num
    end
end)
