function [Vertex_stored] = EmbInfo(Vertex_en,K_fix, K_emb, m_pricision)
%EMBINFO 此处显示有关此函数的摘要
%   此处显示详细说明
% 输入：
% 加密后的Vertex_en;
% 混洗密钥K_fix；
% 嵌入信息密钥K_emb;
% 模型顶点存储精度m_pricision;
% 
% 输出：
% 载密模型Vertex_stored

vocated_len = 32;%32位表示空出的空间

%% 1. 将顶点标准化

    %vertex0 = 1-Vertex_en;
    %Preprocessing  预处理
    [~, bit_len] = meshPrepro(m_pricision, Vertex_en);%预处理后顶点是Vertex
    magnify = 10^m_pricision;
    Vertex_10 = Vertex_en*magnify;%预处理后顶点是Vertex
    
    vertex_num = size(Vertex_10,1);%顶点数目
    
    bitArray = vertexToBinaryArray(Vertex_10, bit_len);%顶点转化为二进制数组
    [~,total_length] = size(bitArray);
    
%% 2. 反混洗，获取长度
   vertex_restore = restoreMatrix(bitArray,K_fix);
   length_array = vertex_restore(end-vocated_len+1:end);
   Vertex_length = bin2dec(char(length_array + '0')); %十进制的空出空间长度
   
%% 3. 嵌入加密的信息

    % 设置随机数生成器的种子为 K_emb
    rng(K_emb);
    
    % 生成一个大小为 1*n 的 0 和 1 随机数组
    info_array = randi([0, 1], 1, Vertex_length);
    
    % 嵌入信息
    vertex_restore(total_length-vocated_len-Vertex_length+1:total_length-vocated_len) = info_array;
    
%% 4. 混洗，重新生成载密顶点
    Vertex_stored_fixed = shuffleMatrix(vertex_restore, K_fix);  % 混洗过程
    
    % 将混洗后的数据流分配到 vertex_store 中
    vertex_store = zeros(vertex_num, 3);  % 初始化最终加密的顶点矩阵
    for i = 1:vertex_num
        for j = 1:3  % 每行有 3 列 (x, y, z 坐标)
            start_idx = (i-1)*3*bit_len + (j-1)*bit_len + 1;
            end_idx = start_idx + bit_len - 1;
            vertex_bin = Vertex_stored_fixed(start_idx:end_idx);  % 取出 bit_len 位
            vertex_store(i, j) = bin2dec(char(vertex_bin + '0'));  % 将二进制转为十进制
        end
    end
    
    % 5. 将其转化为小数表示，并还原（1-vertex_store）
    vertex_store = vertex_store/magnify;
    Vertex_stored = 1 - vertex_store;

end
