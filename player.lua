local Player = {}

function Player.initialize()
    _G.player = {
        x = _G.window_width / 2,
        y = _G.window_height / 2,
        size = 20,
        direction = math.pi / 2,
        bullets = {},
        attackTimer = 0,
        -- TODO: Sound Manager? Probably need a better sound than this.
        fireSound = love.audio.newSource("audio/fire.ogg", "static")
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
        -- TODO: We need to make sure we kill asteroids behind others if first bullet kills enemy.
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
        local dist = math.sqrt((asteroid.x - _G.player.x)^2 + (asteroid.y - _G.player.y)^2)
        if dist < minDist then
            closestAsteroid = asteroid
            minDist = dist
        end
    end

    if closestAsteroid then
        local dx = closestAsteroid.x - _G.player.x
        local dy = closestAsteroid.y - _G.player.y

        -- Update the direction of the player to face the closest asteroid
        -- TODO: Why does this work with math.atan2 but not math.atan?
        local targetAngle = math.atan2(dy, dx)
        _G.player.direction = targetAngle

        local bulletX = _G.player.x + _G.player.size * math.cos(targetAngle)
        local bulletY = _G.player.y + _G.player.size * math.sin(targetAngle)


        local bulletDx = math.cos(targetAngle) * _G.devSettings.bulletSpeed.value
        local bulletDy = math.sin(targetAngle) * _G.devSettings.bulletSpeed.value


        table.insert(_G.player.bullets, {x = bulletX, y = bulletY, dx = bulletDx, dy = bulletDy})
        _G.player.fireSound:play()

    end
end

function Player.draw()
    local shipSize = _G.player.size
    local angle = _G.player.direction

    local vertices = {
        _G.player.x + shipSize * math.cos(angle), _G.player.y + shipSize * math.sin(angle),
        _G.player.x + shipSize * math.cos(angle - math.pi * 2 / 3), _G.player.y + shipSize * math.sin(angle - math.pi * 2 / 3),
        _G.player.x + shipSize / 3 * math.cos(angle + math.pi), _G.player.y + shipSize / 3 * math.sin(angle + math.pi),
        _G.player.x + shipSize * math.cos(angle + math.pi * 2 / 3), _G.player.y + shipSize * math.sin(angle + math.pi * 2 / 3)
    }

    love.graphics.polygon("line", vertices)

    for _, bullet in ipairs(_G.player.bullets) do
        love.graphics.circle("fill", bullet.x, bullet.y, 5)
    end
end

return Player
