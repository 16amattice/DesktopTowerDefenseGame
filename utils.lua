local Utils = {}

function Utils.isNumpadKey(key)
    return key:find("^kp%d") ~= nil or key:find("^kpnumlock") ~= nil or key:find("^kp[+\\-*/.]") ~= nil
end


function Utils.lineSegmentsIntersect(A, B, C, D)
    local function ccw(A, B, C)
        if not (A and B and C) or
           not (A.x and A.y and B.x and B.y and C.x and C.y) then
            return false
        end
        return (C.y - A.y) * (B.x - A.x) > (B.y - A.y) * (C.x - A.x)
    end

    if not (A and B and C and D) or
       not (A.x and A.y and B.x and B.y and C.x and C.y and D.x and D.y) then
        return false
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
