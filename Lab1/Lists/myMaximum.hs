myMaximum :: [Int] -> Int
myMaximum ([h]) = h
myMaximum (h:inputList)
    | h < maxL = maxL
    | otherwise = h
    where maxL = myMaximum inputList
