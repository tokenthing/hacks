-- Put this in a LocalScript inside StarterPlayerScripts

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RemoteExecutorUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 150)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Title bar (for dragging)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 25)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Remote Executor"
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Text = "✕"
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = titleBar

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Input textbox for remote/script name
local inputBox = Instance.new("TextBox")
inputBox.PlaceholderText = "Enter RemoteEvent/Function/Script name"
inputBox.Size = UDim2.new(1, -20, 0, 35)
inputBox.Position = UDim2.new(0, 10, 0, 45)
inputBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
inputBox.TextColor3 = Color3.new(1,1,1)
inputBox.ClearTextOnFocus = false
inputBox.Font = Enum.Font.SourceSans
inputBox.TextSize = 18
inputBox.Parent = mainFrame

-- Execute button
local execButton = Instance.new("TextButton")
execButton.Text = "Execute"
execButton.Size = UDim2.new(1, -20, 0, 35)
execButton.Position = UDim2.new(0, 10, 0, 90)
execButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
execButton.TextColor3 = Color3.new(1,1,1)
execButton.Font = Enum.Font.SourceSansBold
execButton.TextSize = 20
execButton.Parent = mainFrame

-- Output label
local outputLabel = Instance.new("TextLabel")
outputLabel.Size = UDim2.new(1, -20, 0, 20)
outputLabel.Position = UDim2.new(0, 10, 0, 135)
outputLabel.BackgroundTransparency = 1
outputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
outputLabel.Font = Enum.Font.SourceSansItalic
outputLabel.TextSize = 14
outputLabel.Text = ""
outputLabel.Parent = mainFrame

local function findInstanceByName(name)
    -- Search entire game for instance with exact name
    local results = {}

    local function search(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child.Name == name then
                table.insert(results, child)
            end
            search(child)
        end
    end

    search(game)
    return results
end

execButton.MouseButton1Click:Connect(function()
    outputLabel.Text = ""
    local name = inputBox.Text
    if name == "" then
        outputLabel.Text = "Please enter a name."
        return
    end

    local foundInstances = findInstanceByName(name)
    if #foundInstances == 0 then
        outputLabel.Text = "No instance found with that name."
        return
    end

    for _, inst in ipairs(foundInstances) do
        if inst:IsA("RemoteEvent") then
            inst:FireServer()
            outputLabel.Text = "Fired RemoteEvent: " .. inst:GetFullName()
        elseif inst:IsA("RemoteFunction") then
            local success, result = pcall(function()
                return inst:InvokeServer()
            end)
            if success then
                outputLabel.Text = "Invoked RemoteFunction: " .. inst:GetFullName() .. "\nResult: " .. tostring(result)
            else
                outputLabel.Text = "Invoke failed: " .. tostring(result)
            end
        elseif inst:IsA("ModuleScript") then
            local success, module = pcall(require, inst)
            if success then
                outputLabel.Text = "Required ModuleScript: " .. inst:GetFullName()
            else
                outputLabel.Text = "Require failed: " .. tostring(module)
            end
        elseif inst:IsA("Script") or inst:IsA("LocalScript") then
            -- You can't "run" Scripts from client - just notify
            outputLabel.Text = "Found Script: " .. inst:GetFullName() .. " (cannot execute)"
        else
            outputLabel.Text = "Found instance: " .. inst:GetFullName() .. " (not executable)"
        end
        -- For simplicity, only act on the first found instance:
        break
    end
end)
