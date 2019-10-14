import torch
import h5py
import numpy as np
from torch.utils.data import Dataset

class MyDataSet(Dataset):
    def __init__(self, filepath):
        self.filepath = filepath
        self.allData = h5py.File(filepath,'r')
<<<<<<< HEAD
        print(self.allData['x_test'].shape)
        print(self.allData['y_test'].shape)
=======
        print(self.allData['x_train'].shape)
        print(self.allData['y_train'].shape)
>>>>>>> dfcf3b88dbdf22ea8ffde39d91b6e9ef58fe19e6
        #self.data = torch.Tensor(allData['x_train'])
        #print(self.data.shape)
        #self.labels = torch.Tensor(allData['x_train'])
        #print(self.labels.shape)


    def __getitem__(self, item):
<<<<<<< HEAD
        x = self.allData['x_test'][item]
        print('x.type',type(x))
        print("x.shape",x.shape)
        y = self.allData['y_test'][item]
=======
        x = np.transpose(self.allData['x_train'])[item]
        print('x.type',type(x))
        print("x.shape",x.shape)
        y = np.transpose(self.allData['y_train'])[item]
>>>>>>> dfcf3b88dbdf22ea8ffde39d91b6e9ef58fe19e6
        print("y.shape",y.shape)
        print('y.type', type(y))
        return x, y

    def __len__(self):
<<<<<<< HEAD
        return len(np.transpose(self.allData['x_test']))

if __name__ == '__main__':
    dataset = MyDataSet('./data/test_1.mat')
    print(len(dataset))
    train_loader = torch.utils.data.DataLoader(dataset,batch_size=128, shuffle=True)
    for batch_idx, data in enumerate(train_loader):
        x_test, y_test = data
        print('batch_idx',batch_idx)
        print(type(data))
        print(type(x_test))
        print(x_test.shape)
        print(y_test.shape)
=======
        return len(np.transpose(self.allData['x_train']))

if __name__ == '__main__':
    dataset = MyDataSet('./train_receiver.mat')
    print(len(dataset))
    train_loader = torch.utils.data.DataLoader(dataset,batch_size=128, shuffle=True)
    for batch_idx, (data, target) in enumerate(train_loader):
        print(batch_idx)
        print(type(data))
        print(data.shape)
        print(target)
>>>>>>> dfcf3b88dbdf22ea8ffde39d91b6e9ef58fe19e6
