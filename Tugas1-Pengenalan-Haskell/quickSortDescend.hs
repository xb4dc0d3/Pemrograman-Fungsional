quickSortDescend:: [(Integer)] -> [(Integer)]

-- //TODO: Implement QuickSort Descending and Compare Slowest to Fastest --
quickSortDescend listOfInteger = 
    if listOfInteger == []
        then []
    else
        
        --- STEP 1: quickSortDescend([x | x <- tail listOfInteger, x >  listOfInteger !! 0])
        --- if listOfInteger[1:] as x , where x > listOfInteger[0] (middle), then add before

        --- STEP 2: set listOfInteger till the ones to be in the middle

        --  STEP 3: quickSortDescend([x | x <- tail listOfInteger ,x <= listOfInteger !! 0])
        --- if listOfInteger[1:] as x , where x <= listOfInteger[0] (middle), then add after 
        quickSortDescend([x | x <- tail listOfInteger, x >  listOfInteger !! 0])
            ++ [listOfInteger !! 0] 
            ++ quickSortDescend([x | x <- tail listOfInteger ,x <= listOfInteger !! 0])

