absValue :: Int -> Int
absValue n
    | n >= 0    = n
    | otherwise = (-n)

power :: Integer -> Integer -> Integer
power x 0 = 1
power x n = x * power x (n-1)

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

slowFib :: Int -> Int
slowFib 0 = 0
slowFib 1 = 1
slowFib n = slowFib(n-1) + slowFib(n-2)

quickFib :: Int -> Int
quickFib n = fst (quickFib' n)

quickFib' :: Int -> (Int, Int)
quickFib' 0 = (0, 0)
quickFib' 1 = (1, 0)
quickFib' n = (res + ant, res)
    where (res, ant) = quickFib' (n-1)
