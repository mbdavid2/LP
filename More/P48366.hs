eval1 :: String -> Int
eval1 expr = evalCalc stack []
    where stack = words expr

evalCalc :: [String] -> [String] -> Int
evalCalc [] [x] = read x :: Int
evalCalc (x:xs) stack
    | x == "+"  = evalCalc xs (sumRes:rest)
    | x == "-"  = evalCalc xs (minRes:rest)
    | x == "*"  = evalCalc xs (mulRes:rest)
    | x == "/"  = evalCalc xs (divRes:rest)
    | otherwise = evalCalc xs (x:stack)
        where a = head stack
              b = stack !! 1
              rest = drop 2 stack
              aInt = read a :: Int
              bInt = read b :: Int
              sumRes = show (bInt + aInt)
              minRes = show (bInt - aInt)
              mulRes = show (bInt * aInt)
              divRes = show (div bInt aInt)

-- eval2 :: String -> Int
-- eval2 expr = evalCalc2 stack []
--   where stack = words expr
--
-- evalCalc2 :: Char -> [String] -> Int
-- evalCalc2 op expr = foldr evalCalc2 () expr
--     where a = head expr
--           b = expr !! 1
--           result = op a b

-- fsmap :: a -> [a -> a] -> a
-- fsmap x [f] = f x
-- fsmap x (f:fs) = (fsmap (f x) fs)

fsmap :: a -> [a -> a] -> a
fsmap x fs = foldl (flip ($)) x fs

-- divideNconquer :: (a -> Maybe b) -> (a -> (a, a)) -> (a -> (a, a) -> (b, b) -> b) -> a -> b
data Racional = Rac Integer Integer

racional :: Integer -> Integer -> Racional
racional x y = simpl (Rac x y)

numerador :: Racional -> Integer
numerador (Rac x y) = x

denominador :: Racional -> Integer
denominador (Rac x y) = y

simpl :: Racional -> Racional
simpl ori@(Rac x y)
    | gcdR == 1  = ori
    | otherwise  = simpl simpleR
        where gcdR = gcd x y
              simpleR = (Rac (x `div` gcdR) (y `div` gcdR))

instance Eq Racional where
    (Rac x y) == (Rac a b) = (x == a && y == b)

instance Show Racional where
    show (Rac x y) = (show x)++"/"++(show y)

data Tree a = Node a (Tree a) (Tree a)

recXnivells :: Tree a -> [a]
recXnivells t = recXnivells' [t]
 where recXnivells' ((Node x fe fd):ts) = x:recXnivells' (ts ++ [fe, fd])

racionals :: [Racional]
racionals = recXnivells (createTree (Rac 1 1))

createTree :: Racional -> Tree Racional
createTree (Rac numer denom) = Node (Rac numer denom) treeA treeB
    where treeA = createTree (Rac numer (numer + denom))
          treeB = createTree (Rac (numer + denom) denom)
