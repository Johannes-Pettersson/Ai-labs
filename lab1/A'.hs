import Data.List

-- Generic part
type StateTriple = [State,State,Value]
type Value = (Int, Int)
--           (f,   g  )
run :: [State]
run = A' [[startState, startParent, (calculateHval startState, 0)]] []

A' :: [StateTriple]->[StateTriple]->[State]
A' [] _ = error "No solution"
A' (s:restOfOpen) closed 
    |   isGoal (fst s) = reverse(retrieveSolution (fst s) (s:closed))
    |   otherwise = A' newOpen (s:closed)
            where newOpen = sortByFvals (restOfOpen ++ [[newState, fst s, calculateFval newState] | newState <- newStates])
                  newStates = filter (`notElem` map fst (restOfOpen ++ closed)) (makeMoves (fst s))
             

retrieveSolution :: State -> [StateTriple] -> [State]
retrieveSolution s closed = 
    let parent = findParent s closed 
    in if parent == startParent then [s] else s: retrieveSolution parent closed
            where findParent y xs = snd . head $ filter ((== y) . fst) xs

calculateHval :: State -> Int
--TODO

calculateFval :: StateTriple -> Int
--TODO

sortByFvals :: [StateTriple] -> [StateTriple]
--TODO


-- Problem specific
type State = [Int]

startState :: State
startState = [0..8]

startParent :: State
startParent = []

isGoal :: State -> Bool
isGoal state = state == [1,2,3,4,5,6,7,8,0]

makeMoves :: State -> [State]
makeMoves state = filter (/= state) (map ($ state) operators)

operators :: [State->State]
operators = [fillSmall, fillLarge, emptySmall, emptyLarge, smallInLargeTillFull,smallInLargeTillEmpty,largeInSmallTillFull,largeInSmallTillEmpty]

fillSmall :: State->State
fillSmall (x,y) = if y < 3 then (x,3) else (x,y)

moveUp :: State->State
moveUp state = 