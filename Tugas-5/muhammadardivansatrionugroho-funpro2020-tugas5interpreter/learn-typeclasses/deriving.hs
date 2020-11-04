--- Enum ---
data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday  
           deriving (Show, Eq, Read, Bounded, Enum, Ord)


type AssocList k v = [(k,v)]  
