data Queue a = Queue [a] [a]
     deriving (Show)

create :: Queue a
create = Queue [] []

push :: a -> Queue a -> Queue a
push x (Queue l1 l2) = (Queue l1 (x:l2))

-- pop :: Queue a -> Queue a
-- pop (Queue [] []) = Queue [] []
-- pop (Queue [] l2) = pop (Queue (reverse l2) [])
-- pop (Queue [x] l2) = (Queue (reverse l2) [])
-- pop (Queue (x:xs) l2) = (Queue xs l2)

pop :: Queue a -> Queue a
pop (Queue [] ls) = (Queue (tail $ reverse ls) [])
pop (Queue (f:fs) ls) = (Queue fs ls)

top :: Queue a -> a
top (Queue [] l) = head(reverse l)
top (Queue (x:xs) _) = x

empty :: Queue a -> Bool
empty (Queue [] []) = True
empty (Queue _ _ ) = False

instance Eq a => Eq (Queue a) where
    (Queue [] []) == (Queue [] []) = True
    (Queue a1 a2) == (Queue b1 b2) = (packQueue a1 a2) == (packQueue b1 b2)

packQueue :: [a] -> [a] -> [a]
packQueue l [] = l
packQueue [] l2 = reverse l2
packQueue (x:xs) l2 = x:(packQueue xs l2)
