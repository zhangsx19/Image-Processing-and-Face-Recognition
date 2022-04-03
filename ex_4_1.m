close all;clear;clc;

% 分别令L为3,4,5，得到不同的人脸模板结果
face_template1 = color_histogram(3);
face_template2 = color_histogram(4);
face_template3 = color_histogram(5);

% 绘制出不同L情况下的人脸模板
figure;
subplot(3, 1, 1);plot(face_template1);title("L = 3");xlabel("颜色索引");ylabel("频率");
subplot(3, 1, 2);plot(face_template2);title("L = 4");xlabel("颜色索引");ylabel("频率");
subplot(3, 1, 3);plot(face_template3);title("L = 5");xlabel("颜色索引");ylabel("频率");
