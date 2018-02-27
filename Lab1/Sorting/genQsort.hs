genQsort :: Ord a => [a] -> [a]
genQsort [] = []
genQsort [x] = [x]
genQsort l = ((genQsort lLeft) ++ equals ++ (genQsort lRight))
    where   lLeft     = (filter (lessThan mid) l)
            lRight    = (filter (biggerThan mid) l)
            equals     = (filter (equal mid) l)
            mid       = l !! (div (length l) 2)

lessThan y x = x < y

equal y x = x == y

biggerThan y x = x > y
