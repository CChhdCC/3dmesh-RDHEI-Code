function bitArray = vertexToBinaryArray(Vertex, bit_len)
    % 输入：
    % Vertex: 大小为 vertex_num * 3 的矩阵
    % bit_len: 每个数字要转换为的二进制位数

    % 获取顶点数
    [vertex_num, ~] = size(Vertex);
    
    % 初始化结果数组
    bitArray = zeros(1, vertex_num * 3 * bit_len);
    
    % 计数器，用于将每个二进制数字存入结果数组的正确位置
    counter = 1;
    
    % 遍历 Vertex 矩阵的每个元素
    for i = 1:vertex_num
        for j = 1:3
            % 获取当前的数字
            num = Vertex(i, j);
            
            % 将数字转换为二进制字符串
            if num >= 0
                binStr = dec2bin(num, bit_len);  % 正数的二进制转换
            else
                error('warning:存在负数');
                %binStr = dec2bin(bitcmp(abs(num), bit_len), bit_len);  % 负数处理
            end
            
            % 将二进制字符串转换为 0 和 1 并存入结果数组
            for k = 1:bit_len
                bitArray(counter) = str2double(binStr(k));
                counter = counter + 1;
            end
        end
    end
end


