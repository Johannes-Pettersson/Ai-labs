data Tree a = Leaf Int | Node (Tree a) (Tree a) deriving (Show)

-- Functions to create a complete binary tree with a full last level where only the leaves contain values. Length of list must be a power of 2.
generateTree :: [Int] -> Tree Int
generateTree xs = buildTree 0 (length xs - 1) xs  

buildTree :: Int -> Int -> [Int] -> Tree Int
buildTree p q xs
  | p==q = Leaf (xs!!p)
  | otherwise = Node (buildTree p ((p+q) `div` 2 ) xs) (buildTree ((p+q) `div` 2 +1 ) q xs)







