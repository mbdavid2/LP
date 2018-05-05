remove :: [Int] -> [Int] -> [Int]
remove [] ly = []
remove (hx:lx) ly
    | elem hx ly = remove lx ly
    | otherwise = (hx:(remove lx ly))
