--- Lectures 1 and 2 - Functions and types ---

--- No 1 ---

noOfSol a b c
    | (b^2-4*a*c) > 0 = "2 Solutions"
    | (b^2-4*a*c) < 0 = "No Solutions"
    | otherwise = "1 Solutions"

--- No 3 membuat menjadi 3 pasang ---
thrice x = [x, x, x]
sums (x : y : ys) = x : sums (x + y : ys)
sums xs           = xs


--- Lectures 3 - Lists and Recursion ---

--- No 1 ---
fac n | n < 0 = -1
      | n == 0 = 1
      | otherwise = n * fac (n - 1)


--- No 2 ---


--- No 3 ---
lastElement lists = head (reverse lists)

--- No 4 ---
beforeLastElement lists = (reverse lists) !! 1

--- No 5 define operator (!!) or getIndex ---

getIndex lists idx = head([val | (i, val) <- zip [0..length lists] lists, i == idx])


--- No 6 define palindrome ---
palindrome lists = lists == reverse lists

--- No 7 define concat ---
doConcat = ""

--- No 8 ---

--- No 9 ---

--- No 10 ---

--- No 11 ---


--- No 12 ---
xs = [1,2,3,4,5]
--- [[ ]] ++ xs   == xs ---> false
--- [[ ]] ++ xs   == [xs] ---> false---
---[[ ]] ++ xs   == [[ ], xs] ---> false
--- [[ ]] ++ [xs] == [[ ], xs] ---> true 
--- [xs]  ++ [ ]  == [xs] ---> true
--- [xs]  ++ [xs] == [xs, xs] ---> true

--- No 13 remove element in second list if there's in first list ---
removeAll :: Eq a => [a] -> [a] -> [a]
removeAll _ [] = []
removeAll x (y:ys)
    | elem y x = removeAll x ys
    | otherwise = y:removeAll x ys


--- No 14 transpose matrix ---
transpose ([]:_) = []
transpose lists = (map head lists) : transpose (map tail lists)


--- No 15 ---
split' :: Eq a => Int -> [a] -> [[a]]
split' num lists
    | num <= 0 || lists == [] = []
    | otherwise = take num lists : split' num (drop num lists)

--- No 16 ---
gaps (x:xs)
    | (length (x:xs)) == 0 || (x:xs) == [] = []
    | otherwise = []


--- Lecture 4 - Higher-order functions ---

--- No 1 ---

--- No 2 --- 
concatCustom xs ys = foldr (:) xs ys

--- No 3 ---
inits = ""

tails = ""

--- No 4 ---
filter' p = concat . map box
  where box x
            | p x = [x]
            | otherwise = []

--- map box input_list ---
--- check if p then do [x] ---
--- else [] ---
--- then [[1], [], [3], [] ...] , need to concat so, [1,3,5,..]

--- No 5 ---

--- No 6 ---

--- No 7 ---
--- Expression of map map ---
--- *Main> :t map map
--- map map :: [a -> b] -> [[a] -> [b]]