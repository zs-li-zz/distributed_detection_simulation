function [ error ] = DVSPRT_error( X,real_theta,m,r,h0,h1,path_length )
% calculate error by change of measure
% input sample packages
% output error probability after change of measure

sample_length=size(X,2); % length of every sample
package_size=size(X,1); % number of samples in one package
repeat=round(package_size/m); % repeat_time_per_package
mu0=-1; mu1=1;
sigma=1;


L=2/2*(mu1-mu0)*X+(mu0^2-mu1^2)/2; %log-likelihood ratio
S=cumsum(L,2);% cumulative log-likelihood ratio
h1_index=ge(S,h1); % judge if geq b
h0_index=le(S,-h0);
tau_b=zeros(1,m); % stopping time of all sensors in one experiment
tau_a=zeros(1,m);
h1_stop=zeros(repeat,1); % stop time for voting rule under theshold b
h0_stop=zeros(repeat,1); 
stop=zeros(repeat,1); % final stopping time
chioce=zeros(repeat,1); % chioce of hypothesis
for re=1:repeat
    for j=1:m
        if ~isempty( find(h1_index(m*(re-1)+j,:)>0, 1) ) 
            tau_b(j)=find(h1_index(m*(re-1)+j,:)>0, 1);
        else 
            tau_b(j)=sample_length+1;
        end
        if ~isempty( find(h0_index(m*(re-1)+j,:)>0, 1) ) 
            tau_a(j)=find(h0_index(m*(re-1)+j,:)>0, 1);
        else
            tau_a(j)=sample_length+1;
        end
    end
    % add consensus delay from sensor 1
    for i=1:m
        if tau_a(i)<=sample_length
            tau_a(i)=tau_a(i)+ceil(path_length(1,i));
        end
        if tau_b(i)<=sample_length
            tau_b(i)=tau_b(i)+ceil(path_length(1,i));
        end
    end
    tau_b=sort(tau_b); tau_a=sort(tau_a); % sorted alarm time sequence \tau_(1),\tau_(2),...
    b_rth_alarm=tau_b(r); %alarm when there are r th alarm for same threshold
    a_rth_alarm=tau_a(r);
    if b_rth_alarm>sample_length
        h1_stop(re)=sample_length+1;
    else
        h1_stop(re)=b_rth_alarm;
    end
    if a_rth_alarm>sample_length
        h0_stop(re)=sample_length+1;
    else
        h0_stop(re)=a_rth_alarm;
    end
    min_stop=min(h0_stop(re),h1_stop(re)); % stopping time
    if min_stop<=sample_length
        stop(re)=min_stop;
        chioce(re)=ge(h0_stop(re),h1_stop(re)); % if cross h1 earlier than cross h0, chioce=1 (means H_1 is chosen)
    else
        chioce(re)=-1; %nothing choosed (stop hold zero)
    end
end

%% calculating error with weight after change measure
e=0;
w=zeros(repeat,1);
delta_miu=mu1-mu0; delta_miu_square=mu1^2-mu0^2;
% if the real theta=0 and we change to theta=1
for re=1:repeat
    if chioce(re)~=real_theta % Means error decision happens. After change of measure, almost all samples will be "wrong"
        % because new sidtribution are drawn from iid distribution, taking
        % the first r sensor observation is the same as taking the corrsponding r ones
%         w(re)=w(re)+( 2*delta_miu*sum(sum(X( m*(re-1)+1:m*(re-1)+r,1:stop(re) )))-r*stop(re)* delta_miu_square )/(-2*sigma^2);%change measure, log of probability ratio
        % for under attack
        w(re)=w(re)+( 2*delta_miu*sum(sum(X( m*(re-1)+1:m*(re-1)+m,1:stop(re) )))-m*stop(re)* delta_miu_square )/(-2*sigma^2);%change measure, log of probability ratio
    end
end
% compensate=-mean(w,1)-100*log(h0); %used to compensate too much negative exponent
% as the maximum error term will dominate
% only calculate the expoenets with [max_e-50,max_e]
max_w=max(w);
error_decision_index=(chioce~=real_theta);
in_realm_index=(w-max_w>50);
calc_index=error_decision_index.*in_realm_index; % the repeat index we use to calculate average error probability
num_cal_avg = sum(calc_index); % sum(calc_index) is the number of the terms that we use to calculate average
if num_cal_avg>1 
    for index=1:num_cal_avg
        if calc_index(index)~=0 % need to calculate
            e=e+exp(w(index)-max_w);
        end
    end
    e=log(e)-log(num_cal_avg)+max_w; % log(e/number_of_samples)
    error = e
else
    error = max_w
end

end






