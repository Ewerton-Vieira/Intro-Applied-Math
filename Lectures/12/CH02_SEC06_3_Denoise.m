clear all, close all, clc
A = imread('../DATA/dog.jpg');
B = rgb2gray(A);

%% Denoise
% B = Bold(2:2:end,2:2:end);
Bold = B;
ind = rand(size(B));
Bnoise = B + uint8(200*randn(size(B)));
% Bnoise = B + uint8(200*rand(size(B)));
% Bnoise = B.*uint8(ind<.2);
imagesc(Bnoise)
colormap gray
axis off
axis tight
set(gcf,'Position',[100 100 600 800])
set(gcf,'PaperPositionMode','auto')
% print('-dpng', '-loose', '../figures/2DFFT_Noise1');

Bt=fft2(Bnoise);
Btshift = fftshift(Bt);
[nx,ny] = size(B);

figure
F = log(abs(Btshift)+1);  % put FFT on log-scale
imagesc(F)
colormap gray
axis off
axis tight
set(gcf,'Position',[100 100 600 800])
set(gcf,'PaperPositionMode','auto')
% print('-dpng', '-loose', '../figures/2DFFT_Noise2');

[X,Y] = meshgrid(-ny/2+1:ny/2,-nx/2+1:nx/2);
R2 = X.^2+Y.^2;
ind = R2<150^2;
Btshiftfilt = Btshift.*ind;

figure
Ffilt = log(abs(Btshiftfilt)+1);  % put FFT on log-scale
imagesc(Ffilt)
colormap gray
axis off
axis tight
set(gcf,'Position',[100 100 600 800])
set(gcf,'PaperPositionMode','auto')
% print('-dpng', '-loose', '../figures/2DFFT_Noise3');

figure
Btfilt = ifftshift(Btshiftfilt);
Bfilt = ifft2(Btfilt);
imagesc(real(uint8(Bfilt)))
colormap gray
axis off
axis tight
set(gcf,'Position',[100 100 600 800])
set(gcf,'PaperPositionMode','auto')
% print('-dpng', '-loose', '../figures/2DFFT_Noise4');

