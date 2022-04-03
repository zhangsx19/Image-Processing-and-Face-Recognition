function result = block_dct_quant_zig(hall_gray,QTAB)
%对原始图像进行预处理（将宽高补足成8的倍数）、-128、分块、DCT和量化，结果的矩阵
%每一列为一个块的DCT系数Zig-Zag扫描后形成的列矢量，第一行为各个块的DC系数
%hall_gray 输入的原始图像
%QTAB 量化步长
%result 输出的结果矩阵
img = preprocess(hall_gray) - 128;
fun = @(block_struct) dct_quant_zig(block_struct.data, QTAB);
[height, width] = size(hall_gray);
process = blockproc(img, [8 8], fun);%960*21
result = zeros(64, height*width/64);%先排完21
for a = 0:height*8/64-1%共15
    for b = 1:width/8
        result(:,b+width/8*a) = process(1+64*a:64+64*a,b);%64*315
    end
end
end

function output = dct_quant_zig(input, QTAB)
    C = dct2(input);
    C_quant = round(C ./ QTAB);
    output = myzig_zag(C_quant);%64*1的列向量
end