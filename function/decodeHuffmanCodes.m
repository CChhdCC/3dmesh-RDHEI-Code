function HuffmanTable = decodeHuffmanCodes(strHuffmanCode)
    % 解析 Huffman 编码字符串，重建 Huffman 编码的索引数组
    pos = 1;
    HuffmanTable = struct('Symbol', [], 'Code', []);
    i = 1;
    
    while pos <= strlength(strHuffmanCode)
        % 读取符号ID（6位）
        symbol = bin2dec(strHuffmanCode(pos:pos+5));
        pos = pos + 6;
        
        % 读取编码长度（6位）
        code_len = bin2dec(strHuffmanCode(pos:pos+5));
        pos = pos + 6;
        
        % 读取实际的编码（长度为code_len的二进制字符串）
        code = strHuffmanCode(pos:pos + code_len - 1);
        pos = pos + code_len;
        
        % 存储符号和编码
        HuffmanTable(i).Symbol = symbol;
        HuffmanTable(i).Code = code;
        i=i+1;
    end
end

