function [vertex_roots, related_trees] = GetTreesFromVertexRelatedSMTT(vertex_related)
    num_vertices = length(vertex_related);
    visited = false(1, num_vertices);
    vertex_roots = [];
    related_trees = struct('id', [], 'child', []);

    function node = traverse(vertex_id)
        node.id = vertex_id;
        node.child = [];
        visited(vertex_id) = true;
        related_trees(vertex_id) = struct('id', vertex_id, 'child', []);
        queue = [vertex_id];
        A = vertex_id;

        while ~isempty(queue)
            current_id = queue(1);
            queue(1) = [];
            neighbors = vertex_related(current_id).relative;
            unvisited_neighbors = neighbors(~visited(neighbors));

            if isempty(unvisited_neighbors)
                % No unvisited neighbors, find the next vertex with unvisited neighbors
                for i = 1:length(A)
                    current_id = A(i);
                    neighbors = vertex_related(current_id).relative;
                    unvisited_neighbors = neighbors(~visited(neighbors));
                    if ~isempty(unvisited_neighbors)
                        queue = [queue, current_id];
                        break;
                    end
                end
            end

            if ~isempty(unvisited_neighbors)
                next_id = unvisited_neighbors(1);
                A = [A, next_id];
                visited(next_id) = true;
                queue = [queue, next_id];
                
                % Find the node in the tree to attach the new child
                new_child = traverse(next_id);
                related_trees(current_id).child = [ related_trees(current_id).child, next_id];
            end
        end

        if isempty(related_trees(current_id).child)
            related_trees(current_id).child = 0; % If no child, set to 0
        end
        
        node.child = related_trees(current_id).child;
        
    end

    for i = 1:num_vertices
        if ~visited(i)
            vertex_roots = [vertex_roots, i];
            node = traverse(i);
            %related_trees = [related_trees, tree];
        end
    end
end

