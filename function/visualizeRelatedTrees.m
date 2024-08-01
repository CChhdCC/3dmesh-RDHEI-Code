function visualizeRelatedTrees(related_trees, title_text)
    % Initialize nodes and edges
    nodes = [];
    edges = [];
    
    % Convert related_trees to graph nodes and edges
    related_trees_length = length(related_trees);
    for i = 1: related_trees_length
        createGraph(related_trees(i));
    end
    
    % Function to create graph recursively
    function createGraph(node)
        nodes = [nodes; node.id];
        if node.child ~= 0  % If node has children
            for j = 1:length(node.child)
                if node.child(j) > 0 && node.child(j) <= length(related_trees)
                    edges = [edges; node.id, node.child(j)];
                    %createGraph(related_trees(node.child(j)));
                else
                    warning('Invalid child id: %d for node id: %d', node.child(j), node.id);
                end
            end
        end
    end

    % Check for invalid edges
    if any(edges(:) > length(related_trees))
        error('Invalid edge found. Some node ids exceed the number of vertices.');
    end

    % Create and plot the graph
    G = digraph(edges(:,1), edges(:,2));
    figure;
    plot(G, 'Layout', 'layered');
    title(title_text);
end
