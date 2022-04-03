function image_processed = preprocess(image)
%prepocess 预处理图像，将宽高补足成8的倍数
%数字图像的原点位于左上角，其中正 x 轴向下延伸，正 y 轴向右延伸,所以是向右向下补足
%   image:原始图像
image_processed = double(image);
[h, w] = size(image_processed);
a = mod(w, 8);
b = mod(h, 8);
if a ~= 0
    col_block = zeros(h, 8 - a);
    col = image_processed(:, w);
    for num=1:(8 - a)
        col_block(:, num) = col;
    end
    image_processed = [image_processed col_block];
end
[h, w] = size(image_processed);
if b ~= 0
    row_block = zeros(8 - b, w);
    row = image_processed(h, :);
    for num=1:(8 - b)
        row_block(num, :) = row;
    end
    image_processed = [image_processed; row_block];
end
end
