factorial :: Integer -> Integer

factorial 0 = 1
factorial n = n * factorial (n-1)

{-
    :t factorial 4
    factorial 4 :: Integer

    :t factorial 
    factorial :: Integer -> Integer
-}

