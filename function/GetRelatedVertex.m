function [vertex_related] = GetRelatedVertex(vertex, face)
    % 获取与每个顶点相关的信息，包括其相邻顶点
    % 输入:
    %   vertex - 顶点位置矩阵 (Nx3)
    %   face - 面信息 (Mx3)
    % 输出:
    %   vertex_related - 包含顶点相关信息的结构体数组

    % 初始化结构体数组
    num_vertices = size(vertex, 1);
    vertex_related(num_vertices) = struct('id', [], 'pos', [], 'relative', []);

    % 构建邻接表
    adjacency_list = cell(num_vertices, 1);
    for i = 1:size(face, 1)
        f = face(i, :);
        for j = 1:3
            for k = 1:3
                if j ~= k
                    adjacency_list{f(j)} = [adjacency_list{f(j)}, f(k)];
                end
            end
        end
    end

    % 移除重复的相邻顶点并填充结构体
    for i = 1:num_vertices
        adjacency_list{i} = unique(adjacency_list{i});
        vertex_related(i).id = i;
        vertex_related(i).pos = vertex(i, :);
        vertex_related(i).relative = adjacency_list{i};
    end
end


