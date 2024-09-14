% Summary of the script:

% 1. Face image data is loaded from the 'allFaces.mat' file. The first 36 people's faces 
%    are selected for training, and the average face is computed.

% 2. Eigenfaces are calculated by performing Singular Value Decomposition (SVD) on 
%    the mean-subtracted training data. The average face and the first 50 eigenfaces 
%    are displayed sequentially as images.

% 3. A test face (the first face of person 37, not part of the training data) is selected, 
%    and the face is reconstructed using varying numbers of eigenfaces (from 25 to 2275 eigenfaces). 
%    The reconstructed faces are displayed, showing how the reconstruction improves as more eigenfaces are used.

% 4. The faces of person 2 and person 7 are projected onto the 5th and 6th principal components (PCA modes). 
%    These projections are plotted on a 2D graph to visualize the separation between the two individuals.

clear all, close all, clc
% Clears all variables, closes all figure windows, and clears the command window.

load ../DATA/allFaces.mat
% Loads the face data from the 'allFaces.mat' file. This file contains variables 
% such as 'faces' (matrix of face images) and 'nfaces' (number of faces per person).

% We use the first 36 people for training data
trainingFaces = faces(:, 1:sum(nfaces(1:36)));
% Extracts the face images of the first 36 people for training purposes. 
% 'sum(nfaces(1:36))' gives the total number of face images for the first 36 people.

avgFace = mean(trainingFaces, 2);  % size n*m by 1;
% Computes the average face by taking the mean of all training face images along the second dimension.
% The result is a column vector of size (n*m) by 1, where 'n' and 'm' are the height and width of each face image.

% Compute eigenfaces on mean-subtracted training data
X = trainingFaces - avgFace * ones(1, size(trainingFaces, 2));
% Subtract the average face from each training face to create a mean-subtracted dataset 'X'.
% This is necessary for computing eigenfaces.

[U, S, V] = svd(X, 'econ');
% Perform Singular Value Decomposition (SVD) on the mean-subtracted data 'X'.
% 'U' contains the eigenfaces (principal components), 'S' contains singular values, and 'V' contains right singular vectors.

figure, axes('position', [0 0 1 1]), axis off
% Creates a full-size figure window and turns off the axes.

imagesc(reshape(avgFace, n, m)), colormap gray
% Displays the average face as an image. 'reshape' converts the column vector back into an (n by m) matrix,
% which represents a face image.

for i = 1:50  % Plot the first 50 eigenfaces
    pause(0.1);  % Wait for 0.1 seconds between each plot
    imagesc(reshape(U(:, i), n, m)); colormap gray;
    % Reshapes and displays the ith eigenface from 'U' as an image. 
    % 'U(:, i)' represents the ith eigenvector (eigenface).
end

%% Now show eigenface reconstruction of an image that was omitted from the test set

testFace = faces(:, 1 + sum(nfaces(1:36))); % First face of person 37
% Selects the first face of the 37th person as a test image (not part of the training set).

axes('position', [0 0 1 1]), axis off
imagesc(reshape(testFace, n, m)), colormap gray
% Displays the test face image for the 37th person.

testFaceMS = testFace - avgFace;
% Subtracts the average face from the test face, so it is ready for reconstruction.

for r = 25:25:2275
    reconFace = avgFace + (U(:, 1:r) * (U(:, 1:r)' * testFaceMS));
    % Reconstructs the test face using the first 'r' eigenfaces.
    % The term 'U(:, 1:r)' selects the first 'r' eigenfaces, and '(U(:, 1:r)' * testFaceMS)' projects the 
    % mean-subtracted test face onto these eigenfaces to get the weights for reconstruction.

    imagesc(reshape(reconFace, n, m)), colormap gray
    % Reshapes and displays the reconstructed face.

    title(['r=', num2str(r, '%d')]);
    % Adds a title indicating how many eigenfaces ('r') were used for reconstruction.

    pause(0.1)  % Waits for 0.1 seconds between each reconstruction.
end

%% Project person 2 and 7 onto PC5 and PC6

P1num = 2;  % Person number 2
P2num = 7;  % Person number 7

% Extract the face images for persons 2 and 7:
P1 = faces(:, 1 + sum(nfaces(1:P1num-1)):sum(nfaces(1:P1num)));
P2 = faces(:, 1 + sum(nfaces(1:P2num-1)):sum(nfaces(1:P2num)));

% Subtract the average face from both person 2 and person 7:
P1 = P1 - avgFace * ones(1, size(P1, 2));
P2 = P2 - avgFace * ones(1, size(P2, 2));

figure 
subplot(1, 2, 1), imagesc(reshape(P1(:, 1), n, m)); colormap gray, axis off
% Displays the first face of person 2.

subplot(1, 2, 2), imagesc(reshape(P2(:, 1), n, m)); colormap gray, axis off
% Displays the first face of person 7.

% Project onto PCA modes 5 and 6:
PCAmodes = [5 6];
PCACoordsP1 = U(:, PCAmodes)' * P1;
% Projects the faces of person 2 onto principal components 5 and 6.

PCACoordsP2 = U(:, PCAmodes)' * P2;
% Projects the faces of person 7 onto principal components 5 and 6.

figure
plot(PCACoordsP1(1, :), PCACoordsP1(2, :), 'kd', 'MarkerFaceColor', 'k')
% Plots the PCA coordinates for person 2 in black diamonds.

axis([-4000 4000 -4000 4000]), hold on, grid on
% Sets the axis limits and turns on the grid.

plot(PCACoordsP2(1, :), PCACoordsP2(2, :), 'r^', 'MarkerFaceColor', 'r')
% Plots the PCA coordinates for person 7 in red triangles.

set(gca, 'XTick', [0], 'YTick', [0]);
% Sets the X and Y axis tick marks to only show 0.
