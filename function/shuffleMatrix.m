function shuffled_matrix = shuffleMatrix(matrix, Kfix)
    % matrix: 输入的1*n的0 1矩阵
    % Kfix: 密钥
    n = length(matrix);
    rng(Kfix);  % 设定随机种子为密钥Kfix
    idx = randperm(n);  % 生成基于密钥的随机序列
    shuffled_matrix = matrix(idx);  % 按照随机序列混洗矩阵
end

