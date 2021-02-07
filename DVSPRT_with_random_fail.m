clear variables; clc;
load('G102.mat');
m=10;
% generate link probability
P=zeros(size(G102));
for i=1:m
    for j=1:m
        if G102(i,j)>0.5
            P(i,j)=rand();
        end
    end
end

% find consensus delay
% find consensus delay
path_length=zeros([m,m]);
for i=1:m
    for j=1:m
        n=1;
        Gn=G102^n;
        while Gn(i,j)<=0.5 && n<=m
            n=n+1;
            Gn=G102^n;
        end
        if n<=m
            path_length(i,j)=path_length(i,j)+1/rand();
        end
    end
end


%% 
disp('loading data...')
load('gaussain_H0_1_12000_5000.mat'); % hypothesis 0, attack sensor 1 and 2
load('gaussain_H1_1_12000_5000.mat'); % used for change of measure
disp('loading data done')
X0=X0(1:10000,1:5000);
X1=X1(1:10000,1:5000);

sample_length=size(X0,2); % length of every sample
package_size=size(X0,1); % number of samples in one package
real_theta=0;
r=7;
repeat=round(package_size/m); % repeat_time_per_package
h_list=10:90:910;

delay_list=zeros([length(h_list),repeat]);
% weight number after change of measure, error is the log of error probability
error_list=zeros([length(h_list),repeat]);

% calculate expected delay and error
for comb_num=1:length(h_list)
    h0=h_list(comb_num); h1=h0;
    
    % get delay
    disp(['get delay with h=',mat2str(h0)])
    [delay_list(comb_num,:)]=DVSPRT_delay(X0,m,r,h0,h1,path_length);
    % get erro by change of measure, use H1 instead
    disp(['get error with h=',mat2str(h0)])
    [error_list(comb_num,:)]=DVSPRT_error(X1,real_theta,m,r,h0,h1,path_length);
    %
end
delay_average=mean(delay_list,2);
error_average=mean(error_list,2);


%% plot

plot(delay_average,error_average,'^-k','LineWidth',1); hold on;
grid on;
% plot(h_list,-error_average./delay_average);

