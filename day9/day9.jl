l = map(x->map(c->parse(Int, c), collect(x)), readlines("input.txt"))
moves=[(1, 0), (-1, 0), (0, 1), (0, -1)]
part1=0
basins=[]
lastBasin = 0
basinMap=map(x->map(y->0, x), l)

function recursiveBasin(basinMap, basins, l, i, j, basin)
    basinMap[i][j] = basin
    basins[basin] += 1
    for mov in moves
        if 1 <= i + mov[1] <= length(basinMap) && 1 <= j + mov[2] <= length(basinMap[i + mov[1]])
            if basinMap[i + mov[1]][j + mov[2]] == 0 && l[i + mov[1]][j + mov[2]] != 9
                recursiveBasin(basinMap, basins, l, i + mov[1], j + mov[2], basin)
            end
        end
    end
end

for (i, vi) in enumerate(l)
    for (j, vj) in enumerate(vi)
        total = 0
        corners = 0
        basin=0
        for mov in moves
            if 1 <= i + mov[1] <= length(l) && 1 <= j + mov[2] <= length(l[i + mov[1]])
                if l[i + mov[1]][j + mov[2]] > vj
                    total += 1
                end
                corners += 1
            end
        end
        if total == corners
            global part1 += vj + 1
        end

        if vj != 9 && basinMap[i][j] == 0
            global lastBasin += 1
            append!(basins, 0)
            recursiveBasin(basinMap, basins, l, i, j, lastBasin)
        end
    end
end

println(part1)
basins = sort(basins, rev=true)
println(basins[1] * basins[2] * basins[3])