data BST a = E | N a (BST a) (BST a) deriving (Show)

insert :: Ord a => BST a -> a -> BST a
insert E x = N x (E) (E)
insert tree@(N root left right) x
    | x == root = tree
    | x > root  = (N root left insertRight)
    | otherwise = (N root insertLeft right)
    where   insertRight = insert right x
            insertLeft = insert left x

create :: Ord a => [a] -> BST a
create list = foldl insert E list
-- create [] = E
-- create (x:xs) = insert tree x
--     where tree = create xs

remove :: Ord a => BST a -> a -> BST a
remove E x = E
remove tree@(N r left right) x
    | x == r    = removeRoot tree
    | x < r     = (N r (remove left x ) right)
    | otherwise = (N r left (remove right x ))

removeRoot (N _ E E) = E
removeRoot (N _ left E) = left
removeRoot (N _ E right) = right
removeRoot (N _ left right) = N x (remove left x) right where x = getmax left

contains :: Ord a => BST a -> a -> Bool
contains E x = False
contains tree@(N r left right) x
    | x == r    = True
    | x < r     = (contains left x)
    | otherwise = (contains right x)

getmax :: BST a -> a
getmax (N r _ E) = r
getmax (N _ _ right) = getmax right

getmin :: BST a -> a
getmin (N r E _) = r
getmin (N _ left _) = getmin left

size :: BST a -> Int
size E = 0
size (N _ left right) = 1 + size left + size right

elements :: BST a -> [a]
elements E = []
elements (N r left right) = (elements left)++[r]++(elements right)
