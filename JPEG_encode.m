function [DC, AC, height, width] = JPEG_encode(img, QTAB, DCTAB, ACTAB)
% JPEG编码
% img: image input
% QTAB: 量化步长
% DCTAB: DC码表
% ACTAB: AC码表
% DC: DC 码流
% AC: AC 码流
% height: image height
% width: image width
[height, width] = size(img);
img_quantified = block_dct_quant_zig(img, QTAB);%对原始图像预处理、分块、DCT和量化，得到zig_zag后的系数
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
end