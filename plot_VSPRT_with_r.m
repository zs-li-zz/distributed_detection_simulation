
plot(delay_average(:,1),-error_average(:,1),'*-k','LineWidth',1); hold on;
plot(delay_average(:,2),-error_average(:,2),'*-b','LineWidth',1); hold on;
plot(delay_average(:,3),-error_average(:,3),'*-g','LineWidth',1); hold on;
plot(delay_average(:,4),-error_average(:,4),'*-y','LineWidth',1); hold on;
plot(delay_average(:,5),-error_average(:,5),'*-c','LineWidth',1); hold on;
grid on;
legend('r=2','r=4','r=6','r=8','r=10');