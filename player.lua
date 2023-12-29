local Player = {}

function Player.initialize()
    _G.player = {
        x = _G.window_width / 2,
        y = _G.window_height / 2,
        size = 50,
        bullets = {},
        attackTimer = 0
    }
end

function Player.update(dt)
    player.attackTimer = player.attackTimer + dt
    if player.attackTimer >= 1 / _G.devSettings.attackSpeed.value then
        player.attackTimer = 0
        Player.fireBullet()
    end

    for i = #player.bullets, 1, -1 do
        local bullet = player.bullets[i]
        bullet.x = bullet.x + bullet.dx * dt
        bullet.y = bullet.y + bullet.dy * dt

        for j, asteroid in ipairs(_G.asteroids) do
            if _G.utils.checkCollision(bullet.x, bullet.y, 5, asteroid.x, asteroid.y, 20) then
                table.remove(_G.asteroids, j)
                table.remove(player.bullets, i)
                break
            end
        end
    end
end

function Player.fireBullet()
    local closestAsteroid, minDist = nil, math.huge
    for _, asteroid in ipairs(_G.asteroids) do
        local dist = math.sqrt((asteroid.x - player.x)^2 + (asteroid.y - player.y)^2)
        if dist < minDist then
            closestAsteroid = asteroid
            minDist = dist
        end
    end

    if closestAsteroid then
        local dx, dy = closestAsteroid.x - player.x, closestAsteroid.y - player.y
        local length = math.sqrt(dx^2 + dy^2)
        dx, dy = dx / length * _G.devSettings.bulletSpeed.value, dy / length * _G.devSettings.bulletSpeed.value

        table.insert(player.bullets, {x = player.x, y = player.y, dx = dx, dy = dy})
    end
end

function Player.draw()
    love.graphics.rectangle("line", player.x - player.size / 2, player.y - player.size / 2, player.size, player.size)

    for _, bullet in ipairs(player.bullets) do
        love.graphics.circle("fill", bullet.x, bullet.y, 5)
    end
end

return Player
