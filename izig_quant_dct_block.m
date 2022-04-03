function image = izig_quant_dct_block(image_quantified, QTAB, height, width)
%iquantify 实现逆zigzag、反量化、IDCT、逆分块和+128功能
%   image_quantified:图像的量化矩阵
%   QTAB:量化系数
%   height: 原始图像高度
%   width: 原始图像宽度
h = ceil(height / 8);
w = ceil(width / 8);
img = zeros(8 * h, 8 * w);
%实现逆zigzag、反量化、IDCT
for a = 1:h
    for b = 1:w
        %注意重建时的块要一一对应
        img((8 * a - 7):(8 * a), (8 * b - 7):(8 * b)) = idct2(myizigzag(image_quantified(:,w  * (a - 1) + b)) .* QTAB);
    end
end
%舍去多余，+128
image = img(1:height, 1:width);
image = uint8(image + 128);
end