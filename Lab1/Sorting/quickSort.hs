qsort :: [Int] -> [Int]
qsort [] = []
qsort [x] = [x]
qsort l = ((qsort lLeft) ++ equals ++ (qsort lRight))
    where   lLeft     = (filter (lessThan mid) l)
            lRight    = (filter (biggerThan mid) l)
            equals     = (filter (equal mid) l)
            mid       = l !! (div (length l) 2)

lessThan :: Int -> Int -> Bool
lessThan y x = x < y

equal :: Int -> Int -> Bool
equal y x = x == y

biggerThan :: Int -> Int -> Bool
biggerThan y x = x > y
