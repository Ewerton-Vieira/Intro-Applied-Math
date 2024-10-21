clear all, close all, clc
A = imread('../DATA/dog.jpg');
B = rgb2gray(A);

%% FFT Compression
figure
Bt=fft2(B);
F = log(abs(fftshift(Bt))+1);  % put FFT on log-scale

% Zero out all small coefficients and inverse transform
Btsort = sort(abs(Bt(:)));
keepvec = [.1 .05 .01 .005 .002 .001];
for k=4:6
    keep = keepvec(k);
    % keep = 0.05;
    thresh = Btsort(floor((1-keep)*length(Btsort)));
    ind = abs(Bt)>thresh;
    Atlow = Bt.*ind;
    Flow = log(abs(fftshift(Atlow))+1);  % put FFT on log-scale
    imshow(mat2gray(Flow),[]);
    
    % Plot Reconstruction
    Alow=uint8(ifft2(Atlow));

    figure
    imshow(Alow)
    
    axis off
    set(gcf,'PaperPositionMode','auto')
    % print('-depsc2', '-loose', ['../figures/2DFFT_Compress',num2str(k)]);
    % print('-dpng', '-loose', ['../figures/2DFFT_Compress',num2str(k)]);
    
end