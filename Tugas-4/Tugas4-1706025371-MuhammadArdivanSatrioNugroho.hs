import Data.Char as Char

--- Soal nomor 1 ---
--- using fold ---
length_by_foldl :: [a] -> Integer
length_by_foldl xs = foldl (\acc _ -> acc + 1) 0 xs

-- length_by_foldr ::  [a] -> Integer
--- const x is a unary function which evaluates to x for all inputs.---
-- length_by_foldr xs = foldr (const (1+)) 0 xs

--- using map ---
length' :: [a] -> Integer
length' xs = foldr (+) 0 (map (\_ -> 1) xs)

--- Soal nomor 2 ---
-- greaterOne n = n > 1
-- addOne n = n + 1
-- addUp  ns  =  filter  greaterOne  (map  addOne  ns)
addUp' :: (Num b, Ord b) => [b] -> [b]
addUp' ns =  map (\x -> x+1) ((filter (\x -> x>0) ns))

--- Soal nomor 3 ---
--- a. Map and Fold ---
sumOfSquares_a :: Integer -> Integer
sumOfSquares_a n = foldl (+) 0 (map (\x-> x^2) [1.. n])

--- b. Fold and List Comprehension ---
sumOfSquares_b :: Integer -> Integer
sumOfSquares_b n = foldl (+) 0 ([x^2 | x <- [1..n]])

--- c. Perbedaan dari kedua pendekatan ---


--- Soal nomor 4 ---
multipleOf5 :: Integral a => [a] -> Integer
--- Reuse length' expression ---
multipleOf5 list = length' (map (\x -> x) (filter (\x -> x `mod` 5 == 0) list))


--- Soal nomor 5 ---
total func n = sum (map func [1..n])

--- Soal nomor 6 ---
reverse' :: Foldable t => t a -> [a]
reverse' xs = foldr (\x acc -> acc ++ [x]) [] xs

--- Soal nomor 7 (PDF) ---

--- Soal nomor 8 ---
pythaTriple :: [(Integer, Integer, Integer)]
pythaTriple = [(x,y,z) | z<- [5..], y<- [z, (z-1) .. 1], x<- [y, (y-1)..1], x*x + y*y == z*z]


--- Soal nomor 9 (PDF) ---

--- Soal nomor 10 (NOT SOLVED) ---
noUpperAndIndent text =  filter Char.isLower text
