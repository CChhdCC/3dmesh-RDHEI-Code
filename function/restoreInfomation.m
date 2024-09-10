function [Emb_array] = restoreInfomation(Vertex_stored,K_fix, K_emb,m_pricision)
%RESTOREINFOMATION 此处显示有关此函数的摘要
%   此处显示详细说明
% 函数功能：还原加密信息的
% restoreInfomation()
% 输入：
% 载密模型Vertex_stored
% 混洗密钥K_fix；
% 嵌入信息密钥K_emb;
% 模型顶点存储精度m_pricision;
% 
% 输出：
% (控制台输出数据量比对结果)
% 嵌入的比特流序列Emb_array

vocated_len = 32;%32位表示空出的空间(规定)

%% 1. 将顶点标准化

    %vertex0 = 1-Vertex_en;
    %Preprocessing  预处理
    [~, bit_len] = meshPrepro(m_pricision, Vertex_stored);%预处理后顶点是Vertex
    %magnify = 10^m_pricision;
    %Vertex_10 = Vertex_stored%*magnify;%预处理后顶点是Vertex
    
    %vertex_num = size(Vertex_10,1);%顶点数目
    
    bitArray = vertexToBinaryArray(Vertex_stored, bit_len);%顶点转化为二进制数组
    [~,total_length] = size(bitArray);
    
%% 2. 反混洗，获取长度
    vertex_restore = restoreMatrix(bitArray,K_fix);
    length_array = vertex_restore(end-vocated_len+1:end);
    Vertex_length = bin2dec(char(length_array + '0')); %十进制的空出空间长度
   
%% 3. 获取加密信息序列
    Emb_array = vertex_restore(total_length-vocated_len-Vertex_length+1:total_length-vocated_len);
    
    % 设置随机数生成器的种子为 K_emb
    rng(K_emb);
    
    % 生成一个大小为 1*n 的 0 和 1 随机数组
    info_array = randi([0, 1], 1, Vertex_length);
    
    if isequal(info_array,Emb_array)
        fprintf('嵌入信息提取成功\n');
    else
         fprintf('嵌入信息提取异常，准确率为：\n');
    end

end

