clear;close all;clc;
b = [-1,1];%差分方程右侧系数
a = [1,0];%差分方程左侧系数
figure;
freqz(b,a),title('频率响应');