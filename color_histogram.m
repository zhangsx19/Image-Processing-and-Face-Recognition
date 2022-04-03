function face_template = color_histogram(L) 
%从训练集中根据输入参数L得到人脸模板，需将样本置于同目录的data/Faces文件夹下
%face_template：人脸模板的颜色矢量v
% L:选取二进制高L位
    face_template = zeros(2^(3 * L), 1);
    % 将图片读取进来并得到人脸标准
    img_folder = 'data/Faces/';
    img_list = dir(img_folder);
    % img_list前两个是"."和"..", 所以计数从3开始
    for img_name=3:length(img_list)
        image = imread([img_folder, img_list(img_name).name]);
        %所有图片的颜色向量u(R)累加，512*1
        face_template = face_template + img2color_vec(image, L);
    end
    % img_list前两个是"."和"..", 所以除以长度-2
    face_template = face_template / (length(img_list) - 2);
end
