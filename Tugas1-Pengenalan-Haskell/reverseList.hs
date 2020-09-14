
reverseList:: [(Integer)] -> [(Integer)]
reverseList [] = []
reverseList listOfInteger = last listOfInteger : reverseList (init listOfInteger)