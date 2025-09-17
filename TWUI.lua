local TweenService = game:GetService("TweenService")

function TWUI:CreateWindow(config)
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = config.Name or "TWUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextSize = 18
    closeButton.Parent = mainFrame

    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Minimize Button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -70, 0, 5)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 255)
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = Color3.new(1, 1, 1)
    minimizeButton.Font = Enum.Font.SourceSansBold
    minimizeButton.TextSize = 18
    minimizeButton.Parent = mainFrame

    -- Mini Icon Frame
    local iconFrame = Instance.new("Frame")
    iconFrame.Size = UDim2.new(0, 50, 0, 50)
    iconFrame.Position = UDim2.new(0, 20, 0, 20)
    iconFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    iconFrame.Visible = false
    iconFrame.Active = true
    iconFrame.Draggable = true
    iconFrame.Parent = screenGui

    local iconButton = Instance.new("TextButton")
    iconButton.Size = UDim2.new(1, 0, 1, 0)
    iconButton.BackgroundTransparency = 1
    iconButton.Text = "📂"
    iconButton.TextSize = 24
    iconButton.Font = Enum.Font.SourceSansBold
    iconButton.TextColor3 = Color3.new(1, 1, 1)
    iconButton.Parent = iconFrame

    -- Tweened Minimize
    minimizeButton.MouseButton1Click:Connect(function()
        local tweenOut = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -200, 1.2, 0),
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

    -- Tweened Restore
    iconButton.MouseButton1Click:Connect(function()
        iconFrame.Visible = false
        mainFrame.Position = UDim2.new(0.5, -200, 1.2, 0)
        mainFrame.BackgroundTransparency = 1
        mainFrame.Visible = true
        TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -200, 0.5, -150),
            BackgroundTransparency = 0
        }):Play()
    end)

    local self = {}
    self.MainFrame = mainFrame
    self.Tabs = {}

    function self:CreateTab(name, iconId)
        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Name = name
        tabFrame.Parent = mainFrame

        self.Tabs[name] = tabFrame
        return tabFrame
    end

    function self:CreateButton(tab, config)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 200, 0, 40)
        button.Position = UDim2.new(0, 10, 0, 10 + (#tab:GetChildren() * 45))
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.SourceSans
        button.TextSize = 18
        button.Text = config.Name or "Button"
        button.Parent = tab

        button.MouseButton1Click:Connect(function()
            if config.Callback then
                config.Callback()
            end
        end)
    end

    return self
end
return TWUI

