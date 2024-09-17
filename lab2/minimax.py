
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


def minimax(tree: Tree) -> int:
    return tree_max(tree)
    

def tree_max(tree: Union[Tree, Leaf]) -> int:
    if type(tree) is Leaf:
        return tree.get_value()
    
    return max(tree_min(tree.left_child), tree_min(tree.right_child))

def tree_min(tree: Union[Tree, Leaf]) -> int:
    if type(tree) is Leaf:
        return tree.get_value()
    
    return min(tree_max(tree.left_child), tree_max(tree.right_child))

print(minimax(create_tree([0,-2,6,2,5,8,9,2])))
