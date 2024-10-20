% Download https://web.cvxr.com/cvx/cvx-rd.zip

% Then run in MATLAB the script cvx_setup

% For MAC OSX you need to give permitions. Open a terminal in the folder 
% crv a run the following lines:

% xattr -d com.apple.quarantine ./lib/cvx_bcompress_mex.mexmaci64
% xattr -d com.apple.quarantine ./lib/cvx_eliminate_mex.mexmaci64
% xattr -d com.apple.quarantine ./sdpt3/Solver/Mexfun/mexnnz.mexmaci64 
% xattr -d com.apple.quarantine ./sdpt3/Solver/Mexfun/mexschurfun.mexmaci64
% xattr -d com.apple.quarantine ./sdpt3/Solver/Mexfun/mexqops.mexmaci64   
% xattr -d com.apple.quarantine ./sdpt3/Solver/Mexfun/mexexpand.mexmaci64
% xattr -d com.apple.quarantine ./sdpt3/Solver/Mexfun/mextriang.mexmaci64
% xattr -d com.apple.quarantine ./sdpt3/Solver/Mexfun/mexMatvec.mexmaci64

clear all, close all, clc

% Solve y = Theta * s for "s"
n = 1000;  % dimension of s
p = 200;   % number of measurements, dim(y)
Theta = randn(p,n);  
y = randn(p,1);

% L1 minimum norm solution s_L1
cvx_begin;
    variable s_L1(n); 
    minimize( norm(s_L1,1) ); 
    subject to 
        Theta*s_L1 == y;
cvx_end;

s_L2 = pinv(Theta)*y;  % L2 minimum norm solution s_L2


%%
figure
subplot(3,2,1)
plot(s_L1,'b','LineWidth',1.5)
ylim([-.2 .2]), grid on
subplot(3,2,2)
plot(s_L2,'r','LineWidth',1.5)
ylim([-.2 .2]), grid on
subplot(3,2,[3 5])
[hc,h] = hist(s_L1,[-.1:.01:.1])
bar(h,hc,'b')
axis([-.1 .1 -50 1000])
subplot(3,2,[4 6])
[hc,h] = hist(s_L2,[-.1:.01:.1])
bar(h,hc,'r')
axis([-.1 .1 -20 400])

set(gcf,'Position',[100 100 600 350])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_ex03_underdetermined');