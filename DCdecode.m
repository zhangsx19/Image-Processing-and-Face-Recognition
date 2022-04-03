function dc_coeff = DCdecode(DCList, col)
%函数功能：把DC码流还原为DC系数
%DCList是1*2031行向量
%col: DC系数的个数 即有图片分为col个8*8矩阵块
    dc_coeff = zeros(1, col);
    for b = 1:col
        if(all(DCList(1:2) == 0))
            %对应Huffman=00,catagory=0,预测误差c^D为0，DC码流为00
            DCList(1:2) = [];
            % 因dc_coeff初始化为全0,此时对应dc_coeff(b)已经是0
        else
            %寻找Huffman_code第一个0的位置
            index = find(~DCList, 1);
            % 计算category
            if(index <= 3)%对应category为1到5，Huffman_code固定为3bit
                %Huffman_code为category的二进制表示
                category = bin2dec(num2str(DCList(1:3), '%d')) - 1;
                DCList(1:3) = [];%用完的DC码流就删除掉
            else%对应catagory为6到11；有关系category = index + 2;
                category = index + 2;
                DCList(1:index) = [];
            end
            %根据category和DC码流计算magnitude,category即为magnitude的bit数
            magnitude = DCList(1:category);
            %根据magnitude还原出DC系数（c^D)
            if(magnitude(1) == 1)
                %首bit是1说明是正数，直接把二进制转成十进制
                dc_coeff(b) = bin2dec(num2str(magnitude, '%d'));
            else
                %首bit是0说明是负数(1补码),先逐bit取反，转成十进制后还要加个负号
                dc_coeff(b) = -bin2dec(num2str(~magnitude, '%d'));
            end
            %用完的DC码流就删除掉
            DCList(1:category) = [];
        end
    end
    for c = 2:col%根据c^D和逆差分方程还原得到c~D
        dc_coeff(c) = dc_coeff(c - 1) - dc_coeff(c);
    end
end