% Exercise 1-1.
% 
% Load the image dog.jpg and compute the full SVD. 
% Choose a rank r < m and confirm that the matrix U^TU is the r × r identity 
% matrix. Now confirm that UU^T is not the identity matrix. 
% Compute the norm of the error between UU^T and the n × n identity matrix 
% as the rank r varies from 1 to n and plot the error.

% Define a matrix
A = [1, 2; 3, 4];

% Calculate Frobenius norm
frobenius_norm = norm(A, 'fro');

fprintf('Frobenius norm: %f\n', frobenius_norm);


% Exercise 1-2.
% 
% Load the image dog.jpg and compute the economy SVD. Compute the relative 
% reconstruction error of the truncated SVD in the Frobenius norm as a 
% function of the rank r. Square this error to compute the fraction of 
% missing variance as a function of r. You may also decide to plot 1 minus 
% the error or missing variance to visualize the amount of norm or variance 
% captured at a given rank r. Plot these quantities along with the 
% cumulative sum of singular values as a function of r. Find the rank r 
% where the reconstruction captures 99% of the total variance. Compare this 
% with the rank r where the reconstruction captures 99% in the Frobenius 
% norm and with the rank r that captures 99% of the cumulative sum of 
% singular values.


