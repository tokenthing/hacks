-- control_client.lua

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Generate + store a random ID if not already created
getgenv().control_id = getgenv().control_id or HttpService:GenerateGUID(false)
local ID = getgenv().control_id

-- Print ID to console if supported
pcall(function()
    rconsoleprint("[Control Client] Your ID: " .. ID .. "\n")
end)

-- Link to your GitHub JSON
local COMMAND_URL = "https://raw.githubusercontent.com/tokenthing/hacks/main/commands.json"

function getHumanoid()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid")
end

function handleCommand(command)
    local humanoid = getHumanoid()
    if command == "jump" then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    elseif command:match("^speed ") then
        local speed = tonumber(command:match("^speed (%d+)$"))
        if speed then humanoid.WalkSpeed = speed end
    elseif command == "spin" then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            while true do
                char.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(5), 0)
                task.wait(0.01)
            end
        end
    end
end

-- Command check loop
while true do
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(COMMAND_URL))
    end)

    if success and result and result.players and result.players[ID] then
        local cmd = result.players[ID].command
        if cmd then
            handleCommand(cmd)
        end
    end

    task.wait(5)
end
