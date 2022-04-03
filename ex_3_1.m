clear;close all;clc;
load('data/hall.mat');
load('data/JpegCoeff.mat');
image = double(hall_gray);
[height,width] = size(image);
img_len = height * width;%图片大小
% 任意生成一个需要隐藏的01序列
hid_len = img_len/2;%定义并记录隐藏信息的长度
hide_info = ceil(rand(hid_len,1)-0.5);%生成长度为hid_len的随机01序列
% 隐藏信息
%图片的每一个像素转成二进制是8bit，在像素亮度分量最低比特位放隐藏信息
P = dec2bin(image.');%把图片的像素转换成二进制：img_len*8
P(1:hid_len, end) = string(hide_info);%最低位替换为要隐藏的信息
% 不编解码直接还原回图片
img = reshape(bin2dec(P), width, height).';
% 将隐藏信息抽取出来
C = dec2bin(img.');%把图片的像素转换成二进制：img_len*8
extract_info = bin2dec(C(1:hid_len, end));%从像素亮度分量最低比特位提取隐藏信息
correct = length(find(extract_info==hide_info));%计算和原始隐藏信息相同的个数
correct_rate = correct / hid_len;
fprintf("只隐藏信息的正确率: %f\n", correct_rate);
% JPEG编码和解码
[DC, AC, height, width] = JPEG_encode(img, QTAB, DCTAB, ACTAB);
img = JPEG_decode(DC, AC, height, width, QTAB, ACTAB);
% 将隐藏信息抽取出来
C = dec2bin(img.');%把图片的像素转换成二进制：img_len*8
extract_info = bin2dec(C(1:hid_len, end));%从像素亮度分量最低比特位提取隐藏信息
correct = length(find(extract_info==hide_info));%计算和原始隐藏信息相同的个数
correct_rate = correct / hid_len;
fprintf("JPEG编码解码后的正确率: %f\n", correct_rate);

%展示图片
figure;
subplot(1, 3, 1);imshow(hall_gray);title("原图片");
subplot(1, 3, 2);imshow(uint8(img));title("隐藏信息后的图片");
subplot(1, 3, 3);imshow(uint8(img));title("隐藏信息后编解码的图片");
