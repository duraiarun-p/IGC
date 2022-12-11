clc;clear;close all;
%%
T=Tiff('/home/arun/Documents/PyWSPrecision/IGC/OS-3-cropped.tif','r');
I=read(T);

siz=size(I);

%%
R=rescale(I(:,:,1));
Rm=imbinarize(R,0.6);

G=rescale(I(:,:,2));
Gm=imbinarize(G,0.6);

B=rescale(I(:,:,3));
Bm=imbinarize(B,0.6);
%%
I1 = rgb2hsv(I);
H=I1(:,:,1);
Hm=imbinarize(H, 0.55);
%%
I2=rgb2lab(I);
L=I2(:,:,1);
% A=rescale(I2(:,:,2));
B1=rescale(I2(:,:,3));
Bm1=imbinarize(B1, 0.65);
%%
I3=rgb2ycbcr(I);
%%
mask1=imcomplement(Hm);
mask2=Bm1;
mask3=imcomplement(Bm);
mask4=imcomplement(Rm);
mask5=imcomplement(Gm);
mask12=immultiply(mask1,mask2);
mask23=immultiply(mask2,mask3);
mask45=immultiply(mask4,mask5);

mask_A=immultiply(mask12,mask23);
mask=immultiply(mask_A,mask45);

%%
SE = strel("diamond",15);

mask_1=imclose(mask,SE);

SE = strel("diamond",5);
mask_2=imfill(mask_1,8);
%%
% I=uint8(zeros(size(I)));
% I_1(:,:,1)=immultiply(I(:,:,1),uint8(mask_2));
% I_1(:,:,2)=immultiply(I(:,:,2),uint8(mask_2));
% I_1(:,:,3)=immultiply(I(:,:,3),uint8(mask_2));

% I_1=I;

mask_2_F=zeros(size(I));
mask_2_F(:,:,1)=mask_2;
mask_2_F(:,:,2)=mask_2;
mask_2_F(:,:,3)=mask_2;
% % I_1=immultiply(I_1,(mask_2_F));
I_1=I.*uint8(mask_2_F);
I_2=I1.*(mask_2_F);
I_3=I2.*(mask_2_F);
I_4=I3.*uint8(mask_2_F);

% I_1 = bsxfun(@times, I, cast(mask_2_F, 'like', I));
% siz=size(I);
% for ch=1:siz(3)
%     I_1(:,:,ch)=I_1(:,:,ch).*uint8(mask_2);
% end
%%
% figure(4),imshow(I);
% figure(7);imshow(Bm);
% figure(6);imshow(Bm1);
% figure(5);imshow(Hm);
% figure(8);imshow(mask);
% figure(9);imshow(mask_1);
% figure(10);imshow(mask_2);
% 
% figure(11),imshow(I_1);
% figure(12),imshow(I_2);
% figure(13),imshow(I_3);
%%

% tile1=I_1;
% tile2=I_2;
% tile3=I_3;
% tile4=I_4;

divline=4;
tileM=mask_2(siz(1)/divline-499:siz(1)/divline,siz(2)/divline-499:siz(1)/divline,:);
tile1=I_1(siz(1)/divline-499:siz(1)/divline,siz(2)/divline-499:siz(1)/divline,:);
tile2=I_2(siz(1)/divline-499:siz(1)/divline,siz(2)/divline-499:siz(1)/divline,:);
tile3=I_3(siz(1)/divline-499:siz(1)/divline,siz(2)/divline-499:siz(1)/divline,:);
tile4=I_4(siz(1)/divline-499:siz(1)/divline,siz(2)/divline-499:siz(1)/divline,:);
%%
figure(14),imshow(tile1);
figure(15),imshow(tile2);
figure(16),imshow(tile3);
figure(17),imshow(tile4);
%%
% figure(1),subplot(131),imshow(tile1(:,:,1));subplot(132),imshow(tile1(:,:,2));subplot(133),imshow(tile1(:,:,3));
% figure(2),subplot(131),imshow(tile2(:,:,1));subplot(132),imshow(tile2(:,:,2));subplot(133),imshow(tile2(:,:,3));
% figure(3),subplot(131),imshow(tile3(:,:,1));subplot(132),imshow(tile3(:,:,2));subplot(133),imshow(tile3(:,:,3));
% figure(4),subplot(131),imshow(tile4(:,:,1));subplot(132),imshow(tile4(:,:,2));subplot(133),imshow(tile4(:,:,3));
%%


tile_V=histeq(tile2(:,:,3));
tile_V(tile_V>0.7)=0;
tile_V(tile_V<0.4)=0;

tile_Vm=imbinarize(tile_V,'global');
tile_Vm_s=immultiply(tileM,imfill(tile_Vm,'holes'));
tile_Vm_s=dustthemask(tile_Vm_s,500,500);
% figure(9),imshow(tile_Vm_s);
%%
% gmag = imgradient(tile1(:,:,3));
% gmag(gmag>800)=0;
% gmag(gmag<100)=0;
% figure(5),
% imshow(gmag,[])
% L=watershed(gmag);
% rgb = label2rgb(L,'jet',[.5 .5 .5]);
% figure(6),imshow(rgb)

function Mn=dustthemask(MTE,m,n)
se = strel('disk',8);
Mn=imopen(MTE,se);
Mn=imclose(Mn,se);
% Mn=imfill(Mn,'holes');
if ~any(Mn(:))==0
boundaries = bwboundaries(Mn);
firstBoundary = boundaries{1};
% Get the x and y coordinates.
x = firstBoundary(:, 2);
y = firstBoundary(:, 1);
% Now smooth with a Savitzky-Golay sliding polynomial filter
windowWidth = 5;
polynomialOrder = 2;
smoothX = sgolayfilt(x, polynomialOrder, windowWidth);
smoothY = sgolayfilt(y, polynomialOrder, windowWidth);
Mn=poly2mask(smoothX,smoothY,m,n);
else
    Mn=false(m,n);
end
end