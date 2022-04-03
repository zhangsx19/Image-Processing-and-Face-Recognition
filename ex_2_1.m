clear;close all;clc;
load('data/hall.mat');
%读取height和width
img_width = 8;
[height, width] = size(hall_gray);
%选取随机的8*8矩阵块
piece_x = floor(rand * (height - img_width) + 1);
piece_y = floor(rand * (width - img_width) + 1);
rand_piece = double(hall_gray(piece_x:(piece_x + img_width - 1),piece_y:(piece_y + img_width - 1)));
%空域
piece_sd = rand_piece - 128;
dct_sd = dct2(piece_sd);%matlab的dct2(A)函数返回 A 的二维离散余弦变换
%频域
dct_fd = dct2(rand_piece);
dct_fd(1,1) = dct_fd(1,1) - 128 * img_width;
%算出二范数
disp(norm(dct_sd - dct_fd));
%write to result
if ~exist('results', 'dir')
    mkdir results;
end % create results/ if the directory does not exist
imwrite(uint8(rand_piece), 'results/preprocess_rand_piece.png');
imwrite(dct_sd, 'results/preprocess_dct_sd.png');
imwrite(dct_fd, 'results/preprocess_dct_fd.png');
%同时显示多张图片
figure('Name', 'img_preprocess', 'NumberTitle', 'off');
subplot(1, 3, 1);imshow(uint8(rand_piece));title("随机8*8块");
subplot(1, 3, 2);imshow(dct_sd);title("空域");
subplot(1, 3, 3);imshow(dct_fd);title("频域");