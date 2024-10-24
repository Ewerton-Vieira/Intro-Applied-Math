clear all, close all, clc
load CYLINDER_ALL.mat
X = VORTALL;

%% augment matrix with mirror images to enforce symmetry/anti-symmetry

Y = [X X];
for k=1:size(X,2)
    xflip = reshape(flipud(reshape(X(:,k),nx,ny)),nx*ny,1);
    Y(:,k+size(X,2)) = -xflip;
end

%% plot mean and subtract;
for r=[1, 20 70 150]
    f1 = plotCylinder(reshape(Y(:,r),nx,ny),nx,ny);
end

%% compute mean and subtract;

VORTavg = mean(Y,2);
f1 = plotCylinder(reshape(VORTavg,nx,ny),nx,ny);  % plot average