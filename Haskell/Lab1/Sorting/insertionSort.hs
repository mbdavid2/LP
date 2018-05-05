isort :: [Int] -> [Int]
isort [] = []
isort (h:hs) = insert (isort hs) h

insert :: [Int] -> Int -> [Int]
insert [] x = [x]
insert (h:hs) x
    | x > h     = h:(insert hs x)
    | otherwise = (x:(h:hs))
