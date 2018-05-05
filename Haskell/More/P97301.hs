fizzBuzz :: [Either Int String]
fizzBuzz = map (auxF) (iterate (+1) 0)

auxF :: Int -> Either Int String
auxF n
    | mod n 3 == 0 && mod n 5 == 0  = Right "FizzBuzz"
    | mod n 3 == 0  = Right "Fizz"
    | mod n 5 == 0  = Right "Buzz"
    | otherwise     = Left n
