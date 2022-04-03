clear;close all;clc;
%read image
load('data/hall.mat');
[height,width,channel] = size(hall_color);%hall_color为120行168列unit8格式的原图
% define center and radius
center = [width+1,height+1]/2;%matlab中的下标从1开始，故中心坐标应各补上1/2。如1-2的中心为1.5而不是2/2=1
radius = min(width, height) / 2;

% draw empty circle
%构建参数方程（选取360个像素点）
img_empty_circle=hall_color;
angle = 0:359;
%不加max和min的话sub2ind会超范围,坐标得限制在1和宽/高之间
x = max(min(round(center(1) + radius * cos(angle)), width), 1);
y = max(min(round(center(2) + radius * sin(angle)), height), 1);
%构建三元组
R = hall_color(:,:,1);
G = hall_color(:,:,2);
B = hall_color(:,:,3);
%对于 RGB 三色不同色通道的操作实现红色空心圆
%因sub2ind是按列排序的，所以是y在前
R(sub2ind(size(img_empty_circle), y, x)) = 255;
img_empty_circle(:,:,1) = R;
G(sub2ind(size(img_empty_circle), y, x)) = 0;
img_empty_circle(:,:,2) = G;
B(sub2ind(size(img_empty_circle), y, x)) = 0;
img_empty_circle(:,:,3) = B;

%draw filled circle
%构建标准方程和逻辑矩阵
img_fill_circle=hall_color;
[x, y] = meshgrid(1:width, 1:height);
distance = sqrt((x - center(1)).^2 + (y - center(2)).^2);
%circle_area = ((distance <= 1.01*radius) & (distance >= 0.99*radius));
circle_area = ((distance <= radius));
%构建三元组
R = hall_color(:,:,1);
G = hall_color(:,:,2);
B = hall_color(:,:,3);
%对于 RGB 三色不同色通道的操作实现红色实心圆
R(circle_area) = 255;
img_fill_circle(:,:,1) = R;
G(circle_area) = 0;
img_fill_circle(:,:,2) = G;
B(circle_area) = 0;
img_fill_circle(:,:,3) = B;

%draw grid
[x, y] = meshgrid(1:width, 1:height);
grid_size = 8; %一格的大小（width and height的最大公约数）
%构建黑白相间的棋盘
xgrid  = mod(floor((x-1) / grid_size), 2);
ygrid = mod(floor((y-1) / grid_size), 2);
grid_mask = xor(xgrid, ygrid);
img_grid = uint8(grid_mask) .* hall_color;%.*:整数只能与同类的整数或双精度标量值组合使用。

%write to result
if ~exist('results', 'dir')
    mkdir results;
end % create results/ if the directory does not exist
imwrite(uint8(img_empty_circle), 'results/emptyCircle.png');
imwrite(uint8(img_fill_circle), 'results/fill_circle.png');
imwrite(uint8(img_grid), 'results/grid.png');
%同时显示多张图片
figure('Name', 'CircleAndGrid', 'NumberTitle', 'off');
subplot(1,3,1);imshow(img_empty_circle);
subplot(1,3,2);imshow(img_fill_circle);
subplot(1,3,3);imshow(img_grid);