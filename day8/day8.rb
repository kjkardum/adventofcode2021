input = []
f = File.open("input.txt", "r")
f.each_line { |line| input << line.strip().split(" | ") }
for i in 0..input.length-1
    input[i] = input[i].map { |x| x.split(" ") }
end


sumPart1 = 0
for i in 0..input.length-1
    for j in 0..input[i][1].length-1
        if [2,3,4,7].include? input[i][1][j].length
            sumPart1 += 1
        end
    end
end
p sumPart1


sumPart2 = 0
letters = { 0 => [], 1 => [], 2 => [], 3 => [], 4 => [], 5 => [], 6 => [], 7 => [], 8 => [], 9 => [] }
letterSegments = { 1 => [], 2 => [], 3 => [], 4 => [], 5 => [], 6 => [], 7 => [] }
for line in 0..input.length-1
    for num in 0..input[line][0].length-1
        if input[line][0][num].length == 2
            letters[1] = input[line][0][num].split("")
        elsif input[line][0][num].length == 3
            letters[7] = input[line][0][num].split("")
        elsif input[line][0][num].length == 4
            letters[4] = input[line][0][num].split("")
        elsif input[line][0][num].length == 7
            letters[8] = input[line][0][num].split("")
        end
    end
    # ako su len 2 i i len 3 brojevi 7 i 1, onda onaj koji fali u len 2 je aaa
    for seg in 0..2
        if not (letters[1].include? letters[7][seg])
            letterSegments[1] = [letters[7][seg]]
            break
        end
    end
    # ako znamo to onda je 9 onaj koji ima sve iz 7 + sve iz 4 + 1, te znamo ggg
    for num in 0..input[line][0].length-1
        if (letters[4] + letters[7]).uniq.length == (letters[4] + letters[7] + input[line][0][num].split("")).uniq.length - 1
            letters[9] = (letters[4] + letters[7] + input[line][0][num].split("")).uniq
            for seg in 0..5
                if not ((letters[4] + letters[7]).uniq.include? letters[9][seg])
                    letterSegments[7] = [letters[9][seg]]
                    break
                end
            end
        end
    end
    # ako znamo 9, znamo 8 eee
    for num in 0..input[line][0].length-1
        if input[line][0][num].length == 7
            letters[8] = input[line][0][num].split("")
            for seg in 0..6
                if not (letters[9].include? letters[8][seg])
                    letterSegments[5] = [letters[8][seg]]
                    break
                end
            end
        end
    end
    # znamo da onaj koji ima 2 iz 4 koji nisu u 1 uz a,e,g + jedan znak da je 6 i znamo fff
    notIn1 = []
    for i in 0..3
        if not (letters[1].include? letters[4][i])
            notIn1 << letters[4][i]
        end
    end
    for num in 0..input[line][0].length-1
        inum = input[line][0][num].split("")
        if ([letterSegments[1][0],letterSegments[5][0],letterSegments[7][0]]+notIn1+inum).uniq.length == \
            ([letterSegments[1][0],letterSegments[5][0],letterSegments[7][0]]+notIn1).uniq.length + 1 and \
            ([letterSegments[1][0],letterSegments[5][0],letterSegments[7][0]]+notIn1+inum).uniq.sort == \
            inum.uniq.sort
            letters[6] = inum
            for seg in 0..5
                if not (([letterSegments[1][0],letterSegments[5][0],letterSegments[7][0]]+notIn1).uniq.include? letters[6][seg])
                    letterSegments[6] = [letters[6][seg]]
                    break
                end
            end
        end
    end
    # ako znamo 6 znamo i 3 iz 1
    for num in 0..1
        if letters[1][num] != letterSegments[6][0]
            letterSegments[3] = [letters[1][num]]
        end
    end
    #koji ima a,c,e,f,g + tocno 1 iz 4 je 0, te znamo bbb
    for num in 0..input[line][0].length-1
        for seg in 0..1
            if ([letterSegments[1][0],letterSegments[3][0],letterSegments[5][0],letterSegments[6][0],letterSegments[7][0],notIn1[seg]]).sort == \
                input[line][0][num].split("").sort
                letterSegments[2] = [notIn1[seg]]
            end
        end
    end
    for num in 1..7
        letterSegments[num] = letterSegments[num][0]
    end
    for seg in 0..letters[8].length-1
        if not (letterSegments.values.include? letters[8][seg])
            letterSegments[4] = letters[8][seg]
        end
    end
    # invert hashmap
    ls=letterSegments
    segments = {
        0=>[ls[1],ls[2],ls[3],ls[5],ls[6],ls[7]].sort,
        1=>[ls[3],ls[6]].sort,
        2=>[ls[1],ls[3],ls[4],ls[5],ls[7]].sort,
        3=>[ls[1],ls[3],ls[4],ls[6],ls[7]].sort,
        4=>[ls[2],ls[3],ls[4],ls[6]].sort,
        5=>[ls[1],ls[2],ls[4],ls[6],ls[7]].sort,
        6=>[ls[1],ls[2],ls[4],ls[5],ls[6],ls[7]].sort,
        7=>[ls[1],ls[3],ls[6]].sort,
        8=>"abcdefg".split(""),
        9=>[ls[1],ls[2],ls[3],ls[4],ls[6],ls[7]].sort,}
    segments = segments.invert
    tempSum = 0
    for num in 0..input[line][1].length-1
        value = input[line][1][num].split("").sort
        tempSum *= 10
        tempSum += segments[value]
    end
    sumPart2 += tempSum
end
p sumPart2