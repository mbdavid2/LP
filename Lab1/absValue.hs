absValue :: Int -> Int
absValue n
    | n >= 0    = n
    | otherwise = (-n)

{-
        *Main> absValue (-4)
        4
        *Main> absValue (3)
        3
-}
