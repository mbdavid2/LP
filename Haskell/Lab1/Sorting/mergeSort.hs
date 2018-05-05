merge :: [Int] -> [Int] -> [Int]
merge [] l = l
merge l [] = l
merge (h1:hs1) (h2:hs2)
    | h1 < h2   = h1:(merge hs1 (h2:hs2))
    | otherwise = h2:(merge (h1:hs1) hs2)

msort :: [Int] -> [Int]
msort [] = []
msort [x] = [x]
msort l = merge (msort lLeft) (msort lRight)
    where   lLeft     = take (div (length l) 2) l
            lRight    = drop (div (length l) 2) l
