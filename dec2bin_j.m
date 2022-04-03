    function bin_vec = dec2bin_j(dec_int)%把十进制转换成二进制（负数表示为1补码）
        if(dec_int > 0)
            bin_vec = split(dec2bin(dec_int), '');%是str格式的二进制,且首尾为空
            bin_vec = str2double(bin_vec(2:end - 1))';
        elseif(dec_int == 0)
            bin_vec = [];
        else
            bin_vec = split(dec2bin(abs(dec_int)), '');
            bin_vec = ~str2double(bin_vec(2:end - 1)).';
        end
    end