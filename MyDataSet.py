import torch
import h5py
import numpy as np
from torch.utils.data import Dataset

class MyDataSet(Dataset):
    def __init__(self, filepath):
        self.filepath = filepath
        self.allData = h5py.File(filepath,'r')
        print(self.allData['x_train'].shape)
        print(self.allData['y_train'].shape)
        #self.data = torch.Tensor(allData['x_train'])
        #print(self.data.shape)
        #self.labels = torch.Tensor(allData['x_train'])
        #print(self.labels.shape)


    def __getitem__(self, item):
        x = np.transpose(self.allData['x_train'])[item]
        print('x.type',type(x))
        print("x.shape",x.shape)
        y = np.transpose(self.allData['y_train'])[item]
        print("y.shape",y.shape)
        print('y.type', type(y))
        return x, y

    def __len__(self):
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