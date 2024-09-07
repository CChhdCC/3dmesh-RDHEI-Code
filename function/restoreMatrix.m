function restored_matrix = restoreMatrix(shuffled_matrix, Kfix)
    % shuffled_matrix: 混洗后的矩阵
    % Kfix: 密钥
    n = length(shuffled_matrix);
    rng(Kfix);  % 设定随机种子为密钥Kfix
    idx = randperm(n);  % 生成与混洗相同的随机序列
    restored_matrix = zeros(1, n);  % 初始化还原矩阵
    restored_matrix(idx) = shuffled_matrix;  % 根据索引还原矩阵
end


