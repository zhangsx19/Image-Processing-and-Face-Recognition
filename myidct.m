function P = myidct(C)%myidct �Լ�д�Ľ���DCT��任�ĺ���
% ����C��Ϊ����
[height,width] = size(C);
assert(height==width, "input isn't a square matrix");
%C:��DCT�任��ͼ�����
    C = double(C);
    N = size(C, 1);
    D = cos((1:2:(2 * N - 1)) .* (0:1:(N - 1))' * pi / 2 / N);
    D(1, :) = sqrt(0.5);
    D = sqrt(2 / N) * D;
    P = D' * C * D;
end

