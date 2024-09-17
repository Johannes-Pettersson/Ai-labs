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
    tree = Tree(Leaf(leaf_values.pop(0)), Leaf(leaf_values.pop(0)))

    if len(leaf_values) > 0:
        tree = Tree(tree, create_tree(leaf_values))

    return tree