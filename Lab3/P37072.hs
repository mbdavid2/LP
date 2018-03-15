data Tree a = Node a (Tree a) (Tree a) | Empty deriving (Show)

size :: Tree a -> Int
size Empty = 0
size (Node _ left right) = 1 + (size left) + (size right)

height :: Tree a -> Int
height Empty = 0
height (Node _ left right) = 1 + max (height left) (height right)

equal :: Eq a => Tree a -> Tree a -> Bool
equal Empty Empty = True
equal _ Empty = False
equal Empty _ = False
equal (Node a1 left1 right1) (Node a2 left2 right2) = a1 == a2 && (equal left1 left2) && (equal right1 right2)

isomorphic :: Eq a => Tree a -> Tree a -> Bool
isomorphic Empty Empty = True
isomorphic _ Empty = False
isomorphic Empty _ = False
isomorphic (Node a1 left1 right1) (Node a2 left2 right2) = (a1 == a2) && (((isomorphic left1 left2) && (isomorphic right1 right2)) || ((isomorphic left1 right2) && (isomorphic right1 left2)))

preOrder :: Tree a -> [a]
preOrder Empty = []
preOrder (Node a left right) = a:((preOrder left)++(preOrder right))

postOrder :: Tree a -> [a]
postOrder Empty = []
postOrder (Node a left right) = ((postOrder left)++(postOrder right))++[a]

inOrder :: Tree a -> [a]
inOrder Empty = []
inOrder (Node a left right) = (inOrder left)++(a:(inOrder right))

breadthFirst :: Tree a -> [a]
breadthFirst x = breadthFirstList [x]

breadthFirstList :: [Tree a] -> [a]
breadthFirstList [] = []
breadthFirstList (Empty:l) = breadthFirstList l
breadthFirstList ((Node x left right):l) = x:(breadthFirstList (l++(left:[right])))

-- build :: Eq a => [a] -> [a] -> Tree

overlap :: (a -> a -> a) -> Tree a -> Tree a -> Tree a
overlap f Empty Empty = Empty
overlap f a Empty = a
overlap f Empty a = a
overlap f (Node a1 l1 r1) (Node a2 l2 r2) = Node (f a1 a2) (overlap f l1 l2) (overlap f r1 r2)
