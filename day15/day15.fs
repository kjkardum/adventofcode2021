open System
let inline charToInt c = int c - int '0'

let limit = 100
let readLines = 
    IO.File.ReadLines "/Users/kjkardum/RiderProjects/Day15aoc2021/Day15aoc2021/input.txt"
    |> Seq.toList
    |> List.map (Seq.toList)
    |> List.map (List.map charToInt)

let riskLevel l = (l % 10 + int(l/10))
let expandLines (lines: int list list) =
    List.map (fun i ->
        List.map (fun j-> riskLevel (lines.[i%limit].[j%limit]+ int(i/limit) + int(j/limit))) [0..(limit*5-1)]
        ) [0..(limit*5-1)]
    
let findPathWithMinimumSumDijkstra (mat: int list list, limit: int) =
    let isInsideGrid (i, j)= i >= 0 && i < limit && j>=0 && j<limit
    let directions = [(0,1);(1,0);(0,-1);(-1,0)]
    let mutable distances = Array2D.init limit limit (fun _ _ -> 20000000)
    let mutable st = [(0,0,0)]
    distances.[0,0] <- 0
    while List.length st > 0 do
        let (i,j,d) = List.reduce (fun (a,b,c) (d,e,f) -> if d < a then (d,e,f) else (a,b,c)) st
        st <- List.filter (fun (a,b,c) -> not <| (a=i && b=j)) st
        for (di,dj) in directions do
            if isInsideGrid(i+di,j+dj) then
                if distances.[i+di,j+dj] > distances.[i,j] + mat.[i+di].[j+dj] then
                    st <- List.filter (fun (a,b,c) -> not <| (a = i+di && b = j+dj)) st
                    distances.[i+di,j+dj] <- distances.[i,j] + mat.[i+di].[j+dj]
                    st <- st @ [(i+di,j+dj,distances.[i+di,j+dj])]
    distances.[limit-1,limit-1]
   
[<EntryPoint>]
let main argv =
    let lines = readLines
    let part1 = findPathWithMinimumSumDijkstra (lines, limit)
    printfn "%s" (part1.ToString())
    let expandedLines = expandLines lines
    let part2 = findPathWithMinimumSumDijkstra (expandedLines, limit*5)
    //let concat acc x = acc + " " + (string x)
    //for line in expandedLines do
    //    printfn "%s" (List.fold concat "" (List.map (fun x-> x.ToString()) line))
    printfn "%s" (part2.ToString())
    0