circleArea :: Double -> Double --function declaration
circleArea r = r*pi


listSumArea:: [Double] -> Double
listSumArea listOfCircleArea = sum [area | area <- listOfCircleArea]