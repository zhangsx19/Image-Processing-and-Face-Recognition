clear;close all;clc;
load('data/JpegCoeff.mat');
load('data/hall.mat');
QTAB = QTAB/2;%量化步长减少为原来的一半
[DC, AC, height, width] = JPEG_encode(hall_gray, QTAB, DCTAB, ACTAB);
img = JPEG_decode(DC, AC, height, width, QTAB, ACTAB);
fprintf("DC码流长度:%d, AC码流长度:%d, 高度:%d, 宽度:%d\n", size(DC, 2), size(AC, 2), height, width);
%压缩比=输入文件长度/输出码流长度
fprintf("压缩比为: %5.4f\n", height * width * 8 / (size(DC, 2) + size(AC, 2)));
%客观评价
PSNR = 10 * log10(255^2 / mse(img, hall_gray));
fprintf("PSNR = %5.4fdB\n", PSNR);
%展示图片
figure;
subplot(1,2,1);imshow(img);title('decode');
imwrite(img, 'results/2_12_decode.png');
subplot(1,2,2);imshow(hall_gray);title('原始图像');
imwrite(hall_gray, 'results/2_12_origin.png');