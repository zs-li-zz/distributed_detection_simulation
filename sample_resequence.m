clear variables; clc;
%% generate data SAMPLE SEQUENCE that each sensor get at each time
% used for sampling dissemination and consensus
load('gaussain_H0_1_12000_15000.mat')
load('gaussain_H1_1_12000_15000.mat')
load('G122.mat')
sample_length=size(X0,2); % length of every sample
package_size=size(X0,1); % number of samples in one package
m=12;
repeat = round(package_size/m); % repeat_time_per_package
Xsd=zeros([repeat,sample_length,m]); % sample dissemination data matrix, every ROW is a sequence of sensor 1 in graph

path_length=zeros([m,m]);
for i=1:m-1
    for j=i+1:m
        n=1;
        Gn=G122^n;
        while Gn(i,j)<=0.1 && n<=12
            n=n+1;
            Gn=G122^n;
        end
        if n<=12
            path_length(i,j)=n;
        end
    end
end
path_length=path_length+path_length';
% row -> sensor index (every 12 rows is a package)
% column -> time index
% 3-rd dimension -> list used to store all samples that received at this time

% neighbor_set=zeros([m,4]);
% for i=1:m
%     neighbor_set(i,:)=find(G122(i,:)~=0);
% end
% for re=1:repeat
%     X_now=X1( m*(re-1)+1:m*re,: );
%     % update neighbor observations including self
%     for i=1:m
%         for j=1:m
%             % 移位数目
%             shift=path_length(i,j);
%             % 这种更新方式把i当做接收方,j是发送方
%             Xsd(m*(re-1)+i,1+shift:end,j)=X_now(j,1:end-shift);
%         end
%     end
% end

% only save sensor 1's observation
for re=1:repeat
    X_now=X1( m*(re-1)+1:m*re,: );
    % update neighbor observations including self
    i=1;
    for j=1:m
        % 移位数目
        shift=path_length(i,j);
        % 这种更新方式把i当做接收方,j是发送方
        Xsd(re,1+shift:end,j)=X_now(j,1:end-shift);
    end
    
end

Xsd1_1=Xsd;
disp('begin saving')
save('Xsd1_1.mat','Xsd1_1');
% disp(Xsd(1,:,:))

% neighbor_set_G122=zeros([m,4]);
% for i=1:m
%     neighbor_set(i,:)=find(G122(i,:)==0);
% end
% % row -> sensor index (every 12 rows is a package)
% % column -> time index
% % 3-rd dimension -> list used to store all samples that received at this time
% for re=1:repeat
%     receive_index=zeros([m,sample_length,m]);
%     X_now=X0( m*(re-1)+1:m*re,: );
%     % update self observations
%     for i=1:m
%         Xsd(i,:,i)=X_now(i,:);
%         receive_index(i,:,i)=ones([sample_length,1]);
%     end
%     temp_observation_index=zeros([m,m]);
%     for k=2:sample_length
%         for i=1:m
%             observation_index=[]; % index=what time*m+from which sensor (project double index into linear index)
%
%             for j=1:4 % for G122 neighbor is 4, for GRID neighbor is 2,3,4
%                 new_sample_set=Xsd(neighbor_set(i,j),k-1,:); % index is sensor name, number is the time of ovservation
%                 observation_index=union(observation_index, index2linear_set(new_sample_set));
%             end
%             % 每次只保留在sensor i，时刻k，新增的observation index [from which sensor, what time]
%             temp_observation_index(i,:)=setdiff(observation_index,temp_observation_index(i,:)); % 长度不一样怎么处理
%         end
%
%     end
%
% end