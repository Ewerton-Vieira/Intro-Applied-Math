clear all; close all; clc

% Load data for cat and dog wave patterns from specified files
load ../DATA/catData_w.mat; 
load ../DATA/dogData_w.mat;

% Concatenate dog and cat wave data for analysis
CD = [dog_wave cat_wave];

% Separate the first 40 samples from each data set as training data
x = [dog_wave(:,1:40) cat_wave(:,1:40)];

% Separate the next 40 samples from each data set as test data
x2 = [dog_wave(:,41:80) cat_wave(:,41:80)];

% Create labels for training data
% Label dogs as 1 and cats as 0 for the first set of samples, then vice versa for the next set
label = [ones(40,1)  zeros(40,1); 
         zeros(40,1) ones(40,1)].';

% Create a neural network for pattern recognition with 2 neurons and use 'trainscg' (scaled conjugate gradient) for training
net = patternnet(2,'trainscg');

% Set the transfer function for the first layer to 'tansig' (hyperbolic tangent sigmoid)
net.layers{1}.transferFcn = 'tansig';

% Train the network using the training data (x) and labels (label)
net = train(net,x,label);

% Display the network architecture
view(net)

% Simulate the network on the training data
y = net(x);

% Simulate the network on the test data
y2 = net(x2);

% Compute the performance of the network on the training data
perf = perform(net,label,y);

% Convert the network's output for training data to class indices
classes2 = vec2ind(y);

% Convert the network's output for test data to class indices
classes3 = vec2ind(y2);

% Plot the network's output for training and test data
subplot(4,1,1), bar(y(1,:),'FaceColor',[.6 .6 .6],'EdgeColor','k') % Output for class 1 on training data
subplot(4,1,2), bar(y(2,:),'FaceColor',[.6 .6 .6],'EdgeColor','k') % Output for class 2 on training data
subplot(4,1,3), bar(y2(1,:),'FaceColor',[.6 .6 .6],'EdgeColor','k') % Output for class 1 on test data
subplot(4,1,4), bar(y2(2,:),'FaceColor',[.6 .6 .6],'EdgeColor','k') % Output for class 2 on test data
