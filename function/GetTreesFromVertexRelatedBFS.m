function [vertex_roots, related_trees] = GetTreesFromVertexRelatedBFS(vertex_related)
%   vertex_related 关联顶点结构体
%   vertex_roots 根节点
%   related_trees 相关树节点结构体
    num_vertices = length(vertex_related);
    visited = false(1, num_vertices);
    vertex_roots = [];
    related_trees = struct('id', [], 'child', []);

    function [tree] = bfs(vertex_id)
        queue = [vertex_id];
        visited(vertex_id) = true;
        related_trees(vertex_id) = struct('id', vertex_id, 'child', []);

        while ~isempty(queue)
            current_id = queue(1);
            queue(1) = [];
            current_node = related_trees(current_id);

            for neighbor = vertex_related(current_id).relative
                if ~visited(neighbor)
                    %node_map(current_id).child = [node_map(current_id).child, neighbor];
                    visited(neighbor) = true;
                    queue = [queue, neighbor];
                    related_trees(neighbor) = struct('id', neighbor, 'child', []);
                    current_node.child = [current_node.child, neighbor];
                end
            end

            if isempty(current_node.child)
                current_node.child = 0; % If no child, set to 0
            end

            related_trees(current_id) = current_node;
        end

       tree = related_trees(vertex_id);
    end

    for i = 1:num_vertices
        if ~visited(i)
            vertex_roots = [vertex_roots, i];
            tree = bfs(i);
        end
    end
end
