clear;close all;clc;
load('data/JpegCoeff.mat');
load('data/hall.mat');
jpegcode = load('jpegcodes.mat');
img = JPEG_decode(jpegcode.DC, jpegcode.AC, jpegcode.height, jpegcode.width, QTAB, ACTAB);
%客观评价
PSNR = 10 * log10(255^2 / mse(img, hall_gray));
fprintf("PSNR = %5.4fdB\n", PSNR);
%展示图片
figure;
subplot(1,2,1);imshow(img);title('decode');
imwrite(img, 'results/2_11_decode.png');
subplot(1,2,2);imshow(hall_gray);title('原始图像');
imwrite(hall_gray, 'results/2_11_origin.png');





