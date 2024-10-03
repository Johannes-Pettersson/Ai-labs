from perceptron import Perceptron
import numpy as np
import csv

# Function to load data from CSV file
def load_data(filepath):
    X = []
    y = []
    with open(filepath, 'r') as file:
        reader = csv.reader(file)
        next(reader)
        for row in reader:
            X.append([float(row[0]), float(row[1])])
            y.append(1 if int(row[2]) == 1 else -1)  # Class as 1 and -1
    return np.array(X), np.array(y)

train_X, train_y = load_data('lab3/Data_uppgift1/OR_train.csv')
test_X, test_y = load_data('lab3/Data_uppgift1/OR_test.csv')


perceptron = Perceptron(train_X, train_y)

print(f"Weights: {perceptron.w}")
print(f"Bias: {perceptron.b}")

# Test
correct_predictions = 0
for i in range(len(test_X)):
    prediction = perceptron.predict(test_X[i])
    predicted_class = 1 if prediction > 0 else 0
    actual_class = 1 if test_y[i] == 1 else 0
    if predicted_class == actual_class:
        correct_predictions += 1

accuracy = correct_predictions / len(test_X)
print(f"Test Accuracy: {accuracy * 100:.2f}%")