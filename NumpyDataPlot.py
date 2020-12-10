import argparse
import numpy as np
import matplotlib.pyplot as plt

"""
    Simply put the untitled file obtained through the "os/plot" export option in
    the FAUST editor in this folder and type "make" in the terminal.
"""

def getData(file):
    f = open(file, "r")
    with open(file) as f:
        content = f.readlines()
    content = [x.strip().split(';')[0] for x in content[3:-8]]
    content = [x for x in content[3:-8] if x != "%---- Chunk Boundary ----"]
    return np.array([[float(x) for x in line.split(' ')] for line in content]).T # Because we know the format of the file

def plotData(Y):
    X = np.arange(Y.shape[1])
    for sig_id in range(Y.shape[0]):
        plt.plot(X,Y[sig_id,:])
    plt.show()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Plotting signal data.")
    parser.add_argument("-f", "--file", help="File Name")
    args = parser.parse_args()
    file = args.file
    Y = getData(file)
    plotData(Y)
