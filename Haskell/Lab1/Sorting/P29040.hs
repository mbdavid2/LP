isort :: [Int] -> [Int]
isort [] = []
isort (h:hs) = insert (isort hs) h

insert :: [Int] -> Int -> [Int]
insert [] x = [x]
insert (h:hs) x
    | x > h     = h:(insert hs x)
    | otherwise = (x:(h:hs))

ssort :: [Int] -> [Int]
ssort [] = []
ssort l = x:(ssort (remove l x))
    where x = minimum l

remove :: [Int] -> Int -> [Int]
remove [] x = []
remove (h:hs) x
    | h == x    = hs
    | otherwise = h:(remove hs x)

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

genQsort :: Ord a => [a] -> [a]
genQsort [] = []
genQsort [x] = [x]
genQsort l = ((genQsort lLeft) ++ equals ++ (genQsort lRight))
    where   lLeft     = (filter (genLessThan mid) l)
            lRight    = (filter (genBiggerThan mid) l)
            equals     = (filter (genEqual mid) l)
            mid       = l !! (div (length l) 2)

genLessThan y x = x < y

genEqual y x = x == y

genBiggerThan y x = x > y
