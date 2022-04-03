function AC = AC_process(AC_coef, ACTAB, blocks)
%计算AC码流
ZRL = [1 1 1 1 1 1 1 1 0 0 1];%16个连零编码为1111-1111-001
EOB = [1 0 1 0];
AC = [];
for i = 1:blocks
    block = AC_coef(:, i);%63*1 一个AC系数块
    while(true)
        % find 第一个非零系数
        %c_ind表示这个系数在block(不断缩短）的第几个位置，c_mag即为这个系数的值
        [c_ind, ~, c_mag] = find(block, 1);
        if(isempty(c_ind))
            break;%block已经没有非零系数
        end
        c_run = c_ind - 1;%c_run的值表示这个系数前面有几个零
        while(c_run > 15)%当run>15时，插入ZRL表示16个连零
            c_run = c_run - 16;%减16后剩下的零也要参与huffman的计算
            AC = [AC, ZRL];
        end
        c_size = ceil(log2(abs(c_mag)+1));%计算size(即DC的Category）
        huffman = ACTAB(c_run * 10 + c_size,4:ACTAB(c_run * 10 + c_size, 3) + 3);%计算对应的huffman
        AC_magnitude = dec2bin_j(c_mag);%计算magnitude
        AC = [AC, huffman, AC_magnitude];%一个AC系数块算完，还要连上之前的AC系数的AC码流
        block(1:c_ind) = [];%没循环一次，block都删掉第一个非零系数及其之前的零
    end
    AC = [AC, EOB];%计算出AC，加上结束符
end
end