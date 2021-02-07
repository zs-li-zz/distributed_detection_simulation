function [ linear_set ] = index2linear_set( observation_index_list )
% change index vector to linear index set
non0_index=find(index_list~=0);
linear_set=[];
for i=1:length(non0_index)
    linear_set=[linear_set,observation_index_list(non0_index(i))*m+non0_index(i)];
end

end

