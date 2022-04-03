function test_img = humanface_check(test_img,L, detect_window, epsilon)
%face_detect 人脸识别用函数，输出加识别框后的图片
%   test_img:需要被人脸检测的图像矩阵
% 	L:选取二进制高L位
%   detect_window:探测窗大小
%   epsilon:不同的距离判别阈值

% 得到人脸标准
face_template = color_histogram(L);
% 读取待测图像
[height, width, ~] = size(test_img);
dis_record = zeros(height, width);
% 定义探测窗口隔多少距离移动检测一次，过大框会偏移，过小执行速度慢
h_step = floor(detect_window(1) / 7);
w_step = floor(detect_window(2) / 7);
% 识别框去重范围
h_repeat = floor(detect_window(1));
w_repeat = floor(detect_window(2));
% 探测窗口开始扫描待测图像
for w=1:w_step:width
    % 防止识别框超过待测图像边界(即最后一次),w表示框的左边
    if w > width - detect_window(2)
        w_select = width - detect_window(2) + 1;
    else
        w_select = w;
    end
    for h=1:h_step:height
        % 防止识别框超过待测图像边界(即最后一次)，h表示框的上边
        if h > height - detect_window(1)
            h_select = height - detect_window(1) + 1;
        else
            h_select = h;
        end
        %获得框内图的颜色向量,[h_select,w_select]表示左上角
        detect_color_vec = img2color_vec(test_img(h_select:(h_select + detect_window(1) - 1),w_select:(w_select + detect_window(2) - 1), :), L);
        %获得探测窗口中的颜色比例矢量并计算与人脸模板之间的距离
        d = distance(detect_color_vec, face_template);
        % 根据阈值判断是否需要纳入考虑，统一把距离记录在框的左上角点
        if d < epsilon
            if dis_record((h_select - h_repeat):(h_select + h_repeat),(w_select - w_repeat):(w_select + w_repeat)) == zeros(1 + 2 * h_repeat, 1 + 2 * w_repeat)
                dis_record(h_select, w_select) = d;
            else
                % 识别框去重，取距离最小的
                [dup_row, dup_col, dup_d] = find(dis_record((h_select - h_repeat):(h_select + h_repeat),(w_select - w_repeat):(w_select + w_repeat)));
                for num=1:length(dup_row)
                    if d < dup_d(num)%只保留一个
                        dis_record(dup_row(num) - 1 + h_select - h_repeat,dup_col(num) - 1 + w_select - w_repeat) = 0;
                        dis_record(h_select, w_select) = d;
                    else
                        dis_record(h_select, w_select) = 0;
                        break
                    end
                end
            end
        end
    end
end

% 画红框
[row, col] = find(dis_record);%boxes有x个非零值--x个框,row x col,img(row,col)表示框的左上角点
for num=1:length(row)
    test_img = draw_redrec(test_img,row(num),col(num),detect_window);
end

end

% 计算区域特征与人脸模板的相近程度（即距离）
function d = distance(test, template)
    d = 1 - sum(sqrt(test .* template));
end
