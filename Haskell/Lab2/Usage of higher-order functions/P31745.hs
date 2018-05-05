flatten :: [[Int]] -> [Int]
flatten l = foldl (++) [] l

myLength :: String -> Int
myLength l = sum (map (const 1) l)

myReverse :: [Int] -> [Int]
myReverse l = foldr (\x y -> y ++ [x]) [] l

countIn :: [[Int]] -> Int -> [Int]
countIn l x = map times l
    where
        times :: [Int] -> Int
        times l = (length (filter ((\a b -> a == b)$x) l))
        
firstWord :: String -> String
firstWord l = takeWhile (/= ' ') $ dropWhile (== ' ') l
