--------------------------------------
--         Pràctica Haskell         --
--        David Moreno Borràs       --
--    Llenguatges de Programació    --
--------------------------------------
import System.IO
import System.Random

data Program a = Prog [[(a,a)]]
    deriving (Show, Read, Eq)

-------------- 1. data Term --------------

data Term = Num Int | Var String | Func String [Term] | ITE Term Term Term | LET String Term Term
    deriving (Show, Read)

-------------- 2. Replace --------------

replace :: [(String, Term)] -> Term -> Term
replace subList (Var str) = findStringAndReplace (str,(Var str)) subList
replace subList (Func a [x]) = Func a [(replace subList x)]
replace subList (Func a args) = Func a (map (replace subList) args)
replace subList (LET str t1 t2) = (LET str replacedt1 replacedt2)
    where replacedt1 = replace subList t1
          replacedt2 = replace subList t2
replace subList term = term

findStringAndReplace :: (String, Term) -> [(String, Term)] -> Term
findStringAndReplace (str, term) [] = term
findStringAndReplace (str, term) (x:xs)
    | str == (fst x)    = snd x
    | otherwise         = findStringAndReplace (str, term) xs

-------------- 3. Instance Eq --------------

instance Eq Term where
    term1 == term2 = (show term1Final) == (show term2Final)
        where term1Final = finalTerm term1
              term2Final = finalTerm term2

finalTerm :: Term -> Term
finalTerm (LET str t1 t2) = performLET (LET str t1 t2)
finalTerm (Func a listT) = Func a (map finalTerm listT)
finalTerm (ITE t1 t2 t3) = ITE (finalTerm t1) (finalTerm t2) (finalTerm t3)
finalTerm basicTerm = basicTerm

performLET :: Term -> Term
performLET (LET str term1 ((LET strB term1B term2B))) = replace [(str, term1)] insideTerm
    where insideTerm = replace [(strB, term1B)] term2B
performLET (LET str term1 term2) = replace [(str, term1)] term2

-------------- 4. Match --------------

match :: Term -> Term -> Maybe [(String,Term)]
match (Var a) term = Just [(a, term)]
match term (Var a) = Just [(a, term)]
match (Func a1 listT1) (Func a2 listT2)
   | basic         = foldl concatMaybe (Just []) (zipWith match listT1 listT2)
-- | basic         = concat $ sequence $ (zipWith match listT1 listT2)
    | otherwise     = Nothing
    where
        basic = a1 == a2 && (length listT1) == (length listT2)
match _ _ = Nothing

concatMaybe :: Maybe [(String,Term)] -> Maybe [(String,Term)] -> Maybe [(String,Term)]
concatMaybe (Just list1) (Just list2) = return (list1 ++ list2)
concatMaybe _ _ = Nothing

-------------- 5. OneStep --------------

oneStep :: Program Term -> Term -> Term

-- Operacions
oneStep p (Func a [(Num x), (Num y)])
    | a == "+"              = Num (x+y)
    | a == "-"              = Num (x-y)
    | a == "*"              = Num (x*y)
    | a == "==" && x == y   = Func "True" []
    | a == "==" && x /= y   = Func "False" []
    | a == ">"  && x > y    = Func "True" []
    | a == ">"  && x <= y   = Func "False" []

-- Logica
oneStep p (Func "not" ((Func bool []):funcList))
    | bool == "False"  = Func "True" []
    | bool == "True"   = Func "False" []

oneStep p (Func "and" [a, b])
    | a == Func "True"  []   = b
    | a == Func "False" []   = Func "False" []
    | b == Func "True"  []   = a
    | b == Func "False" []   = Func "False" []

oneStep p (Func "or" [a, b])
    | a == Func "True"  []   = Func "True" []
    | a == Func "False" []   = b
    | b == Func "True"  []   = Func "True" []
    | b == Func "False" []   = a

-- ITE
oneStep p (ITE ifBool termA termB)
    | (ITE ifBool termA termB)      /= possibleOneStep = possibleOneStep
    | ifBool == (Func "True" [])    = termA
    | ifBool == (Func "False" [])   = termB
        where possibleOneStep = (oneStep p ifBool)

-- LET
oneStep p (LET name term1 termInside)
    | (show term1) /=  (show possibleOneStep)               = (LET name possibleOneStep termInside)
    | (show termInside) /=  (show possibleOneStepInside)    = (LET name term1 possibleOneStepInside)
    | otherwise                                             = performLET (LET name term1 termInside)
        where possibleOneStepInside = (oneStep p termInside)
              possibleOneStep = (oneStep p term1)

oneStep p (Num x) = Num x
oneStep p (Var x) = Var x

--oneStep p (Func a []) = (Func a []) -> no fa falta
oneStep p (Func a listT)
  | not change = matchProg p (Func a listT)
  | otherwise  = (Func a step)
    where   step = fst pair
            change = snd pair -- més eficient guardar-ho en una parella???
            pair = oneStepWhile p listT


-- el bool és per no haver de fer (show maybeStep) == show (listT) a dalt
oneStepWhile :: Program Term -> [Term] -> ([Term],Bool)
oneStepWhile p [] = ([],False)
oneStepWhile p (x:listTerms)
  | show possible == show x = ((x:(fst(oneStepWhile p listTerms))),False)
  | otherwise               = ((possible:listTerms),True)
      where possible = (oneStep p x)


applyPossibleMatch :: Maybe [(String,Term)] -> Term -> Term -> Term
applyPossibleMatch Nothing term xB = term
applyPossibleMatch (Just list) term xB = replace list xB

matchProg :: Program Term -> Term -> Term
matchProg (Prog [[]]) term = term
matchProg (Prog [[],list]) term = matchProg (Prog ([list])) term
matchProg (Prog ((((xA,xB)):restx):rest)) term
    | possibleMatch == Nothing  = matchProg (Prog (((restx):rest))) term
    | otherwise                 = applyPossibleMatch possibleMatch term xB
        where possibleMatch = match xA term

-------------- 6. Reduce --------------

reduce :: Program Term -> Term -> Term
reduce p term
    | (show possibleReduce) == (show term) = possibleReduce
    | otherwise                            = (reduce p possibleReduce)
    where possibleReduce = (oneStep p term)

-------------- 7. TTerm --------------

data TTerm = INum Int | IVar String | IFunc String | Apply TTerm TTerm | Lambda String TTerm
    deriving (Show, Read)

-------------- 8. Transform --------------

transform :: Term -> TTerm
transform (Num x) = INum x
transform (Var str) = IVar str
transform (Func a []) = Apply (IFunc a) (IVar "")
transform (Func a [x]) = Apply (IFunc a) (transform x)
transform (Func a xs) = Apply (transform (Func a (init xs))) (transform (last xs))
transform (LET name termSubs termInside) = (Apply (Lambda name inside) subs)
    where inside = transform termInside
          subs = transform termSubs
-- ITE??
-- transform (ITE termBool term1s term2) =


transformProgram:: Program Term -> Program TTerm
transformProgram (Prog [[]]) = (Prog [[]])
transformProgram (Prog list) = (Prog (map (map (\(x,y) -> (transform x, transform y))) $ list))

-------------- 9. Types --------------

data Types = TBool | TInt | ListInt | TVar String | Arrow Types Types | Unk
    deriving (Show, Read, Eq) -- Deriving d'Eq també per no haver de fer show cada vegada que vulgui comparar

data BinTree a = NodeA a (BinTree a) (BinTree a) | NodeL a (BinTree a) (BinTree a) | Leaf TTerm a
    deriving (Show)

buildTree :: TTerm -> BinTree Types
buildTree (IFunc name)
    | name == "and" || name == "or"             = Leaf (IFunc name) (Arrow TBool (Arrow TBool TBool))
    | name == "true" || name == "false"         = Leaf (IFunc name) TBool
    | name == "not"                             = Leaf (IFunc name) (Arrow TBool TBool)
    | name == "+" || name == "-" || name == "*" = Leaf (IFunc name) (Arrow TInt (Arrow TInt TInt))
    | name == ">" || name == "=="               = Leaf (IFunc name) (Arrow TInt (Arrow TInt TBool))
    | name == "Empty"                           = Leaf (IFunc name) ListInt
    | name == "Cons"                            = Leaf (IFunc name) (Arrow TInt (Arrow ListInt ListInt))
    | name == "Append"                          = Leaf (IFunc name) (Arrow TInt (Arrow ListInt ListInt))
    | name == "ITE"                             = Leaf (IFunc name) (Arrow TBool (Arrow (TVar "a") (Arrow (TVar "a") (TVar "a"))))
    | otherwise                                 = Leaf (IFunc name) Unk --buscar a prog??

buildTree (INum x) = Leaf (INum x) TInt
    -- | (show forceT) == (show Unk)        = Leaf (INum x) TInt
    -- | otherwise                          = Leaf (Inum x) forceT

buildTree (IVar str) = Leaf (IVar str) Unk

buildTree (Lambda string tterm) = NodeL typeLambda left right
    -- | tLeft == Unk || tRight == Unk = NodeL typeLambda left right
    -- | otherwise                     = NodeL typeLambda left right
    where left = (Leaf (IVar string) Unk)
          right = (buildTree tterm)
          tLeft = (getType left)
          tRight = (getType right)
          typeLambda = Arrow tLeft tRight

buildTree (Apply tterm1 tterm2)
    | b /= Unk && c /= Unk = NodeA a left (buildTreeKnownType tterm2 c)
    -- | b /= Unk = NodeA a (buildTreeKnownType tterm1 b) right
    | b /= Unk && c == Unk = NodeA a left right -- No propaguis si es Unk
    | otherwise = NodeA Unk left right
    where left = (buildTree tterm1)
          right = (buildTree tterm2)
          b = getType left
          (c,a) = splitArrowType b

-- es podria fer que si es força a un NInt a ser un tipus que no es NInt digui que es erroni
buildTreeKnownType :: TTerm -> Types -> BinTree Types
buildTreeKnownType (IVar str) knownType = Leaf (IVar str) knownType
buildTreeKnownType (Apply tterm1 tterm2) knownType = NodeA knownType left right
    where left = (buildTree tterm1)
          right = (buildTree tterm2)
buildTreeKnownType (Lambda string tterm) knownType = NodeL knownType left right
    where left = (Leaf (IVar string) knownType)
          right = (buildTree tterm)

splitArrowType :: Types -> (Types,Types)
splitArrowType (Arrow type1 type2) = (type1,type2)
splitArrowType _ = (Unk,Unk)

-- ITE??

getType :: BinTree Types -> Types
getType (Leaf _ types) = types
getType (NodeA types _ _) = types
getType (NodeL types _ _) = types

--wellTypedTerm :: BinTree Types -> Types -> Bool

-- Use this when building the tree and give the type it returns to the left name var
findLambdaType :: BinTree Types -> String -> Types
findLambdaType (Leaf (IVar name) knownType) findName
    | name == findName = knownType
    | otherwise        = Unk

-- traverseTree :: BinTree Types -> Types -> Bool
-- -- traverseTree (Leaf x typ) knownType = typ == knownType
-- -- traverseTree (NodeA typ left right) knownType =
-- traverseTree (NodeL typ left right) knownType = (NodeL typ left right)
-- force "left" type, find in right tree

wellTypedTerm (Leaf _ _) = True
wellTypedTerm (NodeA typ left right)
    | (getType left) == (Arrow (getType right) (typ)) = True
    | otherwise = False
wellTypedTerm (NodeL typ left right)
    | typ == (Arrow (getType left) (getType right)) = True
    | otherwise = False

-- wellTyped :: Program TTerm -> Bool
-- wellTyped (Prog list)

{-
• ">", "=="::(Arrow TInt (Arrow TInt TBool))
• "not"::(Arrow TBool TBool)
• "and", "or"::(Arrow TBool (Arrow TBool TBool))
• "True", "False"::TBool
• "+", "−", "∗"::(Arrow TInt (Arrow TInt TInt))
• "Empty"::ListInt, "Cons"::(Arrow TInt (Arrow ListInt ListInt))
• "ITE"::(Arrow TBool (Arrow (TVar "a") (Arrow (TVar "a") (TVar "a"))))
-}



-------------- Entrada/Sortida y aleatorització --------------

genera :: RandomGen s => s -> Int -> Int -> Int -> ([Int],s)
genera s 0 _ _ = ([],s)
genera s n lo hi = (x:l,s2)
    where   (x,s1) = randomR (lo,hi) s
            (l,s2) = genera s1 (n-1) lo hi

jocProves :: (Program Term, Term)
jocProves = do
            let e11 = Func "Append" [Func "Empty" [],Var "l"]
            let e12 = Var "l"
            let e21 = Func "Append" [Func "Cons" [Var "x", Var "l1"], Var "l2"]
            let e22 = LET "m" (Func "Append" [Var "l1", Var "l2"]) (Func "Cons" [Var "x", Var "m"])
            let prog1 = Prog [[(e11,e12),(e21,e22)]]
            let ne1 = LET "x" (Num 3) (LET "y" (Num 5) (Func "+" [Var "x", Var "y"]))
            let final = (Func "Append" [Func "Cons" [ne1, Func "Empty" []], Func "Empty" []])
            (prog1,final)

main =  do
        std <- newStdGen
        let (l1,s1) = genera std 1 1 2
        print l1
        let (l2,s2) = genera s1 1 7 14
        print l2
        let (prog,term) = jocProves
        let reducedTerm = reduceRandom std prog term
        print reducedTerm

reduceRandom :: RandomGen s => s -> Program Term -> Term -> Term
reduceRandom seed p term
    | (show possibleReduce) == (show term) = possibleReduce
    | otherwise                            = (reduceRandom seed p possibleReduce)
    where possibleReduce = (oneStepRand seed p term)

oneStepRand :: RandomGen s => s -> Program Term -> Term -> Term

-- -- ITE
-- oneStepRand p (ITE ifBool termA termB)
--     | (ITE ifBool termA termB)      /= possibleOneStep = possibleOneStep
--     | ifBool == (Func "True" [])    = termA
--     | ifBool == (Func "False" [])   = termB
--         where possibleOneStep = (oneStep p ifBool)
--
-- -- LET
-- oneStepRand p (LET name term1 termInside)
--     | (show term1) /=  (show possibleOneStep)               = (LET name possibleOneStep termInside)
--     | (show termInside) /=  (show possibleOneStepInside)    = (LET name term1 possibleOneStepInside)
--     | otherwise                                             = performLET (LET name term1 termInside)
--         where possibleOneStepInside = (oneStep p termInside)
--               possibleOneStep = (oneStep p term1)

oneStepRand seed p leT@(LET name term1 termInside) = performLET leT

-- si intenta fer oneStep a un de la llista, i no hi ha cap canvi, ho de intentar amb un altre?
oneStepRand seed p (Func a listT)
    | all (== 1) first  = oneStep p (Func a listT)
    | otherwise         = (Func a (half1++[randElem]++(tail half2)))
    where   maxRand = ((length (listT)) - 1)
            (first,s1) = genera seed 1 1 2
            (l1,s2) = genera s1 1 0 maxRand
            randElem = listT !! (head l1)
            half1 = fst pair
            half2 = snd pair
            pair = splitAt (head l1) listT
