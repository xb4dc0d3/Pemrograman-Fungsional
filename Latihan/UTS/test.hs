rot :: String -> Int -> String
rot s n = (drop n s) ++ (take n s)
