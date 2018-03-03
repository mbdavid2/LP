eql :: [Int] -> [Int] -> Bool
eql l1 l2 = equalSize && and (zipWith (==) l1 l2)
    where equalSize = (length l1 == length l2) 
          
prod :: [Int] -> Int
prod l  = foldl (*) 1 l

prodOfEvens :: [Int] -> Int
prodOfEvens l  = prod evens
    where evens = (filter even l)
          
powersOf2 :: [Integer]
powersOf2 = iterate (*2) 1

scalarProduct :: [Float] -> [Float] -> Float
scalarProduct l1 l2 = sum (zipWith (*) l1 l2)
