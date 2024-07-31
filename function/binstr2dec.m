function decValue = binstr2dec(binStr)
    % binstr2dec 将一个二进制字符串转换为十进制数值
    %   decValue = binstr2dec(binStr) 将二进制字符串 binStr 转换为十进制数值
    %
    %   binStr: 输入的二进制字符串
    %   decValue: 输出的十进制数值

    % 检查输入是否为字符串
    if ~ischar(binStr) && ~isstring(binStr)
        error('输入必须是一个字符串');
    end
    
    % 检查输入字符串是否仅包含 '0' 和 '1'
    if any(binStr ~= '0' & binStr ~= '1')
        error('输入字符串只能包含 ''0'' 和 ''1''');
    end
    
    % 将二进制字符串转换为十进制数值
    decValue = 0;
    len = length(binStr);
    for i = 1:len
        bit = str2double(binStr(i));
        decValue = decValue + bit * 2^(len - i);
    end
end


