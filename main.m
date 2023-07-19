close all;
clear all
clc

addpath function

chosen=1;
for ii=1:chosen
    img2 = imread(['.cropinfrared\',num2str(ii),'.jpg']);
    img1 = imread(['.\crop_LR_visible\',num2str(ii),'.jpg']);
 

%%
if size(img1,3)>1
    img1=rgb2gray(img1);
    img1=im2double(img1);
else
    img1=im2double(img1);
end
if size(img2,3)>1
    img2=rgb2gray(img2);
    img2=im2double(img2);
else
    img2=im2double(img2);
end


FilterType = 2;
Iteration = 5;
tic;
%% 
r = 15;
lambda = 0.3;
G1 = guidedfilter(img1, img1, r, lambda);
G11 = guidedfilter(G1, G1, r, lambda);
G111 = guidedfilter(G11, G11, r, lambda);

%% 
[C1,energy1] = CF(img1,FilterType,Iteration);
[C11,energy11] = CF(C1,FilterType,Iteration);
[C111,energy111] = CF(C11,FilterType,Iteration);

%%
d1 = (img1-C1);
d2 = (C1-G1);
d3 = (G1-C11);
d4 = (C11-G11);
d5 = (G11-C111);
d6 = (C111-G111);

I1=0.8.*G111+1.8.*d1+1.8.*d2+d3+0.5.*d4+0.3.*d5+0.1.*d6;
I1=im2double(I1);
%%
B1 = WGF(I1, I1, r, lambda);
B2 = WGF(img2, img2, r, lambda);
B1=im2double(B1);
D1=I1-B1;
D1=im2double(D1);
D2=img2-B2;
%%
EN1 = entropy(B1);
EN2 = entropy(B2);
ep1 = (1/(sqrt(2*pi)*0.8732)) * exp(-(EN1-7.4600)^2/2*0.8732^2);
ep2 = (1/(sqrt(2*pi)*0.8732)) * exp(-(EN2-7.4600)^2/2*0.8732^2);
K=ep1./(ep1+ep2);

%%
w=(1/15)*[1,2,1;2,3,2;1,2,1];
E1 = calcFocusMeasure_new(D1, 3, 'EOL');
E1=imfilter(E1,w,'conv','symmetric','same');
E2 = calcFocusMeasure_new(D2, 3, 'EOL');
E2=imfilter(E2,w,'conv','symmetric','same');

M1=E1./(E1+E2);
M2=E2./(E1+E2);
FD=D1.*M1+D2.*M2;
FB=(ep1./(ep1+ep2))*B1+(ep2./(ep1+ep2))*B2;
F=FB+FD;

end