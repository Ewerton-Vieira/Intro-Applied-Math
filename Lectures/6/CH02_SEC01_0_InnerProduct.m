clear all, close all, clc

% Define the data points for two functions f and g
f = [0 0 .1 .2  .25  .2 .25 .3 .35 .43 .45 .5 .55  .5 .4 .425 .45 .425 .4 .35 .3 .25 .225 .2 .1 0 0];
g = [0 0 .025 .1  .2  .175 .2 .25 .25 .3 .32 .35 .375  .325 .3 .275 .275 .25 .225 .225 .2 .175 .15 .15 .05 0 0] - 0.025;

% Define the x values corresponding to the data points for f and g
x = 0.1*(1:length(f));  % Scaled x values based on the length of f

% Interpolate the functions f and g to get smoother curves
xf = (.01:.01:x(end));  % Create a finer x-grid for interpolation
f_interp = interp1(x, f, xf, 'cubic');  % Cubic interpolation of f on finer grid
g_interp = interp1(x, g, xf, 'cubic');  % Cubic interpolation of g on finer grid

% Plot the interpolated function f (smoothed) and the original data points
plot(xf(20:end-10), f_interp(20:end-10), 'k', 'LineWidth', 1.5)  % Plot interpolated f in black
hold on
plot(x(2:end-1), f(2:end-1), 'bo', 'MarkerFace', 'b')  % Plot original f points as blue circles

% Plot the interpolated function g (smoothed) and the original data points
plot(xf(20:end-10), g_interp(20:end-10), 'k', 'LineWidth', 1.5)  % Plot interpolated g in black
plot(x(2:end-1), g(2:end-1), 'ro', 'MarkerFace', 'r')  % Plot original g points as red circles

% Set the x-axis and y-axis limits
xlim([.1 2.7])  % Set x-axis range
ylim([-.1 .6])  % Set y-axis range

% Customize the appearance of the axes
set(gca, 'XTick', [.2:.1:2.6], 'XTickLabels', {}, 'LineWidth', 1.2)  % Custom x-ticks without labels
set(gca, 'YTick', []);  % Remove y-tick marks
box off  % Remove box around the plot

% Adjust figure size and position on the screen
set(gcf, 'Position', [100 100 550 250])

% Set paper position mode to auto for printing
set(gcf, 'PaperPositionMode', 'auto')



%% Compute the inner product between the interpolated functions f_interp and g_interp

% Replace NaN values with 0
f_interp(isnan(f_interp)) = 0;
g_interp(isnan(g_interp)) = 0;

delta_x = xf(2) - xf(1); % Assuming uniform spacing in xf

inner_product = sum((f_interp * g_interp') * delta_x)  % Assuming uniform spacing in xf

% Display the result
disp(['Inner product between f_interp and g_interp: ', num2str(inner_product)]);
