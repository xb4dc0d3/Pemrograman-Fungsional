circleArea :: Double -> Double --function declaration
circleArea r = r*pi


listSumArea:: [Double] -> Double
listSumArea [] = 0
listSumArea (x:xs) = x + listSumArea(xs)