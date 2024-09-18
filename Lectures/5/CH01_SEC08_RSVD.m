clear all, close all, clc       % Clears all variables, closes figures, and clears the command window.
A = imread('jupiter.jpeg');      % Reads the image file 'jupiter.jpg' into the matrix A.
X = double(rgb2gray(A));        % Converts the image to grayscale and casts it to double precision.

[U,S,V] = svd(X,'econ');        % Performs deterministic SVD (Singular Value Decomposition) on the grayscale image X.

r = 400;                        % Target rank for approximation, which specifies the number of singular values to retain.
q = 1;                          % Number of power iterations to improve the approximation in randomized SVD.
p = 5;                          % Oversampling parameter used in randomized SVD to capture additional details.
[rU,rS,rV] = rsvd(X,r,q,p);     % Performs randomized SVD (rSVD) on X using rank r, q power iterations, and oversampling p.

%% Reconstruction

% Reconstruction using standard SVD
XSVD = U(:,1:r)*S(1:r,1:r)*V(:,1:r)';   % Reconstruct the image using the first r singular values/vectors from deterministic SVD.
errSVD = norm(X - XSVD, 2) / norm(X, 2); % Calculate the relative error between the original image and the SVD-reconstructed image.

% Reconstruction using randomized SVD (rSVD)
XrSVD = rU(:,1:r)*rS(1:r,1:r)*rV(:,1:r)'; % Reconstruct the image using the first r singular values/vectors from randomized SVD.
errrSVD = norm(X - XrSVD, 2) / norm(X, 2); % Calculate the relative error between the original image and the rSVD-reconstructed image.

%% Plot

% Create a new figure and plot the original and reconstructed images.
ax1 = axes('Position',[.005 .005 .33 .99]);  % Create axes for the original image.
imagesc(X), axis off, colormap gray          % Display the original grayscale image without axes.

ax2 = axes('Position',[.335 .005 .33 .99]);  % Create axes for the SVD-reconstructed image.
imagesc(XSVD), axis off                      % Display the image reconstructed using standard SVD without axes.

ax3 = axes('Position',[.665 .005 .33 .99]);  % Create axes for the rSVD-reconstructed image.
imagesc(XrSVD), axis off                     % Display the image reconstructed using randomized SVD without axes.

% Adjust figure size and position.
set(gcf,'Position',[100 100 2114 1000])       % Set the figure window size.
set(gcf,'PaperPositionMode','auto')           % Adjust paper size for saving.
print('-depsc2', '-loose', 'rSVD.eps');       % Save the figure as an EPS file for high-quality output.

%% Illustrate power iterations

% Create a random matrix for demonstrating the effect of power iterations on singular value decay.
X = randn(1000, 100);            % Generate a 1000x100 random matrix.
[U, S, V] = svd(X,'econ');       % Perform standard SVD on the random matrix.
S = diag(1:-.01:.01);            % Create a diagonal matrix of singular values that decay from 1 to 0.01.
X = U * S * V';                  % Reconstruct the matrix X using the decayed singular values.

% Plot the singular values from the initial SVD.
plot(diag(S), 'ko', 'LineWidth', 1.5)  % Plot the diagonal of the matrix S (the singular values) as black circles.
hold on

CC = jet(11);                    % Generate a colormap for the lines in subsequent iterations.
Y = X;                           % Initialize Y to the matrix X for power iterations.
for q = 1:5
    Y = X' * Y;                  % Perform a power iteration step: first multiply Y by the transpose of X.
    Y = X * Y;                   % Multiply the result by X again.
    [Uq, Sq, Vq] = svd(Y,'econ'); % Compute SVD on the matrix Y after power iterations.
    plot(diag(Sq), '-o', 'Color', CC(mod(2*q+4,11)+1,:), 'LineWidth', 1.5); % Plot the singular values for the current iteration in color.
end

% Add a legend showing how the singular values evolve after different numbers of power iterations.
legend('SVD', 'rSVD, q=1', 'rSVD, q=2', 'rSVD, q=3', 'rSVD, q=4', 'rSVD, q=5');

% Adjust figure size and axis limits for better visualization.
set(gcf,'Position',[100 100 500 225])  % Set the figure size.
ylim([0 1])                            % Limit the y-axis to the range [0, 1] for clarity.
