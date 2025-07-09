local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 🔑 Create persistent ID (stored in getgenv)
getgenv().control_id = getgenv().control_id or HttpService:GenerateGUID(false)
local ID = getgenv().control_id

-- 🌐 Your local server address
local SERVER = "http://localhost:3000" -- CHANGE IF NEEDED

-- 🧾 Register with your server
pcall(function()
    HttpService:PostAsync(
        SERVER.."/register",
        HttpService:JSONEncode({ id = ID }),
        Enum.HttpContentType.ApplicationJson
    )
end)

-- 🖥️ Print ID to executor console (if supported)
pcall(function()
    rconsoleclear()
    rconsoleprint("@@LIGHT_BLUE@@\n[Remote Client] Your Control ID: @@WHITE@@ " .. ID .. "\n")
end)

-- 🎮 Command handler
local function handleCommand(cmd)
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")

    if cmd == "jump" then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    elseif cmd and cmd:match("^speed ") then
        local speed = tonumber(cmd:match("^speed (%d+)"))
        if speed then humanoid.WalkSpeed = speed end
    elseif cmd == "spin" then
        task.spawn(function()
            local root = char:FindFirstChild("HumanoidRootPart")
            while true do
                if not root then break end
                root.CFrame *= CFrame.Angles(0, math.rad(5), 0)
                task.wait(0.01)
            end
        end)
    end
end

-- 🔁 Poll server every 5 seconds
while true do
    local success, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(SERVER.."/command/"..ID))
    end)

    if success and data and data.command then
        handleCommand(data.command)
    end

    task.wait(5)
end
