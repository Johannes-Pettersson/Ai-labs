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


def perceptron(X, y, max_pass=10, eta=1.0):
    # Initialize weights and bias to zero
    w = np.zeros(X.shape[1])
    b = 0
    mistakes = []
    print("\n")

    # Loop through data for max_pass times
    for t in range(max_pass):
        error_count = 0

        for i in range(len(y)):
            # Make prediction (linear combination of weights and inputs)
            prediction = np.dot(w, X[i]) + b

            if y[i] * prediction <= 0:
                # Update weights and bias if prediction was wrong
                w = w + eta * y[i] * X[i]
                b = b + eta * y[i]
                error_count += 1
        mistakes.append(error_count)
        print(f"Epoch {t+1}: {error_count} mistakes")

    return w, b, mistakes

train_X, train_y = load_data('lab3/Data_uppgift1/OR_train.csv')
test_X, test_y = load_data('lab3/Data_uppgift1/OR_test.csv')


w, b, mistakes = perceptron(train_X, train_y, max_pass=10)

print(f"Weights: {w}")
print(f"Bias: {b}")

# Test
correct_predictions = 0
for i in range(len(test_X)):
    prediction = np.dot(w, test_X[i]) + b
    predicted_class = 1 if prediction > 0 else 0
    actual_class = 1 if test_y[i] == 1 else 0
    if predicted_class == actual_class:
        correct_predictions += 1

accuracy = correct_predictions / len(test_X)
print(f"Test Accuracy: {accuracy * 100:.2f}%")
