RDHEI readme

此部分暂且为部分变量的含义与结构暂存的解析，后续会升级成为整个代码的解析。

strStream 压缩比特流：

| 变量名 | 含义 | 位数 |
| ------ |----- | ----|
| m_presition | 精度 | 4位 |
| strLenHuffman | Huffman编码长度 | 16位 |
| strHuffmanCode | 具体的Huffman编码(三部分:序号id（6位）; 编码长度（6位）; 编码) | 多位 |
| Vertex_Roots | 根节点位置(无msb替换) | （32+32+32）* nRoots |
| symbols | 非根节点((msb_length的对应Huffman编码+lsb)*(x,y,z)) | 多位 |
| ... | ... | ... |
| vocated_len | 空出的空间长度 | 32位 |


感觉精度就不存了，因为存了就没办法直接拿出来，就说精度是约定好的。m=5.
