function color_vec = img2color_vec(img, L)
%将图像根据L转变成颜色比例向量v的函数，L就是选取二进制高L位
%   img:图像
%   L:选取二进制高L位
    color_vec = zeros(2^(3 * L), 1);
    % 抽取前L位，因为后续还需要向左移位，所以延展位数
    %image大小即图片大小
    image = double(bitshift(img, -(8 - L)));
    color_list = bitshift(image(:, :, 1), 2 * L) + bitshift(image(:, :, 2), L) + image(:, :, 3);
    % 展平成1维数组，方便后续计算
    color_list = color_list(:);%每一个像素的（R<<2L)+(G<<L)+(B)
    %计算dirac(P_xy-c(n))
    %color_vec(4)对应n=3,color_vec(4)=sum(color_list==3)
    %即n=color_list(xiangsu),应该放到color_vec(n+1),因length(color_list)<<n，用像素来循环效率远高于n循环
    for xiangsu=1:length(color_list)
        n = color_list(xiangsu);
        color_vec(n + 1) = color_vec(n + 1) + 1;
    end
    % 转换成比例
    color_vec = color_vec / length(color_list);%sum(color_vec)=1,color_list表示像素点
end
