clc;clear;close all
% This code read a single image, produce a low-resolution image and improve
% the image resolution by gradient profile sharpness (GPS) and image 
% reconstruction algorithm.
%
% Reference paper: Q. Yan, Y. Xu, X. Yang and T. Q. Nguyen, "Single Image
% Superresolution Based on Gradient Profile Sharpness," in IEEE Transactions
% on Image Processing, vol. 24, no. 10, pp. 3187-3202, Oct. 2015, 
% doi: 10.1109/TIP.2015.2414877.
%
% Written by: Hesam Shokouh Alaei
%
%
H = imread ('angioectasia-P0-2.png');  %read high-resolution image
factor = 4;  %up/down scaling ratios
L = imresize(H,1/factor);   %Down-Sampling to produce low-resolution image
U = imresize(L,factor);   %Up-Sampling to produce upscaled-resoultion image
N = 14;  % only the gradient profiles with more than N profile points are
...described by the mixed gaussian model
m0 = 100;
for band = 1:3
f_x = GPS_x(U,L,m0,N,band);  % transformed gradients in x direction
f_y = GPS_y(U,L,m0,N,band);  % transformed gradients in y direction

%Image Reconstruction
beta = 0.03;
t = 0.005;
u = U(:,:,band);
u = double(u);
[fx,fy] = gradient(u);
Dx = fx./u;
Dx(isnan(Dx))=0;
Dx(isinf(Dx))=0;
Dy = fy./u;
Dy(isnan(Dy))=0;
Dy(isinf(Dy))=0;
sigma = 1.2;
LR = L(:,:,band);
LR = double(LR);
step = 1;
D0 = 2000;
D1 = 1000;
while D1 <= D0
    D0 = D1;
    img = imgaussfilt(u,sigma);
    Lhat = imresize(img,1/factor);
    temp1 = Lhat - LR;
    temp2 = imresize(temp1,factor);
    EI = imgaussfilt(temp2,sigma);
    EI = 2.*EI;
    EG = 2.*(u.*Dx.*Dx'-f_x.*Dx'+Dy'.*Dy.*u-Dy'.*f_y);
    u = u - t.*(EI+beta.*EG);
    if step==1
        J0 = sum(u,'all');
        D0 = 2000;
    else
       J1 = sum(u,'all');
       J = [J0,J1];
       J0 = J1;
       D1 = abs(diff(J));
    end
    step =step +1;
end

Image1(:,:,band) = uint8(u);
end

Image2 = U;
Image3 = H;
Image4 = L;

% Evaluation
SSIM = ssim(Image1,Image3);
disp('SSIM (proposed) = ');
disp(SSIM);
SSIM = ssim(Image2,Image3);
disp('SSIM (interpolation) = ');
disp(SSIM);
str1 = ['Low Resolution Image , scale = ',num2str(factor)];
str2 = ['Interpolated Method , scale = ',num2str(factor)];

%Mean Square Error 
MSE = MeanSquareError(Image3, Image1);
disp('Mean Square Error (proposed) = ');
disp(MSE);

%Mean Square Error 
MSE = MeanSquareError(Image3, Image2);
disp('Mean Square Error (interpolation) = ');
disp(MSE);

% you can observe and compare both image resulted from GPS and image
% resulted from interpolation method
figure;montage({Image3,Image4,Image1,Image2});
text(100, -15, 'High Resolution Image','FontSize',13,'FontWeight','bold')
text(500, -15, str1,'FontSize',13,'FontWeight','bold')
text(130, 920, 'Proposed Method','FontSize',13,'FontWeight','bold')
text(520, 920, str2,'FontSize',13,'FontWeight','bold')




