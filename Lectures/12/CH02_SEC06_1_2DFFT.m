clear all, close all, clc
A = imread('../DATA/dog.jpg');
B = rgb2gray(A);

for j=1:size(B,1);
    Cshift(j,:) = fftshift(fft(B(j,:)));
    C(j,:) = (fft(B(j,:)));
end

for j=1:size(C,2);
    D(:,j) = fft(C(:,j));
end

subplot(1,3,1)
imagesc(B);
subplot(1,3,2)
imagesc(log(abs(Cshift)))
subplot(1,3,3)
imagesc(fftshift(log(abs(D))))
colormap gray
%%
figure
imagesc(B)
colormap gray
axis off
axis tight
set(gcf,'Position',[100 100 600 800])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/2DFFTa');

figure
imagesc(log(abs(Cshift)))
colormap gray

axis off
axis tight
set(gcf,'Position',[100 100 600 800])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/2DFFTb');
figure
imagesc(fftshift(log(abs(D))))
colormap gray
axis off
axis tight
set(gcf,'Position',[100 100 600 800])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/2DFFTc');



