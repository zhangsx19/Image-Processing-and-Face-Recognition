clear;close all;clc;
load('data/hall.mat');
load('data/JpegCoeff.mat');
image = double(hall_gray);
[height, width] = size(image);
img_len = height * width;
% 图像预处理（将宽高补足成8的倍数）、-128、分块、DCT和量化
img_quantified = block_dct_quant_zig(image,QTAB);
% 生成随机信息
hid_len = 168;%randi(img_len);%定义并记录隐藏信息的长度
hide_info = ceil(rand(hid_len,1)-0.5).';%生成长度为hid_len的随机01序列
hide_seq = [hide_info, zeros(1, img_len - hid_len)];
% 将信息隐藏入img_quantified
hidden = reshape(bitshift(bitshift(img_quantified.', -1, 'int64'), 1, 'int64'), 1, []);
img_quantified = reshape(hidden + hide_seq, [], 64).';
%JPEG编码
blocks = size(img_quantified, 2);
%计算DC码流
DC_coef = img_quantified(1, :);%把各个图像块的量化后的直流分量表示为1个矢量c̃D
DC_coef = [DC_coef(1), DC_coef(1:end - 1)- DC_coef(2:end)] ;%差分运算得到c^D
dc_block_process = @(data) DC_process(data, DCTAB);
DC = arrayfun(dc_block_process, DC_coef, 'UniformOutput', false);%Uniform 输出中不能存在非标量值
DC = cell2mat(DC);%把cell转换成mat,计算出DC码流
%计算AC码流
AC_coef = img_quantified(2:end, :);%Zig-Zag扫描形成列矢量去掉DC系数 63*315
AC = AC_process(AC_coef, ACTAB, blocks);
% JPEG解码
col = ceil(height / 8) * ceil(width / 8);
img_quantified = zeros(64, col);
% 解码出DC系数
dc_coeff = DCdecode(DC, col);
img_quantified(1,:) = dc_coeff;
% 解码出AC系数
ac_coeff = ACdecode(AC, ACTAB, col);
img_quantified(2:64,:) = ac_coeff;
%还原图片
image = izig_quant_dct_block(img_quantified, QTAB, height, width);

% 将隐藏信息抽取出来
extract_seq = mod(reshape(img_quantified.', 1, []), 2);
extract_info = extract_seq(1:hid_len);

%计算压缩比
fprintf("方法1压缩比为: %5.4f\n", height * width * 8 / (size(DC, 2) + size(AC, 2)));
%计算正确率
correct = length(find(extract_info==hide_info));
correct_rate = correct / hid_len;
fprintf("方法1在JPEG编解码后的正确率: %f\n", correct_rate);
%计算PSNR
PSNR = 10 * log10(255^2 / mse(image, hall_gray));
fprintf("方法1的PSNR = %6.4fdB\n", PSNR);
%展示图片
figure;
subplot(1, 2, 1);imshow(hall_gray);title("原图片");
subplot(1, 2, 2);imshow(uint8(image));title("隐藏信息后的编解码图片");
