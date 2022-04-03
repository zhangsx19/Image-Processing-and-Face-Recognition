function C = mydct(P)
% 输入P需为方阵
[height,width] = size(P);
assert(height==width, "input isn't a square matrix");
C = double(P);
N = size(P, 1);%保证D和P大小相同
D = cos((1:2:(2 * N - 1)) .* (0:1:(N - 1))' * pi / 2 / N);%构建DCT矩阵
D(1, :) = sqrt(0.5);
D = sqrt(2 / N) * D;
C = D * C * D';
end
