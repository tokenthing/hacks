local sidebarOpen = false
sidebarToggle.MouseButton1Click:Connect(function()
    sidebarOpen = not sidebarOpen
    if sidebarOpen then
        sidebarFrame.Position = UDim2.new(0, -sidebarWidth, 0, 0)
        sidebarFrame.Visible = true
        sidebarToggle.Text = "←"
        TweenService:Create(
            sidebarFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
            { Position = UDim2.new(0, 0, 0, 0) }
        ):Play()
    else
        sidebarToggle.Text = "→"
        local tween = TweenService:Create(
            sidebarFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
            { Position = UDim2.new(0, -sidebarWidth, 0, 0) }
        )
        tween:Play()
        tween.Completed:Connect(function()
            sidebarFrame.Visible = false
        end)
    end
end)
