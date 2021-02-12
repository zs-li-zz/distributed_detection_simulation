clear variables; clc;
%% generate data SAMPLE SEQUENCE that each sensor get at each time
% used for sampling dissemination 
load('gaussain_H0_1_12000_15000.mat')
load('gaussain_H1_1_12000_15000.mat')
load('G122.mat')
sample_length=size(X0,2); % length of every sample
package_size=size(X0,1); % number of samples in one package
m=12;
repeat = round(package_size/m); % repeat_time_per_package
Xsd=zeros([repeat,sample_length,m]); % sample dissemination data matrix, every ROW is a sequence of sensor 1 in graph

path_length=zeros([m,m]);
for decider_sensor=1:m-1
    for j=decider_sensor+1:m
        n=1;
        Gn=G122^n;
        while Gn(decider_sensor,j)<=0.1 && n<=12
            n=n+1;
            Gn=G122^n;
        end
        if n<=12
            path_length(decider_sensor,j)=n;
        end
    end
end
path_length=path_length+path_length';

% data structure:
% row -> sensor index (every 12 rows is a package)
% column -> time index
% 3-rd dimension -> list used to store all samples that received at this time

% % save all sensor's observations (This method takes up too much storage space and is discarded)
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

% only save sensor decider sensor's observations
decider_sensor = 1;
for re=1:repeat
    X_now=X1( m*(re-1)+1:m*re,: );
    % update neighbor observations including self
    decider_sensor=1;
    for j=1:m
        % 移位数目
        shift=path_length(decider_sensor,j);
        % 这种更新方式把i当做接收方,j是发送方
        Xsd(re,1+shift:end,j)=X_now(j,1:end-shift);
    end
    
end

Xsd1_1=Xsd;
disp('begin saving')
save('Xsd1_1.mat','Xsd1_1');
% disp(Xsd(1,:,:)) % for checking

