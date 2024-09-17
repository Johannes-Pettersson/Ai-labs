from typing import Union

class Tree():
    def __init__(self, left_child, right_child) -> None:
        self.left_child = left_child
        self.right_child = right_child

class Leaf():
    def __init__(self, value) -> None:
        self.value = value

    def get_value(self) -> int:
        return self.value
    

def create_tree(leaf_values) -> Tree:
    tree = 