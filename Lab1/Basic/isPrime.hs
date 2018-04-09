has2Divisors :: Int -> Int -> Bool
has2Divisors i n
    | i*i > n           = False
    | (mod n i) == 0    = True
    | otherwise         = has2Divisors (i+1) n


isPrime :: Int -> Bool
isPrime n
    | n < 2 = False
    | otherwise = has2Divisors 2 n


isPrimeWhere :: Int -> Bool
isPrimeWhere n
    | n < 2 = False
    | otherwise = not (has2Div 2)
    where
        has2Div :: Int -> Bool
        has2Div x
            | x == n            = False
            | (mod n x) == 0    = True
            | otherwise         = has2Div (x+1)

isPrimeIlluminati :: Int -> Bool
isPrimeIlluminati n
    | n < 2 = False
    | otherwise = not (has2Div 2)
    where
        has2Div :: Int -> Bool
        has2Div x
            | x*x > n            = False
            | (mod n x) == 0    = True
            | otherwise         = has2Div (x+1)
