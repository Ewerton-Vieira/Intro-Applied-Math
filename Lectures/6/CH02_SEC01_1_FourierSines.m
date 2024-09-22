% Explanation:
% Initialization and Hat Function: 
% The script defines the x domain and constructs a hat function, a triangular-shaped 
% function commonly used in signal processing.

% Fourier Series Approximation: 
% The Fourier series is computed iteratively, adding terms of sine and cosine functions.
% Each Fourier term is visualized in a different color.

% Error and Coefficient Plotting: 
% After computing the Fourier series, it calculates the approximation error and plots both 
% the Fourier coefficient amplitudes and the relative error, highlighting the significant terms 
% in the Fourier series.

clear all, close all, clc

% Define the domain for x
dx = 0.001;        % Grid step size
L = pi;            % Length of the interval
x = (-1+dx:dx:1)*L; % Create an array from -L to L with step size dx
n = length(x);     % Length of the array x
nquart = floor(n/4); % One quarter of the length of the array

% Define the hat function (triangular pulse)
f = 0*x;          % Initialize f with zeros the same size as x
f(nquart:2*nquart) = 4*(1:nquart+1)/n;          % Rising edge of the hat function
f(2*nquart+1:3*nquart) = 1-4*(0:nquart-1)/n;    % Falling edge of the hat function

% Plot the hat function
plot(x, f, '-k', 'LineWidth', 1.5), hold on     % Plot the hat function in black

% Compute the Fourier series approximation
CC = jet(20);       % Define a colormap with 20 different colors
A0 = sum(f.*ones(size(x)))*dx;  % Compute the zeroth Fourier coefficient (A0)
fFS = A0/2;         % Initialize Fourier series with the zeroth term

% Loop to compute Fourier coefficients and update the Fourier series approximation
for k = 1:20
    A(k) = sum(f.*cos(pi*k*x/L))*dx;  % Compute the cosine Fourier coefficient Ak
    B(k) = sum(f.*sin(pi*k*x/L))*dx;  % Compute the sine Fourier coefficient Bk
    fFS = fFS + A(k)*cos(k*pi*x/L) + B(k)*sin(k*pi*x/L);  % Add the k-th term to the series
    
    % Plot the Fourier series approximation in the corresponding color
    plot(x, fFS, '-', 'Color', CC(k,:), 'LineWidth', 1.2) 
    pause(1)        % Pause to visualize each step of the Fourier approximation
end

%% Plot Fourier coefficient amplitudes and approximation error
figure             % Open a new figure

% Initialize error and coefficient arrays
clear ERR; 
clear A;  
fFS = A0/2;        % Start with the zeroth term
A(1) = A0/2;       % Store zeroth coefficient
ERR(1) = norm(f-fFS);  % Compute the initial error (difference between f and fFS)

kmax = 100;        % Maximum number of Fourier terms to compute
for k = 1:kmax
    A(k+1) = sum(f.*cos(pi*k*x/L))*dx;   % Compute the cosine coefficient Ak
    B(k+1) = sum(f.*sin(pi*k*x/L))*dx;   % Compute the sine coefficient Bk
    
    % Update the Fourier series approximation
    fFS = fFS + A(k+1)*cos(k*pi*x/L) + B(k+1)*sin(k*pi*x/L); 
    
    % Compute the error (difference between f and fFS)
    ERR(k+1) = norm(f-fFS)/norm(f);  
end

% Define a threshold for error to determine significant Fourier terms
thresh = median(ERR)*sqrt(kmax)*4/sqrt(3);
r = max(find(ERR > thresh));  % Find the index where the error is greater than the threshold
r = 7;                        % Set r manually to 7

% Plot the Fourier coefficient amplitudes
subplot(2,1,1)    % Create a subplot for coefficient amplitudes
semilogy(0:1:kmax, A, 'k', 'LineWidth', 1.5)  % Plot the amplitudes in logarithmic scale
hold on
semilogy(r, A(r+1), 'bo', 'LineWidth', 1.5)  % Highlight the significant coefficient
xlim([0 kmax])   % Set the x-axis limit
ylim([10^(-7) 1]) % Set the y-axis limit

% Plot the approximation error
subplot(2,1,2)    % Create a subplot for error plot
semilogy(0:1:kmax, ERR, 'k', 'LineWidth', 1.5)  % Plot the error in logarithmic scale
hold on
semilogy(r, ERR(r+1), 'bo', 'LineWidth', 1.5)  % Highlight the significant error point
