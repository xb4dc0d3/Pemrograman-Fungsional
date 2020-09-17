listSum:: [(Integer)] -> Integer
listSum [] = 0
listSum (x:xs) = x + (listSum xs)