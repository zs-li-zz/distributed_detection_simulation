clear variables; clc;
disp('loading data...')
load('Xsd0_1.mat'); % hypothesis 0, observation at sensor 1
load('Xsd1_1.mat');
disp('loading data done')
d=1; % decider


sample_length=size(Xsd0_1,2); % length of every sample
package_size=size(Xsd0_1,1); % number of samples in one package
real_theta=0;
m=12;
repeat=round(package_size/m); % repeat_time_per_package
h_list=1000:1000:13000;

delay_list=zeros([length(h_list),repeat]);
% weight number after change of measure, error is the log of error probability
error_list=zeros([length(h_list),repeat]);

% calculate expected delay and error
for comb_num=1:length(h_list)
    h0=h_list(comb_num); h1=h0;
    
    % get delay
    disp(['get delay with h=',mat2str(h0)])
    [delay_list(comb_num,:)]=SDDSPRT_delay(Xsd0_1,m,d,h0,h1);
    % get erro by change of measure, use H1 instead
    disp(['get error with h=',mat2str(h0)])
    [error_list(comb_num,:)]=SDDSPRT_error(Xsd1_1,real_theta,m,d,h0,h1);
    %
end
delay_average=mean(delay_list,2);
error_average=mean(error_list,2);


%% plot

plot(delay_average,error_average,'*-b','LineWidth',1); hold on;
grid on;
