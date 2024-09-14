% Summary:
% Image Creation and Manipulation:
% A square matrix with a white square in the center is created, displayed, 
% and then rotated by 10 degrees. The rotated image is cropped back to 
% the original size and displayed alongside the original image.
%
% Singular Value Decomposition (SVD):
% SVD is applied to both the original and rotated images. The singular 
% values of both images are plotted on a logarithmic scale for comparison.
%
% Visualization:
% The comparison between the singular values of the original and rotated 
% images provides insight into how rotation affects the rank and structure 
% of the image.


clear all, close all, clc
% Clears all variables from memory, closes all figure windows, and clears the command window.

n = 1000;
% Defines the size of the square matrix (n x n).

q = n/4;
% Defines a variable 'q' which is one-quarter of 'n'. This will be used to position the inner square.

X = zeros(n, n);
% Creates an n x n matrix 'X' filled with zeros (black image).

X(q:(n/2)+q, q:(n/2)+q) = 1;
% Fills a central square region of the matrix 'X' with ones (white image).
% The square starts at row 'q' and ends at row 'n/2 + q', and similarly for the columns.
% This forms a white square in the middle of a black background.

subplot(2,2,1), imshow(X); colormap gray, axis off
% Displays the original matrix 'X' (containing the centered square) in the top-left subplot.
% 'colormap gray' applies a grayscale colormap, and 'axis off' removes the axis labels.

Y = imrotate(X, 10, 'bicubic');
% Rotates the image 'X' by 10 degrees using bicubic interpolation, storing the result in 'Y'.

Y = Y - Y(1, 1);
% Subtracts the value at the top-left corner (Y(1,1)) from every element in the matrix 'Y'.
% This operation removes any artifacts or background values that were introduced by the rotation.

nY = size(Y, 1);
% Finds the size of the new matrix 'Y' after the rotation and stores it in 'nY'.

startind = floor((nY - n) / 2);
% Computes the starting index for cropping the rotated image 'Y' back to its original size.
% 'startind' ensures the cropped region is centered.

Xrot = Y(startind:startind + n - 1, startind:startind + n - 1);
% Crops the rotated image 'Y' to match the size of the original image 'X'.
% The resulting matrix 'Xrot' is the same size as 'X' but rotated by 10 degrees.

subplot(2,2,2), imshow(Xrot); colormap gray, axis off
% Displays the cropped, rotated image 'Xrot' in the top-right subplot.
% 'colormap gray' applies a grayscale colormap, and 'axis off' removes the axis labels.

[U, S, V] = svd(X);
% Performs Singular Value Decomposition (SVD) on the original image 'X'.
% 'U', 'S', and 'V' are the resulting matrices from SVD.
% 'S' contains the singular values, which represent the strengths of the components of the image.


subplot(2,2,3), semilogy(diag(S), '-ko')
% Plots the singular values (diagonal elements of 'S') for the original image 'X' on a logarithmic scale.
% 'semilogy' creates a plot where the Y-axis is logarithmic.
% The singular values are plotted as black circles connected by a line.

[U, S, V] = svd(Xrot);
% Performs SVD on the rotated image 'Xrot'.
% This allows us to compare how the singular values change after rotation.


ylim([1.e-16 1.e4]), grid on
% Sets the Y-axis limits for the plot to range from 1.e-16 to 1.e4 and turns the grid on.

set(gca, 'YTick', [1.e-16 1.e-12 1.e-8 1.e-4 1 1.e4])
% Customizes the Y-axis tick marks to show specific values ranging from 1.e-16 to 1.e4.

set(gca, 'XTick', [0 250 500 750 1000])
% Customizes the X-axis tick marks to display values at 0, 250, 500, 750, and 1000.

subplot(2,2,4), semilogy(diag(S), '-ko')
% Plots the singular values for the rotated image 'Xrot' on a logarithmic scale.
% The plot uses black circles connected by a line (similar to the previous plot).

ylim([1.e-16 1.e4]), grid on
% Sets the Y-axis limits to the same range (1.e-16 to 1.e4) and turns the grid on.

set(gca, 'YTick', [1.e-16 1.e-12 1.e-8 1.e-4 1 1.e4])
% Customizes the Y-axis tick marks for the second plot to match the first plot.

set(gca, 'XTick', [0 250 500 750 1000])
% Customizes the X-axis tick marks to match the first plot.
