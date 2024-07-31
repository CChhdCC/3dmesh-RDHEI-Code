function [vertex_roots, related_trees] = GetTreesFromVertexRelatedDFS(vertex_related)
%   vertex_related 关联顶点结构体
%   vertex_roots 根节点
%   related_trees 相关树节点结构体
    num_vertices = length(vertex_related);
    visited = false(1, num_vertices);
    vertex_roots = [];
    related_trees(num_vertices) = struct('id', [], 'child', []);
    
    function [tree] = dfs(vertex_id)
        tree.id = vertex_id;
        tree.child = [];
        visited(vertex_id) = true;
        
        for neighbor = vertex_related(vertex_id).relative
            if ~visited(neighbor)
                tree.child = [tree.child, neighbor];
                child_tree = dfs(neighbor);
                related_trees(neighbor).id = child_tree.id;
                related_trees(neighbor).child = child_tree.child;
            end
        end
        
        if isempty(tree.child)
            tree.child = 0; % If no child, set to 0
        end
    end

    for i = 1:num_vertices
        if ~visited(i)
            vertex_roots = [vertex_roots, i];
            tree = dfs(i);
            related_trees(i).id = tree.id;
            related_trees(i).child = tree.child;
        end
    end
end


