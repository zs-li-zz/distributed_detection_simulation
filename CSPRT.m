clear variables; clc;
% load  Gaussain data
disp('loading data...')
load('gaussain_H0_1_12000_10000.mat')
load('gaussain_H1_1_12000_10000.mat')
disp('loading data done')

sample_length=10000; % length of every sample
package_size=12000; % number of samples in one package
real_theta=0;
m=12;
repeat=round(package_size/m); % repeat_time_per_package
h_list=100:1000:14100;
% delay_average=zeros([length(h_list),1]);
% error_average=zeros([length(h_list),1]);

delay_list=zeros([length(h_list),repeat]);
% weight number after change of measure, error is the log of error probability
error_list=zeros([length(h_list),repeat]);

% calculate expected delay and error
for comb_num=1:length(h_list)
    h0=h_list(comb_num); h1=h0;
    
    % get delay
    disp(['get delay with h=',mat2str(h0)])
    [delay_list(comb_num,:)]=CSPRT_delay(X0,h0,h1,m);
    % get erro by change of measure, use H1 instead
    disp(['get error with h=',mat2str(h0)])
    [error_list(comb_num,:)]=CSPRT_error(X1,real_theta,h0,h1,m);
    %
end
delay_average=mean(delay_list,2);
error_average=mean(error_list,2);


%% plot

plot(delay_average,error_average,'o-r','LineWidth',1); hold on;
grid on;
%% plot theoreical line
x=0:10:500;
y=-2*m*x;
plot(x,y); hold on;

