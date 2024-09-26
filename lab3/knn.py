import numpy as np
import csv
import matplotlib.pyplot as plt
from statistics import mode


def distance(img1, img2):
    assert len(img1) == len(img2), "images not the same length"

    total_distance = 0

    for i in range(len(img1)):
        total_distance += np.abs(int(img1[i]) - int(img2[i]))

    return total_distance

def merge(list1, list2):
 
    merged_list = [(list1[i], list2[i]) for i in range(0, len(list1))]
     
    return merged_list

def knn(training_data, training_class_labels, sample, k):
    
    distances = []

    for i in range(len(training_data)):
        distances.append(distance(training_data[i], sample))

    merged_list = merge(distances, training_class_labels)

    sorted_merged_list = sorted(merged_list, key=lambda x: x[0])

    votes = []
    for i in range(k):
        votes.append(sorted_merged_list[i][1])

    
    return mode(votes)


with open('lab3/Data_uppgift1/mnist_train.csv', 'r') as csv_training_file:
    traing_data = csv.reader(csv_training_file)
    training_images = []
    training_labels = []

    for row in traing_data:
        training_images.append(row[:-1])
        training_labels.append(row[-1])

    #Remove first line of data:
    training_images = training_images[1:]
    training_labels = training_labels[1:]

    
    with open('lab3/Data_uppgift1/mnist_test.csv', 'r') as csv_test_file:
        test_data = csv.reader(csv_test_file)
        test_images = []    
        test_labels = []

        for row in test_data:
            test_images.append(row[:-1])
            test_labels.append(row[-1])

        #Remove first line of data:
        test_images = test_images[1:]
        test_labels = test_labels[1:]


        k_val = 10
        correct_predictions = 0
        incorrect_predictions = 0

        for i in range(20):
            prediction = knn(training_images, training_labels, test_images[i], k_val)
            
            if prediction == test_labels[i]:
                #correct prediction
                correct_predictions += 1
            else:
                #incorrect prediction
                incorrect_predictions += 1

        print(f"KNN finished: \nCorrect predictions: {correct_predictions}\nIncorrect predictions: {incorrect_predictions}\nAccuracy: {(correct_predictions/(correct_predictions+incorrect_predictions))*100}%")

        






