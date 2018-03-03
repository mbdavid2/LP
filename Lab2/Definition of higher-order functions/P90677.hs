myFoldl :: (a -> b -> a) -> a -> [b] -> a
myFoldl f val [x] = (f val x)
myFoldl f val (h:hs) = (myFoldl f (f val h) hs)
