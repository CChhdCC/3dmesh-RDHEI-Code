function binStr = num2binstr(number, numBits)
    % num2binstr 将一个数字转换为指定位数的二进制字符串
    %   binStr = num2binstr(number, numBits) 将number转换为numBits位的二进制字符串
    %   如果numBits不足以表示number，则会自动增加位数以适应number

    % 检查输入的数字是否为非负整数
    if number < 0 || floor(number) ~= number
        error('输入的数字必须是非负整数');
    end
    
    % 将数字转换为二进制字符串
    binStr = dec2bin(number);
    
    % 检查需要的位数是否大于当前的位数
    if numBits > length(binStr)
        % 补齐位数，在前面加0
        binStr = [repmat('0', 1, numBits - length(binStr)), binStr];
    elseif numBits < length(binStr)
        % 如果指定位数不足以表示数字，发出警告并输出完整位数的字符串
        warning('指定的位数不足以表示输入数字，输出完整位数的二进制字符串');
    end
end


