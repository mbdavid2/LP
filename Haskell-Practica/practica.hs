--------------------------------------
--         Pràctica Haskell         --
--        David Moreno Borràs       --
--    Llenguatges de Programació    --
--------------------------------------
import System.IO
(!=) :: Eq a => a -> a -> Bool 
(!=) = (/=)

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

-- Rep l'string de la variable i el terme original
-- + la llista de substitucio (funciona com lookup)
-- Si no el troba, torna el terme original
-- Si el troba, el substitueix
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

-- Retorna el Term resultant final d'aplicar tots els LETS de dins
finalTerm :: Term -> Term
finalTerm (LET str t1 t2) = performLET (LET str t1 t2)
finalTerm (Func a listT) = Func a (map finalTerm listT)
finalTerm (ITE t1 t2 t3) = ITE (finalTerm t1) (finalTerm t2) (finalTerm t3)
finalTerm basicTerm = basicTerm

-- Aplica un LET i retorna el terme resultant
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
    | otherwise     = Nothing
    where
        basic = a1 == a2 && (length listT1) == (length listT2)
match _ _ = Nothing

-- Aixo no representa que es pot fer amb el >>= ? en plan aplica la funcio ++ a cada element
-- Hauria de ser >>= amb zipWith/map/foldl?¿?¿
-- >>= es nomes amb un element! jo vull desempaquetar 2 elements, fer f a b, i empaquetar el resultat
concatMaybe :: Maybe [(String,Term)] -> Maybe [(String,Term)] -> Maybe [(String,Term)]
concatMaybe (Just list1) (Just list2) = return (list1 ++ list2)
concatMaybe Nothing Nothing = Nothing
concatMaybe (Just list) Nothing = (Just list)
concatMaybe Nothing (Just list) = (Just list)

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
    | (show termInside) /=  (show possibleOneStep)  = (LET name term1 possibleOneStep)
    | otherwise                                     = performLET (LET name term1 termInside)
        where possibleOneStep = (oneStep p termInside)

-- Si el primer de dins que es troba es Var/Num, ja no pot fer res més :(
oneStep p (Func a ((Var v):listT)) = (Func a ((Var v):listT))
oneStep p (Func a ((Num n):listT)) = (Func a ((Num n):listT))

oneStep p (Func a []) = (Func a [])

oneStep p term@(Func a (x:listT))
    | null redu = matchProg p term 
    | otherwise = (Func a (irre++((oneStep p (head redu)):(tail redu))))
    where irre = takeWhile (\x -> show (oneStep p x) == show x) (x:listT)
          redu = dropWhile (\x -> show (oneStep p x) == show x) listT
          possibleMatch = matchProg p (Func a (x:listT))
              
-- oneStepWhile :: Program Term -> [Term] -> [Term]
-- mapWhile (x:xs) bool 
--     | bool && (x /= possibleOneStep) = (possibleOneStep):mapWhile
--     | otherwise = (x:xs)
--         where possibleOneStep = oneStep (Prog [[]]) x
          
          

              
              
              
              
              
              
              
              
              
              

applyPossibleMatch :: Maybe [(String,Term)] -> Term -> Term -> Term
applyPossibleMatch Nothing term xB = term
applyPossibleMatch (Just list) term xB = replace list xB

matchProg :: Program Term -> Term -> Term
matchProg (Prog [[]]) term = term
matchProg (Prog ((((xA,xB)):restx):rest)) term
    | possibleMatch == Nothing  = matchProg (Prog (((restx):rest))) term
    | otherwise                 = applyPossibleMatch possibleMatch term xB
        where possibleMatch = match xA term
