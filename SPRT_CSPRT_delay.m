function [ delay ] = SPRT_CSPRT_delay( X,h0,h1,gamma0,gamma1,m )
% input sample packages
% output delay and error probability after change of measure

sample_length=size(X,2); % length of every sample
package_size=size(X,1); % number of samples in one package
repeat=round(package_size/m); % repeat_time_per_package
mu0=-1; mu1=1;
Delta=2;
b=1;

L=2/2*(mu1-mu0)*X+(mu0^2-mu1^2)/2; %log-likelihood ratio
W=cumsum(L,2);
b1_index1=ge(W,gamma1).*lt(W,gamma1+Delta); % judge if geq b
b1_index2=ge(W,gamma1+Delta).*lt(W,gamma1+2*Delta); 
b1_index3=ge(W,gamma1+2*Delta).*lt(W,gamma1+3*Delta); 
b1_index4=ge(W,gamma1+3*Delta); 

b0_index1=le(W,-gamma0).*gt(W,-gamma0-Delta); % judge if geq b
b0_index2=le(W,-gamma0-Delta).*gt(W,-gamma0-2*Delta);
b0_index3=le(W,-gamma0-2*Delta).*gt(W,-gamma0-3*Delta); 
b0_index4=le(W,-gamma0-3*Delta); 

Y=b*b1_index1+2*b*b1_index2+3*b*b1_index3+4*b*b1_index4-b*b0_index1-2*b*b0_index2-3*b*b0_index3-4*b*b0_index4;
Yfc=zeros([repeat,sample_length]); % triggers received at FC
for re=1:repeat
    Yfc(re,:)=sum(Y( m*(re-1)+1:re*m,: ));
end

F=2/2*(mu1-mu0)*Yfc+(mu0^2-mu1^2)/2; %log-likelihood ratio again
Fs=cumsum(F,2); % horizental cumulative sum of F
% Revise those who go towards the wrong direction
for re=1:repeat
    if max(Fs(re,:))>0
        Fs_temp=0; % only handle F^-
        for k=1:sample_length
            if Fs_temp+F(re,k)>0
                Fs_temp=0;
            else 
                Fs_temp=Fs_temp+F(re,k);
            end
            Fs(re,k)=Fs_temp;
        end
    end
end
h1_index=ge(Fs,h1); % judge if geq b
h0_index=le(Fs,-h0);
h1_stop=zeros(repeat,1); % stop time for voting rule under theshold b
h0_stop=zeros(repeat,1);
stop=zeros(repeat,1); % final stopping time
chioce=zeros(repeat,1); % chioce of hypothesis
for re=1:repeat
    
    if ~isempty( find(h1_index(re,:)>0, 1) )
        tau_b=find(h1_index(re,:)>0, 1);
    else
        tau_b=sample_length+1;
    end
    if ~isempty( find(h0_index(re,:)>0, 1) )
        tau_a=find(h0_index(re,:)>0, 1);
    else
        tau_a=sample_length+1;
    end
    
    if tau_b>sample_length
        h1_stop(re)=sample_length+1;
    else
        h1_stop(re)=tau_b;
    end
    if tau_a>sample_length
        h0_stop(re)=sample_length+1;
    else
        h0_stop(re)=tau_a;
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
