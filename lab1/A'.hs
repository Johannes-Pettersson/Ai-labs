import Data.List
import Data.Maybe
import Data.Ord

-- Generic part
type StateTriple = (State,State,Value)
type Value = (Int, Int)
--           (f,   g  )

run :: [State]
run = aStar [(startState, startParent, (calculateHval startState, 0))] []

aStar :: [StateTriple]->[StateTriple]->[State]
aStar [] _ = error "No solution"
aStar (s:restOfOpen) closed 
    |   isGoal (fstStateTriple s) = reverse(retrieveSolution (fstStateTriple s) (s:closed))
    |   otherwise = aStar newOpen (s:closed)
            where newOpen = sortByFvals (restOfOpen ++ [(newState, fstStateTriple s, ((getGval s) + 1 + calculateHval newState, (getGval s) + 1)) | newState <- newStates])
                  newStates = filter (`notElem` map fstStateTriple (restOfOpen ++ closed)) (makeMoves (fstStateTriple s))
             

retrieveSolution :: State -> [StateTriple] -> [State]
retrieveSolution s closed = 
    let parent = findParent s closed 
    in if parent == startParent then [s] else s: retrieveSolution parent closed
            where findParent y xs = sndStateTriple . head $ filter ((== y) . fstStateTriple) xs

sndStateTriple :: StateTriple -> State
sndStateTriple (_, state, _) = state

fstStateTriple :: StateTriple -> State
fstStateTriple (state, _, _) = state

getGval :: StateTriple -> Int
getGval (_, _, (_, g)) = g

sortByFvals :: [StateTriple] -> [StateTriple]
sortByFvals = sortBy (comparing (\(_, _, (f, _)) -> f))


-- Problem specific

calculateHval :: State -> Int
calculateHval state = sum (map (manhattanDistance state) (state!!0)) + sum (map (manhattanDistance state) (state!!1)) + sum (map (manhattanDistance state) (state!!2))

manhattanDistance :: State -> Int -> Int
manhattanDistance state num
    | num == 1 = if elem num (state!!0) then fromJust $ elemIndex num (state!!0) else if elem num (state!!1) then (fromJust $ elemIndex num (state!!1)) + 1 else (fromJust $ elemIndex num (state!!2)) + 2
    | num == 2 = if elem num (state!!0) then if (state!!0)!!1 == num then 0 else 1 else if elem num (state!!1) then if (state!!1)!!1 == num then 1 else 2 else if (state!!2)!!1 == num then 2 else 3
    | num == 3 = if elem num (state!!0) then (2 - (fromJust $ elemIndex num (state!!0))) else if elem num (state!!1) then (2 - (fromJust $ elemIndex num (state!!1))) + 1 else (2 - (fromJust $ elemIndex num (state!!2))) + 2
    | num == 4 = if elem num (state!!1) then fromJust $ elemIndex num (state!!1) else if elem num (state!!0) then (fromJust $ elemIndex num (state!!0)) + 1 else (fromJust $ elemIndex num (state!!2)) + 1
    | num == 5 = if elem num (state!!1) then if (state!!1)!!1 == num then 0 else 1 else if elem num (state!!0) then if (state!!0)!!1 == num then 1 else 2 else if (state!!2)!!1 == num then 1 else 2
    | num == 6 = if elem num (state!!1) then (2 - (fromJust $ elemIndex num (state!!1))) else if elem num (state!!0) then (2 - (fromJust $ elemIndex num (state!!0))) + 1 else (2 - (fromJust $ elemIndex num (state!!2))) + 1
    | num == 7 = if elem num (state!!2) then fromJust $ elemIndex num (state!!2) else if elem num (state!!1) then (fromJust $ elemIndex num (state!!1)) + 1 else (fromJust $ elemIndex num (state!!0)) + 2
    | num == 8 = if elem num (state!!2) then if (state!!2)!!1 == num then 0 else 1 else if elem num (state!!1) then if (state!!1)!!1 == num then 1 else 2 else if (state!!0)!!1 == num then 2 else 3
    | otherwise = 0


type State = [[Int]]

startState :: State
startState = [[0,6,3],[2,1,5],[7,4,8]]

startParent :: State
startParent = []

isGoal :: State -> Bool
isGoal state = state == [[1,2,3],[4,5,6],[7,8,0]]

makeMoves :: State -> [State]
makeMoves state = filter (/= state) (map ($ state) operators)

operators :: [State->State]
operators = [moveUp, moveRight, moveDown, moveLeft]

moveUp :: State -> State
moveUp state
    | elem 0 (state!!1) = toList (unzip (reverse' (zip (state!!0) (state!!1)) (fromJust $ elemIndex 0 (state!!1)))) ++ drop 2 state
    | elem 0 (state!!2) = take 1 state ++ toList (unzip (reverse' (zip (state!!1) (state!!2)) (fromJust $ elemIndex 0 (state!!2))))
    | otherwise = state


moveDown :: State -> State
moveDown state
    | elem 0 (state!!0) = toList (unzip (reverse' (zip (state!!0) (state!!1)) (fromJust $ elemIndex 0 (state!!0)))) ++ drop 2 state
    | elem 0 (state!!1) = take 1 state ++ toList (unzip (reverse' (zip (state!!1) (state!!2)) (fromJust $ elemIndex 0 (state!!1))))
    | otherwise = state

moveRight :: State -> State
moveRight state
    | elem 0 (state!!0) = if (fromJust $ elemIndex 0 (state!!0)) == 2 then state else [swap' (fromJust $ elemIndex 0 (state!!0)) (state!!0)] ++ drop 1 state
    | elem 0 (state!!1) = if (fromJust $ elemIndex 0 (state!!1)) == 2 then state else take 1 state ++ [swap' (fromJust $ elemIndex 0 (state!!1)) (state!!1)] ++ drop 2 state
    | elem 0 (state!!2) = if (fromJust $ elemIndex 0 (state!!2)) == 2 then state else take 2 state ++ [swap' (fromJust $ elemIndex 0 (state!!2)) (state!!2)]
    | otherwise = state

moveLeft :: State -> State
moveLeft state
    | elem 0 (state!!0) = if (fromJust $ elemIndex 0 (state!!0)) == 0 then state else [swap' ((fromJust $ elemIndex 0 (state!!0))-1) (state!!0)] ++ drop 1 state
    | elem 0 (state!!1) = if (fromJust $ elemIndex 0 (state!!1)) == 0 then state else take 1 state ++ [swap' ((fromJust $ elemIndex 0 (state!!1))-1) (state!!1)] ++ drop 2 state
    | elem 0 (state!!2) = if (fromJust $ elemIndex 0 (state!!2)) == 0 then state else take 2 state ++ [swap' ((fromJust $ elemIndex 0 (state!!2))-1) (state!!2)]
    | otherwise = state


swap' :: Int -> [a] -> [a]
swap' indexOfLeft list = take indexOfLeft list ++ [(list!!(indexOfLeft+1)), (list!!indexOfLeft)] ++ drop (indexOfLeft+2) list

reverse' :: [(a,a)] -> Int -> [(a,a)]
reverse' list num
    | num == 0 = reverseFirst list
    | num == 1 = reverseSecond list
    | num == 2 = reverseThird list
    | otherwise = list

reverseFirst :: [(a,a)] -> [(a,a)]
reverseFirst [(a,b),c,d] = [(b,a),c,d]

reverseSecond :: [(a,a)] -> [(a,a)]
reverseSecond [a,(b,c),d] = [a,(c,b),d]

reverseThird :: [(a,a)] -> [(a,a)]
reverseThird [a,b,(c,d)] = [a,b,(d,c)]

toList :: ([Int], [Int]) -> [[Int]]
toList (val1, val2) = [val1, val2]