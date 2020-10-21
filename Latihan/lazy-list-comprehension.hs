divisor:: Integer -> [Integer]
divisor x = [i | i <- [1..x], x `mod` i == 0]