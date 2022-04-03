function ent=draw_redrec(img,row,col,detect_window)
% sw表示矩形框的左上角、右下脚点的在图像中的位置坐标值
% n 表示框线的宽度
%读取图像矩阵的页面数,24位彩色图像
r_w = detect_window(1);
c_w = detect_window(2);
R = zeros(size(img(row,col:col+c_w,1:3)));
R(:,:,1) = 255;
img(row,col:col+c_w,1:3)=R;
img(row+r_w,col:col+c_w,1:3)=R;
R = zeros(size(img(row:row+r_w,col,1:3)));
R(:,:,1) = 255;
img(row:row+r_w,col,1:3)=R;
img(row:row+r_w,col+c_w,1:3)=R;
ent=img; %返回加了标记框的图像矩阵