%%
tic;
clear; clc;close all;
addpath(genpath(pwd));
% vextex0: Original vertex information
% vextex1: Encrypted vertex information
% vextex2: Vertex information embedded in secret data after encryption
% vextex3: Vertex information after extraction and restoration

fid = fopen('results-380.txt','w'); % Save output
%dataset = dir('origin');
dataset = dir('380');
testmodel = dir('testmodel');
files = dataset;
[num, ~]= size(files);
C = 0;
Capacity = [];
K_en = 2024;%加密
K_fix = 114;%混洗
K_emb = 514;%嵌入加密
for i = 1 : num
    if strfind(files(i).name,'.off')% if strfind(files(i).name,'.ply') %Read a file in .ply format
        name = files(i).name;
    else
        continue;
    end
    %source_dir = ['origin/',name];
    source_dir = ['380/',name];
    display(name)
    fprintf(fid, '%s\n',name);
    display('m        capacity        nocost_capacity             hd                   snr             hd_str                   snr_str');
    fprintf(fid, 'm          capacity        nocost_capacity             hd               snr             hd_str                   snr_str\n');
    m = 5;% Vertex information storage accuracy m  模型顶点存储精度由m决定。
    %% Read a 3D mesh file  读取文件
    
    [~, file_name, suffix] = fileparts(source_dir);
    if(strcmp(suffix,'.obj')==0) %off
        [vertex, face] = read_mesh(source_dir);
        vertex = vertex'; face = face';
    else %obj
        Obj = readObj(source_dir);
        vertex = Obj.v; face = Obj.f.v;
    end
    vertex0 = 1-vertex;
    %% Preprocessing  预处理
    magnify = 10^m;
    [Vertex, bit_len] = meshPrepro(m, vertex0);%预处理后顶点是Vertex
    
    vertex_num = size(Vertex,1);%顶点数目
    face_num =  size(face,1);%面数目
     fprintf('Vertex_num: %d \n ', vertex_num);
     fprintf('Face_num: %d \n ', face_num);
    %% 获取与每个顶点相关的信息
    vertex_related = GetRelatedVertex(Vertex, face);
    
        % 显示结果
%         for i = 1:length(vertex_related)
%             fprintf('Vertex ID: %d | ', vertex_related(i).id);
%             fprintf('Position: [%.2f, %.2f, %.2f] | ', vertex_related(i).pos);
%             fprintf('Relative Vertices: %s\n ', num2str(vertex_related(i).relative));
%         end
    %% 生成树信息
    %
    % 使用DFS方法生成树
    [vertex_roots_dfs, related_trees_dfs] = GetTreesFromVertexRelatedDFS(vertex_related);
    %
        disp('DFS生成的树结构:');
        disp(related_trees_dfs);
    
        % 显示生成树结果
%         for i = 1:length(related_trees_dfs)
%             fprintf('Vertex ID: %d | ', related_trees_dfs(i).id);
%             fprintf('child Vertices: %s\n ', num2str(related_trees_dfs(i).child));
%         end
    %
%     disp('dFS生成树的根节点:');
%     disp(vertex_roots_dfs);
    %
         % 显示根节点结果
%         for i = 1:length(vertex_roots_dfs)
%             fprintf('****************Vertex root ID: %d \n ', vertex_roots_dfs(i));
%         end
    fprintf('根节点数目: %d \n ', length(vertex_roots_dfs));
    % 可视化DFS生成的树
    
    % visualizeRelatedTrees(related_trees_dfs, sprintf('DFS Tree %d', i));
    %%
    % 使用BFS方法生成树
    %[vertex_roots_bfs, related_trees_bfs] = GetTreesFromVertexRelatedBFS(vertex_related);
    
    %     disp('BFS生成的树结构:');
    %     disp(related_trees_bfs);
    %
    %     显示生成树结果
    %     for i = 1:length(related_trees_bfs)
    %         fprintf('Vertex ID: %d | ', related_trees_bfs(i).id);
    %         fprintf('child Vertices: %s\n ', num2str(related_trees_bfs(i).child));
    %     end
    %
    %disp('BFS生成树的根节点:');
    %disp(vertex_roots_bfs);
    %
    %     显示根节点结果
    %     for i = 1:length(vertex_roots_bfs)
    %         fprintf('****************Vertex root ID: %d \n ', vertex_roots_bfs(i));
    %     end
    
    
    
    % 可视化BFS生成的树
    %visualizeRelatedTrees(related_trees_bfs, sprintf('BFS Tree %d', i));
    %%
    % 使用SMTT方法生成树
    %[vertex_roots_smtt, related_trees_smtt] = GetTreesFromVertexRelatedSMTT(vertex_related);
    %
    %     disp('SMTT生成的树结构:');
    %     disp(related_trees_smtt);
    %
    %     % 显示生成树结果
    %     for i = 1:length(related_trees_smtt)
    %         fprintf('Vertex ID: %d | ', related_trees_smtt(i).id);
    %         fprintf('child Vertices: %s\n ', num2str(related_trees_smtt(i).child));
    %     end
    %
    %
    %disp('SMTT生成树的根节点:');
    %disp(vertex_roots_smtt);
    %
    %     % 显示根节点结果
    %     for i = 1:length(vertex_roots_smtt)
    %         fprintf('****************Vertex root ID: %d \n ', vertex_roots_smtt(i));
    %     end
    %
    % 可视化生成的树
    %visualizeRelatedTrees(related_trees_smtt, sprintf('SMTT Tree %d', i));
    
    %% MSB替换
    
    [MSBLength_Statistics,MultiMSB_ProcessedModel] = GetMSBLengthAndLSBPos(Vertex,vertex_roots_dfs,related_trees_dfs, bit_len);
    
%     figure;
%     bar(MSBLength_Statistics);
    
    % 显示MSB替换结果
%     for i = 1:length(MultiMSB_ProcessedModel)
%         fprintf('Vertex ID: %d || ', MultiMSB_ProcessedModel(i).id);
%         fprintf('msbx_length: %d | ', MultiMSB_ProcessedModel(i).msbx_length);
%         fprintf('lsbx: %s || ', MultiMSB_ProcessedModel(i).lsbx);
%         fprintf('msby_length: %d | ', MultiMSB_ProcessedModel(i).msby_length);
%         fprintf('lsby: %s || ', MultiMSB_ProcessedModel(i).lsby);
%         fprintf('msbz_length: %d | ', MultiMSB_ProcessedModel(i).msbz_length);
%         fprintf('lsbz: %s \n ', MultiMSB_ProcessedModel(i).lsbz);
%     end
    
    %% Huffman编码
    [HuffmanCodes,avglen] = GenerateHuffmanCodes(MSBLength_Statistics);
    
    % 显示Huffman编码
%     for i = 1:length(HuffmanCodes)
%         fprintf('Symbol: %d, Code: %s\n', HuffmanCodes(i).Symbol, HuffmanCodes(i).Code);
%     end
    
    %% 比特流整合
    [strStream,vocated_room,param_length] = CompressedStream( m,bit_len,HuffmanCodes,MultiMSB_ProcessedModel,vertex_roots_dfs);

    vocated_len = binstr2dec(vocated_room);
    ER = vocated_len/length(vertex);
    ER_noCost = (vocated_len + param_length)/length(vertex);
    
    fprintf('%s ER: %f\n', name, ER);
    fprintf('%s No Cost ER: %f\n', name, ER_noCost);
    
    %% 加密比特流，生成加密后的模型
    
    Vertex_en = StreamEncryption(strStream ,vertex_num,vocated_len, K_en, K_fix, bit_len, magnify);
    
    %% 嵌入信息，生成载密模型
    
    Vertex_stored = EmbInfo(Vertex_en,K_fix, K_emb, m);
    
    %% 还原模型，还原信息
    
    %还原信息
    Emb_array = restoreInfomation(Vertex_stored,K_fix, K_emb,m);
    %还原模型顶点
    Vertex_restore = restoreVertex(Vertex_stored,face,K_fix, K_en,m, strStream,Vertex);
    
    %% Print models 展示不同阶段模型
%     figure,
%     plot_mesh(vertex,face);%原始模型
%     figure,
%     plot_mesh(Vertex_en,face);%加密模型
%     figure,
%     plot_mesh(Vertex_stored,face);%载密模型
%     figure,
%     plot_mesh(Vertex_restore,face);%还原模型
     %% Experimental result 实验结果
    %Compute HausdorffDist
    hd = HausdorffDist(vertex,Vertex_restore,1,0);
    %Compute SNR
    snr = meshSNR(vertex,Vertex_restore);
     %Compute HausdorffDist_str
    hd_str = HausdorffDist(vertex,Vertex_stored,1,0);
    %Compute SNR_str
    snr_str = meshSNR(vertex,Vertex_stored);
    %Compute capacity
    [vex_num, ~] = size(vertex);
    capacity = ER;
    nocost_capacity = ER_noCost;
    C = C + capacity;
    fprintf(fid,'%d          %f         %f         %e          %f         %e          %f\n', m,capacity, nocost_capacity,hd, snr,hd_str, snr_str);
    display([num2str(m),'                ',num2str(capacity),'                    ', num2str(nocost_capacity),'                    ',num2str(hd),'                  ',num2str(snr),'                    ',num2str(hd_str),'                  ',num2str(snr_str)]);
    Capacity = [Capacity, capacity];
    
    
    
    
    
    
    
end
avecapacity = C / (num-3);
 display(avecapacity);
toc;

% 关闭文件
fclose(fid);