data Queue a = Queue [a] [a]
     deriving (Show)

create :: Queue a
create = Queue [] []

push :: a -> Queue a -> Queue a
push x (Queue l1 l2) = (Queue l1 (x:l2))

pop :: Queue a -> Queue a
pop (Queue [] []) = Queue [] []
pop (Queue [] l2) = pop (Queue (reverse l2) [])
pop (Queue [x] l2) = (Queue (reverse l2) [])
pop (Queue (x:xs) l2) = (Queue xs l2)

top :: Queue a -> a
top (Queue [] l) = head(reverse l)
top (Queue (x:xs) _) = x

empty :: Queue a -> Bool
empty (Queue [] []) = True
empty (Queue _ _ ) = False
