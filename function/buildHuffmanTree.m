function huffmanTree = buildHuffmanTree(HuffmanTable)
    % 初始化哈夫曼树的根节点
    huffmanTree = struct('left', [], 'right', [], 'symbol', []);
    
    for i = 1:length(HuffmanTable)
        code = HuffmanTable(i).Code;
        symbol = HuffmanTable(i).Symbol;
        
        % 调用递归函数插入编码到哈夫曼树中
        huffmanTree = insertIntoHuffmanTree(huffmanTree, code, symbol);
    end
end

function currentNode = insertIntoHuffmanTree(currentNode, code, symbol)
    % 递归地将Huffman编码插入树结构中
    if isempty(code)
        % 如果当前编码为空，表示到达叶节点，存储符号
        currentNode.symbol = symbol;
    else
        % 获取当前比特位
        bit = code(1);
        remainingCode = code(2:end);  % 剩余的编码
        
        if bit == '0'
            % 如果左子节点不存在，则创建
            if isempty(currentNode.left)
                currentNode.left = struct('left', [], 'right', [], 'symbol', []);
            end
            % 递归处理剩余的编码
            currentNode.left = insertIntoHuffmanTree(currentNode.left, remainingCode, symbol);
        elseif bit == '1'
            % 如果右子节点不存在，则创建
            if isempty(currentNode.right)
                currentNode.right = struct('left', [], 'right', [], 'symbol', []);
            end
            % 递归处理剩余的编码
            currentNode.right = insertIntoHuffmanTree(currentNode.right, remainingCode, symbol);
        end
    end
end
