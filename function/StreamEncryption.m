function [Vertex_en] = StreamEncryption(strStream ,vertex_num,vocated_len, K_en, K_fix, bit_len, magnify)
%VERTEX 此处显示有关此函数的摘要
%   此处显示详细说明
% 函数输入：
% strStream 比特流字符串；
% 顶点数目vertex_num；
% 加密密钥Ken；
% 混洗密钥Kfix；
% 顶点位数bit_len
% 预处理幂magnify；
% 输出：
% 加密后的vertex_en;

if isstring(strStream)
    strStream = char(strStream);
end

% 1. 转化比特流字符串为长度为 1*len_str 的数字矩阵
    len_str = length(strStream);
    Vertex_befor_encry_array = zeros(1, bit_len * vertex_num * 3);
    Vertex_befor_encry_array(1:len_str) = strStream - '0';  % 转换比特流字符串为数字并填入矩阵

    % 2. 使用密钥 Ken 生成一个 0 和 1 的随机矩阵，与 Vertex_befor_encry_array 异或操作
    rng(K_en);  % 设置随机种子为 Ken 密钥
    random_matrix = randi([0, 1], 1, bit_len * vertex_num * 3);  % 生成随机 0,1 矩阵
    Vertex_encryed_array = xor(Vertex_befor_encry_array, random_matrix);  % 异或操作

    % 将嵌入长度 vocated_len 写入加密数据流的末尾 32 位
    vocated_bin = dec2bin(vocated_len, 32) - '0';  % 32 位二进制表示
    Vertex_encryed_array(end-31:end) = vocated_bin;  % 将 vocated_len 写入末尾

    % 3. 使用密钥 Kfix 生成混洗矩阵，进行混洗
    rng(K_fix);  % 设置随机种子为 Kfix 密钥
    Vertex_encryed_fixed = shuffleMatrix(Vertex_encryed_array, K_fix);  % 混洗过程

    % 4. 将混洗后的数据流分配到 vertex_en 中
    vertex_en = zeros(vertex_num, 3);  % 初始化最终加密的顶点矩阵
    for i = 1:vertex_num
        for j = 1:3  % 每行有 3 列 (x, y, z 坐标)
            start_idx = (i-1)*3*bit_len + (j-1)*bit_len + 1;
            end_idx = start_idx + bit_len - 1;
            vertex_bin = Vertex_encryed_fixed(start_idx:end_idx);  % 取出 bit_len 位
            vertex_en(i, j) = bin2dec(char(vertex_bin + '0'));  % 将二进制转为十进制
        end
    end
    
    % 5. 将其转化为小数表示，并还原（1-vertex_en）
    vertex_en = vertex_en/magnify;
    Vertex_en = 1 - vertex_en;
    

end
