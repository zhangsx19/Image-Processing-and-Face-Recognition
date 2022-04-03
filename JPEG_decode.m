function image = JPEG_decode(DC, AC, height, width, QTAB, ACTAB)
%JpegDecode
%   DC: DC码流
%   AC: AC码流
%   height: 原始图像高度
%   width: 原始图像宽度
%   QTAB: 量化系数
%   ACTAB: AC码本
col = ceil(height / 8) * ceil(width / 8);
image_quantified = zeros(64, col);
% 解码出DC系数
dc_coeff = DCdecode(DC, col);
image_quantified(1,:) = dc_coeff;
% 解码出AC系数
ac_coeff = ACdecode(AC, ACTAB, col);
image_quantified(2:64,:) = ac_coeff;
% 逆zigzag、反量化、IDCT、拼接和+128
image = izig_quant_dct_block(image_quantified, QTAB, height, width);
end
