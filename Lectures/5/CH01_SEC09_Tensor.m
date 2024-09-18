clear all; close all; clc     % Clear all variables, close all figures, and clear the command window.

% Define grid for spatial (x, y) and temporal (t) dimensions.
x = -5:0.1:5;                 % x values ranging from -5 to 5 with a step of 0.1.
y = -6:0.1:6;                 % y values ranging from -6 to 6 with a step of 0.1.
t = 0:0.1:10*pi;              % t values ranging from 0 to 10*pi with a step of 0.1 (time dimension).

% Generate 3D grid for variables X, Y, and T (spatial x, y and temporal t).
[X, Y, T] = meshgrid(x, y, t); 

% Create the 3D matrix A using two expressions:
% 1. An exponential Gaussian in space modulated by a cosine in time.
% 2. A hyperbolic secant (sech) and tangent (tanh) combination modulated by a sine in time.
A = exp(-(X.^2 + 0.5*Y.^2)).*cos(2*T) + ...   % First term: spatial Gaussian modulated by cosine in time.
    (sech(X).*tanh(X).*exp(-0.2*Y.^2)).*sin(T); % Second term: sech-tanh function modulated by sine in time.

% Loop through time points and display each frame using pcolor.
for j = 1:length(t)
  pcolor(x, y, A(:,:,j)), shading interp, caxis([-1 1]), drawnow  % Plot each slice (2D frame) of the 3D data matrix A.
end

% Create figure 1 and display 8 selected time slices of the 3D matrix A.
figure(1)                      
for j = 1:8
  subplot(2,4,j)                 % Create a 2x4 grid of subplots.
  pcolor(x, y, A(:,:,8*j-3)),    % Plot every 8th slice starting from the 5th slice.
  colormap(hot), shading interp,  % Use the 'hot' colormap and interpolate shading.
  caxis([-1 1]), axis off         % Set color axis limits and turn off axis.
end

% Create figure 2 for tensor decomposition analysis using PARAFAC.
figure(2)
model = parafac(A,2);            % Perform PARAFAC decomposition on the 3D matrix A with rank 2.
[A1, A2, A3] = fac2let(model);   % Extract the factor matrices A1, A2, and A3 from the PARAFAC model.

% Plot the factor matrices obtained from PARAFAC.
subplot(3,1,1), plot(y, A1, 'LineWidth', 2)  % Plot the first factor matrix A1 against y (spatial dimension y).
subplot(3,1,2), plot(x, A2, 'LineWidth', 2)  % Plot the second factor matrix A2 against x (spatial dimension x).
subplot(3,1,3), plot(t, A3, 'LineWidth', 2)  % Plot the third factor matrix A3 against t (temporal dimension t).

% Format the x-axis and labels for the plots.
subplot(3,1,1), set(gca, 'Xtick', [-6 0 6], 'FontSize', 15)       % Set x-axis ticks for y dimension (-6, 0, 6).
subplot(3,1,2), set(gca, 'Xtick', [-5 0 5], 'FontSize', 15)       % Set x-axis ticks for x dimension (-5, 0, 5).
subplot(3,1,3), set(gca, 'Xlim', [0 10*pi], 'Xtick', [0 5*pi 10*pi], 'XtickLabels', {'0','5\pi','10\pi'}, 'FontSize', 15)  
% Set x-axis limits and ticks for time (t) and label them as 0, 5π, and 10π.
