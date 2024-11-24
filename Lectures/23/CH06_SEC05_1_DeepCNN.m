clear all; close all; clc

% Load the training dataset (assumed to be images and labels)
load lettersTrainSet

% Randomly select 20 images from the training set for visualization
perm = randperm(1500,20);
for j = 1:20
    subplot(4,5,j); % Arrange plots in a 4x5 grid
    imshow(XTrain(:,:,:,perm(j))); % Display each selected image
end

%% Define the Convolutional Neural Network architecture

layers = [
    imageInputLayer([28 28 1]);          % Input layer for 28x28 grayscale images
    convolution2dLayer(5,16);            % Convolutional layer with 16 filters of size 5x5
    reluLayer();                         % ReLU activation function
    maxPooling2dLayer(2,'Stride',2);     % Max pooling layer with pool size 2x2 and stride of 2
    fullyConnectedLayer(3);              % Fully connected layer with 3 output classes
    softmaxLayer();                      % Softmax layer for classification
    classificationLayer()                % Classification output layer
];

% Set training options using stochastic gradient descent with momentum
options = trainingOptions('sgdm');

% Set random number generator for reproducibility
rng('default')

% Train the network using the training data and specified options
net = trainNetwork(XTrain,TTrain,layers,options);

% Load the test dataset (images and labels)
load lettersTestSet;

% Classify the test images using the trained network
YTest = classify(net,XTest);

% Calculate and display the classification accuracy on the test set
accuracy = sum(YTest == TTest)/numel(TTest)
