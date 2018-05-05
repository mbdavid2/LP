average :: [Int] -> Float
average l = fromIntegral (foldr (+) 0 l) / fromIntegral (myLength l)

myLength :: [Int] -> Int
myLength [] = 0
myLength (h:inputList) = 1 + myLength inputList

average2 :: [Int] -> Float
average2 l = fromIntegral (sum l) / fromIntegral (myLength l)
