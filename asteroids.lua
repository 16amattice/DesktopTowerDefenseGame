local Asteroids = {}
_G.asteroids = {}


function Asteroids.spawn()
    local ax, ay
    repeat
        ax = love.math.random(0, _G.window_width)
        ay = love.math.random(0, _G.window_height)
    until math.sqrt((_G.x + _G.square_size / 2 - ax)^2 + (_G.y + _G.square_size / 2 - ay)^2) >= _G.devSettings.minDistance.value

    local vertices = {}
    local numVertices = love.math.random(5, 8)
    local angleStep = (2 * math.pi) / numVertices
    local asteroidSize = love.math.random(15, 30)

    for i = 0, numVertices - 1 do
        local angle = i * angleStep
        local radius = asteroidSize + love.math.random(-5, 5)
        local x = ax + radius * math.cos(angle)
        local y = ay + radius * math.sin(angle)
        table.insert(vertices, x)
        table.insert(vertices, y)
    end
    local rotationSpeed = love.math.random(-0.2, 0.2)
    table.insert(_G.asteroids, {x = ax, y = ay, speed = _G.devSettings.enemySpeed.value, rotationSpeed = rotationSpeed, vertices = vertices})
end

function Asteroids.update(dt)
    for i = #_G.asteroids, 1, -1 do
        local asteroid = _G.asteroids[i]
        local dirX = _G.x + _G.square_size / 2 - asteroid.x
        local dirY = _G.y + _G.square_size / 2 - asteroid.y
        local length = math.sqrt(dirX^2 + dirY^2)
        local rotation = asteroid.rotationSpeed * dt
        dirX = dirX / length
        dirY = dirY / length

        local dx = dirX * asteroid.speed * dt
        local dy = dirY * asteroid.speed * dt

        asteroid.x = asteroid.x + dx
        asteroid.y = asteroid.y + dy

        for j = 1, #asteroid.vertices, 2 do
            local vx = asteroid.vertices[j] - asteroid.x + dx
            local vy = asteroid.vertices[j + 1] - asteroid.y + dy
            asteroid.vertices[j] = asteroid.x + vx * math.cos(rotation) - vy * math.sin(rotation)
            asteroid.vertices[j + 1] = asteroid.y + vx * math.sin(rotation) + vy * math.cos(rotation)
        end
        
        -- Can we make this better?
        for _, bullet in ipairs(_G.player.bullets) do
            local bulletEnd = {x = bullet.x + bullet.dx * dt, y = bullet.y + bullet.dy * dt}
            for i, asteroid in ipairs(_G.asteroids) do
                for j = 1, #asteroid.vertices, 2 do
                    local k = j + 2
                    if k > #asteroid.vertices then k = 1 end
                    local edgeStart = {x = asteroid.vertices[j], y = asteroid.vertices[j + 1]}
                    local edgeEnd = {x = asteroid.vertices[k], y = asteroid.vertices[k + 1]}
                    if utils.lineSegmentsIntersect({x = bullet.x, y = bullet.y}, bulletEnd, edgeStart, edgeEnd) then
                        table.remove(_G.asteroids, i)
                        break
                    end
                end
            end
        end
    end
end

function Asteroids.draw()
    for _, asteroid in ipairs(_G.asteroids) do
        love.graphics.polygon("line", asteroid.vertices)
    end
end

return Asteroids
