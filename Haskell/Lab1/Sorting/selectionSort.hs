ssort :: [Int] -> [Int]
ssort [] = []
ssort l = x:(ssort (remove l x))
    where x = minimum l

remove :: [Int] -> Int -> [Int]
remove [] x = []
remove (h:hs) x
    | h == x    = hs
    | otherwise = h:(remove hs x)
