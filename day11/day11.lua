local file = io.open("input.txt")
local part1m = {}
local i = 0
if file then
    for line in file:lines() do
        i = i + 1
        local chars = {}
        for c in string.gmatch(line, ".") do
            chars[#chars+1] = tonumber(c)
        end
        part1m[i] = chars
    end
    file:close()
else
    error('file not found')
end

local part1 = 0
local part2 = 0
local relativeDirections = {
    {-1, -1},
    {-1, 0},
    {-1, 1},
    {0, -1},
    {0, 1},
    {1, -1},
    {1, 0},
    {1, 1}
}


while true do
    -- check if all elements of matrix are 0
    local allZero = true
    for i = 1, #part1m do
        for j = 1, #part1m[i] do
            if part1m[i][j] ~= 0 then
                allZero = false
            end
        end
    end
    if allZero then
        break
    end
    part2 = part2 + 1
    -- print("Round: " .. round)
    -- for i = 1, #part1m do
    --     for j = 1, #part1m[i] do
    --         io.write(part1m[i][j])
    --     end
    --     io.write("\n")
    -- end
    for i = 1, #part1m do
        for j = 1, #part1m[i] do
            part1m[i][j] = part1m[i][j] + 1
        end
    end
    local blinked = {}
    local blinks = 1
    while blinks > 0 do
        blinks = 0
        for i = 1, #part1m do
            for j = 1, #part1m[i] do
                if part1m[i][j] >= 10 then
                    if part2<=100 then
                        part1 = part1 + 1
                    end
                    part1m[i][j] = 0
                    blinked[#blinked+1] = {i, j}
                    blinks = blinks + 1
                    for k = 1, #relativeDirections do
                        local x = i + relativeDirections[k][1]
                        local y = j + relativeDirections[k][2]
                        if x > 0 and x <= #part1m and y > 0 and y <= #part1m[i] then
                            local found = false
                            for l = 1, #blinked do
                                if blinked[l][1] == x and blinked[l][2] == y then
                                    found = true
                                    break
                                end
                            end
                            if not found or not part1m[x][y] == 0 then
                                part1m[x][y] = part1m[x][y] + 1
                            end
                        end
                    end
                end
            end
        end
    end
end
print("Part 2: " .. part1)
print("Part 2: " .. part2)