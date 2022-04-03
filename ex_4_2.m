close all;clc;clear;
% 使用到的一些参数
test_img = imread('data/football.jpeg');
detect_window = [45, 30];
% 分别令L为3,4,5，得到不同的人脸检测结果,距离判别阈值经调试分别为0.3,0.5和0.6
test_image1 = humanface_check(test_img, 3, detect_window, 0.30);
test_image2 = humanface_check(test_img, 4, detect_window, 0.50);
test_image3 = humanface_check(test_img, 5, detect_window, 0.60);

% 将结果呈现并写成图片
figure;imshow(test_img);title("原始待测图像");
figure;imshow(test_image1);title("L=3的人脸检测结果");
figure;imshow(test_image2);title("L=4的人脸检测结果");
figure;imshow(test_image3);title("L=5的人脸检测结果");
%保存图像
imwrite(test_image1, 'results/face_check_result_L3.jpg');
imwrite(test_image2, 'results/face_check_result_L4.jpg');
imwrite(test_image3, 'results/face_check_result_L5.jpg');
