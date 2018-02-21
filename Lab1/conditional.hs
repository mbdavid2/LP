prodNormal n m = n*m

prod n m
    | n == 0    = 0
    | otherwise = (prod (n-1) m) + m
    
-- otherwise == True
