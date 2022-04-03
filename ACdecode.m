function ac_coeff = ACdecode(ACList, ACTAB, col)
%函数功能：把AC码流还原为AC系数
%ACList是1*23072行向量,AC码流
%ACTAB:AC码表
%col: AC系数矩阵的个数 即有图片分为col个8*8矩阵块
    ZRL = [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1];
    EOB = [1, 0, 1, 0];
    ac_coeff = zeros(63, col);
    b = 1;pos = 0;
    while(b <= col)
        %AC系数矩阵的非零系数被转换完后，就被删除掉
        if(all(ACList(1:4) == EOB))%结束符说明一个AC系数矩阵已经转换完，b++
            b = b + 1;
            pos = 0;
            ACList(1:4) = [];
        elseif(length(ACList) > 11 && all(ACList(1:11) == ZRL))%判断遇到了16个连零
            pos = pos + 16;
            ACList(1:11) = [];
        else
            %取run和size，size即对应Amplitude的bit数，即Huffman_code后面的size比特即为AC非零系数的二进制
            %ACTAB第一列是Run,第二列是size,第三列是码长，以后则是Huffman_code
            for c = 1:size(ACTAB, 1)%按表2.3从上到下的顺序一个个匹配Run/size
                L = ACTAB(c, 3);%码长
                %若码长比ACList剩下的长度还长，肯定不是该Huffman_code,也是防止索引超出数组元素的数目
                if(L > length(ACList))
                    continue;
                end
                if(all(ACList(1:L) == ACTAB(c, 4:L + 3)))
                    ac_run = ACTAB(c, 1);%表示非零系数前面有几个零
                    ac_size = ACTAB(c, 2);
                    ACList(1:L) = [];
                    break;
                end
            end
            pos = pos + ac_run + 1;%表示非零系数在zig_zag后的系数向量中的位置
            %同DC系数，把amplitude表示的二进制转换为十进制的AC系数
            amplitude = ACList(1:ac_size);
            if(amplitude(1) == 1)
                ac_coeff(pos, b) = bin2dec(num2str(amplitude, '%d'));
            else
                ac_coeff(pos, b) = -bin2dec(num2str(~amplitude, '%d'));
            end
            ACList(1:ac_size) = [];%转换完的一个非零系数就在码流中删除掉
        end
    end
end