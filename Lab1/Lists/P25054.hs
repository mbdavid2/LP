myLength :: [Int] -> Int
myLength [] = 0
myLength (h:inputList) = 1 + myLength inputList

myMaximum :: [Int] -> Int
myMaximum ([h]) = h
myMaximum (h:inputList)
    | h < maxL = maxL
    | otherwise = h
    where maxL = myMaximum inputList

average :: [Int] -> Float
average l = fromIntegral (sum l) / fromIntegral (myLength l)

buildPalindrome :: [Int] -> [Int]
buildPalindrome l = reverse l ++ l

remove :: [Int] -> [Int] -> [Int]
remove [] ly = []
remove (hx:lx) ly
    | elem hx ly = remove lx ly
    | otherwise = (hx:(remove lx ly))

flatten :: [[Int]] -> [Int]
flatten [] = []
flatten (h:hs) = foldl (++) h hs

oddsNevens :: [Int] -> ([Int],[Int])
oddsNevens [] = ([],[])
oddsNevens (h:hs)
    | isEven h  = (evens, h:odds)
    | otherwise = (h:evens, odds)
    where (evens, odds) = oddsNevens hs

isEven :: Int -> Bool
isEven x = mod x 2 == 0

primeDivisors :: Int -> [Int]
primeDivisors x = filter isPrime (filter (divisor x) [2..x])

divisor :: Int -> Int -> Bool
divisor x y = mod x y == 0

isPrime :: Int -> Bool
isPrime n
    | n < 2 = False
    | otherwise = not (has2Div 2)
    where
        has2Div :: Int -> Bool
        has2Div x
            | x*x > n           = False
            | (mod n x) == 0    = True
            | otherwise         = has2Div (x+1)
