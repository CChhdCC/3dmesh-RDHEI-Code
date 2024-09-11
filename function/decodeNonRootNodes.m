function nonRootNodes = decodeNonRootNodes(strNotRoot, HuffmanTree, bit_len, n)
    nonRootNodes(n) = struct('msbx_length', [], 'lsbx', [], ...
                             'msby_length', [], 'lsby', [], ...
                             'msbz_length', [], 'lsbz', []);

    pos = 1;  % 初始位置
    for i = 1:n
        % 1. 解码 msbx_length
        [msbx_length, newPos] = matchHuffmanCodeFromStream(strNotRoot, pos, HuffmanTree);
        pos = newPos;

        % 2. 提取 lsbx（LSB 是固定长度）
        lsbx = strNotRoot(pos:pos + (bit_len - msbx_length) - 1);
        pos = pos + (bit_len - msbx_length);

        % 3. 解码 msby_length
        [msby_length, newPos] = matchHuffmanCodeFromStream(strNotRoot, pos, HuffmanTree);
        pos = newPos;

        % 4. 提取 lsby
        lsby = strNotRoot(pos:pos + (bit_len - msby_length) - 1);
        pos = pos + (bit_len - msby_length);

        % 5. 解码 msbz_length
        [msbz_length, newPos] = matchHuffmanCodeFromStream(strNotRoot, pos, HuffmanTree);
        pos = newPos;

        % 6. 提取 lsbz
        lsbz = strNotRoot(pos:pos + (bit_len - msbz_length) - 1);
        pos = pos + (bit_len - msbz_length);

        % 7. 存储解码结果
        nonRootNodes(i).msbx_length = msbx_length;
        nonRootNodes(i).lsbx = lsbx;
        nonRootNodes(i).msby_length = msby_length;
        nonRootNodes(i).lsby = lsby;
        nonRootNodes(i).msbz_length = msbz_length;
        nonRootNodes(i).lsbz = lsbz;
    end
end

function [length, newPos] = matchHuffmanCodeFromStream(strStream, pos, HuffmanTree)
    % 根据 HuffmanTree 从比特流 strStream 中的 pos 位置开始匹配 Huffman 编码，返回匹配到的长度以及更新后的位置
    currentNode = HuffmanTree;
    streamLength = strlength(strStream);
    while isempty(currentNode.symbol)
        if pos > streamLength
            error('Huffman decoding error: Reached end of stream unexpectedly.');
        end
        bit = strStream(pos);
        pos = pos + 1;
        if bit == '0'
            currentNode = currentNode.left;
        elseif bit == '1'
            currentNode = currentNode.right;
        end
    end
    length = currentNode.symbol;
    newPos = pos;
end



