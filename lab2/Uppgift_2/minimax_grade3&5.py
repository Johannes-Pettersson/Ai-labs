from typing import Union
import math

class Tree():
    def __init__(self, left_child, right_child, depth=None) -> None:
        self.left_child = left_child
        self.right_child = right_child
        self.depth = depth

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
        return Tree(Leaf(leaf_values.pop(0)), Leaf(leaf_values.pop(0)), 1)

    return Tree(left_child=create_tree(leaf_values[:int(len(leaf_values)/2)]), 
            right_child=create_tree(leaf_values[int(len(leaf_values)/2):]), depth=math.log2(len(leaf_values)))


def minimax(tree: Tree):
    alpha = -math.inf
    beta = math.inf
    return minimax_max(tree, alpha, beta)

def minimax_max(tree: Union[Tree, Leaf], alpha, beta):
    if isinstance(tree, Leaf):
        return (tree.get_value(), 0)

    (max_val, num_cut_left) = minimax_min(tree.left_child, alpha, beta) 

    if max_val >= beta:
        return (max_val, int(num_cut_left+(2**(tree.depth-1))))
    
    alpha = max(alpha, max_val)

    (max_val_new, num_cut_right) = minimax_min(tree.right_child, alpha, beta)
    max_val = max(max_val, max_val_new)

    return (max_val, num_cut_left+num_cut_right)


def minimax_min(tree: Union[Tree, Leaf], alpha, beta):
    if isinstance(tree, Leaf):
        return (tree.get_value(), 0)
    
    (min_val, num_cut_left) = minimax_max(tree.left_child, alpha, beta)

    if min_val <= alpha:
        return (min_val, int(num_cut_left+(2**(tree.depth-1))))
    
    beta = min(min_val, beta)

    (min_val_new, num_cut_right) = minimax_max(tree.right_child, alpha, beta)
    min_val = min(min_val, min_val_new)


    return (min_val, num_cut_left+num_cut_right)



print(minimax(create_tree([0,-2,6,2,-3,-7,8,2])))
print(minimax(create_tree([3,5,2,7])))
print(minimax(create_tree([0,-2,6,2,5,8,9,2])))
print(minimax(create_tree([-20,20,17,0,1,3,5,6,8,10,-2,-6,0,10,12,-7])))
print(minimax(create_tree([1,2,3,4,5,6,7,8])))
print(minimax(create_tree([-2,3,12,5,-1,0,4,7])))
print(minimax(create_tree([3,-7,1,8])))
print(minimax(create_tree([0,2,7,13])))