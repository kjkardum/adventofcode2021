wordsWhen     :: (Char -> Bool) -> String -> [String]
wordsWhen p s =  case dropWhile p s of
                      "" -> []
                      s' -> w : wordsWhen p s''
                            where (w, s'') = break p s'

readInt :: String -> Int
readInt = read

convertToCount :: [Int] -> [Int]
convertToCount l = map (\x -> length $ filter (==x) l) [0..8]

listOfN :: Int -> [Int]
listOfN n = replicate n 8

rotateLeft :: [Int] -> [Int]
rotateLeft l = tail l ++ [head l]

loopN :: Int -> [Int] -> Int
loopN 0 l = sum l
loopN n l = loopN (n-1) (zipWith (\ i x -> (if i == 6 then x + rotateLeft l !! 8 else x)) [0..] (rotateLeft l))

main = do
        contents <- readFile "input.txt"
        print . loopN 256 . convertToCount . map readInt . wordsWhen(==',') $ contents
