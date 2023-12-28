_G.utils = require("utils")

local DevSettings = {}
_G.devSettings = {
    spawnRate = { value = 2, edit = false },
    minDistance = { value = 100, edit = false },
    enemySpeed = { value = 100, edit = false }
}
_G.selectedSetting = 1
_G.inputBuffer = ""

function DevSettings.handleInput(key)
    local settingKeys = {"spawnRate", "minDistance", "enemySpeed"}

    if key == "tab" then
        local currentIndex = _G.utils.indexOf(settingKeys, _G.selectedSetting)
        _G.selectedSetting = settingKeys[(currentIndex % #settingKeys) + 1]
        _G.inputBuffer = ""
    elseif _G.selectedSetting then
        if key == "backspace" then
            _G.inputBuffer = _G.inputBuffer:sub(1, -2)
        elseif tonumber(key) or _G.utils.isNumpadKey(key) then
            _G.inputBuffer = _G.inputBuffer .. key:match("%d")
        elseif key == "return" or key == "kpenter" then
            if tonumber(_G.inputBuffer) then
                _G.devSettings[_G.selectedSetting].value = tonumber(_G.inputBuffer)
            end
            _G.inputBuffer = ""
        end
    end
end

function DevSettings.draw()
    love.graphics.setColor(0, 0, 0, 0.7) -- Semi-transparent background
    love.graphics.rectangle("fill", 10, 10, 200, 120)

    local settingOrder = {"spawnRate", "minDistance", "enemySpeed"}
    local y = 15
    for _, key in ipairs(settingOrder) do
        local setting = devSettings[key]
        if selectedSetting == key then
            love.graphics.setColor(1, 1, 0) -- Highlight color for selected setting
            love.graphics.print(key .. ": " .. setting.value .. " (" .. inputBuffer .. ")", 15, y)
        else
            love.graphics.setColor(1, 1, 1) -- White color for unselected settings
            love.graphics.print(key .. ": " .. setting.value, 15, y)
        end
        y = y + 20
    end
    love.graphics.setColor(1, 1, 1) -- Reset color to white for subsequent drawings
end

return DevSettings
