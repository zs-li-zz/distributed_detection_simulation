clear variables; clc;
% load  Gaussain data

sample_length=12000; % length of every sample
package_size=10000; % number of samples in one package
real_theta=0;
repeat=100; % repeat_time_per_package
package_num=1;
delay_list=zeros([repeat,package_num]);

h1=10000;
h0=10000;
m_list=[2,10,40,100];

for m_index=1:4
m=m_list(m_index);
r=m;

for package_index=1:package_num
    
    disp(['loading data package ',mat2str(package_index),' ...'])
    file_str=['gaussain_H0_',mat2str(package_index),'_10000_12000.mat'];
    load(file_str)
    disp('loading data done')
     
    delay_list(:,package_index)=VSPRT_delay(X0(1:m*100,:),real_theta,h0,h1,m,r);
    disp(['test data package ',mat2str(package_index),' done'])
end
% save('delay_list_h10_10000.mat','delay_list');
% hist(delay_list(:));

%% plot CDF of delay
Z=(delay_list-10000/2)./sqrt(4/2^3*h0); % V=4
x_list=-5:0.01:10;
count=zeros([length(x_list),1]);
i=1;
for x=-5:0.01:10
    count(i) = sum(sum(Z<=x))/repeat;
    i=i+1;
    
end
% subplot(1,2,1);
plot(x_list,count);  hold on; % xlim([-2,3]);

end
legend('m=2','m=10','m=40','m=100');

% compare with phi^r
Phi=normcdf(x_list);
% subplot(1,2,2);
plot(x_list,Phi.^2); hold on;
plot(x_list,Phi.^10); hold on;
plot(x_list,Phi.^40); hold on;
plot(x_list,Phi.^100); hold on;
% plot(x_list,Phi.^10); hold on;
legend('m=2','m=10','m=40','m=100');
grid on;
xlim([-2,4]);


%% compare with theory
% r=2;
% Phi=normcdf(x_list);
% gamma=zeros(size(Phi));
% for k=r:m
%    gamma=gamma+ nchoosek(m,k) * x_list.^k.*(1-x_list).^(m-k);
%     
% end

% plot(x_list,gamma); xlim([0,1]);
