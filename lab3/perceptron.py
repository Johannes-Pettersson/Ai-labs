import numpy as np


class Perceptron():
    def __init__(self, X, y, eta=1.0, max_pass=10) -> None:
        # Initialize weights and bias to zero
        self.w = np.zeros(X.shape[1])
        self.b = 0
        self.mistakes = []
        print("\n")

        # Loop through data for max_pass times
        for t in range(max_pass):
            error_count = 0
        
            for i in range(len(y)):
                # Make prediction (linear combination of weights and inputs)
                prediction = np.dot(X[i], self.w) + self.b

                if y[i] * prediction <= 0:
                    # Update weights and bias if prediction was wrong
                    self.w = self.w + eta * y[i] * X[i]
                    self.b = self.b + eta * y[i]
                    error_count += 1

            self.mistakes.append(error_count)
            print(f"Epoch {t+1}: {error_count} mistakes")

    def predict(self, x_i):
        return np.dot(self.w, x_i) + self.b

