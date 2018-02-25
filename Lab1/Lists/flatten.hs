flatten :: [[Int]] -> [Int]
flatten [] = []
flatten (h:hs) = foldl (++) h hs

flatten2 :: [[Int]] -> [Int]
flatten2 [] = []
flatten2 (h:hs) = h ++ flatten2 hs
