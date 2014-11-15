
s =15;
alltimes_cg = [];

for b = 1:4
 event = ['event',num2str(b),'.txt'];

 %load (file_name3); % load spm file, an output from "megload_160_102010_easy"
 event2 = load (event); % load MEG event timing/type info

 times = event2(:,1); %event time (MEG time)
 
    % this step load cogent times/trigger codes (separately for picture and
    % greeble onsets)
  eval(['load SFG_block' num2str(b) '_sub' num2str(s) '_timeinfo.mat';]); 
  eval(['load SFG_block' num2str(b) '_sub' num2str(s) '_Greebtimeinfo.mat';]); 
  
    piccode = trialarray_time(:,2); % piccodes are two digits coding emotion+SF
    pictimes = trialarray_time(:,3);
    greebcode = trialarray_Greebtime(:,2)+ piccode*10; %make greebcode three digits: piccode+greebsize
    greebtimes = trialarray_Greebtime(:,3);
    
    %adjust for cogent times
    d = pictimes(1) - times(1);% this computes the timing difference between the first meg trigger and first cogent trigger
                               % however, because the difference btw the
                               % 1st ones have been off too much, we'll try
                               % use the diff btw the second ones instead
    %d = greebtimes(1) - times(2);                           
    pictimes = pictimes - d;% All cogent times will subtract this difference to get adjusted for meg recorded time
    greebtimes = greebtimes - d;% same for greebles
    
    if s == 15 && b ==1%special case 0926 b1: first cogent trigger corresponds to the 28th meg trigger; i.e. meg recording starts late and have 27 fake triggers in front
        d = pictimes(1) - times(28);
        pictimes = pictimes - d;
        greebtimes = greebtimes - d;
    end    

% create trials structure to store trigger timing and types; default values "1"    
D.trials.events = repmat(struct('type',1,'value',1,'time',1,'duration',''), 1, 300);

for i=1:300 %for each one of the triggers in a block

        if rem(i,2)==1 %for odd triggers -> picture onsets (time unit: seconds)
            D.trials.events(i).time = pictimes((i+1)/2,1)/1000 + .017336;% add this difference (calculated from photodiode trigger to adjust for the time meg picon trigger travels to the presentation screen (where photodiode is)
            D.trials.events(i).type = piccode((i+1)/2,1);
        else %for even triggers -> greeble onsets
            D.trials.events(i).time = greebtimes(i/2,1)/1000 + .017336;
            D.trials.events(i).type = greebcode(i/2,1);
        end
end

    for i = 1:length(D.trials.events)    
    type(i,1) = D.trials.events(i).type;
    latency(i,1) = D.trials.events(i).time;
    end  
    
    alltimes_cg = [alltimes_cg; type latency];
end

diff_time = alltimes_mt(:,2) - alltimes_cg(:,2);