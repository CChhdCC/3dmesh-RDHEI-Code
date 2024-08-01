function [HuffmanCodes,avglen] = GenerateHuffmanCodes(MSBLength_Statistics)
    % GenerateHuffmanCodes 生成Huffman编码
    % 输入：
    % MSBLength_Statistics 数字出现次数的统计
    % 输出：
    % HuffmanCodes Huffman编码的结构体数组，包含符号和值对

    % 确定符号和概率
    symbols = 1:length(MSBLength_Statistics);
    probabilities = MSBLength_Statistics / sum(MSBLength_Statistics);

    % 移除出现次数为0的符号和概率
    nonZeroIndices = MSBLength_Statistics > 0;
    symbols = symbols(nonZeroIndices);
    probabilities = probabilities(nonZeroIndices);

    % 创建Huffman字典
    [dict, avglen] = huffmandict(symbols, probabilities);

    % 将字典转换为可读的Huffman编码格式
    HuffmanCodes = struct('Symbol', [], 'Code', []);
    for i = 1:length(dict)
        HuffmanCodes(i).Symbol = dict{i,1};
        HuffmanCodes(i).Code = strjoin(string(dict{i,2}), '');
    end
end
