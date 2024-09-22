clear all, close all, clc

% Define the grid spacing and length of the interval
dx = 0.01;       % Grid step size
L = 2*pi;        % Length of the interval
x = 0:dx:L;      % Create an array from 0 to L with step size dx

% Define the initial function f
f = zeros(size(x));  % Initialize f with zeros the same size as x
% f = sin(x/L);      % Uncomment to use sine function for f (commented out)
% f = ones(size(x)); % Uncomment to use a constant function for f (commented out)

% Set the middle half of f to 1
f(floor(length(f)/4):floor(3*length(f)/4)) = 1 + f(floor(length(f)/4):floor(3*length(f)/4));

% Initialize Fourier Series approximation fFS
fFS = zeros(size(x));

% Compute the zeroth Fourier coefficient (A0)
A0 = (1/pi)*sum(f.*ones(size(x)))*dx;  % Integral approximation for A0

% Begin Fourier Series approximation loop, m defines the number of terms
for m = 1:100
    fFS = A0/2;  % Start with the zeroth term in Fourier Series
    
    % Compute the Fourier coefficients and sum the terms
    for k = 1:m
        Ak = (1/pi)*sum(f.*cos(2*pi*k*x/L))*dx;  % Calculate Ak coefficient
        Bk = (1/pi)*sum(f.*sin(2*pi*k*x/L))*dx;  % Calculate Bk coefficient
        fFS = fFS + Ak*cos(2*k*pi*x/L) + Bk*sin(2*k*pi*x/L);  % Update Fourier Series sum
    end
    
    % Plot the original function f and its Fourier Series approximation fFS
    plot(x, f, 'k')       % Plot original function in black
    hold on
    plot(x, fFS, 'r-')    % Plot Fourier Series approximation in red
    
    % Pause to visualize the evolution of the approximation
    pause(0.1)
end
