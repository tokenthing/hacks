local TWUI = {}
local TweenService = game:GetService("TweenService")

local function addCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
end

local function addShadow(instance)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Image = "rbxassetid://1316045217"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.ImageTransparency = 0.5
    shadow.ZIndex = instance.ZIndex - 1
    shadow.Parent = instance
end

function TWUI:CreateWindow(config)
    local player = game.Players.LocalPlayer
    if not player then
        warn("TWUI: LocalPlayer not found. This must be run in a LocalScript.")
        return nil
    end

    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = config.Name or "TWUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 420, 0, 320)
    mainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
    mainFrame.BackgroundColor3 = Color3.fromRGB(34, 40, 49)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ZIndex = 2
    mainFrame.Parent = screenGui
    addCorner(mainFrame, 18)
    addShadow(mainFrame)

    -- Sidebar (Script Suggestion)
    local sidebarWidth = 170
    local sidebarFrame = Instance.new("Frame")
    sidebarFrame.Size = UDim2.new(0, sidebarWidth, 1, 0)
    sidebarFrame.Position = UDim2.new(0, -sidebarWidth, 0, 0)
    sidebarFrame.BackgroundColor3 = Color3.fromRGB(38, 44, 51)
    sidebarFrame.BorderSizePixel = 0
    sidebarFrame.ZIndex = 20
    sidebarFrame.Visible = false
    sidebarFrame.Parent = mainFrame
    addCorner(sidebarFrame, 16)
    addShadow(sidebarFrame)

    local sidebarLabel = Instance.new("TextLabel")
    sidebarLabel.Size = UDim2.new(1, 0, 0, 40)
    sidebarLabel.Position = UDim2.new(0, 0, 0, 0)
    sidebarLabel.BackgroundTransparency = 1
    sidebarLabel.Text = "Script Suggestions"
    sidebarLabel.TextColor3 = Color3.fromRGB(220,220,220)
    sidebarLabel.Font = Enum.Font.GothamBold
    sidebarLabel.TextSize = 18
    sidebarLabel.ZIndex = 21
    sidebarLabel.Parent = sidebarFrame

    -- Only suggest scripts that are most reliable
    local scripts = {
        {
            Name = "Infinite Yield",
            Url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
        },
        {
            Name = "Simple Spy",
            Url = "https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"
        }
    }

    local scriptY = 50
    for i, v in ipairs(scripts) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 32)
        btn.Position = UDim2.new(0, 10, 0, scriptY)
        btn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
        btn.Text = v.Name
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 15
        btn.ZIndex = 22
        btn.Parent = sidebarFrame
        addCorner(btn, 10)
        addShadow(btn)
        btn.MouseButton1Click:Connect(function()
            local success, err = pcall(function()
                loadstring(game:HttpGet(v.Url))()
            end)
            if not success then
                warn("Script failed: "..err)
            end
        end)
        scriptY = scriptY + 38
    end

    -- Sidebar Toggle Button (Arrow)
    local sidebarToggle = Instance.new("TextButton")
    sidebarToggle.Size = UDim2.new(0, 28, 0, 60)
    sidebarToggle.Position = UDim2.new(0, -28, 0.5, -30)
    sidebarToggle.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
    sidebarToggle.Text = "→"
    sidebarToggle.TextColor3 = Color3.new(1,1,1)
    sidebarToggle.Font = Enum.Font.GothamBlack
    sidebarToggle.TextSize = 22
    sidebarToggle.ZIndex = 30
    sidebarToggle.Parent = mainFrame
    addCorner(sidebarToggle, 12)
    addShadow(sidebarToggle)

    local sidebarOpen = true
    sidebarToggle.MouseButton1Click:Connect(function()
        sidebarOpen = not sidebarOpen
        if sidebarOpen then
            sidebarFrame.Visible = false
            local tween = TweenService:Create(sidebarFrame, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, 0)
            })
            tween:Play()
            sidebarToggle.Text = "→"
        else
            local tween = TweenService:Create(sidebarFrame, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, -sidebarWidth, 0, 0)
            })
            tween:Play()
            sidebarToggle.Text = "←"
            tween.Completed:Connect(function()
                sidebarFrame.Visible = true
            end)
        end
    end)

    -- Main UI (rest unchanged) ...
    -- Title bar, tabs, etc. as in previous versions

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 56, 89)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    titleBar.ZIndex = 3
    addCorner(titleBar, 14)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.Name or "TWUI"
    titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 22
    titleLabel.ZIndex = 4
    titleLabel.Parent = titleBar

    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 20
    closeButton.ZIndex = 5
    closeButton.Parent = titleBar
    addCorner(closeButton, 12)
    addShadow(closeButton)
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Minimize Button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -70, 0, 5)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
    minimizeButton.Text = "–"
    minimizeButton.TextColor3 = Color3.new(1, 1, 1)
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 20
    minimizeButton.ZIndex = 5
    minimizeButton.Parent = titleBar
    addCorner(minimizeButton, 12)
    addShadow(minimizeButton)

    -- Mini Icon Frame
    local iconFrame = Instance.new("Frame")
    iconFrame.Size = UDim2.new(0, 54, 0, 54)
    iconFrame.Position = UDim2.new(0, 20, 0, 20)
    iconFrame.BackgroundColor3 = Color3.fromRGB(60, 140, 190)
    iconFrame.Visible = false
    iconFrame.Active = true
    iconFrame.Draggable = true
    iconFrame.ZIndex = 10
    iconFrame.Parent = screenGui
    addCorner(iconFrame, 16)
    addShadow(iconFrame)

    local iconButton = Instance.new("TextButton")
    iconButton.Size = UDim2.new(1, 0, 1, 0)
    iconButton.BackgroundTransparency = 1
    iconButton.Text = "🗂"
    iconButton.TextSize = 30
    iconButton.Font = Enum.Font.GothamBold
    iconButton.TextColor3 = Color3.new(1, 1, 1)
    iconButton.ZIndex = 11
    iconButton.Parent = iconFrame
    minimizeButton.MouseButton1Click:Connect(function()
        local tweenOut = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -210, 1.2, 0),
            BackgroundTransparency = 1
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            mainFrame.Visible = false
            iconFrame.Visible = true
            iconFrame.BackgroundTransparency = 1
            TweenService:Create(iconFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        end)
    end)
    iconButton.MouseButton1Click:Connect(function()
        iconFrame.Visible = false
        mainFrame.Position = UDim2.new(0.5, -210, 1.2, 0)
        mainFrame.BackgroundTransparency = 1
        mainFrame.Visible = true
        TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -210, 0.5, -160),
            BackgroundTransparency = 0
        }):Play()
    end)

    local self = {}
    self.MainFrame = mainFrame
    self.Tabs = {}

    function self:CreateTab(name, iconId)
        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, -20, 1, -60)
        tabFrame.Position = UDim2.new(0, 10, 0, 50)
        tabFrame.BackgroundColor3 = Color3.fromRGB(44, 49, 59)
        tabFrame.BackgroundTransparency = 0.08
        tabFrame.Name = name
        tabFrame.ZIndex = 6
        tabFrame.Parent = mainFrame
        addCorner(tabFrame, 14)
        addShadow(tabFrame)
        self.Tabs[name] = tabFrame
        return tabFrame
    end

    function self:CreateButton(tab, config)
        if not tab then
            warn("TWUI: Tab not found for CreateButton!")
            return
        end
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 220, 0, 44)
        button.Position = UDim2.new(0, 16, 0, 16 + (#tab:GetChildren() * 48))
        button.BackgroundColor3 = Color3.fromRGB(55, 100, 230)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.Gotham
        button.TextSize = 18
        button.Text = config.Name or "Button"
        button.ZIndex = 7
        button.Parent = tab
        addCorner(button, 10)
        addShadow(button)
        button.MouseButton1Click:Connect(function()
            if config.Callback then
                config.Callback(button)
            end
        end)
        return button
    end

    function self:CreateSlider(tab, config)
        if not tab then
            warn("TWUI: Tab not found for CreateSlider!")
            return
        end
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(0, 220, 0, 48)
        sliderFrame.Position = UDim2.new(0, 16, 0, 16 + (#tab:GetChildren() * 54))
        sliderFrame.BackgroundColor3 = Color3.fromRGB(55, 65, 100)
        sliderFrame.ZIndex = 7
        sliderFrame.Parent = tab
        addCorner(sliderFrame, 10)
        addShadow(sliderFrame)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0.5, 0)
        label.Text = (config.Name or "Slider") .. ": " .. tostring(config.CurrentValue or "")
        label.TextColor3 = Color3.new(1, 1, 1)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextSize = 17
        label.ZIndex = 8
        label.Parent = sliderFrame
        local slider = Instance.new("TextButton")
        slider.Size = UDim2.new(1, 0, 0.5, 0)
        slider.Position = UDim2.new(0, 0, 0.5, 0)
        slider.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
        slider.Text = ""
        slider.ZIndex = 8
        slider.Parent = sliderFrame
        addCorner(slider, 6)
        local dragging = false
        slider.MouseButton1Down:Connect(function()
            dragging = true
        end)
        slider.MouseButton1Up:Connect(function()
            dragging = false
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                local value = math.floor((config.Range[1] or 0) + ((config.Range[2] or 100) - (config.Range[1] or 0)) * relX)
                value = math.floor(value / (config.Increment or 1)) * (config.Increment or 1)
                label.Text = (config.Name or "Slider") .. ": " .. tostring(value)
                if config.Callback then
                    config.Callback(value)
                end
            end
        end)
        return sliderFrame
    end

    return self
end

return TWUI
