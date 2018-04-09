sumMultiples35 :: Integer -> Integer
sumMultiples35 n = sum [x | x <- [0..n-1], mult35 x]
    where mult35 :: Integer -> Bool
          mult35 x = (mod x 3) == 0 || (mod x 5) == 0

fibs :: [Integer]
fibs = map fst $ iterate (\(a,b) -> (b,a+b)) (0,1)

fibonacci :: Int -> Integer
fibonacci n = fibs !! n

sumEvenFibonaccis :: Integer -> Integer
sumEvenFibonaccis n = sum $ filter even $ takeWhile (< n) fibs

largestPrimeFactor :: Int -> Int
largestPrimeFactor n = head $ filter (isDivisor n) $ primes n

isDivisor :: Int -> Int -> Bool
isDivisor n x = (mod n x) == 0

primes :: Int -> [Int]
primes n = filter isPrimeIlluminati $ takeWhile (>2) $ iterate (\x -> x-1) n 

isPrimeIlluminati :: Int -> Bool
isPrimeIlluminati n
    | n < 2 = False
    | otherwise = not (has2Div 2)
    where
        has2Div :: Int -> Bool
        has2Div x
            | x*x > n           = False
            | (mod n x) == 0    = True
            | otherwise         = has2Div (x+1)

isPalindromic :: Integer -> Bool
isPalindromic n = and $ zipWith (==) (show n) (reverse $ show n)
