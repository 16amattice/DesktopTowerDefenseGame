local Health = {}

function Health.initialize()
    _G.playerHealth = _G.devSettings.playerHealth.value
end

function Health.decrease(amount)
    if _G.playerHealth > 0 then
        _G.playerHealth = _G.playerHealth - amount
    end

    if _G.playerHealth <= 0 then
        _G.playerHealth = 0
        Health.gameOver()
    end
end


function Health.gameOver()
    _G.gameState = "gameover"
end

function Health.drawGameOver()
    if _G.gameState == "gameover" then
        love.graphics.printf("Game Over\nPress Enter to Restart", 0, _G.window_height / 2, _G.window_width, 'center')
    end
end

function Health.drawHealth()
    love.graphics.printf("Health: " .. _G.playerHealth, _G.window_width - 120, 10, 120, 'right')
end

-- Refactor into a GameState function?
function Health.restartGame()
    if _G.gameState == "gameover" and (love.keyboard.isDown("return") or love.keyboard.isDown("kpenter")) then
        -- Reset game state
        _G.gameState = "playing"

        -- Reset health
        Health.initialize()

        -- Clear asteroids and bullets
        _G.asteroids = {}
        _G.player.bullets = {}

        -- Reset player position
        _G.player.x = _G.window_width / 2
        _G.player.y = _G.window_height / 2
        _G.player.direction = math.pi / 2 

        -- Why are we calling these in so many spots. Lets fix this already :).
        _G.devSettings.spawnRate.value = 2
        _G.devSettings.minDistance.value = 100
        _G.devSettings.enemySpeed.value = 100
        _G.devSettings.attackSpeed.value = 3
        _G.devSettings.bulletSpeed.value = 100
        _G.devSettings.playerHealth.value = 10
        _G.devSettings.Sounds.value = true
    end
end


return Health
