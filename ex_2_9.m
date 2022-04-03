clear;close all;clc;
load('data/JpegCoeff.mat');
load('data/hall.mat');
[DC, AC, height, width] = JPEG_encode(hall_gray, QTAB, DCTAB, ACTAB);
save('jpegcodes.mat', 'DC', 'AC', 'height', 'width');
fprintf("DC码流长度:%d, AC码流长度:%d, 高度:%d, 宽度:%d\n", size(DC, 2), size(AC, 2), height, width);
%压缩比=输入文件长度/输出码流长度
fprintf("压缩比为: %5.4f\n", height * width * 8 / (size(DC, 2) + size(AC, 2)));