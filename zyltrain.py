# -*- coding: utf-8 -*-
# @Time    : 2019/3/18 9:01
# @Author  : zyl
# @File    : train.py
# @Contact : hit_zyl@126.com

import torch as t
from torch.utils.data import TensorDataset
from torch.utils.data import DataLoader
import h5py
import numpy as np

#from decoding_nets.customized_net import CustomizedNet


def load_data(options):
    print('loading train data set')
    train_snr_range = np.arange(
        options.train_snr_start,
        options.train_snr_end+options.train_snr_space,
        options.train_snr_space)
    x_train, y_train, x_valid, y_valid = [], [], [], []
    train_data_dir = './data/train/'
    for snr in train_snr_range:
        file_name = str(options.n) + 'SNR' + str(snr) + '.mat'
        with h5py.File(train_data_dir + file_name, 'r') as f:
            x_train.extend(np.transpose(f['receive']).astype('float32'))
            y_train.extend(np.transpose(f['label']).astype('float32'))
        # file_name = str(options.n) + 'SNR' + str(snr) + 'valid.mat'
        # with h5py.File(train_data_dir + file_name, 'r') as f:
        #     x_valid.extend(np.transpose(f['receive']).astype('float32'))
        #     y_valid.extend(np.transpose(f['label']).astype('float32'))
    print('train data snr range from ', options.train_snr_start, 'to',
          options.train_snr_end)
    return x_train, y_train, x_valid, y_valid


def get_data(train_ds, valid_ds, bs):
    return (
        DataLoader(train_ds, batch_size=bs, shuffle=True),
        DataLoader(valid_ds, batch_size=bs),
    )


# def get_model(options):
#     model = CustomizedNet(options.train_net_iter)
#     return model, t.optim.SGD(model.parameters(), lr=options.learning_rate, momentum=options.momentum)


def loss_batch(model, loss_f, xb, yb, opt=None):
    loss = loss_f(model(xb), yb)
    if opt is not None:
        opt.zero_grad()
        loss.backward()
        opt.step()
    return loss.item(), len(xb)


def preprocess(x, y):
    return x.to('cuda'), y.to('cuda')


class WrappedDataLoader:
    def __init__(self, dl, func):
        self.dl = dl
        self.func = func

    def __len__(self):
        return len(self.dl)

    def __iter__(self):
        batches = iter(self.dl)
        for b in batches:
            yield (self.func(*b))


def ber(y_pred, y_target):
    return t.mean(t.abs(y_pred - y_target))


def train_net(options):
    x_train, y_train, x_valid, y_valid = map(t.tensor, (load_data(options)))
    train_ds = TensorDataset(x_train, y_train)
    valid_ds = TensorDataset(x_valid, y_valid)
    train_dl, valid_dl = get_data(train_ds, valid_ds, options.batch_size)
    train_dl = WrappedDataLoader(train_dl, preprocess)
    valid_dl = WrappedDataLoader(valid_dl, preprocess)

    criterion = t.nn.BCELoss()
    # start training
    bp_decoder, opt = get_model(options)
    print('loading model', t.cuda.max_memory_allocated(device=None)/1000/1000, 'MB')

    print("Start training\n" + "->"*40)
    for epoch in range(options.epochs):
        for xb, yb in train_dl:
            pred = bp_decoder(xb)
            loss = criterion(pred, yb)
            opt.zero_grad()
            loss.backward()
            opt.step()
        print('training', t.cuda.max_memory_allocated(device=None)/1000/1000, 'MB')
        print('epoch = ', epoch, 'loss = ', loss.data)
        # for xb, yb in valid_dl:
        #     pred = bp_decoder(xb)
        #     val_loss = criterion(pred, yb)
        # print('val', t.cuda.max_memory_allocated(device=None) / 1000 / 1000, 'MB')
        # print('epoch = ', epoch, 'val_loss = ', val_loss)
        if epoch % 100 == 0:
            t.save(bp_decoder.state_dict(), options.net_path +
                   'epoch_' + str(epoch) + '_' + options.net_name)
    t.save(bp_decoder.state_dict(), options.net_path + options.net_name)
