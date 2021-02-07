m=10;
r=4;

x=0:0.01:1;
Phi=normcdf(x);
gamma=zeros(size(Phi));
for k=r:m
   gamma=gamma+ nchoosek(m,k) * x.^k.*(1-x).^(m-k);
    
end

plot(gamma,x);
figure;
plot(x,gamma);