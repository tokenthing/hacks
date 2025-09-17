function TWUI:CreateWindow(config)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = config.Name or "TWUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true -- ✅ Makes it draggable
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
