% Summary:
% This script performs the following tasks:
% 
% 1. Generates synthetic data matrices using trigonometric and exponential functions.
% 2. Adds Gaussian noise to the generated matrix.
% 3. Applies Singular Value Decomposition (SVD) to the noisy data.
% 4. Reconstructs a cleaned matrix by retaining only the significant singular values.
% 5. Reconstructs another matrix that captures 90% of the energy in the singular values.
% 6. Visualizes the original, noisy, cleaned, and energy-captured matrices as images.


% Plots singular values and their cumulative energy for analysis.% Clear all variables, close all figures, and clear the command window
clear all, close all, clc

% Create a time vector from -3 to 3 with a step size of 0.01
t = (-3:.01:3)';

% Define a true U matrix with the first column being a modulated cosine wave
% and the second column being a sine wave
Utrue = [cos(17*t).*exp(-t.^2) sin(11*t)];

% Define a diagonal matrix S with values 2 and 0.5 on the diagonal
Strue = [2 0; 0 .5];

% Define a true V matrix with the first column being a modulated sine wave
% and the second column being a cosine wave
Vtrue = [sin(5*t).*exp(-t.^2) cos(13*t)];

% Compute the matrix X as Utrue * Strue * Vtrue'
X = Utrue*Strue*Vtrue';

% Display the matrix X as an image
figure, imshow(X);

%%
% Add Gaussian noise to the matrix X with standard deviation sigma = 1
sigma = 1;
Xnoisy = X + sigma * randn(size(X));

% Display the noisy matrix as an image
figure, imshow(Xnoisy);

%%
% Perform Singular Value Decomposition (SVD) on the noisy matrix Xnoisy
[U, S, V] = svd(Xnoisy);

% Get the number of rows in the noisy matrix
N = size(Xnoisy, 1);

% Define a cutoff threshold for singular values based on the noise level
cutoff = (4 / sqrt(3)) * sqrt(N) * sigma;

% Find the rank r by selecting singular values greater than the cutoff
r = max(find(diag(S) > cutoff));

% Reconstruct the matrix X using only the top r singular values and vectors
Xclean = U(:, 1:r) * S(1:r, 1:r) * V(:, 1:r)';

% Display the cleaned (denoised) matrix as an image
figure, imshow(Xclean);

%%
% Compute the cumulative sum of the singular values normalized by their total sum
cdS = cumsum(diag(S)) ./ sum(diag(S));

% Find the rank r90 that captures 90% of the total energy
r90 = min(find(cdS > 0.90));

% Reconstruct the matrix X using the top r90 singular values and vectors
X90 = U(:, 1:r90) * S(1:r90, 1:r90) * V(:, 1:r90)';

% Display the 90% energy-reconstructed matrix as an image
figure, imshow(X90);

%% Plot singular values
figure
% Plot the singular values on a logarithmic scale (semilog) with circles
semilogy(diag(S), '-ok', 'LineWidth', 1.5)
hold on, grid on
% Highlight the top r singular values in red
semilogy(diag(S(1:r, 1:r)), 'or', 'LineWidth', 1.5)
% Plot the cutoff threshold as a red dashed line
plot([-20 N+20], [cutoff cutoff], 'r--', 'LineWidth', 2)
% Set axis limits and add a rectangle around certain values
axis([-10 610 .003 300])
rectangle('Position', [-5, 20, 100, 200], 'LineWidth', 2, 'LineStyle', '--')

% Plot the singular values again, with similar details but different axis limits
figure
semilogy(diag(S), '-ok', 'LineWidth', 1.5)
hold on, grid on
semilogy(diag(S(1:r, 1:r)), 'or', 'LineWidth', 1.5)
plot([-20 N+20], [cutoff cutoff], 'r--', 'LineWidth', 2)
axis([-5 100 20 200])

% Plot the cumulative energy as a function of singular values
figure
plot(cdS, '-ok', 'LineWidth', 1.5)
hold on, grid on
% Highlight the values capturing 90% and all energy up to r and r90
plot(cdS(1:r90), 'ob', 'LineWidth', 1.5)
plot(cdS(1:r), 'or', 'LineWidth', 1.5)
% Customize axis ticks and limits
set(gca, 'XTick', [0 300 r90 600], 'YTick', [0 .5 0.9 1.0])
xlim([-10 610])
% Add a dashed line indicating the rank r90 capturing 90% energy
plot([r90 r90 -10], [0 0.9 0.9], 'b--', 'LineWidth', 1.5)
