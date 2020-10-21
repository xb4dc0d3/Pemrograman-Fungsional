
--- Problem 1 ---
myLast :: [a] -> a
myLast [] = error "Empty lists"
myLast [x] = x
myLast (_:xs) = myLast xs


--- Problem 2 ---
myButLast :: [p] -> p
myButLast [] = error "Empty Lists"
myButLast xs = head(tail(reverse xs))


--- Problem 3 ---
elementAt :: [a] -> Int -> a
elementAt lst i = lst !! i


--- Problem 4 ---
myLength :: [a] -> Integer
myLength xs = foldr (+) 0 (map (\_ -> 1) xs)

--- Problem 5 ---
myReverse :: [a] -> [a]
myReverse [] = []
myReverse (x:xs) = myReverse xs ++ [x]

--- Problem 6 ---
-- isPalindrome :: [a] -> Bool
-- isPalindrome [] = True
isPalindrome :: Eq a => [a] -> Bool
isPalindrome xs = (xs == (myReverse xs))

--- Problem 7 (?) ---

--- Problem 8 ---
compress :: Eq a => [a] -> [a]
compress x = foldr (\a b -> if a == (head b) then b else a:b) [head x] x


--- Problem 9 (?) --- 


--- Problem 10 (?) --- 

