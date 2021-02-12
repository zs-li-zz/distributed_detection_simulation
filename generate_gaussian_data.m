%% generate data
% H_0~N(mu0,sigma0)  H_1~N(mu1,sigma1) 
length=15000; % length of every sample
package_size=12000; % number of samples in one package
package_num=1; % number of packages for each hypothesis

% DATA parameter
mu0=-1;
mu1=1;
sigma0=1;
sigma1=1;
for i=1:package_num
    X0=normrnd(mu0,sigma0,[package_size,length]);
    X0=single(X0);
    file_str=['gaussain_H0_',mat2str(i),'_',mat2str(package_size),'_',mat2str(length)];
    save(file_str,'X0');
    X1=normrnd(mu1,sigma1,[package_size,length]);
    X1=single(X1);
    file_str=['gaussain_H1_',mat2str(i),'_',mat2str(package_size),'_',mat2str(length)];
    save(file_str,'X1');
    disp(i)
end



%% generate partly falsfied data

length=5000; % length of every sample
package_size=10000; % number of samples in one package
m=10;
r=3;
repeat=round(package_size/m);
X0=zeros([package_size,length]);
for re=1:repeat
    X0(m*(re-1)+1:m*(re-1)+r,:)=normrnd(mu1,sigma1,[r,length]);
    X0(m*(re-1)+r+1:m*(re-1)+m-1,:)=normrnd(mu0,sigma0,[m-r-1,length]);
    X0(m*(re-1)+m,:)=normrnd(mu1,sigma1,[1,length]);
end

% file_str=['gaussain_attack_',mat2str(r),'H1_',mat2str(m-r),'H0_',mat2str(package_size),'_',mat2str(length)];
file_str=['gaussain_attack_2H1_7H0_1H1_',mat2str(package_size),'_',mat2str(length)];

save(file_str,'X0');