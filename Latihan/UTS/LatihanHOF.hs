--- Exercises from chapter 9-10 of The Craft of Functional Programming ---
mystery xs = foldr (++) [] (map sing xs)
    where 
        sing x = [x]
sumOfSquares xs = foldr (+) 0 (map(\y -> y^2) xs)

--- Composition function from each lists ---
--- Example [\x -> x+1, \x -> x+2, id] 3 ---
composeList :: [a -> a] -> a -> a
composeList fs v = foldr (flip(.)) id fs $ v

--- Implement Flip function ---
flip' op x y = y `op` x



--- List Comprehension HOF ---

--- [x+1| x <- xs ]

soal1 xs = map (+1) xs

--- [x+y|x <- xs, y <-ys ]

soal2 xs ys = concat (map (\x -> map (\y -> (x+y)) ys) xs)

--- [x+2|x <- xs, x > 3 ]
soal3 xs = map (+2) (filter (\x -> x > 3) xs)

--- [x+3 | (x,_) <- xys ]
soal4 :: Num b1 => [(b1, b2)] -> [b1]
soal4 xys = map (\(x,_) -> x+3) xys

--- [ x+4 | (x,y) <- xys, x+y < 5 ]
soal5 xys = map ((+4).fst) (filter(\(x,y) -> x+y < 5) xys)

--- [x+5 | Just x <- mxs ]
soal6 mxs = map (\(Just x) -> x+5) (filter isJust mxs)