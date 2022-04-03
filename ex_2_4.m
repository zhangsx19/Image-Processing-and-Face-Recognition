clear;close all;clc;
load('data/hall.mat');
%补全为8的倍数，读取height width
hall_process = preprocess(hall_gray);
hall_sub = hall_process - 128;
[height, width] = size(hall_sub);
%对每一个 8 × 8 的系数矩阵进行转置
fun = @(block_struct) dct2(block_struct.data);
DCT = blockproc(hall_sub, [8 8], fun);
fun = @(block_struct) idct2(transpose(block_struct.data))+128;
D_tran_every = blockproc(DCT, [8 8], fun);
%对每一个 8 × 8 的系数矩阵逆时针旋转90
fun = @(block_struct) dct2(block_struct.data);
DCT = blockproc(hall_sub, [8 8], fun);
fun = @(block_struct) idct2(rot90(block_struct.data))+128;
D_rot90_every = blockproc(DCT, [8 8], fun);
%对每一个 8 × 8 的系数矩阵逆时针旋转180
fun = @(block_struct) dct2(block_struct.data);
DCT = blockproc(hall_sub, [8 8], fun);
fun = @(block_struct) idct2(rot90(block_struct.data,2))+128;
D_rot180_every = blockproc(DCT, [8 8], fun);
%对全图的系数矩阵进行转置
edge = min(width,height);
C = dct2(hall_sub(1:edge,1:edge));
D_tran_whole = idct2(C')+128;
%对全图的系数矩阵逆时针旋转90
D_rot90_whole = idct2(rot90(C))+128;
%对全图的系数矩阵逆时针旋转180
D_rot180_whole = idct2(rot90(C,2))+128;

%write to result
if ~exist('results', 'dir')
    mkdir results;
end % create results/ if the directory does not exist
imwrite(uint8(D_tran_every), 'results/D_tran_every.png');
imwrite(uint8(D_rot90_every), 'results/D_rot90_every.png');
imwrite(uint8(D_rot180_every), 'results/D_rot180_every.png');
imwrite(uint8(D_tran_whole), 'results/D_tran_whole.png');
imwrite(uint8(D_rot90_whole), 'results/D_rot90_whole.png');
imwrite(uint8(D_rot180_whole), 'results/D_rot180_whole.png');%必须转换为uint8才写入，否则图片为空白
%展示图片 -every
figure('Name', 'DCT_tran_every', 'NumberTitle', 'off');
subplot(1, 3, 1);imshow(uint8(D_tran_every));title("D tran every");
subplot(1, 3, 2);imshow(uint8(D_rot90_every));title("D rot90 every");
subplot(1, 3, 3);imshow(uint8(D_rot180_every));title("D rot180 every");
%展示图片 -whole
figure('Name', 'DCT_tran_whole', 'NumberTitle', 'off');
subplot(1, 3, 1);imshow(uint8(D_tran_whole));title("D tran whole");
subplot(1, 3, 2);imshow(uint8(D_rot90_whole));title("D rot90 whole");
subplot(1, 3, 3);imshow(uint8(D_rot180_whole));title("D rot180 whole");