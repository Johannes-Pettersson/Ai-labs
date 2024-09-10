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
type State = [Int]

startState :: State
startState = [2..15]

startParent :: State
startParent = [1..15]

isGoal :: State -> Bool
isGoal xs = xs == [1]

makeMoves :: State -> [State]
makeMoves state = filter (/= state) [op pin state | pin <- state, op <- operators]


operators :: [Int->State->State]
operators = [moveRight, moveLeft, moveDownRight, moveDownLeft, moveUpRight, moveUpLeft]


moveRight :: Int -> State -> State
moveRight pin state
    | pin `elem` [4,7,8,11,12,13] && pin `elem` state && pin+1 `elem` state && pin+2 `notElem` state = pin+2 : filter (/= pin) (filter (/= pin+1) state)
    | otherwise = state

moveLeft :: Int -> State -> State
moveLeft pin state
    | pin `elem` [6,10,9,15,14,13] && pin `elem` state && pin-1 `elem` state && pin-2 `notElem` state = pin-2 : filter (/= pin) (filter (/= pin-1) state)
    | otherwise = state

moveDownRight :: Int -> State -> State
moveDownRight pin state
    | pin `elem` [1..6] && pin `elem` state && (nextPin pin) `elem` state && (nextPin (nextPin pin)) `notElem` state = (nextPin (nextPin pin)) : filter (/= pin) (filter (/= nextPin pin) state)
    | otherwise = state
  where
    nextPin x
        | x >= 7 = x + 5
        | x >= 4 = x + 4
        | x >= 2 = x + 3
        | x >= 1 = x + 2
        | otherwise = x

moveDownLeft :: Int -> State -> State
moveDownLeft pin state
    | pin `elem` [1..6] && pin `elem` state && (nextPin pin) `elem` state && (nextPin (nextPin pin)) `notElem` state = (nextPin (nextPin pin)) : filter (/= pin) (filter (/= nextPin pin) state)
    | otherwise = state
  where
    nextPin x
        | x >= 7 = x + 4
        | x >= 4 = x + 3
        | x >= 2 = x + 2
        | x >= 1 = x + 1
        | otherwise = x

moveUpRight :: Int -> State -> State
moveUpRight pin state
    | pin `elem` [11,12,13,7,8,4] && pin `elem` state && (nextPin pin) `elem` state && (nextPin (nextPin pin)) `notElem` state = (nextPin (nextPin pin)) : filter (/= pin) (filter (/= nextPin pin) state)
    | otherwise = state
  where
    nextPin x
        | x >= 11 = x - 4
        | x >= 7 = x - 3
        | x >= 4 = x - 2
        | x >= 2 = x - 1
        | otherwise = x

moveUpLeft :: Int -> State -> State
moveUpLeft pin state
    | pin `elem` [6,15,14,13,9,10] && pin `elem` state && (nextPin pin) `elem` state && (nextPin (nextPin pin)) `notElem` state = (nextPin (nextPin pin)) : filter (/= pin) (filter (/= nextPin pin) state)
    | otherwise = state
  where
    nextPin x
        | x >= 11 = x - 5
        | x >= 7 = x - 4
        | x >= 4 = x - 3
        | x >= 2 = x - 2
        | otherwise = x