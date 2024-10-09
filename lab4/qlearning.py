import numpy as np
from random import random, randint

np.seterr(all='raise')

### This file contains suggested skeleton code if you do not know how to start ###
##  You do not have to follow this skeleton code, you can use your own structure ##


class QTable:
    def __init__(self, _gamma, _alpha, _epsilon, _action_size, _state_size):

        self.alpha = _alpha
        self.gamma = _gamma
        self.epsilon = _epsilon
        self.action_size = _action_size
        self.initial_array_size = _state_size


        # s, a, r , the previous state, action, and reward, initially null
        self.previous_Q_index = np.nan
        self.previous_action = np.nan
        self.previous_reward = np.nan

        # Initiate Q-tables here
        self.q_table = []
        for i in range(self.initial_array_size):
            self.q_table.append([0] * self.action_size)

    def set_previous(self, Q_index, action, reward):
        self.previous_Q_index = Q_index
        self.previous_action = action
        self.previous_reward = reward

    def get_Q_index(self, coded_state):
        return coded_state # Return the index of a row in the Qtable

    def get_Q_actions(self, Q_index) -> list:
        return self.q_table[Q_index] # Return action for a row in the Qtable

    def get_Q(self, Q_index, action):
        # get Q value for a state action pair
        return self.q_table[Q_index][action]

    def set_Q(self, Q_index, action, new_Q):
        # Set calculated Q value for a state action pair
        self.q_table[Q_index][action] = new_Q

    def get_max_Q(self, Q_index):
        return max(self.q_table[Q_index]) # Maxumum Q value in a row

    def epsilon_greedy(self, Q_index):
        rand_num = random()
        if rand_num > self.epsilon:
            return self.get_best_action(Q_index)
        else:
            return randint(0,3)
         # Either best action or random action
        

    def get_best_action(self, current_state):
        return self.get_Q_actions(current_state).index(self.get_max_Q(current_state)) # Best action

    def update_Q(self, current_state, current_reward):
        # Algorithm used from "Artificial Intelligence A Modern Approach" by Stuart Russell and Peter Norvig
        # Q-Learning-Agent, page 844, figure 21.8

        current_Q = self.get_Q(self.previous_Q_index, self.previous_action)
        bellman_error = self.previous_reward 
        bellman_error += self.gamma * self.get_max_Q(self.get_Q_index(current_state))
        bellman_error -= current_Q
        new_Q = current_Q + self.alpha * (bellman_error)

        self.set_Q(self.previous_Q_index, self.previous_action, new_Q)

        action = self.epsilon_greedy(self.get_Q_index(current_state))

        self.previous_Q_index = self.get_Q_index(current_state)
        self.previous_action = action
        self.previous_reward = current_reward
        return action # Action to take for next step AFTER epsilon greedy has been used

