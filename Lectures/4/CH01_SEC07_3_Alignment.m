% Summary of the script:

% 1. A 1000x1000 matrix 'X' is created, with a square block set to 1, while the rest is 0.

% 2. Singular Value Decomposition (SVD) is applied to the matrix 'X', and the matrix is displayed.
%    The singular values of 'X' are plotted on a semilogarithmic plot.

% 3. The matrix 'X' is rotated through 12 different angles (from 0 to 44 degrees in increments of 4).

% 4. For each rotation:
%    a) The matrix 'X' is rotated, cropped to maintain the original size, and normalized.
%    b) The resulting rotated matrix is displayed, with different colors indicating the rotation angle.
%    c) SVD is performed on the rotated matrix, and its singular values are plotted on the same semilogarithmic plot.
%    d) The original matrix 'Xrot' is updated with the new rotated version based on pixel values greater than 0.5.

% 5. The axis limits and ticks are customized to provide clear visualization of singular values, 
%    and the figure is adjusted for better layout.

% Clear all variables, close all figures, and clear the command window
clear all, close all, clc

% Define the size of the matrix (n x n) as 1000
n = 1000;

% Create an n x n matrix 'X' filled with zeros
X = zeros(n, n);

% Set a square block in the center of the matrix 'X' to 1
X(n/4:3*n/4, n/4:3*n/4) = 1;

% Define the number of angles (12 angles from 0 to 44 degrees in increments of 4)
nAngles = 12;

% Create a colormap 'cm' for different rotation angles using the jet colormap
cm = colormap(jet(nAngles));

% Perform Singular Value Decomposition (SVD) on the matrix 'X'
[U, S, V] = svd(X);

% Display the original matrix 'X' and its SVD plot
subplot(1, 2, 1), imagesc(X), hold on; % Display 'X' as an image
subplot(1, 2, 2), semilogy(diag(S), '-o', 'color', cm(1,:)), hold on, grid on % Plot singular values

% Initialize 'Xrot' as the original matrix 'X'
Xrot = X;

% Loop through 12 angles, rotating the matrix 'X' by (j-1)*4 degrees
for j = 2:nAngles
    % Rotate the matrix 'X' by (j-1)*4 degrees using bicubic interpolation
    Y = imrotate(X, (j-1)*4, 'bicubic');  
    
    % Crop the rotated matrix 'Y' to retain the original size (1000x1000)
    startind = floor((size(Y, 1) - n) / 2);
    Xrot1 = Y(startind:startind+n-1, startind:startind+n-1);
    
    % Normalize and adjust the rotated matrix to subtract the first element
    Xrot2 = Xrot1 - Xrot1(1, 1);    
    Xrot2 = Xrot2 / max(Xrot2(:));
    
    % Update the matrix 'Xrot' for visualization with the current rotation index
    Xrot(Xrot2 > .5) = j;
    
    % Perform SVD on the cropped and rotated matrix 'Xrot1'
    [U, S, V] = svd(Xrot1);
    
    % Display the updated rotated matrix and plot its singular values
    subplot(1, 2, 1), imagesc(Xrot), colormap([0 0 0; cm])    
    subplot(1, 2, 2), semilogy(diag(S), '-o', 'color', cm(j,:))       
end

% Adjust axis limits for the semilogarithmic plot and set custom ticks for the x and y axes
axis([1.e-16 1.e3 -10 1000])
set(gca, 'XTick', [0 250 500 750 1000])
set(gca, 'YTick', [1.e-16 1.e-12 1.e-8 1.e-4 1. 1.e4])

% Set the figure position and size
set(gcf, 'Position', [100 100 550 230])
