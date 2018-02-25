myLength :: [Int] -> Int
myLength [] = 0
myLength (h:inputList) = 1 + myLength inputList
