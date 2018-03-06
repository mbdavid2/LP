ones :: [Integer]
ones = iterate id 1

nats :: [Integer]
nats = iterate (+1) 1

-- ints :: [Integer]

triangulars :: [Integer]
triangulars = scanl (+) 0 (iterate (+1) 1)

factorials :: [Integer]
factorials = scanl (*) 1 (iterate (+1) 1)

-- fibs :: [Integer]

-- primes :: [Integer]

-- hammings :: [Integer]

-- lookNsay :: [Integer]

-- tartaglia :: [[Integer]]
