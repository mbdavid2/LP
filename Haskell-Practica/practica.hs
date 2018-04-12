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
transform (Func a [x]) = Apply (IFunc a) (transform x)
transform (Func a xs) = Apply (transform (Func a (init xs))) (transform (last xs))
transform (LET name termSubs termInside) = (Apply (Lambda name inside) subs)
    where inside = transform termInside
          subs = transform termSubs
-- ITE??

transformProgram:: Program Term -> Program TTerm
transformProgram (Prog [[]]) = (Prog [[]])
transformProgram (Prog list) = (Prog (map (map (\(x,y) -> (transform x, transform y))) $ list))

-------------- 9. Types --------------

-- data Types = TBool | TInt | ListsInt | TVar String | Arrow Type Type
--     deriving (Show, Read)

{-
• ">", "=="::(Arrow TInt (Arrow TInt TBool))
• "not"::(Arrow TBool TBool)
• "and", "or"::(Arrow TBool (Arrow TBool TBool))
• "True", "False"::TBool
• "+", "−", "∗"::(Arrow TInt (Arrow TInt TInt))
• "Empty"::ListInt, "Cons"::(Arrow TInt (Arrow ListInt ListInt))
• "ITE"::(Arrow TBool (Arrow (TVar "a") (Arrow (TVar "a") (TVar
"a"))))
-}

-- wellTyped :: Program TTerm -> Bool
-- wellTyped (Prog list)

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
