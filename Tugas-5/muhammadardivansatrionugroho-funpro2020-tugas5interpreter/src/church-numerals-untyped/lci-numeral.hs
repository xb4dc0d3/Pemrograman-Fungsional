------------------------------- Lambda Calculus Interpreter -------------------------------

{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
{-# OPTIONS_GHC -fno-warn-tabs #-}

import System.IO
import Data.List
import Data.Char
import Data.Maybe
import Data.List.Split
import Text.Parsec
import Text.Parsec.String
import qualified Text.PrettyPrint as PP

data Term = Var String
          | Application Term Term
          | Abstraction String Term
          deriving(Show, Eq)

data Result = Res Term Int [Term] [String] deriving(Show, Eq)


delete1 x [] = []
delete1 x (y:xs) | (x == y) = (delete1 x xs)
                | otherwise = (y:delete1 x xs)

removeLast :: [String] -> [String]
removeLast [] = []
removeLast [last] = []
removeLast (l:ls) = [l]++(removeLast ls)

freeVars :: Term -> [String]
freeVars t = case t of  Var s -> [s]
                        Application t1 t2 -> freeVars t1 ++ freeVars t2
                        Abstraction s1 t2 -> delete1 s1 (freeVars t2)

boundVars :: Term -> [String]
boundVars (Var v) = []
boundVars (Application t1 t2) = boundVars t1 ++ boundVars t2
boundVars (Abstraction s1 t2) = [s1] ++ boundVars t2

renameVarinTerm :: Term -> String -> String -> Term
renameVarinTerm (Var s1) s s' = if (s1 == s) then (Var s') else (Var s1)
renameVarinTerm (Abstraction s1 t) s s' = if (s1 /= s) then (Abstraction s1 (renameVarinTerm t s s')) else (Abstraction s1 t)
renameVarinTerm (Application t1 t2) s s' = (Application (renameVarinTerm t1 s s') (renameVarinTerm t2 s s'))

------- Alpha reduce applies only to abstraction! ------
azList :: [String]
azList = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]

alphaReduction :: String->Term -> Term
alphaReduction str (Abstraction s t) = (Abstraction s' t') where
    s' = str
    t' = renameVarinTerm t s s'
alphaReduction str term = term

alphaReduceAll :: [String]->Term -> Term
alphaReduceAll (s:strs) (Abstraction s1 t1) = (alphaReduction s (Abstraction s1 (alphaReduceAll strs t1)))
alphaReduceAll (strs) t = t

replace :: Term->String->Term -> Term
replace (Var s1) str trepl = if (str == s1) then trepl else (Var s1)
replace (Abstraction s1 t1) str trepl = if (str == s1) then (replace t1 str trepl) else (Abstraction s1 (replace t1 str trepl))
replace (Application t1 t2) str trepl = (Application (replace t1 str trepl) (replace t2 str trepl))

betaReduction :: Term -> Term
betaReduction term = case term of
    (Var s) -> (Var s)
    (Application (Var v1) t) -> (Application (Var v1) t)
    (Application (Abstraction abstr t) appt) -> (replace (Abstraction abstr t) abstr appt)
    (Application (Application t1 t2) appt) -> (Application (betaReduction (Application t1 t2)) appt)
    (Abstraction s t) -> (Abstraction s t)

step :: Term -> (Term, String)
step (Var s) = ((Var s), "_")
step (Application (Var v1) t) = ((Application (Var v1) (fst (step t))), snd (step t))
step (Application (Application t1 t2) t3) = if (fst newtt == (Application (Application t1 t2) t3)) then ((Application (fst (step (Application t1 t2))) (fst (step t3))),  (snd (step (Application t1 t2)))++","++(snd (step t3))) else newtt
    where
        newtt = ((Application (betaReduction (Application t1' t2)) t3), "beta")
            where
                t1' = (alphaReduceAll intrsct t1)
                    where
                        intrsct = azList \\ varsInT
                        varsInT = (freeVars t2) ++ (boundVars t2)
step (Abstraction str1 t1) = case t1 of
    (Application t2 (Var str2)) -> if (str1 == str2 && (notElem str1 (freeVars t2))) then (t2, "eta") else ((Abstraction str1 (fst (step t1))), snd (step t1)) --eta Reduction
    otherwise -> ((Abstraction str1 (fst (step t1))), snd (step t1))
step (Application t1 t2) = ((betaReduction (Application t1' t2)), "beta")
    where
        t1' = (alphaReduceAll intrsct t1)
            where
                intrsct = azList \\ varsInT
                varsInT = (freeVars t2) ++ (boundVars t2)

reduceNF :: Term -> [String]
reduceNF t1 = if (t1 == fst (step t1)) then [prettyprint t1] else [prettyprint t1]++(reduceNF t2) where 
    t2 = fst (step t1)

printNF strs = mapM_ print (reduceNF (myparse(strs)))

reducesList :: Term -> [String]
reducesList t1 = if (t1 == fst (step t1)) then ["_"] else [snd t2]++(reducesList (fst t2)) where 
    t2 = step t1

reduceTuples :: Term -> ([Term], [String])
reduceTuples t1 = if (t1 == fst (step t1)) then ([t1], ["_"]) else ([t1]++(fst (reduceTuples (fst t2))), [snd t2]++(snd (reduceTuples (fst t2)))) where 
    t2 = step t1

reduce :: Term -> Result
reduce term = Res (reductions!!last) (size-1) reductions (removeLast redexes) where
    reductions = fst (reduceTuples term)
    redexes = snd (reduceTuples term)
    size = length reductions
    last = size-1

--------------------------------------- PARSER --------------------------------------------
lambdaTerm :: Parser Term
lambdaTerm = lambdaAbstraction <|> lambdaApplication <|> simple

lambdaAbstraction :: Parser Term
lambdaAbstraction = do
    char '\\'
    var <- letter
    char '.'
    body <- lambdaTerm
    return(Abstraction [var] body)

lambdaApplication :: Parser Term
lambdaApplication = do
    apps <- many1 simple
    return(foldl1 Application apps)

simple :: Parser Term
simple = lambdaVar <|> paren

lambdaVar :: Parser Term
lambdaVar = do
    var <- letter
    return(Var [var])

paren :: Parser Term
paren = do
    char '('
    term <- lambdaTerm
    char ')'
    return term

myparse :: String -> Term
myparse str = case (parse lambdaTerm "" str) of
    Left msg -> error $ show msg
    Right term' -> term'

test = myparse "\\z.(\\f.\\x.fzx)(\\y.y)"
pair = myparse "\\x.\\y.\\z.zxy"


-------------------------------------- PRETTY PRINT --------------------------------------
ppr :: Term -> PP.Doc
ppr (Var x) = PP.text x
ppr (Abstraction x e) = PP.fcat [(PP.fcat [PP.text "\\",PP.text x,PP.text "."]),(ppr e)]
ppr apply = PP.fcat (map parenApp (args apply))

args (Application x y) = args x ++ [y]
args x = [x]

parenApp (x@(Application _ _)) = PP.parens (ppr x)
parenApp (x@(Abstraction _ _)) = PP.parens (ppr x)
parenApp x = ppr x

prettyprint :: Term -> String
prettyprint term = PP.render (ppr term)

-------------------------------------- HELPER -------------------------------------------


--- Split String Input one by one ---
split_input x = splitEvery 1 x

--- Show numeral to church notation ---
numeral_to_lambda :: Integer -> String -> Integer -> String
numeral_to_lambda num1 op num2
    | op == "+" = (prettyprint (chPlus (church num1) (church num2)))
    | op == "*" = (prettyprint (chMult (church num1) (church num2)))
    | otherwise = "Something's wrong"



------------------------------------------- Main ------------------------------------------
loopPrinter = do 
    putStr "> "
    inputStr <- readLn 
    -- Just 0 - 9 ---
    putStrLn ("Normal form of " ++ inputStr ++ ": ")
    if (length inputStr) == 1
        then do
            let num1 = read ((split_input inputStr)!!0) :: Integer
            let lambda_church_notation = prettyprint((church num1))
            putStrLn("==> Lambda church notation: "++ lambda_church_notation)
            putStrLn ("==> Numeral notation: " ++ (numeral (flagNumeral lambda_church_notation))++ "\n")
        else do
            let num1 = read ((split_input inputStr)!!0) :: Integer
            let op = ((split_input inputStr)!!1)
            let num2 = read ((split_input inputStr)!!2) :: Integer
            let lambda_church_notation = numeral_to_lambda num1 op  num2
            putStrLn("==> Lambda church notation: "++ lambda_church_notation)
            putStrLn ("==> Numeral notation: " ++ (numeral (flagNumeral lambda_church_notation))++ "\n")
    loopPrinter

main :: IO ()
main = do  
    putStrLn ("Type a numeral expression like \"1\", \"1+2\", \"2*4\", or ^D to exit:")
    loopPrinter

---------------------------------------- TEST CASES ---------------------------------------
inputString = "(\\x.\\y.x)(\\z.z)"
parseInputString = myparse inputString
myterm = Application (Abstraction "x" ( Abstraction "y"  (Var "x"))) (Abstraction "z" ( Var "z"))
prettyPrinted = prettyprint myterm

------------------------------------- Church Numerals -------------------------------------


---- Convert from Numeral to Church ---
church :: Integer -> Term
church 0 = myparse "\\f.\\x.x"
church 1 = myparse "\\f.\\x.fx"
church n = myparse (res!!size) where
    res = reduceNF (myparse ("\\f.\\x.f(("++(prettyprint (church (n-1)))++")fx)"))
    size = ((length res)-1)

--- Helper to convert string church literal to Maybe Integer ---
term_to_integer :: Term -> Maybe Integer
term_to_integer (Abstraction s (Abstraction z apps)) = go apps
    where
        go (Var x) | x == z = Just 0
        go (Application (Var f) e) | f == s = (+ 1) <$> go e
        go _ = Nothing
term_to_integer _ = Nothing

--- Convert from Church to Numeral ---
--- Maybe Int to Int ---
flagNumeral :: String -> Integer
flagNumeral bb = fromMaybe (-1) (term_to_integer (myparse bb))

numeral :: Integer -> String
numeral yy 
    | yy == -1 = "Not church representation"
    | otherwise = show yy

{- chSucc n = n+1 -}
chSucc :: Term -> Term
chSucc str = myparse (res!!size) where 
    res = reduceNF (myparse ("\\f.\\x.f(("++(prettyprint str)++")fx)"))
    size = ((length res)-1)

{- chPlus m n = m + n -}
chPlus :: Term -> Term -> Term
chPlus str1 str2 = myparse (res!!size) where 
    res = reduceNF (myparse ("\\f.\\x.("++(prettyprint str1)++")f(("++(prettyprint str2)++")fx)"))
    size = ((length res)-1)

{- chMult m n = m * n -}
chMult :: Term -> Term -> Term
chMult str1 str2 = myparse (res!!size) where 
    res = reduceNF (myparse ("\\f.("++(prettyprint str1)++")(("++(prettyprint str2)++")f)"))
    size = ((length res)-1)