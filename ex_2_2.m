clear;close all;clc;
load('data/hall.mat');
%读取height和width
img_width = 8;
[height, width] = size(hall_gray);
%选取随机的8*8矩阵块
piece_x = floor(rand * (height - img_width) + 1);
piece_y = floor(rand * (width - img_width) + 1);
rand_piece = double(hall_gray(piece_x:(piece_x + img_width - 1),piece_y:(piece_y + img_width - 1)));
% spatial domain
piece_sd = rand_piece - 128;
dct_sd = dct2(piece_sd);%matlab的dct2(A)函数返回 A 的二维离散余弦变换
dct_sd1 = mydct(piece_sd);
% frequency domain
dct_fd = dct2(rand_piece);
dct_fd(1,1) = dct_fd(1,1) - 128 * img_width;
dct_fd1 = mydct(rand_piece);
dct_fd1(1,1) = dct_fd1(1,1) - 128 * img_width;
%算出二范数
disp(norm(dct_sd - dct_fd));
disp(norm(dct_sd1 - dct_fd1));
%write to result
if ~exist('results', 'dir')
    mkdir results;
end % create results/ if the directory does not exist
imwrite(uint8(rand_piece), 'results/preprocess_rand_piece.png');
imwrite(dct_sd, 'results/preprocess_dct_sd.png');
imwrite(dct_fd, 'results/preprocess_dct_fd.png');
imwrite(dct_sd1, 'results/preprocess_dct_sd1.png');
imwrite(dct_fd1, 'results/preprocess_dct_fd1.png');
%同时显示多张图片
figure('Name', 'img_preprocess', 'NumberTitle', 'off');
subplot(2, 2, 1);imshow(dct_sd);title("matlab提供的dct2空域");
subplot(2, 2, 2);imshow(dct_fd);title("matlab提供的dct2频域");
subplot(2, 2, 3);imshow(dct_sd1);title("自行实现的mydct空域");
subplot(2, 2, 4);imshow(dct_fd1);title("自行实现的mydct频域");