_G.love = require("love")
_G.utils = require("utils")
local Asteroids = require("asteroids")
local DevSettings = require("dev_settings")
local Player = require("player")

function love.load()
    _G.window_width = love.graphics.getWidth()
    _G.window_height = love.graphics.getHeight()
    _G.square_size = 50
    _G.x = (_G.window_width - _G.square_size) / 2
    _G.y = (_G.window_height - _G.square_size) / 2
    Player.initialize()
    _G.spawnTimer = 0
    _G.showDevSettings = false
    _G.asteroids = {}
end

function love.update(dt)
    _G.spawnTimer = _G.spawnTimer + dt
    local spawnInterval = 1 / _G.devSettings.spawnRate.value
    if _G.spawnTimer >= spawnInterval then
        _G.spawnTimer = 0
        Asteroids.spawn()
    end
    Player.update(dt)
    Asteroids.update(dt)
end

function love.keypressed(key)
    if key == "s" and love.keyboard.isDown("lctrl", "rctrl") then
        _G.showDevSettings = not _G.showDevSettings
        if _G.showDevSettings then
            _G.selectedSetting = "spawnRate"
            _G.inputBuffer = ""
        else
            _G.selectedSetting = nil
        end
    elseif _G.showDevSettings then
        DevSettings.handleInput(key)
    end
end

function love.draw(dt)
    Player.draw()
    Asteroids.draw()

    if _G.showDevSettings then
        DevSettings.draw()
    end

end
