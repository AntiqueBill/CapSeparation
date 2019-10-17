import h5py
import scipy.io as sio
import numpy as np

def load_data(train_data_dir):
    print('loading train data set')
    #x_train, y_train, x_valid, y_valid = [], [], [], []
    #train_data_dir = './data/'
    allData = h5py.File(train_data_dir,'r')
    x_train = np.transpose(allData['x_train']).astype('float64')
    print("x_train.shape", x_train.shape)
    y_train = np.transpose(allData['y_train']).astype('float64')
    print("y_train.shape", y_train.shape)
    x_valid = np.transpose(allData['x_valid']).astype('float64')
    print("x_valid.shape", x_valid.shape)
    y_valid = np.transpose(allData['y_valid']).astype('float64')
    print("y_valid.shape", y_valid.shape)

    return x_train, y_train

if __name__ == '__main__':
    train_data_dir = './data/train_receiver.mat'
    x_train, y_train = load_data(train_data_dir)