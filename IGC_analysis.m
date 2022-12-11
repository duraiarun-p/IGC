clc;clear;close all;
%%
T=Tiff('/home/arun/Documents/PyWSPrecision/IGC/OS-3-cropped.tif','r');
I=read(T);
%%
I1 = rgb2hsv(I);
% I1=I;
H=I1(:,:,1);
S=I1(:,:,2);
V=I1(:,:,3);
% Hm=imbinarize(H, mean(H(:)));
% Sm=imbinarize(S, mean(S(:)));
% Vm=imbinarize(V, mean(V(:)));
Hm=imbinarize(H, 0.5);
Sm=imbinarize(S, 0.5);
Vm=imbinarize(V, 0.5);
% Hm=imbinarize(H, 'global');
% Sm=imbinarize(S, 'global');
% Vm=imbinarize(V, 'global');
% Hm=imbinarize(H, 'adaptive');
% Sm=imbinarize(S, 'adaptive');
% Vm=imbinarize(V, 'adaptive');
%%

%%
figure(1);
subplot(131),
imshow(I(:,:,1));
subplot(132),
imshow(I(:,:,2));
subplot(133),
imshow(I(:,:,3));
%%
figure(2);
subplot(131),
imshow(H);
subplot(132),
imshow(S);
subplot(133),
imshow(V);
%%
figure(3);
subplot(131),
imshow(Hm);
subplot(132),
imshow(Sm);
subplot(133),
imshow(Vm);
%%
figure(4),imshow(I);
figure(7);imshow(Vm);
figure(6);imshow(Sm);
figure(5);imshow(Hm);