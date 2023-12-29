local Asteroids = {}
_G.asteroids = {}

function Asteroids.spawn()
    local ax, ay
    repeat
        ax = love.math.random(0, _G.window_width)
        ay = love.math.random(0, _G.window_height)
    until math.sqrt((_G.x + _G.square_size / 2 - ax)^2 + (_G.y + _G.square_size / 2 - ay)^2) >= _G.devSettings.minDistance.value
    table.insert(_G.asteroids, {x = ax, y = ay, speed = _G.devSettings.enemySpeed.value})
end

function Asteroids.update(dt)
    for i = #_G.asteroids, 1, -1 do
        local asteroid = _G.asteroids[i]
        local dirX = _G.x + _G.square_size / 2 - asteroid.x
        local dirY = _G.y + _G.square_size / 2 - asteroid.y
        local length = math.sqrt(dirX^2 + dirY^2)
        dirX = dirX / length
        dirY = dirY / length

        asteroid.x = asteroid.x + dirX * asteroid.speed * dt
        asteroid.y = asteroid.y + dirY * asteroid.speed * dt

        if _G.utils.checkCollision(asteroid.x, asteroid.y, 20, _G.x, _G.y, _G.square_size) then
            table.remove(_G.asteroids, i)
        end
    end
end

function Asteroids.draw()
    for i, asteroid in ipairs(_G.asteroids) do
        love.graphics.circle("line", asteroid.x, asteroid.y, 20)
    end
end

return Asteroids
