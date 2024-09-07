tic;
clear; clc;close all;

% 示例数据集
vertex = [0 0 0; 1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1];
face = [1 2 3; 1 3 4; 2 3 5; 2 4 6];

% 构建vertex_related
vertex_related = GetRelatedVertex(vertex, face);

% 显示结果
for i = 1:length(vertex_related)
    fprintf('Vertex ID: %d | ', vertex_related(i).id);
    fprintf('Position: [%.2f, %.2f, %.2f] | ', vertex_related(i).pos);
    fprintf('Relative Vertices: %s\n ', num2str(vertex_related(i).relative));
end
%%
% 使用DFS方法生成树
[vertex_roots_dfs, related_trees_dfs] = GetTreesFromVertexRelatedDFS(vertex_related);

% 显示生成树结果
for i = 1:length(related_trees_dfs)
    fprintf('Vertex ID: %d | ', related_trees_dfs(i).id);
    fprintf('child Vertices: %s\n ', num2str(related_trees_dfs(i).child));
end
% 
% % 使用BFS方法生成树
% [vertex_roots_bfs, related_trees_bfs] = GetTreesFromVertexRelatedBFS(vertex_related);
% 
% % 显示生成树结果
% for i = 1:length(related_trees_bfs)
%     fprintf('Vertex ID: %d | ', related_trees_bfs(i).id);
%     fprintf('child Vertices: %s\n ', num2str(related_trees_bfs(i).child));
% end
%%
% 可视化DFS生成的树

visualizeRelatedTrees(related_trees_dfs, sprintf('DFS Tree %d', i));


% 可视化BFS生成的树
%visualizeRelatedTrees(related_trees_bfs, sprintf('BFS Tree %d', i));
%%

% 使用该方法生成树
% [vertex_roots, related_trees] = GetTreesFromVertexRelatedSMTT(vertex_related);

% 显示生成树结果
% for i = 1:length(related_trees)
%     fprintf('Vertex ID: %d | ', related_trees(i).id);
%     fprintf('child Vertices: %s\n ', num2str(related_trees(i).child));
% end

% 显示根节点结果
%     for i = 1:length(vertex_roots)
%         fprintf('****************Vertex root ID: %d \n ', vertex_roots(i));
%     end  

% 可视化生成的树
% visualizeRelatedTrees(related_trees, sprintf('Tree %d', i));

%% MSB替换

[MSBLength_Statistics,MultiMSB_ProcessedModel] = GetMSBLengthAndLSBPos(vertex,vertex_roots_dfs,related_trees_dfs, 8);

figure;
bar(MSBLength_Statistics);

% 显示MSB替换结果
for i = 1:length(MultiMSB_ProcessedModel)
    fprintf('Vertex ID: %d | ', MultiMSB_ProcessedModel(i).id);
    fprintf('msbx_length: %d | ', MultiMSB_ProcessedModel(i).msbx_length);
    fprintf('lsbx: %s | ', MultiMSB_ProcessedModel(i).lsbx);
    fprintf('msby_length: %d | ', MultiMSB_ProcessedModel(i).msby_length);
    fprintf('lsby: %s | ', MultiMSB_ProcessedModel(i).lsby);
    fprintf('msbz_length: %d | ', MultiMSB_ProcessedModel(i).msbz_length);
    fprintf('lsbz: %s | \n', MultiMSB_ProcessedModel(i).lsbz);
end

 %% Huffman编码
    [HuffmanCodes,avglen] = GenerateHuffmanCodes(MSBLength_Statistics);
    
    % 显示Huffman编码
    for i = 1:length(HuffmanCodes)
        fprintf('Symbol: %d, Code: %s\n', HuffmanCodes(i).Symbol, HuffmanCodes(i).Code);
    end



