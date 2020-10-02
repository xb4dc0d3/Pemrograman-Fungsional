--- Soal no.1 ---
myCurry :: ((a,b)->c)->(a->b->c)
myCurry f x y = f (x,y)

myUncurry :: (a->b->c)-> (a,b)->c
myUncurry f (x,y) = f x y

--- Soal no,2 ---
-- fib_helper :: Integer -> Integer
-- fib_helper num 
--         | num == 0 = 0
--         | num == 1 = 1
--         | otherwise = fib_helper(num-1) + fib_helper(num-2)
-- fibonacci :: Integer -> [(Integer)]
-- fibonacci num = map fib_helper [0..num]
fib_helper :: [Integer]
fib_helper = 0 : next
    where next = 1 : zipWith (+) fib_helper next

fibonacci :: Int -> [Integer]
fibonacci = flip take fib_helper

--- Soal no.3 ---
multiply_helper :: Integer -> Integer -> Integer
multiply_helper x y 
            | y == 0 = 0
            | y == 1 = x
            | otherwise = x + (multiply_helper x (y-1)) ---addition method---

power :: Integer -> Integer -> Integer
power x y
        | y == 0 = 1
        | y == 1 = x
        | otherwise = (multiply_helper x (power x (y-1)))

--- Soal no.4 ---
sumEven :: [(Integer)] -> Integer
sumEven listInteger = sum (filter even listInteger)

--- Soal no.5 ---
eq_invest  ::Double->Double->Double->Double
eq_invest nominal rate duration 
                        | duration == 0 = nominal
                        | otherwise = nominal + eq_invest (nominal * (1+rate/100)) rate (duration-1)

invest :: Double -> Double -> Double -> Double
invest nom rate dur = (eq_invest nom rate dur) - nom