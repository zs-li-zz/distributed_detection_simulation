function [ delay ] = VSPRT_delay( X,h0,h1,m,r )
% input sample packages
% output delay and error probability after change of measure

sample_length=size(X,2); % length of every sample
package_size=size(X,1); % number of samples in one package
repeat=round(package_size/m); % repeat_time_per_package
mu0=-1; mu1=1;

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
num_nostop=sum(chioce<0); % number of chioces that don't stop before length
delay=stop;
mean_stop=sum(stop)/(repeat-num_nostop)

