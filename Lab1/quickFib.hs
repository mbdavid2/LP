quickFib :: Int -> Int
quickFib n = fst (quickFib' n)

quickFib' :: Int -> (Int, Int)
quickFib' 0 = (0, 0)
quickFib' 1 = (1, 0)
quickFib' n = (res + ant, res)
    where (res, ant) = quickFib' (n-1)
