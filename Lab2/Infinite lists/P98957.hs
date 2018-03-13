ones :: [Integer]
ones = iterate id 1

nats :: [Integer]
nats = iterate (+1) 1

ints :: [Integer]
ints = (0:intsAux 1)

intsAux :: Integer -> [Integer]
intsAux n = (n:((-n):(intsAux (n+1))))

triangulars :: [Integer]
triangulars = scanl (+) 0 (iterate (+1) 1)

factorials :: [Integer]
factorials = scanl (*) 1 (iterate (+1) 1)

fibs :: [Integer]
fibs = 1:1:zipWith (+) fibs (tail fibs)

-- slowFib 0 = 0
-- slowFib 1 = 1
-- slowFib n = slowFib (n - 2 ) + slowFib (n - 1)


-- primes :: [Integer]
-- primes = [x | x <- (iterate (+1) 2), isPrime x]
--
-- isPrime :: Integer -> Bool
-- isPrime n
--     | n < 2 = False
--     | otherwise = not (has2Div 2)
--     where
--         has2Div :: Integer -> Bool
--         has2Div x
--             | x*x > n            = False
--             | (mod n x) == 0    = True
--             | otherwise         = has2Div (x+1)

primes :: [Integer]
primes = primesAux [] (iterate (+1) 2)

primesAux :: [Integer] ->  [Integer] -> [Integer]
primesAux l1 (x:xs)
    | anyDiv l1   = primesAux l1 xs
    | otherwise     = x:(primesAux (x:l1) xs)
    -- x:l1 because we don't care about the order of the primes inside, only the list we return
    where
        anyDiv :: [Integer] -> Bool
        anyDiv [] = False
        anyDiv (h:hs)
            | mod x h == 0  = True
            | otherwise     = anyDiv hs


--- Aux for hammings ---

primesUntil :: Integer -> [Integer]
primesUntil x = primesUntilAux x [] (iterate (+1) 6)

primesUntilAux :: Integer -> [Integer] ->  [Integer] -> [Integer]
primesUntilAux n l1 (x:xs)
    | x == n        = []
    | anyDivUntil l1     = primesUntilAux n l1 xs
    | otherwise     = x:(primesUntilAux n (x:l1) xs)
    where
        anyDivUntil :: [Integer] -> Bool
        anyDivUntil [] = False
        anyDivUntil (h:hs)
            | mod x h == 0  = True
            | otherwise     = anyDivUntil hs

--- Aux for hammings ---

hammings :: [Integer]
hammings = [x | x <- nats, any (notDiv x) (primesUntil x)]

notDiv :: Integer -> Integer -> Bool
notDiv x y = mod x y /= 0

-- onlyDiv235 :: Integer -> Bool
-- onlyDiv235 n = divBy235 && not (hasBiggerDiv 6)
--     where
--         hasBiggerDiv :: Integer -> Bool
--         hasBiggerDiv x
--             | x > n             = False
--             | (mod n x) == 0    = True && (x /= n)
--             | otherwise         = hasBiggerDiv (x+1)
--
--
--         divBy235 :: Bool
--         divBy235 = (mod n 2 == 0) || (mod n 3 == 0) || (mod n 5 == 0)

-- lookNsay :: [Integer]

-- tartaglia :: [[Integer]]
