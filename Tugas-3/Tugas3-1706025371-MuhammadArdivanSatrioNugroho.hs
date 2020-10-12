--- Soal no.1 ---

myCurry :: ((a,b)->c)->(a->b->c)
myCurry f x y = f (x,y)

myUncurry :: (a->b->c)-> (a,b)->c
myUncurry f (x,y) = f x y

--- Soal no,2 ---

--- Helper function to add the next val ---
fib_helper :: [Integer]
fib_helper = 0 : next
    where next = 1 : zipWith (+) fib_helper next

--- Get Fibonacci List ---
fibonacci :: Int -> [Integer]
fibonacci n = take (n+1) fib_list
  where fib_list = 0:1:(zipWith (+) fib_list (tail fib_helper))

--- Soal no.3 ---
multiply_helper :: Integer -> Integer -> Integer
--- Addition method ---
multiply_helper x y 
            | y == 0 = 0
            | y == 1 = x
            | otherwise = x + (multiply_helper x (y-1))

power :: Integer -> Integer -> Integer
power a b
        | a == 0 = 1
        | b == 1 = a
        | otherwise = (multiply_helper a (power a (b-1)))

--- Soal no.4 ---

sumEven :: [(Integer)] -> Integer
--- Filter the even number and sum them all ---
sumEven listInteger = sum (filter even listInteger)

--- Soal no.5 ---

--- Decimal precision helper ---
trunc_dec :: Double -> Int -> Double
trunc_dec result dec_prec = (fromIntegral (round (result * t))) / t
    where t = 10^dec_prec

--- Asumsi: boleh menggunakan rekursif biasa ---
eq_invest  ::Double->Double->Double->Double
eq_invest nominal rate duration 
                        | duration == 0 = nominal
                        | otherwise = nominal + eq_invest (nominal * (1+rate/100)) rate (duration-1)

--- Asumsi: decimal precision 1 after comma ---
invest :: Double -> Double -> Double -> Double
invest nom rate dur = trunc_dec ((eq_invest nom rate dur) - nom) 1