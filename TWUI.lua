-- TWUI.lua
local TWUI = {}

function TWUI:CreateWindow(config)
    -- Create ScreenGui, main frame, title bar, etc.
end

function TWUI:CreateWindow(config)
    local self = {}
    function self:CreateTab(name, iconId)
        -- tab creation logic
    end
    return self
end


function TWUI:CreateButton(tab, config)
    -- Button creation logic
end

function TWUI:CreateToggle(tab, config)
    -- Toggle with state tracking
end

-- Add sliders, dropdowns, labels, etc.

return TWUI
