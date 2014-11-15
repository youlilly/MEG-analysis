%% Assign timing according to stim conditions
allsubs = 1:16;
trialarray_time = zeros(150,3);

for sub = allsubs
    
for j = 1:4 
    eval(['load SFG_block' num2str(j) '_sub' num2str(sub) '_results.mat;']); 
    %eval(['load Block' num2str(i) 'Sub' num2str(a) 'RT']);   
    % Stim(,2) - emo =1(fear),2(disgust),3(neutral), Stim(,3)- sf=1(low),2(high)
    pT = [];
    pT = results.onsets.piconTimes'; 
    
    for n=1:length(piconTimes)
        if (emoindex(n))==1 && (sfindex(n))==1 % fear, LSF
            Clabel= 11;
        elseif (emoindex(n))==2 && (sfindex(n))==1
            Clabel= 12;
        elseif (emoindex(n))==3 && (sfindex(n))==1
            Clabel= 13;
        elseif (emoindex(n))==1 && (sfindex(n))==2
            Clabel= 21;
        elseif (emoindex(n))==2 && (sfindex(n))==2
            Clabel= 22;
        else
            Clabel= 23;
        end
        trialarray_time(n,1)=n;
        trialarray_time(n,2)=Clabel;
        trialarray_time(n,3)=pT(n);
    end
    
    eval(['save SFG_block' num2str(j) '_sub' num2str(sub) '_timeinfo trialarray_time']); 
    
end

end
    
%save 
