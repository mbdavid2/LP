--          Recursive countIF
-- countIf :: (Int -> Bool) -> [Int] -> Int
-- countIf f [] = 0
-- countIf f (h:hs)
--     | f h       = (1 + (countIf f hs))
--     | otherwise = countIf f hs

countIf :: (Int -> Bool) -> [Int] -> Int
countIf f l = length $ filter f l

pam :: [Int] -> [Int -> Int] -> [[Int]]
pam nums func = [map f nums | f <- func]

pam2 :: [Int] -> [Int -> Int] -> [[Int]]
pam2 num func = [map ($x) func | x <- num]

filterFoldl :: (Int -> Bool) -> (Int -> Int -> Int) -> Int -> [Int] -> Int
filterFoldl cond op val l = foldl op val (filter cond l)

insert :: (Int -> Int -> Bool) -> [Int] -> Int -> [Int]
insert f l x = (takeWhile (flip(f) x) l)++(x:(dropWhile (flip(f) x) l))

insertionSort :: (Int -> Int -> Bool) -> [Int] -> [Int]
insertionSort f l = foldl (insert f) [] l
