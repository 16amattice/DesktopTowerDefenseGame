_G.love = require("love")
_G.utils = require("utils")
_G.Health = require("health")
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
    Health.initialize()
    _G.spawnTimer = 0
    _G.showDevSettings = false
    _G.asteroids = {}
    _G.gameState = "playing"
end

function love.update(dt)
    if _G.gameState == "playing" then
        _G.spawnTimer = _G.spawnTimer + dt
        local spawnInterval = 1 / _G.devSettings.spawnRate.value
        if _G.spawnTimer >= spawnInterval then
            _G.spawnTimer = 0
            Asteroids.spawn()
        end
        Player.update(dt)
        Asteroids.update(dt)
    end

    Health.restartGame()
end

function love.keypressed(key)
    if _G.showDevSettings then
        DevSettings.handleInput(key)
    elseif key == "s" and love.keyboard.isDown("lctrl", "rctrl") then
        _G.showDevSettings = not _G.showDevSettings
        if _G.showDevSettings then
            _G.selectedSetting = "spawnRate"
            _G.inputBuffer = ""
        else
            _G.selectedSetting = nil
        end
    end
    if key == "space" then
        if _G.gameState ~= "gameover" then
            if _G.gameState ~= "paused" then
                _G.gameState = "paused"
            else
                _G.gameState = "playing"
            end
        end
    end
end


function love.draw(dt)
    if _G.gameState == "playing" or "paused" then
        Player.draw()
        Asteroids.draw()

        if _G.showDevSettings then
            DevSettings.draw()
        end
    end

    Health.drawHealth()

    if _G.gameState == "gameover" then
        Health.drawGameOver()
    end
end
