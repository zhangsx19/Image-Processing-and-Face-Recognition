close all;clc;clear;
% 使用到的一些参数
test_img = imread('data/football.jpeg');
detect_window = [45, 30];
%处理图像，操作框也要随着变化
test_img1 = imrotate(test_img, -90);
detect_window1 = fliplr(detect_window);%顺时针旋转90度
test_img2 = imresize(test_img, [size(test_img, 1), size(test_img, 2) * 2]);
detect_window2 = [detect_window(1), detect_window(2) * 2];%宽度拉伸2倍
test_img3 = imadjust(test_img, [0.15 0.15 0; 0.9 0.9 1],[]);%改变颜色
% 分别令L为3,4,5，得到不同的人脸检测结果
test_image1 = humanface_check(test_img1, 3, detect_window1, 0.30);
test_image2 = humanface_check(test_img2, 3, detect_window2, 0.30);
test_image3 = humanface_check(test_img3, 3, detect_window, 0.30);
test_image4 = humanface_check(test_img, 3, detect_window, 0.30);
% 将结果呈现并写成图片

figure;imshow(test_image1);title("旋转90度的检测结果");
figure;imshow(test_image2);title("宽度拉伸两倍的检测结果");
figure;imshow(test_image3);title("改变颜色的检测结果");
figure;imshow(test_image4);title("原始L=3检测结果");
%保存图像
imwrite(test_image1, 'results/face_check_result_a.jpg');
imwrite(test_image2, 'results/face_check_result_b.jpg');
imwrite(test_image3, 'results/face_check_result_c.jpg');