permutations1 :: Eq a => [a] -> [[a]]
permutations1 [] = [[]]
permutations1 l = [ (x:ls) | x <- l, ls <- (permutations1 (deleteOnce x l))]

deleteOnce :: Eq a => a -> [a] -> [a]
deleteOnce a (x:xs)
    | a == x    = xs
    | otherwise = x:(deleteOnce a xs)

permutations2 :: Int -> [[Int]]
permutations2 n = permutations1 [1..n]

permutations3 :: [a] -> [[a]]
permutations3 list = perm3Aux list (length list)
perm3Aux l 0 = [[]]
perm3Aux l leng = [ (x:ls) | x <- l, ls <- (perm3Aux l (leng-1))]
