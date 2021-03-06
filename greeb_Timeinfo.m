%% Assign timing according to stim conditions
%allsubs = 1:16;
trialarray_time_gre = zeros(150,3);

%for sub = allsubs
    
for j = 1:4 
    %eval(['load SFG_block' num2str(j) '_sub' num2str(sub) '_results.mat;']); 
    eval(['load SFG_block1_sub' num2str(sub) '_results.mat;']); 
    %eval(['load Block' num2str(i) 'Sub' num2str(a) 'RT']);   
    % Stim(,2) - emo =1(fear),2(disgust),3(neutral), Stim(,3)- sf=1(low),2(high)
    greebindex = greebsizeindex';
    gT = [];
    gT = results.onsets.greebonTimes'; 
    
    for m=1:length(greebonTimes)
        if greebindex(m) == 1 % fear, LSF
            Glabel= 1;
        elseif greebindex(m) == 2
            Glabel= 2;
        elseif greebindex(m) == 3 
            Glabel= 3;
        elseif greebindex(m) == 4 
            Glabel= 4;
        end
        trialarray_time_gre(m,1)=m;
        trialarray_time_gre(m,2)=Glabel;
        trialarray_time_gre(m,3)=gT(m);
    end
    
    eval(['save SFG_block' num2str(j) '_sub' num2str(sub) '_Greebtimeinfo trialarray_time_gre']); 
    
end

%end
    
%save 
