oddsNevens :: [Int] -> ([Int],[Int])
oddsNevens [] = ([],[])
oddsNevens (h:hs)
    | isEven h  = (evens, h:odds)
    | otherwise = (h:evens, odds)
    where (evens, odds) = oddsNevens hs

isEven :: Int -> Bool
isEven x = mod x 2 == 0
