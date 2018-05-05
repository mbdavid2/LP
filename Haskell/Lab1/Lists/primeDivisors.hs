primeDivisors :: Int -> [Int]
primeDivisors x = filter isPrime (filter (divisor x) [2..x-1])

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
