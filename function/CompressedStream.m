function [strStream,vocated_room, param_length] = CompressedStream( m_presition,bit_len,HuffmanCodes,MultiMSB_ProcessedModel,Vertex_Roots)
%COMPRESSEDSTREAM 此处显示有关此函数的摘要
%   此处显示详细说明
%   输入：
%   m_presition 精度 
%   HuffmanCodes 
%   MultiMSB_ProcessedModel MSB替换每个位置的结果
%   输出：
%   strStream 压缩比特流
%   vocated_room 空出的空间长度32位二进制表示
    strStream = "";
    num_vertices = length(MultiMSB_ProcessedModel);
    HuffmanCodesWithNone(bit_len) = struct('Symbol', [], 'Code', "");
    vocated_len = 32;%32位表示空出的空间
    huffman_len = 16;
    for i = 1:bit_len
        HuffmanCodesWithNone(i).Symbol = i;
    end
    for i = 1:length(HuffmanCodes)
        HuffmanCodesWithNone(HuffmanCodes(i).Symbol).Code = HuffmanCodes(i).Code;%0-bit_len的Huffman编码，若不存在，则为空“”，若存在，即为其对应代码。
    end
    
    % 插入精度
    strStream = strStream + num2binstr(m_presition,4);
    
    % 插入Huffman编码
    strHuffmanCode = "";
    for i = 1 : length(HuffmanCodes)
        strHuffmanCode = strHuffmanCode + num2binstr(HuffmanCodes(i).Symbol,6);%序号id（6位）
        strHuffmanCode = strHuffmanCode + num2binstr(strlength(HuffmanCodes(i).Code),6);%编码长度（6位）
        strHuffmanCode = strHuffmanCode + HuffmanCodes(i).Code;%编码
    end
    strLenHuffman = num2binstr(strlength(strHuffmanCode),huffman_len); %Huffman编码长度（16位）
    strStream = strStream + strLenHuffman + strHuffmanCode;
    
    % 插入根节点位置
    symbols = 1:num_vertices;
    noRoots = true(1, num_vertices);
    for i = Vertex_Roots
        strStream = strStream + MultiMSB_ProcessedModel(i).lsbx + MultiMSB_ProcessedModel(i).lsby + MultiMSB_ProcessedModel(i).lsbz ;
        noRoots(i) = false;
    end
    symbols = symbols(noRoots);
    
    % 插入非根节点
    for i = symbols
        if strlength(HuffmanCodesWithNone(MultiMSB_ProcessedModel(i).msbx_length).Code) == 0
             error('warning:存在某MSB长度无Huffman编码');
        end
        strStream = strStream + HuffmanCodesWithNone(MultiMSB_ProcessedModel(i).msbx_length).Code + MultiMSB_ProcessedModel(i).lsbx;

        if strlength(HuffmanCodesWithNone(MultiMSB_ProcessedModel(i).msby_length).Code) == 0
             error('warning:存在某MSB长度无Huffman编码');
        end
        strStream = strStream + HuffmanCodesWithNone(MultiMSB_ProcessedModel(i).msby_length).Code + MultiMSB_ProcessedModel(i).lsby;

        if strlength(HuffmanCodesWithNone(MultiMSB_ProcessedModel(i).msbz_length).Code) == 0
             error('warning:存在某MSB长度无Huffman编码');
        end
        strStream = strStream + HuffmanCodesWithNone(MultiMSB_ProcessedModel(i).msbz_length).Code + MultiMSB_ProcessedModel(i).lsbz;
    end

    nStreamlen = strlength(strStream);
    param_length = m_presition + huffman_len + strlength(strHuffmanCode) + vocated_len;
    vocated_length = num_vertices * bit_len * 3 - nStreamlen - vocated_len;
    vocated_room = num2binstr(vocated_length, vocated_len);
    
end

