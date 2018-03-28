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
largestPrimeFactor n = last $ filter (divisor n) $ primes n

divisor :: Int -> Int -> Bool
divisor n x = (mod n x) == 0

primes :: Int -> [Int]
primes n = primesAux [] [2..n]

primesAux :: [Int] -> [Int] -> [Int]
primesAux l1 [] = []
primesAux l1 (x:xs)
    | anyDiv l1     = primesAux l1 xs
    | otherwise     = x:(primesAux (x:l1) xs)
    where
        anyDiv :: [Int] -> Bool
        anyDiv [] = False
        anyDiv (h:hs)
            | mod x h == 0  = True
            | otherwise     = anyDiv hs

isPalindromic :: Integer -> Bool
isPalindromic n = and $ zipWith (==) (show n) (reverse $ show n)
