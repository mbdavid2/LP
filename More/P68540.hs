diffSqrs :: Int -> Int
diffSqrs n = b - a
    where list = [1..n]
          a = sum $ map pow list
          b = pow $ sum list

pow = (\x -> x*x)

pythagoreanTriplets :: Int -> [(Int, Int, Int)]
pythagoreanTriplets n = filter (\(a,b,c) -> (a+b+c)==n) [(a,b,c) | a <- [1..n], b <- [a..n], c <- [b..n], (pow c) == (pow a) + (pow b)]


next :: [Integer] -> [Integer]
next currRow = zipWith (+) ([0] ++ currRow) (currRow ++ [0])

tartaglia :: [[Integer]]
tartaglia = iterate next [1]

sumDigits :: Integer -> Integer
sumDigits n = sum $ digs n

digs ::  Integer -> [Integer]
digs 0 = []
digs x = digs (x `div` 10) ++ [x `mod` 10]

digitalRoot :: Integer -> Integer
digitalRoot 0 = 0
digitalRoot n = digitalRootAux $ digs n

digitalRootAux :: [Integer] -> Integer
digitalRootAux [x] = x
digitalRootAux list = digitalRoot $ sum list
