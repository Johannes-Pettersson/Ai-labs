from perceptron import Perceptron
import csv
import numpy as np

# Function to load data from CSV file
def load_data(filepath):
    X = []
    Z = []
    y = []
    with open(filepath, 'r') as file:
        reader = csv.reader(file)
        next(reader)
        for row in reader:
            X.append([float(row[1]), float(row[2])])
            Z.append([1 if row[3] == 1 else -1, 1 if row[4] == 1 else -1])
            y.append(1 if row[5] == 1 else -1)
    return np.array(X), np.array(Z), np.array(y)

train_X, train_Z, train_y = load_data('lab3/Data_uppgift2/XOR_train.csv')
test_X, test_Z, test_y = load_data('lab3/Data_uppgift2/XOR_test.csv')

print("Training: perceptron_z1")
perceptron_z1 = Perceptron(train_X, train_Z[0])

print("Training: perceptron_z2")
perceptron_z2 = Perceptron(train_X, train_Z[1])

print("Training: perceptron_y")
perceptron_y = Perceptron(train_Z, train_y)

# Test
correct_predictions = 0
for i in range(len(test_X)):
    prediction = perceptron_y.predict([perceptron_z1.predict(test_X[i]), perceptron_z2.predict(test_X[i])])
    
    predicted_class = 1 if prediction > 0 else 0
    actual_class = 1 if test_y[i] == 1 else 0
    if predicted_class == actual_class:
        correct_predictions += 1

accuracy = correct_predictions / len(test_X)
print(f"Test Accuracy: {accuracy * 100:.2f}%")