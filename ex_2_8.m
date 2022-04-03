clear;close all;clc;
load('data/JpegCoeff.mat');
load('data/hall.mat');
result = block_dct_quant_zig(hall_gray,QTAB);
save('results/result.mat','result');