local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- UI Setup
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "FlingUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 10)

-- Close Button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Fling Button
local flingBtn = Instance.new("TextButton", frame)
flingBtn.Size = UDim2.new(0.9, 0, 0, 40)
flingBtn.Position = UDim2.new(0.05, 0, 0.5, -20)
flingBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
flingBtn.Text = "FLING FALL"
flingBtn.TextColor3 = Color3.new(1, 1, 1)
flingBtn.Font = Enum.Font.GothamBold
flingBtn.TextSize = 16
Instance.new("UICorner", flingBtn).CornerRadius = UDim.new(1, 0)

-- Fling Logic
flingBtn.MouseButton1Click:Connect(function()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local humanoid = char:FindFirstChild("Humanoid")
	if not (hrp and humanoid) then return end

	-- Step 1: Fall over
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)

	for _, part in ipairs(char:GetChildren()) do
		if part:IsA("BasePart") and part ~= hrp then
			part.Anchored = false
			part.CanCollide = true
		end
	end

	-- Step 2: Downward force
	local force = Instance.new("BodyVelocity")
	force.Velocity = Vector3.new(0, -1000, 0)
	force.MaxForce = Vector3.new(0, math.huge, 0)
	force.P = 1250
	force.Parent = hrp

	-- Step 3: Get up after 3s
	task.delay(0.1, function()
		if force then force:Destroy() end
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		task.wait(0.1)
		humanoid:ChangeState(Enum.HumanoidStateType.Running)
	end)
end)
