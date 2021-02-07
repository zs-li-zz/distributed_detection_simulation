clear variables; clc;
% load  Gaussain data
disp('loading data...')
load('gaussain_H0_1_12000_15000.mat')
load('gaussain_H1_1_12000_15000.mat')
% load('gaussain_partchanged_8H1_2H0_10000_5000.mat')
disp('loading data done')
X0=X0(1:10000,1:5000);
X1=X1(1:10000,1:5000);
% X1=X_change(1:10000,1:5000);

sample_length=5000; % length of every sample
package_size=10000; % number of samples in one package
real_theta=0;
m=10;
repeat=round(package_size/m); % repeat_time_per_package
h_list=100:100:1100;
r_list=10;
delay_average=zeros([length(h_list),length(r_list)]);
error_average=zeros([length(h_list),length(r_list)]);
for r_index=1:length(r_list)
    r=r_list(r_index);
    delay_list=zeros([length(h_list),repeat]);
    % weight number after change of measure, error is the log of error probability
    error_list=zeros([length(h_list),repeat]);
    
    % calculate expected delay and error
    for comb_num=1:length(h_list)
        h0=h_list(comb_num); h1=h0;
        
        % get delay
        disp(['get delay with h=',mat2str(h0)])
        [delay_list(comb_num,:)]=VSPRT_delay(X0,h0,h1,m,r);
        % get erro by change of measure, use H1 instead
        disp(['get error with h=',mat2str(h0)])
        [error_list(comb_num,:)]=VSPRT_error(X1,real_theta,h0,h1,m,r);
        %
    end
    delay_average(:,r_index)=mean(delay_list,2); % takg average according to y axis(horizental mean)
    error_average(:,r_index)=mean(error_list,2);
    
end

% save('error_avg_2to10.mat','error_average')
% save('delay_avg_2to10.mat','delay_average')
%% plot
plot(delay_average,error_average-log(nchoosek(m,r)),'o-k','LineWidth',1); hold on;
grid on;

beta_list=(log(nchoosek(m,r))-r*h_list)';
plot(delay_average,beta_list,'*-k','LineWidth',1); hold on;
%% plot theoreical line
% x=0:100:500;
% plot(x,-2*2*x,'k'); hold on;
% plot(x,-2*4*x,'k'); hold on;
% plot(x,-2*6*x,'k'); hold on;
% plot(x,-2*8*x,'k'); hold on;
% plot(x,-2*10*x,'k'); hold on;

%% different r
% loglog(delay_average(:,1),error_average(:,1),'*-k','LineWidth',1); hold on;
% loglog(delay_average(:,2),error_average(:,2),'*-b','LineWidth',1); hold on;
% loglog(delay_average(:,3),error_average(:,3),'*-g','LineWidth',1); hold on;
% loglog(delay_average(:,4),error_average(:,4),'*-y','LineWidth',1); hold on;
% loglog(delay_average(:,5),error_average(:,5),'*-c','LineWidth',1); hold on;
% grid on;
% legend('r=6','r=7','r=8','r=9','r=10');