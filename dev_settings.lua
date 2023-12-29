_G.utils = require("utils")

local DevSettings = {}
_G.devSettings = {
    spawnRate = { value = 2, edit = false },
    minDistance = { value = 100, edit = false },
    enemySpeed = { value = 100, edit = false },
    attackSpeed = { value = 3, edit = false},
    bulletSpeed = { value = 100, edit = false},
    playerHealth = { value = 10, edit = false},
    Sounds = { value = true, edit = false}
}
_G.selectedSetting = 1
_G.inputBuffer = ""

function DevSettings.handleInput(key)
    local settingKeys = {"spawnRate", "minDistance", "enemySpeed", "attackSpeed", "bulletSpeed", "playerHealth", "Sounds"}

    if key == "tab" then
        local currentIndex = _G.utils.indexOf(settingKeys, _G.selectedSetting)
        _G.selectedSetting = settingKeys[(currentIndex % #settingKeys) + 1]
        _G.inputBuffer = ""
    else
        if _G.selectedSetting then
            if key == "backspace" then
                _G.inputBuffer = _G.inputBuffer:sub(1, -2)
            elseif key:len() == 1 and key:match("%d") then
                _G.inputBuffer = _G.inputBuffer .. key
            elseif key == "return" or key == "kpenter" then
                if _G.selectedSetting == "Sounds" then
                    _G.devSettings[_G.selectedSetting].value = not _G.devSettings[_G.selectedSetting].value
                elseif tonumber(_G.inputBuffer) then
                    _G.devSettings[_G.selectedSetting].value = tonumber(_G.inputBuffer)
                end
                _G.inputBuffer = ""
            elseif _G.utils.isNumpadKey(key) then
                local numpadNumber = key:match("kp(%d)")
                if numpadNumber then
                    _G.inputBuffer = _G.inputBuffer .. numpadNumber
                end
            end
        end
    end
end


function DevSettings.draw()
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 10, 10, 200, 120)

    local settingOrder = {"spawnRate", "minDistance", "enemySpeed", "attackSpeed", "bulletSpeed", "playerHealth", "Sounds"}
    local y = 15
    for _, key in ipairs(settingOrder) do
        local setting = _G.devSettings[key]
        local value = setting.value
        local valueStr = type(value) == "boolean" and (value and "True" or "False") or tostring(value)

        if _G.selectedSetting == key then
            love.graphics.setColor(1, 1, 0)
            love.graphics.print(key .. ": " .. valueStr .. " (" .. _G.inputBuffer .. ")", 15, y)
        else
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(key .. ": " .. valueStr, 15, y)
        end
        y = y + 20
    end
    love.graphics.setColor(1, 1, 1)
end


return DevSettings
