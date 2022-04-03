%采用空域的处理方法，即C=D*(P-128)*D',展示的是dct变换后又逆变换回来的图像
close all;clc;clear;
load('data/hall.mat');
%补全为8的倍数，读取height width
hall_process = preprocess(hall_gray);
%hall_sub_select = hall_process(17:32, 41:56);
hall_sub = hall_process- 128;
[height, width] = size(hall_sub);
%不置零变换的图像
fun = @(block_struct) dct2(block_struct.data);
DCT = blockproc(hall_sub, [8 8], fun);
fun = @(block_struct) idct2(block_struct.data)+128;
D_nozero = blockproc(DCT, [8 8], fun);
%右侧四列置零变换的图像
fun = @(block_struct) dct2(block_struct.data);
DCT = blockproc(hall_sub, [8 8], fun);
for a = 0:(width / 8)-1
    DCT(:,5+8*a:8+8*a) = 0;
end
fun = @(block_struct) idct2(block_struct.data)+128;
D_rightzero = blockproc(DCT, [8 8], fun);
%左侧四列置零变换的图像
fun = @(block_struct) dct2(block_struct.data);
DCT = blockproc(hall_sub, [8 8], fun);
for a = 0:(width / 8)-1
    DCT(:,1+8*a:4+8*a) = 0;
end
fun = @(block_struct) idct2(block_struct.data)+128;
D_leftzero = blockproc(DCT, [8 8], fun);
%write to result
if ~exist('results', 'dir')
    mkdir results;
end % create results/ if the directory does not exist
imwrite(uint8(hall_process), 'results/zeroDCT_notdct.png');
imwrite(uint8(D_nozero), 'results/zeroDCT_D_nozero.png');
imwrite(uint8(D_rightzero), 'results/zeroDCT_D_rightzero.png');
imwrite(uint8(D_leftzero), 'results/zeroDCT_D_leftzero.png');%必须转换为uint8才写入，否则图片为空白

%展示图片
figure('Name', 'DCT_zero', 'NumberTitle', 'off');
subplot(2, 2, 1);imshow(uint8(hall_process));title("未经dct的原图像");
subplot(2, 2, 2);imshow(uint8(D_nozero));title("不置零变换的图像");
subplot(2, 2, 3);imshow(uint8(D_rightzero));title("右侧四列置零变换的图像");
subplot(2, 2, 4);imshow(uint8(D_leftzero));title("左侧四列置零变换的图像");
%展示图片
figure('Name', 'DCT_zero', 'NumberTitle', 'off');
subplot(2, 2, 2);imshow(uint8(D_nozero(21:28,51:58)));title("不置零变换的提取图像");
subplot(2, 2, 3);imshow(uint8(D_rightzero(21:28,51:58)));title("右侧四列置零变换的提取图像");
subplot(2, 2, 4);imshow(uint8(D_leftzero(21:28,51:58)));title("左侧四列置零变换的提取图像");
