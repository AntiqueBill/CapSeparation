clear all
data = load('../data/test/train_receiver.mat');
x_train = data.x_train;
y_train = data.y_train;
x_valid = data.x_valid;
y_valid = data.y_valid;

x_train = channel(x_train, 2);
y_train = channel(y_train, 3);
x_valid = channel(x_valid, 2);
y_valid = channel(y_valid, 3);

save('../data/test/train_channel','x_train','y_train','x_valid', 'y_valid')