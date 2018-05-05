myFoldl :: (a -> b -> a) -> a -> [b] -> a
myFoldl f val [] = val
myFoldl f val (h:hs) = (myFoldl f (f val h) hs)

myFoldr :: (a -> b -> b) -> b -> [a] -> b
myFoldr f val [] = val
myFoldr f val (h:hs) = f h (myFoldr f val hs)

myIterate :: (a -> a) -> a -> [a]
myIterate f val = val:(myIterate f newVal)
    where newVal = f val

myUntil :: (a -> Bool) -> (a -> a) -> a -> a
myUntil cond f val
    | cond val  = val
    | otherwise = myUntil cond f (f val)

myMap :: (a -> b) -> [a] -> [b]
myMap f l = [f x | x <- l]

myFilter :: (a -> Bool) -> [a] -> [a]
myFilter f l = [ x | x <- l, (f x)]

myAll :: (a -> Bool) -> [a] -> Bool
myAll f l = and $ map f l

myAny :: (a -> Bool) -> [a] -> Bool
myAny f l = or $ map f l

myZip :: [a] -> [b] -> [(a, b)]
myZip [] _ = []
myZip _ [] = []
myZip (h1:l1) (h2:l2) = (h1,h2):(myZip l1 l2)

myZipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
myZipWith f l1 l2 = [ f x y | (x,y) <- (myZip l1 l2) ]
