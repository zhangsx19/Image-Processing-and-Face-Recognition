function color_vec = img2color_vec(img, L)
%��ͼ�����Lת�����ɫ��������v�ĺ�����L����ѡȡ�����Ƹ�Lλ
%   img:ͼ��
%   L:ѡȡ�����Ƹ�Lλ
    color_vec = zeros(2^(3 * L), 1);
    % ��ȡǰLλ����Ϊ��������Ҫ������λ��������չλ��
    %image��С��ͼƬ��С
    image = double(bitshift(img, -(8 - L)));
    color_list = bitshift(image(:, :, 1), 2 * L) + bitshift(image(:, :, 2), L) + image(:, :, 3);
    % չƽ��1ά���飬�����������
    color_list = color_list(:);%ÿһ�����صģ�R<<2L)+(G<<L)+(B)
    %����dirac(P_xy-c(n))
    %color_vec(4)��Ӧn=3,color_vec(4)=sum(color_list==3)
    %��n=color_list(xiangsu),Ӧ�÷ŵ�color_vec(n+1),��length(color_list)<<n����������ѭ��Ч��Զ����nѭ��
    for xiangsu=1:length(color_list)
        n = color_list(xiangsu);
        color_vec(n + 1) = color_vec(n + 1) + 1;
    end
    % ת���ɱ���
    color_vec = color_vec / length(color_list);%sum(color_vec)=1,color_list��ʾ���ص�
end
