-- Library / Built in Function ---

import Data.Char as Char

--- Fungsi sumOfSquares No.1 ---
sumOfSquares :: [(Integer)] -> Integer
sumOfSquares [] = 0
sumOfSquares (x:xs) = x*x + sumOfSquares(xs)

--- Fungsi triangular No.2 ---
triangular :: Integer -> Integer
triangular num
    | num == 0 = 0
    | otherwise = num + triangular(num-1)

--- Fungsi power scratch No.3, hanya bilangan bulat positif ---
power :: Integer -> Integer -> Integer
power num pow 
        | pow == 0 = 1
        | otherwise = (num) * (power num (pow-1))

--- Fungsi isPalindrome No.4 ---
lowerCaseString :: String -> String
getLetter:: String -> String
isPalindrome :: String -> Bool

lowerCaseString text = map Char.toLower text
getLetter text = filter Char.isLetter (lowerCaseString text)
isPalindrome xs
        | xs == "" = True
        | otherwise = getLetter xs == reverse (getLetter xs)