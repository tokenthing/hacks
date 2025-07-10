local function loadCustomCommands()
    if not request then return end

    local success, res = pcall(function()
        return request({
            Url = "https://raw.githubusercontent.com/tokenthing/hacks/refs/heads/remotecontrol/commands.json",
            Method = "GET"
        })
    end)

    if success and res and res.Body then
        local data = game:GetService("HttpService"):JSONDecode(res.Body)
        customCommands = data
        print("✅ Loaded commands from GitHub")
    else
        warn("❌ Failed to load GitHub commands")
    end
end
