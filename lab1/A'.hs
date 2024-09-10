import Data.List

-- Generic part
type StatePair = (State,State)

run :: [State]
run = gps [(startState,startParent)] []

gps :: [StatePair]->[StatePair]->[State]
gps [] _ = error "No solution"
gps (s:restOfOpen) closed 
    |   isGoal (fst s) = reverse(retrieveSolution (fst s) (s:closed))  
    |   otherwise = gps newOpen (s:closed) 
            where newOpen = restOfOpen ++ zip newStates (repeat (fst s))
                  newStates = filter (`notElem` map fst (restOfOpen ++ closed)) (makeMoves (fst s))
             

retrieveSolution :: State -> [StatePair] -> [State]
retrieveSolution s closed = 
    let parent = findParent s closed 
    in if parent == startParent then [s] else s: retrieveSolution parent closed
            where findParent y xs = snd . head $ filter ((== y) . fst) xs
           


-- Problem specific
type State = (Int,Int)

startState :: State
startState = (0,0)

startParent :: State
startParent = (-1,-1)

isGoal :: State -> Bool
isGoal (x,_) = x==2

makeMoves :: State -> [State]
makeMoves state = filter (/= state) (map ($ state) operators)

operators :: [State->State]
operators = [fillSmall, fillLarge, emptySmall, emptyLarge, smallInLargeTillFull,smallInLargeTillEmpty,largeInSmallTillFull,largeInSmallTillEmpty]

fillSmall :: State->State
fillSmall (x,y) = if y < 3 then (x,3) else (x,y) 

fillLarge :: State->State
fillLarge (x,y) = if x < 4 then (4,y) else (x,y)

emptySmall :: State->State
emptySmall (x,y) = if y > 0 then (x,0) else (x,y)

emptyLarge :: State->State
emptyLarge (x,y) = if x > 0 then (0,y) else (x,y)

smallInLargeTillFull :: State->State
smallInLargeTillFull (x,y) = if x+y >= 4 && x < 4 && y > 0 then (4,y-(4-x)) else (x,y)

smallInLargeTillEmpty :: State->State
smallInLargeTillEmpty (x,y) = if x+y < 4 && y > 0 then (x+y,0) else (x,y)

largeInSmallTillFull :: State->State
largeInSmallTillFull (x,y) = if x+y >= 3 && y < 3 && x > 0 then (x-(3-y),3) else (x,y)

largeInSmallTillEmpty :: State->State
largeInSmallTillEmpty (x,y) = if x+y < 3 && y > 0 then (0,x+y) else (x,y)

