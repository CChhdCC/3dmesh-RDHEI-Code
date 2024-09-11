function [Vertex_restore] = restoreVertex(Vertex_stored,face,K_fix, K_en,m_pricision, strStream,Vertex)
%RESTOREVERTEX 此处显示有关此函数的摘要
% %   此处显示详细说明
% 函数功能：还原模型顶点的
% restoreVertex()
% 输入：
% 载密模型vertex_stored
% 顶点拓扑关系face
% 混洗密钥K_fix；
% 加密密钥K_en；
% 模型顶点存储精度m;
% 
% 输出：
% 还原模型顶点vertex_restore

vocated_len = 32;%32位表示空出的空间(规定)

%% 1. 将顶点标准化

    %vertex0 = 1-Vertex_en;
    %Preprocessing  预处理
    [~, bit_len] = meshPrepro(m_pricision, Vertex_stored);%预处理后顶点是Vertex
    magnify = 10^m_pricision;
    %Vertex_10 = Vertex_stored%*magnify;%预处理后顶点是Vertex
    
    vertex_num = size(Vertex_stored,1);%顶点数目
    
    bitArray = vertexToBinaryArray(Vertex_stored, bit_len);%顶点转化为二进制数组
    [~,total_length] = size(bitArray);
    
%% 2. 反混洗，获取长度
    vertex_restore = restoreMatrix(bitArray,K_fix);
    length_array = vertex_restore(end-vocated_len+1:end);
    Vertex_length = bin2dec(char(length_array + '0')); %十进制的空出空间长度
    
%% 3. 使用密钥 Ken 生成一个 0 和 1 的随机矩阵，与 Vertex_befor_encry_array 异或操作
    rng(K_en);  % 设置随机种子为 Ken 密钥
    random_matrix = randi([0, 1], 1, total_length);  % 生成随机 0,1 矩阵
    vertex_unencryed = xor(vertex_restore, random_matrix);  % 异或操作
    
%% 获取并拆分比特流序列
    bitstream = vertex_unencryed(1:total_length-Vertex_length-vocated_len);
    
    % 将字符串转换为数字数组
    strArray = char(strStream)-'0';
    
    % 判断二者是否相等（逐元素比较）
    if isequal(strArray, bitstream)
        fprintf('压缩比特流准确\n');
    else
         fprintf('压缩比特流准确异常，：\n');
    end
    
%% 提取Huffman编码
    num_ptr = 0;%计数指针
    
    m = bitstream(num_ptr+1:num_ptr+4);%精度值
    num_ptr = num_ptr+4;
    
    HuffmanLen_array = bitstream(num_ptr+1:num_ptr+16);%
    num_ptr = num_ptr+16;
    Huffman_length = bin2dec(char(HuffmanLen_array + '0'));
    
    HuffmanCode_array = bitstream(num_ptr+1:num_ptr+Huffman_length);%
    num_ptr = num_ptr+Huffman_length;
    strHuffmanCode = char(HuffmanCode_array+ '0');
    
    HuffmanTable = decodeHuffmanCodes(strHuffmanCode);%Huffman编码表
    
    HuffmanTree = buildHuffmanTree(HuffmanTable);

%% 构建生成树

    % 获取与每个顶点相关的信息
    vertex_related = GetRelatedVertex(Vertex_stored, face);
    % 使用DFS方法生成树
    [vertex_roots_dfs, related_trees] = GetTreesFromVertexRelatedDFS(vertex_related);
    
%% 提取根节点
    num_roots = length(vertex_roots_dfs);
    
    MultiMSB_ProcessedModel_Roots(num_roots) = struct('id', [], 'msbx_length', [], 'lsbx', "",'msby_length', [], 'lsby', "",'msbz_length', [], 'lsbz', "");
    for i=1:num_roots %获取根节点信息
         MultiMSB_ProcessedModel_Roots(i).id = vertex_roots_dfs(i);%struct('id', vertex_roots_dfs(i), 'msbx_length', 0, 'lsbx', strThisPosX ,'msby_length', 0, 'lsby', strThisPosY ,'msbz_length', 0, 'lsbz', strThisPosZ);
         MultiMSB_ProcessedModel_Roots(i).msbx_length = 0;
         MultiMSB_ProcessedModel_Roots(i).lsbx = char(bitstream(num_ptr+1:num_ptr+bit_len)+'0');
         num_ptr=num_ptr+bit_len;
         
         MultiMSB_ProcessedModel_Roots(i).msby_length = 0;
         MultiMSB_ProcessedModel_Roots(i).lsby =char(bitstream(num_ptr+1:num_ptr+bit_len)+'0');
         num_ptr=num_ptr+bit_len;
         
         MultiMSB_ProcessedModel_Roots(i).msbz_length = 0;
         MultiMSB_ProcessedModel_Roots(i).lsbz =char(bitstream(num_ptr+1:num_ptr+bit_len)+'0');
         num_ptr=num_ptr+bit_len;
    end

    %% 提取非根结点
    
    NotRoot_array = bitstream(num_ptr+1:end);
    strNotRoot = char(NotRoot_array+'0');
    num_notRoot = vertex_num - num_roots;
    
    notRootNodes = decodeNonRootNodes(strNotRoot, HuffmanTree, bit_len, num_notRoot);
    
    MultiMSB_ProcessedModel(vertex_num) = struct('id', [], 'msbx_length', [], 'lsbx', "",'msby_length', [], 'lsby', "",'msbz_length', [], 'lsbz', "");
    notRoot_ptr = 1;
    for j = 1:vertex_num
       % 判断是否是根节点，给根节点赋值
        if any(vertex_roots_dfs == j)
           continue;
        end
        if notRoot_ptr > vertex_num
            error('重构非根节点结构数组出错');
        end
        MultiMSB_ProcessedModel(j).id = j;%struct('id', vertex_roots_dfs(i), 'msbx_length', 0, 'lsbx', strThisPosX ,'msby_length', 0, 'lsby', strThisPosY ,'msbz_length', 0, 'lsbz', strThisPosZ);
         MultiMSB_ProcessedModel(j).msbx_length = notRootNodes(notRoot_ptr).msbx_length;
         MultiMSB_ProcessedModel(j).lsbx = notRootNodes(notRoot_ptr).lsbx;
         
         MultiMSB_ProcessedModel(j).msby_length = notRootNodes(notRoot_ptr).msby_length;
         MultiMSB_ProcessedModel(j).lsby = notRootNodes(notRoot_ptr).lsby;
         
         MultiMSB_ProcessedModel(j).msbz_length =  notRootNodes(notRoot_ptr).msbz_length;
         MultiMSB_ProcessedModel(j).lsbz = notRootNodes(notRoot_ptr).lsbz;
         notRoot_ptr = notRoot_ptr+1;
    end
    
    %% 反向MSB替换     
    vertex_restruct = restoreVerticesFromMSB(MultiMSB_ProcessedModel_Roots, MultiMSB_ProcessedModel, related_trees, bit_len);
    %fprintf('反向MSB替换\n');
    
    if isequal(vertex_restruct, Vertex)
        fprintf('压缩比特流准确\n');
    else
         fprintf('压缩比特流准确异常，：\n');
    end
    
    vertex_restruct = vertex_restruct/magnify;
    Vertex_restore = 1-vertex_restruct;


end

