type Fact = String
type Premise = [Fact]
type Conclusion = [Fact]
type Rule = (Premise,Conclusion)
type RuleSet = [Rule]
type WM = [Fact]

subSet :: Eq a => [a] -> [a]-> Bool
subSet a b = null [x | x<-a , x `notElem` b]

--startWM :: WM
--startWM = ["a","e"]

--rules :: RuleSet
--rules = [(["a","b"],["c"]), (["c"],["d"]), (["g"],["h"]),(["a","d"],["f","g"]),(["e"],["d"])]

startWM :: WM
startWM = ["katt_sover", "solen_sken", "brottslingar_gralar", "groda_hoppar"]

rules :: RuleSet
rules = [(["katt_sover", "hund_skaller"], ["granne_vaknar"])         -- om katt sover och hund skäller, granne vaknar
    , (["granne_vaknar"], ["kaffe_bryggs"])                          -- om granne vaknar, då bryggs kaffe
    , (["tvspel_slapps"], ["gamer_spelar_det"])                      -- om tvspel släpps, gamer spelar det
    , (["brottsligar_gralar", "kaffe_bryggs"], ["fred_på_jorden"])   -- om bråttslingar grälar och kaffe bryggs, då blir det fred på jorden
    , (["solen_sken"], ["taco_tillagas"])                            -- om solen skiner, tillagas tacos
    , (["taco_tillagas", "hund_skaller"], ["hund_far_taco"])         -- om tacos tillagas och hund skäller, då får hunden tacos
    , (["groda_hoppar", "taco_tillagas"], ["fiesta_borjar"])         -- om grodor hoppar och tacos tillagas, då börjar fiesta
    , (["fiesta_borjar"], ["brottslingar_dansar"])                   -- om fiesta börjar, då dansar bråttslingarna
    , (["fred_på_jorden", "gamer_spelar_det"], ["universum_balans"]) -- om fred på jorden och gamer spelar det, då är universum i balans
    , (["universum_balans"], ["katt_vaknar"])]                       -- om universum är i balans, då vaknar katten

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