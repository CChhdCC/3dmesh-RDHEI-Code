function vertex_restruct = restoreVerticesFromMSB(MultiMSB_ProcessedModel_Roots, notRootNodes, related_trees, bit_len)
    % 输入参数：
    num_root = length(MultiMSB_ProcessedModel_Roots);
    num_notRoot = length(notRootNodes);
    vertex_num = length(related_trees);
    
    % 初始化队列和中间存储容器
    queue = zeros(1, vertex_num); % 任务队列，存储节点id
    queue_start = 1;
    queue_end = 1;
    
    % 中间存储容器
    vertex_restruct_2str(vertex_num) = struct('id', [], 'posx', "", 'posy', "", 'posz', "");
    
    % 初始化根节点
    for i = 1:num_root
        root_id = MultiMSB_ProcessedModel_Roots(i).id;
        queue(queue_end) = root_id;
        queue_end = queue_end + 1;
        
        % 存入中间存储结构
        vertex_restruct_2str(root_id).id = root_id;
        vertex_restruct_2str(root_id).posx = MultiMSB_ProcessedModel_Roots(i).lsbx;
        vertex_restruct_2str(root_id).posy = MultiMSB_ProcessedModel_Roots(i).lsby;
        vertex_restruct_2str(root_id).posz = MultiMSB_ProcessedModel_Roots(i).lsbz;
    end
    
    % 处理非根节点
    notRootIndex = 1;  % 初始化 notRootIndex
    
    while queue_start < queue_end
        % 从队首取出当前节点
        current_id = queue(queue_start);
        queue_start = queue_start + 1;
        
        % 获取当前节点的坐标，检查是否存在合法值
        current_posx = vertex_restruct_2str(current_id).posx;
        current_posy = vertex_restruct_2str(current_id).posy;
        current_posz = vertex_restruct_2str(current_id).posz;
        
        if isempty(current_posx) || isempty(current_posy) || isempty(current_posz)
            error('当前节点的坐标值为空，无法继续还原');
        end
        
        % 获取子节点
        children = related_trees(current_id).child;
        
        % 遍历所有子节点，进行MSB替换还原
        for child = children
            if child == 0
                continue; % 无子节点，跳过
            end
            
            % 获取非根节点的数据
%             if notRootIndex > num_notRoot
%                 error('notRootNodes中的索引超出范围');
%             end
            nonRootNode = notRootNodes(child);  % 对应notRootNodes中的索引
%             notRootIndex = notRootIndex + 1;
            
            % 还原X坐标
            msbx_length = nonRootNode.msbx_length;
            restored_posx = [current_posx(1:msbx_length), nonRootNode.lsbx];
            if length(restored_posx)~=bit_len
                error('%d posx拼接错误',child);
            end
            
            % 还原Y坐标
            msby_length = nonRootNode.msby_length;
            restored_posy = [current_posy(1:msby_length), nonRootNode.lsby];
             if length(restored_posy)~=bit_len
                error('%d posy拼接错误',child);
            end
            
            % 还原Z坐标
            msbz_length = nonRootNode.msbz_length;
            restored_posz = [current_posz(1:msbz_length), nonRootNode.lsbz];
             if length(restored_posz)~=bit_len
                error('%d posz拼接错误',child);
            end
            
            % 将还原后的坐标存入中间存储结构
            vertex_restruct_2str(child).id = child;
            vertex_restruct_2str(child).posx = restored_posx;
            vertex_restruct_2str(child).posy = restored_posy;
            vertex_restruct_2str(child).posz = restored_posz;
            
            % 将子节点加入队列
            queue(queue_end) = child;
            queue_end = queue_end + 1;
        end
    end
    
    % 检查所有节点是否都有合法的坐标
    for i = 1:vertex_num
        if isempty(vertex_restruct_2str(i).posx) || isempty(vertex_restruct_2str(i).posy) || isempty(vertex_restruct_2str(i).posz)
            error('节点%d的坐标值为空，无法生成最终结果', i);
        end
    end
    
    % 将二进制坐标转换为十进制数值表示
    vertex_restruct = zeros(vertex_num, 3); % 初始化输出矩阵
    
    for i = 1:vertex_num
        % 将二进制字符串转换为十进制数值
        vertex_restruct(i, 1) = bin2dec(vertex_restruct_2str(i).posx);
        vertex_restruct(i, 2) = bin2dec(vertex_restruct_2str(i).posy);
        vertex_restruct(i, 3) = bin2dec(vertex_restruct_2str(i).posz);
    end
end
