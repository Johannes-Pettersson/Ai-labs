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

forwardChaining:: WM -> WM -> RuleSet -> WM
forwardChaining  newWM oldWM rules = if newWM == oldWM then oldWM else forwardChaining (onePass newWM rules) newWM rules

--onePass:: WM -> RuleSet -> WM
--TBD

--backwardChaining :: RuleSet -> Fact -> WM -> Bool
--TBD