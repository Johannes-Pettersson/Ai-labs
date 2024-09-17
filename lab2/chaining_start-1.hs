type Fact = String
type Premise = [Fact]
type Conclusion = [Fact]
type Rule = (Premise,Conclusion)
type RuleSet = [Rule]
type WM = [Fact]

subSet :: Eq a => [a] -> [a]-> Bool
subSet a b = null [x | x<-a , x `notElem` b]

startWM :: WM
startWM = ["a","e"]

rules :: RuleSet
rules = [(["a","b"],["c"]), (["c"],["d"]), (["g"],["h"]),(["a","d"],["f","g"]),(["e"],["d"])]

runForward :: WM
runForward = forwardChaining (onePass startWM rules) startWM rules

forwardChaining :: WM -> WM -> RuleSet -> WM
forwardChaining  newWM oldWM rules = if newWM == oldWM then oldWM else forwardChaining (onePass newWM rules) newWM rules

onePass :: WM -> RuleSet -> WM
onePass wm [] = wm  -- if empty, return wm
onePass wm ((premise, conclusion) :rest) -- split current rule with rest of rules
  | subSet premise wm = onePass (wm ++ [fact | fact <- conclusion, fact `notElem` wm]) rest -- check if premise is subset of current wm
  | otherwise = onePass wm rest -- else continue 


backwardChaining :: RuleSet -> WM -> Fact -> Bool
backwardChaining _ wm goal
    | goal `elem` wm = True -- if object is known, return true
backwardChaining [] _ _ = False -- of no more rules, return false
backwardChaining ((premise, conclusion): rest) wm goal
    | any (goal==) conclusion = all (True==) (map (backwardChaining ((premise, conclusion): rest) wm) premise)
    | otherwise = backwardChaining rest wm goal