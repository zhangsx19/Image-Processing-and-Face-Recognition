function output = DC_process(DC_coef, DCTAB)%对每个DC系数计算category、huffman_code和DC_magnitude
        category = ceil(log2(abs(DC_coef)+1)) + 1;%Category = ⌈log2(|Error| + 1)⌉
        huffman_code = DCTAB(category,2:DCTAB(category, 1) + 1);%找到category对应的huffman_code
        DC_magnitude = dec2bin_j(DC_coef);%预测误差的二进制表示（负数为1的补码）
        output = [huffman_code, DC_magnitude];
    end