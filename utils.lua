local Utils = {}

function Utils.checkCollision(ax, ay, ar, bx, by, bs)
    local distance = math.sqrt((bx + bs / 2 - ax)^2 + (by + bs / 2 - ay)^2)
    return distance < ar + bs / 2
end

function Utils.isNumpadKey(key)
    return key:find("^kp%d") ~= nil
end

function Utils.lineSegmentsIntersect(A, B, C, D)
    local function ccw(A, B, C)
        return (C.y - A.y) * (B.x - A.x) > (B.y - A.y) * (C.x - A.x)
    end

    return ccw(A, C, D) ~= ccw(B, C, D) and ccw(A, B, C) ~= ccw(A, B, D)
end

function Utils.indexOf(table, value)
    for i, v in ipairs(table) do
        if v == value then
            return i
        end
    end
    return nil
end

return Utils
