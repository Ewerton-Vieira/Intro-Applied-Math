clear all; close all;

% Simulate Lorenz system
% Set time step and total simulation time
dt = 0.01;    % Time step
T = 8;        % Total time
t = 0:dt:T;   % Time vector from 0 to T with step dt

% Parameters of the Lorenz system
b = 8/3;
sig = 10;
r = 28;

% Define the Lorenz system as an anonymous function
Lorenz = @(t,x)([ sig * (x(2) - x(1));          ... % dx/dt
                  r * x(1) - x(1) * x(3) - x(2); ... % dy/dt
                  x(1) * x(2) - b * x(3)        ]); % dz/dt              

% Set ODE solver options for high accuracy (unused in this script)
ode_options = odeset('RelTol',1e-10, 'AbsTol',1e-11);

% Initialize input and output matrices for training data
input = [];
output = [];

% Generate training trajectories
for j = 1:100  % Number of training trajectories
    % Random initial condition in a cube centered at zero
    x0 = 30 * (rand(3,1) - 0.5);
    % Solve Lorenz system with initial condition x0
    [t,y] = ode45(Lorenz, t, x0);
    % Append data to input (current state) and output (next state)
    input = [input; y(1:end-1,:)];
    output = [output; y(2:end,:)];
    % Plot trajectory
    plot3(y(:,1), y(:,2), y(:,3)), hold on;
    % Mark initial condition with a red circle
    plot3(x0(1), x0(2), x0(3), 'ro');
end
% Configure plot
grid on; view(-23,18);

%%
% Define a feedforward neural network with three hidden layers of 10 neurons each
net = feedforwardnet([10 10 10]);
% Set activation functions for each layer
net.layers{1}.transferFcn = 'logsig';  % Layer 1: Logistic sigmoid function
net.layers{2}.transferFcn = 'radbas';  % Layer 2: Radial basis function
net.layers{3}.transferFcn = 'purelin'; % Layer 3: Linear function
% Train the network using the input and output data
net = train(net, input.', output.');

%%
% Simulate and plot the Lorenz system from a new initial condition
figure(2)
% Generate a new random initial condition
x0 = 20 * (rand(3,1) - 0.5);
% Solve the Lorenz system with initial condition x0
[t,y] = ode45(Lorenz, t, x0);
% Plot the Lorenz trajectory
plot3(y(:,1), y(:,2), y(:,3)), hold on;
% Mark initial condition with a red circle
plot3(x0(1), x0(2), x0(3), 'ro', 'LineWidth', 2);
grid on;

% Initialize neural network prediction with initial condition
ynn(1,:) = x0.';
% Iterate over time steps to generate neural network prediction
for jj = 2:length(t)
    % Predict next state using neural network
    y0 = net(x0);
    % Store predicted state
    ynn(jj,:) = y0.';
    % Update current state
    x0 = y0;
end
% Plot neural network predicted trajectory
plot3(ynn(:,1), ynn(:,2), ynn(:,3), ':', 'LineWidth', 2);

% Plot comparison of actual and predicted trajectories over time
figure(3)
% Plot x-component
subplot(3,2,1), plot(t, y(:,1), t, ynn(:,1), 'LineWidth', 2);
% Plot y-component
subplot(3,2,3), plot(t, y(:,2), t, ynn(:,2), 'LineWidth', 2);
% Plot z-component
subplot(3,2,5), plot(t, y(:,3), t, ynn(:,3), 'LineWidth', 2);

% Repeat the process with a new random initial condition
figure(2)
% Generate a new random initial condition
x0 = 20 * (rand(3,1) - 0.5);
% Solve the Lorenz system
[t,y] = ode45(Lorenz, t, x0);
% Plot the Lorenz trajectory
plot3(y(:,1), y(:,2), y(:,3)), hold on;
% Mark initial condition with a red circle
plot3(x0(1), x0(2), x0(3), 'ro', 'LineWidth', 2);
grid on;

% Initialize neural network prediction
ynn(1,:) = x0.';
for jj = 2:length(t)
    % Predict next state using neural network
    y0 = net(x0);
    % Store predicted state
    ynn(jj,:) = y0.';
    % Update current state
    x0 = y0;
end
% Plot neural network predicted trajectory
plot3(ynn(:,1), ynn(:,2), ynn(:,3), ':', 'LineWidth', 2);

% Plot comparison of actual and predicted trajectories over time
figure(3)
% Plot x-component
subplot(3,2,2), plot(t, y(:,1), t, ynn(:,1), 'LineWidth', 2);
% Plot y-component
subplot(3,2,4), plot(t, y(:,2), t, ynn(:,2), 'LineWidth', 2);
% Plot z-component
subplot(3,2,6), plot(t, y(:,3), t, ynn(:,3), 'LineWidth', 2);

%%
% Adjust the view angle of the 3D plot
figure(2), view(-75,15);

% Adjust plots in figure 3
figure(3)
% Set font size and x-axis limits for each subplot
subplot(3,2,1), set(gca,'FontSize',15,'XLim',[0 8]);
subplot(3,2,2), set(gca,'FontSize',15,'XLim',[0 8]);
subplot(3,2,3), set(gca,'FontSize',15,'XLim',[0 8]);
subplot(3,2,4), set(gca,'FontSize',15,'XLim',[0 8]);
subplot(3,2,5), set(gca,'FontSize',15,'XLim',[0 8]);
subplot(3,2,6), set(gca,'FontSize',15,'XLim',[0 8]);
% Add legend to the plots
legend('Lorenz','NN');
