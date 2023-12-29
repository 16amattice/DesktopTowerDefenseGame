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
    local bulletsToRemove = {}

    player.attackTimer = player.attackTimer + dt
    if player.attackTimer >= 1 / _G.devSettings.attackSpeed.value then
        player.attackTimer = 0
        Player.fireBullet()
    end

    for i, bullet in ipairs(_G.player.bullets) do

        bullet.x = bullet.x + bullet.dx * dt
        bullet.y = bullet.y + bullet.dy * dt
        
        local bulletEnd = {x = bullet.x + bullet.dx * dt, y = bullet.y + bullet.dy * dt}
        for j, asteroid in ipairs(_G.asteroids) do
            for k = 1, #asteroid.vertices, 2 do
                local l = k + 2
                if l > #asteroid.vertices then l = 1 end
                local edgeStart = {x = asteroid.vertices[k], y = asteroid.vertices[k + 1]}
                local edgeEnd = {x = asteroid.vertices[l], y = asteroid.vertices[l + 1]}
                if utils.lineSegmentsIntersect({x = bullet.x, y = bullet.y}, bulletEnd, edgeStart, edgeEnd) then
                    table.remove(_G.asteroids, j)
                    bulletsToRemove[i] = true
                    break
                end
            end
            if bulletsToRemove[i] then break end
        end
    end

    for i = #_G.player.bullets, 1, -1 do
        if bulletsToRemove[i] then
            table.remove(_G.player.bullets, i)
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
        love.graphics.circle("fill", bullet.x, bullet.y, 2)
    end
end

return Player
