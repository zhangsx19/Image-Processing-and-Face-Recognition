function P = myidct(C)%myidct 自己写的进行DCT逆变换的函数
% 输入C需为方阵
[height,width] = size(C);
assert(height==width, "input isn't a square matrix");
%C:经DCT变换的图像矩阵
    C = double(C);
    N = size(C, 1);
    D = cos((1:2:(2 * N - 1)) .* (0:1:(N - 1))' * pi / 2 / N);
    D(1, :) = sqrt(0.5);
    D = sqrt(2 / N) * D;
    P = D' * C * D;
end

