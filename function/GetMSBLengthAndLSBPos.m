function [MSBLength_Statistics,MultiMSB_ProcessedModel] = GetMSBLengthAndLSBPos(Vertex,Vertex_Roots,Related_Trees, bit_len)
%GETMSBLENGTHANDLSBPOS 此处显示有关此函数的摘要
%   此处显示详细说明
%   输入：
%   Vertex 顶点位置矩阵
%   Vertex_Roots 根节点矩阵
%   Related_Trees 树节点结构关系矩阵
%   输出：
%   MSBLength_Statistics MSB替换长度频数统计
%   MultiMSB_ProcessedModel multi-MSB操作后的顶点结构矩阵，包含id、msbx_length、lsbx、msby_length、lsby、msby_length、lsby

    %初始化各参数
    num_vertices = size(Vertex, 1);
    MSBLength_Statistics = zeros(bit_len,1);
    MultiMSB_ProcessedModel(num_vertices) = struct('id', [], 'msbx_length', [], 'lsbx', "",'msby_length', [], 'lsby', "",'msbz_length', [], 'lsbz', "");
    
    for i = 1:num_vertices
        
        strThisPosX = num2binstr(Vertex(i,1),bit_len);
        strThisPosY = num2binstr(Vertex(i,2),bit_len);
        strThisPosZ = num2binstr(Vertex(i,3),bit_len);
        
        % 判断是否是根节点，给根节点赋值
        if any(Vertex_Roots == i)
            MultiMSB_ProcessedModel(i).id = i;%struct('id', i, 'msbx_length', 0, 'lsbx', strThisPosX ,'msby_length', 0, 'lsby', strThisPosY ,'msbz_length', 0, 'lsbz', strThisPosZ);
            MultiMSB_ProcessedModel(i).msbx_length = 0;
            MultiMSB_ProcessedModel(i).lsbx = strThisPosX;
            MultiMSB_ProcessedModel(i).msby_length = 0;
            MultiMSB_ProcessedModel(i).lsby = strThisPosY;
            MultiMSB_ProcessedModel(i).msbz_length = 0;
            MultiMSB_ProcessedModel(i).lsbz = strThisPosZ;
        end
        
        %遍历此节点的孩子节点
        for child = Related_Trees(i).child
            if child == 0
                break;
            end
            strChildPosX = num2binstr(Vertex(child,1),bit_len);
            strChildPosY = num2binstr(Vertex(child,2),bit_len);
            strChildPosZ = num2binstr(Vertex(child,3),bit_len);
            lengthX = 0;
            lengthY = 0;
            lengthZ = 0;
            
             MultiMSB_ProcessedModel(child).id = child;
            
            % X坐标--------------------------------------------------------
            for nIndexX = 1:bit_len
                if strThisPosX(nIndexX) == strChildPosX(nIndexX)
                    lengthX = lengthX + 1;
                    continue;    
                end
                break;
            end
            if lengthX > 0 %MSB相同数目统计
                MSBLength_Statistics(lengthX) = MSBLength_Statistics(lengthX)+1;
            end
            %长度坐标赋值
            MultiMSB_ProcessedModel(child).msbx_length = lengthX;
            if lengthX + 1 > bit_len
                 MultiMSB_ProcessedModel(child).lsbx = "";
            else
                 MultiMSB_ProcessedModel(child).lsbx = strChildPosX(lengthX + 1:bit_len);
            end
            
            % Y坐标--------------------------------------------------------
            for nIndexY = 1:bit_len
                if strThisPosY(nIndexY) == strChildPosY(nIndexY)
                    lengthY = lengthY + 1;
                    continue;    
                end
                break;
            end
            if lengthY > 0 %MSB相同数目统计
                MSBLength_Statistics(lengthY) = MSBLength_Statistics(lengthY)+1;
            end
            %长度坐标赋值
            MultiMSB_ProcessedModel(child).msby_length = lengthY;
            if lengthY + 1 > bit_len
                 MultiMSB_ProcessedModel(child).lsby = "";
            else
                 MultiMSB_ProcessedModel(child).lsby = strChildPosY(lengthY + 1:bit_len);
            end
            
            % Z坐标--------------------------------------------------------
            for nIndexZ = 1:bit_len
                if strThisPosZ(nIndexZ) == strChildPosZ(nIndexZ)
                    lengthZ = lengthZ + 1;
                    continue;    
                end
                break;
            end
            if lengthZ > 0 %MSB相同数目统计
                MSBLength_Statistics(lengthZ) = MSBLength_Statistics(lengthZ)+1;
            end
            %长度坐标赋值
            MultiMSB_ProcessedModel(child).msbz_length = lengthZ;
            if lengthZ + 1 > bit_len
                 MultiMSB_ProcessedModel(child).lsbz = "";
            else
                 MultiMSB_ProcessedModel(child).lsbz = strChildPosZ(lengthZ + 1:bit_len);
            end
        end
        
    end

end

