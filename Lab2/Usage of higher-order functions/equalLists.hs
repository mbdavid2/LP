{- eql :: [Int] -> [Int] -> Bool
eql [] [] = True
eql (hx:x) (hy:y)
    | hx == hy      = eql x y
    | otherwise     = False -}
    
eql :: [Int] -> [Int] -> Bool
eql l1 l2 = equalSize && and (zipWith (==) l1 l2)
    where equalSize = (length l1 == length l2) 
