
from typing import Union

class Tree():
    def __init__(self, left_child, right_child) -> None:
        self.left_child = left_child
        self.right_child = right_child

    def print(self):
        print("Tree")
        self.left_child.print()
        self.right_child.print()

class Leaf():
    def __init__(self, value) -> None:
        self.value = value

    def get_value(self) -> int:
        return self.value

    def print(self):
        print(f"Leaf: {self.value}")

def create_tree(leaf_values: list) -> Tree:
    if len(leaf_values) == 2:
        return Tree(Leaf(leaf_values.pop(0)), Leaf(leaf_values.pop(0)))

    return Tree(left_child=create_tree(leaf_values[:int(len(leaf_values)/2)]), right_child=create_tree(leaf_values[int(len(leaf_values)/2):]))


class Minimax():
    def __init__(self) -> None:
        self.alpha = None
        self.beta = None

    def run(self, tree: Tree):
        return self.max(tree, 0)
    
    def max(self, tree: Union[Tree, Leaf], level):
        print(f"Running max on level: {level}")
        if type(tree) is Leaf:
            return tree.get_value()
        
        max_val =  max(self.min(tree.left_child, level+1), self.min(tree.right_child, level+1))

        if self.beta is not None and max_val >= self.beta:
            print(f"Klippte på level {level}")
            return max_val
        
        self.alpha = max(max_val, self.alpha if self.alpha is not None else max_val)

        return max_val

    def min(self, tree: Union[Tree, Leaf], level):
        print(f"Running min on level: {level}")
        if type(tree) is Leaf:
            return tree.get_value()
        
        min_val = min(self.max(tree.left_child, level+1), self.max(tree.right_child, level+1))

        if self.alpha is not None and min_val <= self.alpha:
            print(f"Klippte på level {level}")
            return min_val
        
        self.beta = min(min_val, self.beta if self.beta is not None else min_val)

        return min_val



print(Minimax().run(create_tree([0,-2,6,2,-3,-7,8,2])))