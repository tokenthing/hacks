local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Setup ScreenGui
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "MiniExecutor"
screenGui.ResetOnSpawn = false

-- Main Frame (Executor Window)
local executorFrame = Instance.new("Frame", screenGui)
executorFrame.Name = "ExecutorFrame"
executorFrame.Size = UDim2.new(0, 400, 0, 300)
executorFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
executorFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
executorFrame.BorderSizePixel = 0
executorFrame.Active = true
executorFrame.Draggable = true

-- Title
local titleLabel = Instance.new("TextLabel", executorFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleLabel.Text = "Mini Executor"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20

-- Script Input Box
local scriptBox = Instance.new("TextBox", executorFrame)
scriptBox.Position = UDim2.new(0, 10, 0, 40)
scriptBox.Size = UDim2.new(1, -20, 1, -90)
scriptBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
scriptBox.TextColor3 = Color3.new(1, 1, 1)
scriptBox.Font = Enum.Font.Code
scriptBox.TextSize = 16
scriptBox.ClearTextOnFocus = false
scriptBox.MultiLine = true
scriptBox.TextYAlignment = Enum.TextYAlignment.Top
scriptBox.TextWrapped = true
scriptBox.PlaceholderText = "-- Write your Lua script here"

-- Execute Button
local executeButton = Instance.new("TextButton", executorFrame)
executeButton.Size = UDim2.new(0, 120, 0, 30)
executeButton.Position = UDim2.new(0, 10, 1, -40)
executeButton.Text = "Execute"
executeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
executeButton.TextColor3 = Color3.new(1, 1, 1)
executeButton.Font = Enum.Font.SourceSansBold
executeButton.TextSize = 18

-- Clear Button
local clearButton = Instance.new("TextButton", executorFrame)
clearButton.Size = UDim2.new(0, 120, 0, 30)
clearButton.Position = UDim2.new(0, 140, 1, -40)
clearButton.Text = "Clear"
clearButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
clearButton.TextColor3 = Color3.new(1, 1, 1)
clearButton.Font = Enum.Font.SourceSansBold
clearButton.TextSize = 18

-- Execute logic
executeButton.MouseButton1Click:Connect(function()
	local code = scriptBox.Text
	if code and code ~= "" then
		local func, err = loadstring(code)
		if func then
			pcall(func)
		else
			warn("Script error: ", err)
		end
	end
end)

-- Clear logic
clearButton.MouseButton1Click:Connect(function()
	scriptBox.Text = ""
end)
