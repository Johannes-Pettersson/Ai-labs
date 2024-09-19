import csv
import numpy as np
import matplotlib.pyplot as plt

index = 0

class CSVtoIMGDisplay():
    def __init__(self, path_to_csv) -> None:
        with open(path_to_csv, 'r') as csv_file:
            self.all_data = list(csv.reader(csv_file))

    def show_img(self, index):
        data = self.all_data[index+1]

        pixels = data[:-1]

        pixels = np.array(pixels, dtype='uint8')

        pixels = pixels.reshape((28,28))
        
        plt.imshow(pixels,cmap='gray')
        plt.show()


img_displayer = CSVtoIMGDisplay('lab3/Data_uppgift1/mnist_test.csv')

img_displayer.show_img(2)