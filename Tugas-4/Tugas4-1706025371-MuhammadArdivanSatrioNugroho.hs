import Data.Char as Char

--- Soal nomor 1 ---
--- using fold ---
length_by_foldl :: [a] -> Integer
length_by_foldl xs = foldl (\acc _ -> acc + 1) 0 xs

length_by_foldr ::  [a] -> Integer
--- const x is a unary function which evaluates to x for all inputs.---
length_by_foldr xs = foldr (const (1+)) 0 xs

--- using map ---
length_by_map :: [a] -> Integer
length_by_map = sum . (map (\_ -> 1))

--- Soal nomor 2 ---
total func n = sum (map func [1..n])

--- Soal nomor 3 ---
sumOfSquares = 0

--- Soal nomor 4 ---
multipleOf5 :: Integral a => [a] -> Integer
--- reuse length_by_foldl ---
multipleOf5 list = length_by_foldl (map (\x -> x) (filter (\x -> x `mod` 5 == 0) list))


--- Soal nomor 5 ---
-- total :: (Int -> Int) -> (Int -> Int)


--- Soal nomor 6 ---
reverse' :: Foldable t => t a -> [a]
reverse' xs = foldr (\x acc -> acc ++ [x]) [] xs


--- Soal nomor 8 ---
pythaTriple :: [(Integer, Integer, Integer)]
pythaTriple = [(x,y,z) | z<- [5..], y<- [z, (z-1) .. 1], x<- [y, (y-1)..1], x*x + y*y == z*z]


--- Soal nomor 10 ---
noUpperAndIndent text =  filter Char.isLower text


