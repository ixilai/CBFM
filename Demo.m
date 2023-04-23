close all;
clear all
clc

img1=imread(); %IR
img2=imread(); %Vis


img1=im2double(img1);
img2=im2double(img2);
A_YUV=ConvertRGBtoYUV(img2);   
f2=A_YUV(:,:,1); 

F=main_color(img1,f2);
%%
[row,column]=size(img1);
F_YUV=zeros(row,column,3);
F_YUV(:,:,1)=F;
F_YUV(:,:,2)=A_YUV(:,:,2);
F_YUV(:,:,3)=A_YUV(:,:,3);
FF=ConvertYUVtoRGB(F_YUV); 

%%
figure,imshow(FF);
