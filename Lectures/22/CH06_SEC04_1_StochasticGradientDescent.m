% Clear all variables, close all figures, and clear the command window
clear all; close all; clc

% Define the grid step size and create ranges for x and y
h = 0.1; 
x = -6:h:6; 
y = -6:h:6; 

% Determine the number of points in x (or y)
n = length(x);

% Create a 2D grid of points using meshgrid
[X, Y] = meshgrid(x, y); 

% Clear unnecessary variables (x and y)
clear x, clear y

% Define a 2D function F1 and add another component to create the function F
F1 = 1.5 - 1.6 * exp(-0.05 * (3 * (X + 3).^2 + (Y + 3).^2)); % Gaussian-like term
F = F1 + (0.5 - exp(-0.1 * (3 * (X - 3).^2 + (Y - 3).^2))); % Add another Gaussian-like term

% Compute the gradient of F (partial derivatives with respect to x and y)
[dFx, dFy] = gradient(F, h, h);

% Define initial points (x0, y0) and colors for plotting
x0 = [4, 0, -5]; 
y0 = [0, -5, 2]; 
col = ['ro', 'bo', 'mo']; % 'ro': red, 'bo': blue, 'mo': magenta

% Loop through the 3 starting points
for jj = 1:3    
    % Randomly sample 10 indices from 1 to n for interpolation
    q = randperm(n); i1 = sort(q(1:10));
    q2 = randperm(n); i2 = sort(q2(1:10));
    
    % Initialize the starting point
    x(1) = x0(jj); 
    y(1) = y0(jj);
    
    % Interpolate the function and its gradient at the initial point
    f(1) = interp2(X(i1, i2), Y(i1, i2), F(i1, i2), x(1), y(1));
    dfx = interp2(X(i1, i2), Y(i1, i2), dFx(i1, i2), x(1), y(1));
    dfy = interp2(X(i1, i2), Y(i1, i2), dFy(i1, i2), x(1), y(1));
    
    % Step size for gradient descent
    tau = 2;
    
    % Perform gradient descent for 50 iterations or until convergence
    for j = 1:50
        % Update x and y using gradient descent
        x(j+1) = x(j) - tau * dfx; 
        y(j+1) = y(j) - tau * dfy;
        
        % Re-sample random indices for interpolation
        q = randperm(n); ind1 = sort(q(1:10));
        q2 = randperm(n); ind2 = sort(q2(1:10));
        
        % Update function value and gradient at the new point
        f(j+1) = interp2(X(i1, i2), Y(i1, i2), F(i1, i2), x(j+1), y(j+1));
        dfx = interp2(X(i1, i2), Y(i1, i2), dFx(i1, i2), x(j+1), y(j+1));
        dfy = interp2(X(i1, i2), Y(i1, i2), dFy(i1, i2), x(j+1), y(j+1));
        
        % Check for convergence (small change in function value)
        if abs(f(j+1) - f(j)) < 10^(-6)
            break
        end
    end    
    
    % Store results for each starting point
    if jj == 1; x1 = x; y1 = y; f1 = f; end
    if jj == 2; x2 = x; y2 = y; f2 = f; end
    if jj == 3; x3 = x; y3 = y; f3 = f; end
    
    % Clear variables for the next iteration
    clear x, clear y, clear f
end

% Plot contour of the function F with descent paths
figure(1)
contour(X, Y, F - 1, 10), colormap([0 0 0]), hold on
plot(x1, y1, 'ro', x1, y1, 'k:', x2, y2, 'mo', x2, y2, 'k:', x3, y3, 'bo', x3, y3, 'k:', 'Linewidth', [2])
set(gca, 'Fontsize', [18])

% Plot 3D surface of the function F with descent paths
figure(2)
surfl(X, Y, F), shading interp, colormap(gray), hold on
plot3(x1, y1, f1 + .1, 'ro', x1, y1, f1, 'k:', x2, y2, f2 + 0.1, 'mo', x2, y2, f2, 'k:', x3, y3, f3 + 0.1, 'bo', x3, y3, f3, 'k:', 'Linewidth', [2])
set(gca, 'Fontsize', [18])
axis([-6 6 -6 6]), view(-25, 60)
