%Program for Mean Square Error Calculation
%Author : Athi Narayanan S
%http://sites.google.com/site/athisnarayanan/

function MSE = MeanSquareError(origImg, distImg)

origImg = double(origImg);
distImg = double(distImg);

[M N] = size(origImg);
error = origImg - distImg;
MSE = sum(sum(error .* error)) / (M * N);