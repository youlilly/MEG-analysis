%% MEG_EEG_Analyzer_megtime
% Created by Yuqi You
% Last commented: 06/04/13
% Intend to analyze yogogawa based MEG data (collected in 2012 fall, Australia)
% in EEGLAB for artefact rejection and then converted back to SPM; this script should work in
% tandem with MEG_Analyzer1_031913.m. 

%%%% For bad subjects using MEG times only

clear all
eeglab

%allsubs = 1:16;
%%
sublist = {'2012_11_23_0892_ME051_B';
    '2012_11_26_0896_ME051_B';
    '2012_12_03_0904_ME051_B';
    '2012_12_03_0905_ME051_B';
    '2012_12_04_0906_ME051_B';
    '2012_12_04_0908_ME051_B';
    '2012_12_05_0909_ME051_B';
    '2012_12_05_0910_ME051_B';
    '2012_12_06_0914_ME051_B';
    '2012_12_10_0917_ME051_B';
    '2012_12_10_me051_0918_B';
    '2012_12_11_0919_ME051_B';
    '2012_12_12_0921_ME051_B';
    '2012_13_12_0924_ME051_B';
    '2012_12_17_0926_ME051_B';
    '2012_12_19_0931_ME051_B';};

%% Import .con MEG data to EEGLAB via fileio


for s = allsubs
    if s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    
    for b = bs
    name = sublist{s,1};    
    filename = strcat(name, num2str(b),'.con');
    EEG = pop_fileio(filename,'channels',1:160);
    setname = strcat('MEGsub',num2str(s),'block',num2str(b));
    EEG.setname = setname;    
    EEG = eeg_checkset( EEG ); %Check dataset for errors
    savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'.set');
    EEG = pop_saveset( EEG,  'filename', savefile); %Save file in .set format
    end
end

%% Downsampling in EEGlab
for s = allsubs
    if s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    
    for b = bs
    name = sublist{s,1};            
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'.set');
    EEG = pop_loadset(filename);
    EEG = pop_resample(EEG,250); %downsample to 250 hz
    savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds.set');
    EEG = pop_saveset( EEG,  'filename', savefile); %Save file in .set format
    end
end

%% Create channel info for each sub and each block

for s = 1%allsubs
    if s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    for b = bs
    name = sublist{s,1};          
    filename = strcat('spm8_',name,num2str(b),'.mat');
    load(filename);
    cor = [num2cell(1:160)',num2cell(D.sensors.meg.pnt(1:160,:)),D.sensors.meg.label(1:160)']; % for the xyz cor for the primary sensors
    
    eval(['dlmcell(''ChanPos_sub' num2str(s) 'block' num2str(b) '.xyz'', cor, ''delimiter'', ''\t'')']);
    end
end
%% Upload channel files to each sub and block
allsubs = 1:16;

for s = 1%allsubs
    if s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    for b = bs
%    name = sublist{s,1};          
 %   filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds.set');
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds_chan_evt_fil_pca.set'); 
    EEG = pop_loadset(filename);
    eval(['EEG = pop_chanedit(EEG,''load'', {''ChanPos_sub' num2str(s) 'block' num2str(b) '.xyz''}, ''nosedir'', ''-X'')']);  
%    eval(['EEG = pop_chanedit(EEG,''load'', {''ChanPos_sub' num2str(s) 'block' num2str(b) '.xyz''}, ''nosedir'', ''-Y'')']);  
   
%    savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds_chan.set');
    savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds_chan_evt_fil_pca.set');
    EEG = pop_saveset( EEG,  'filename', savefile); %Save file in .set format    
    end
end

%% Remove channel info
allsubs = 1:16;

for s = allsubs
    if s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    for b = bs 
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_epoch_br.set');
    EEG = pop_loadset(filename);
    EEG.chanlocs = [];
    savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_epoch_br_nchan.set');
    EEG = pop_saveset( EEG,  'filename', savefile); %Save file in .set format    
    end
end


%% Add events from spm files
% has modified this and add downsampled time points to ica-removed EEG data

allsubs = [5:10 11 15 16];

for s = allsubs
    if s == 6 || s == 8
        bs = 1;
    elseif s == 9
        bs = 3;
    elseif s == 10
        bs = 4;
    else
        bs = 1:4;
    end
    
    for b = bs
    name = sublist{s,1}; 
   % filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds_chan.set');    
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_ica_rm.set');
    EEG = pop_loadset(filename); %Load up EEG dataset

    filename2 = strcat('spm8_mt_',name,num2str(b),'.mat');
    load(filename2);

    for i = 1:length(D.trials.events)
    
    EEG.event(i).type = D.trials.events(i).type;
    EEG.event(i).latency = D.trials.events(i).time*1000/4;%doing this to match the timing of downsampled data (250hz)
    
    end
  %  savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds_chan_evt.set');
    savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_ica_rm_megevt.set');
    EEG = pop_saveset( EEG,  'filename', savefile); %Save file in .set format    
    EEG = eeg_checkset( EEG ); %#ok<NASGU>
    
    end
end

%% The following steps are debugging steps to check MEG and Cogent onset times
% Inspect timing info for bad subjects 5, 7, 15 / good subjects 2,3
% has modified this and add downsampled time points to ica-removed EEG data
sublist = {'2012_11_23_0892_ME051_B';
    '2012_11_26_0896_ME051_B';
    '2012_12_03_0904_ME051_B';
    '2012_12_03_0905_ME051_B';
    '2012_12_04_0906_ME051_B';
    '2012_12_04_0908_ME051_B';
    '2012_12_05_0909_ME051_B';
    '2012_12_05_0910_ME051_B';
    '2012_12_06_0914_ME051_B';
    '2012_12_10_0917_ME051_B';
    '2012_12_10_me051_0918_B';
    '2012_12_11_0919_ME051_B';
    '2012_12_12_0921_ME051_B';
    '2012_13_12_0924_ME051_B';
    '2012_12_17_0926_ME051_B';
    '2012_12_19_0931_ME051_B';};

allsubs = 2%[1 2 3 4 6 8 9 10 11:14 16];%[2 5 7 15];

for s = allsubs
    if s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    alltimes = [];
    
    for b = bs
    name = sublist{s,1}; 
    filename2 = strcat('spm8_',name,num2str(b),'.mat');
    load(filename2);
    type = [];
    latency = [];
    
    for i = 1:length(D.trials.events)    
    type(i,1) = D.trials.events(i).type;
    latency(i,1) = D.trials.events(i).time;
    end  
    
    alltimes = [alltimes; type latency];
    
    end
    
    filename = strcat('Times_',num2str(s),'.mat');
    save(filename, 'alltimes');

end

%% load raw Cogent event times (debugging)
s = 11;
alltimes = [];
t = [];
for b = 1:4
  eval(['load SFG_block' num2str(b) '_sub' num2str(s) '_timeinfo.mat';]); 
  eval(['load SFG_block' num2str(b) '_sub' num2str(s) '_Greebtimeinfo.mat';]); 
  for i = 1:300
      if rem(i,2) == 1 
      t(i,1) = trialarray_time((i+1)/2,3);
      else
      t(i,1) = trialarray_Greebtime((i)/2,3); 
      end
  end
    alltimes = [alltimes; t];
end

%% load raw MEG event times (debugging)
alleventtimes = [];
allcodes = [];

for allblock = 1:4
 event = ['event',num2str(allblock),'.txt'];
% %event = ['event',block,'.txt'];
 event2 = load (event);
 times = [];
 
 %sub15
%  if allblock ==1
%  times = event2(find(event2(1:length(event2),2)==32),1);
%  times_2 = times(27:length(times),1);
%  codes = event2(find(event2(:,2)==32),2);
%  else
%  times = event2(find(event2(1:length(event2),2)==32),1);
%  times_2 = times(1:300,1);
%  codes = event2(find(event2(:,2)==32),2);    
%  end
 
 %Other subjects
 times = event2(find(event2(1:length(event2),2)==32),1);
 times_2 = times(1:300,1);
 codes = event2(find(event2(:,2)==32),2);  
 alleventtimes = [alleventtimes; times_2];
 allcodes = [allcodes; codes];
end

diff = alleventtimes - alltimes; % Compute Cogent Time/MEG Time difference

%% Compare MEG and Cogent Times sub15/16(debugging)
sublist = {'2012_11_23_0892_ME051_B';
    '2012_11_26_0896_ME051_B';
    '2012_12_03_0904_ME051_B';
    '2012_12_03_0905_ME051_B';
    '2012_12_04_0906_ME051_B';
    '2012_12_04_0908_ME051_B';
    '2012_12_05_0909_ME051_B';
    '2012_12_05_0910_ME051_B';
    '2012_12_06_0914_ME051_B';
    '2012_12_10_0917_ME051_B';
    '2012_12_10_me051_0918_B';
    '2012_12_11_0919_ME051_B';
    '2012_12_12_0921_ME051_B';
    '2012_13_12_0924_ME051_B';
    '2012_12_17_0926_ME051_B';
    '2012_12_19_0931_ME051_B';};

allsubs = 16%[1 2 3 4 6 8 9 10 11:14 16];%[2 5 7 15];
alltimes_mt = [];
alltimes_cg = [];

for s = allsubs
    if s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    alltimes = [];
    
    for b = bs
    name = sublist{s,1}; 
    % load meg times
    filename2 = strcat('spm8_mt_',name,num2str(b),'.mat');
    load(filename2);
    type = [];
    latency = [];
    
    for i = 1:length(D.trials.events)    
    type(i,1) = D.trials.events(i).type;
    latency(i,1) = D.trials.events(i).time;
    end  
    
    alltimes_mt = [alltimes_mt; type latency];
    % load cogent times
    filename2 = strcat('spm8_CG_',name,num2str(b),'.mat');
    load(filename2);
    type = [];
    latency = [];
    
    for i = 1:length(D.trials.events)    
    type(i,1) = D.trials.events(i).type;
    latency(i,1) = D.trials.events(i).time;
    end  
    
    alltimes_cg = [alltimes_cg; type latency];
    end

end

diff_time = alltimes_mt(:,2) - alltimes_cg(:,2);
diff_type = alltimes_mt(:,1) - alltimes_cg(:,1);

%% Back to pipeline: filter 0.1 to 40 hz

for s = allsubs
    
    if s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    
    for b = bs        
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds_chan_evt.set');
    EEG = pop_loadset(filename); %Load up EEG dataset
    
    EEG = pop_eegfilt( EEG, 0.1, 0, [], 0);
    %EEG, locutoff = 1, hicutoff = 0, [] = no notch filter, 0 = filter length
    EEG = eeg_checkset( EEG );
    EEG = pop_eegfilt( EEG, 0, 40, [], 0); %Filter in 2 steps to reduce chance of crashing
    EEG = eeg_checkset( EEG );
    savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds_chan_evt_fil.set');
    EEG = pop_saveset(EEG, savefile);    
    end
    
end
    
%% run ica for concatenated (allblocks) data

allsubs = [1 3:16];

for s = allsubs
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
 
    if s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    for b = bs        
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds_chan_evt_fil.set');
    EEG = pop_loadset(filename);
    [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG,EEG);     
 %   EEG = pop_runica(EEG, 'icatype', 'runica');
 %   savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds_chan_evt_fil_ica.set');
 %   EEG = pop_saveset( EEG,  'filename', savefile); %Save file in .set format    
    end
    
    EEG = pop_mergeset(ALLEEG,1:4);
    EEG = pop_runica(EEG, 'icatype', 'runica');
    savefile = strcat('MEGsub',num2str(s),'allblocks_ds_chan_evt_fil_ica.set');
    EEG = pop_saveset( EEG,  'filename', savefile); %Save file in .set format   
    clear EEGLAB
    clear ALLEEG
end

%% run ica for each separate block / this step not necessary
%allsubs = 1:16;

for s = allsubs 
    if s == 6 || s == 8
        bs = 1;
    elseif s == 9
        bs = 3;
    elseif s == 10
        bs = 4;
    else
        bs = 1:4;
    end
    
    for b = bs        
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds_chan_megevt_fil.set');
    EEG = pop_loadset(filename);  
    EEG = pop_runica(EEG, 'icatype', 'runica');
    savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds_chan_megevt_fil_ica.set');
    EEG = pop_saveset( EEG,  'filename', savefile); %Save file in .set format    
    end
    
end

%% plot ica topos and generate component maps
%allsubs = 1:16;

for s = allsubs 
    if s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    for b = bs        
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds_chan_fil_30_ica.set');
    EEG = pop_loadset(filename);  
    EEG = pop_topoplot(EEG, 0, 1:30, 'PCA component maps');
    eval(['saveas(gcf,''Sub' num2str(s) 'block' num2str(b) '_fil30_ICAcomponents.tif'');']); %Example saved file: "grandavgchanA15best.ai"
    close(gcf) %Close the figure you just graphed, so you don't end up with a million figure windows all open at once
    clear EEG;
  %  savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_ica2.set');
   % EEG = pop_saveset( EEG,  'filename', savefile); %Save file in .set format    
    end
end

%% Inspect component (potential artefacts) properties
components = { %potential components to reject (second ICA)
    {},{},{},{7};
    {6 8},{},{},{};
    {22 25},{6},{6,21},{7};
    {8},{},{8},{};
    {7},{14},{8 14},{7};
    {6 8 11 12 20},{6 16 19},{9 10 12},{9 14 25};
    {21 25},{8 29},{8},{30};
    {},{},{},{};
    {16},{18},{26},{12};
    {6},{13 21},{16 17 19 25},{3 4 5 12};
    {20},{26},{3},{10 18};
    {18},{24},{13 19},{11 20 26};
    {11},{21},{22},{};
    {7 10 20},{14 18 30},{19 20},{};  
    {27 30},{},{22},{};
    {20 24},{5 6 9},{3},{4 5 6};    
    };

%%  Inspect component (potential artefacts) properties(PCA)
components = { %potential components to reject (first PCA)
    {6},{5 10},{9 15},{5 6};
    {3 4 5 6 9 15 16},{},{},{};
    {2 5 6},{2 4 6 8 9},{2 5 6 8},{2 5 7};
    {6 15},{5 17 27},{5 18 23},{5 16 20};
    {6 7 8 16 26},{7 16 35},{4 9 15 16},{4 12 46};
    {2 11 14},{2 5 8},{2 5 6 8 9},{2 5 6 9 32};
    {3 12 13 14 30},{2 15 19 31},{2 16 17 27},{2 14 19 29 33};
    {4 5 11},{2 6 7 32 33},{2 8 15 38},{2 8 18};
    {4 7 17 18 30},{3 4 14},{2 19},{4 11 28};
    {2 3 7 8 14},{1 2 6 9 21 22},{1 3 10 17},{1 3 7 9};
    {4 5 6 10 23 24},{4 5 7 31},{3 7 8},{3 4 5 6 22 37};
    {3 5 6 9 21 22},{4 5 9 11 17},{3 5 6 7 12 29},{5 8 11 20 24 41};
    {2 5 9 20 27},{3 5 14 18},{2 6 13 28},{3 6 15};
    {2 4 5 6 7},{2 3 6 7 10},{1 5 6 7},{2 3 8 14};  
    {4 18 19 21 24},{4 6 24},{2 19 3 4 5},{2 19 20};
    {1 20 23 28},{1 24},{1 15 18 21},{1 5 27};    
    };
%% Inspect component (potential artefacts) properties(ICA - epoch -PCA)
components = { % for second PCA after first ICA and epoching
    {1 2 4 5 7},{3 6},{1 2 3 4 5 6 10},{};
    {4 13},{},{},{};
    {},{4 7},{},{};
    {8},{},{},{2};
    {12 17 20 22},{15 18 20},{16 22},{14 18 20 28};
    {12},{4},{9},{4};
    {5 7 9 15},{3 7 9 11 15 21 28},{4 5 8 10 13 14 21 28},{3 7 8 9 12 24};
    {21},{4},{8 16},{};
    {12 24},{8 25 27},{22 30},{};
    {6 19},{3 12},{5 6 14},{9};
    {12 18 26 29 30},{20 22 23 26 30},{5 15 17 22 27 28 29},{7 12 16 18 26 29 30};
    {17},{27},{},{};
    {},{},{},{22};
    {7 27},{27},{2 3 7 11},{};  
    {3 4 6 7 8 12 15 16 25},{2 4 5 6 8 9 10 13 15 22 30},{2 3 4 5 7 9 11 12 13 16 17 19 23},{2 3 6 22 30};
    {4 17},{3 27},{4 9},{4 5 21};    
    };
%% Inspect component (potential artefacts) properties(5 bad subjects)
%allsubs = 15%1:16;

components = { %for 5 bad subjects; components of suspicion
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};   
    {1 2 3 4 5 11 12 16 18 19 29},{1 2 3 4 5 6 7 17},{1 2 3 4 5 6 8 9 13 15 16},{1 2 3 4 5 6 7 8 10 18 20};
    {},{},{},{};
    {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 21 26 27 29},{1 5 12},{1 6 13},{1 6 18 30};
    {},{},{},{};
    {},{},{},{};   
    {},{},{},{};
    {1 2 3 4 5 6 9 12 13 28},{1 2 3 4 5 6 7 8 9 10 11 12 20 26},{1 2 3 6 7 8 10 11 12 13 14 15 19 24},{1 2 3 4 5 6 7 8 9 10 11 12 13 17 23};
    {},{},{},{};
    {},{},{},{};
    {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 19 20 21 26},{1 2 3 4 5 6 7 8 9 10 14 15 16 17 18 19 20 21 24 30},{1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 18 26 27 29},{1 2 4 5 6 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23};   
    {2 9 15 28 30},{2 12 23 30},{2 15 21 27 30},{2 21 26 29};
    {},{},{},{};  
    };
%%
components = { % after-epoch PCA for 5 bad subjects
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};   
    {1 3 4},{1 2 3 4 5 6 7 13 20 27 28},{1 2 4 7 8 14 22 27 28},{1 2 3 5 6 10 22 25 28};
    {},{},{},{};
    {1 2 3 5 6 8 11 12 24 26},{1 2 3 4 5 6 7 8 9 10 11 12 13 14 21 29},{1 2 3 4 5 6 7 8 9 19 11 12 15 16 17 19 20},{1 2 3 4 5 7 8 13 21 23 25 26};
    {},{},{},{};
    {},{},{},{};   
    {},{},{},{};
    {1 2 3 4 5 6 9 10 11 28},{1 2 3 4 5 12 14 23},{1 2 4 5 6 7 9 10 12 13 14},{1 3 4 5 6 11 12 13 17 18 23 26 27 28};
    {},{},{},{};
    {},{},{},{};
    {1 3 4 5 6 7 8 9 10 11 12 13 15 18 28},{1 2 3 4 5 6 7 8 10 17 19},{1 2 3 4 5 7 9 10 12 16 25 27},{1 2 3 4 5 6 7 8 9 10 11 12 16 22 25};   
    {1 2 3 4 5 11 12 19},{1 2 3 4 8 10 13 22 30},{1 2 3 4 5 6 7 8 16 21 29},{1 2 3 5 6 15 16 18 20 22 28 30};
    {},{},{},{};  
    };

%% Inspect component (potential artefacts) properties(5 bad subjects)
%allsubs = 15%1:16;

components = { %for 4 bad subjects; components of suspicion 1-30hz
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};   
    {1 2 3 4 5 9 10 19 24},{1 2 3 4 5 9 12 13 15},{1 2 3 4 5 6 7 9 10 11 14 28 30},{1 2 3 4 5 6 7 10 14 18 24 29 30};
    {},{},{},{};
    {1 4 5 6 30},{1 3 10 27},{1 5 13 17 26 30},{1 5 6 15 30};
    {},{},{},{};
    {},{},{},{};   
    {},{},{},{};
    {1 2 3 4 7 8 12 18},{1 2 3 4 9 16 24},{1 2 3 4 15 21 22 29},{1 2 3 4 7 17 18 23};
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};   
    {2 8 23 29},{2 11 20 22},{2 15},{2 18 19};
    {},{},{},{};  
    };
%%
allsubs = [6:10 16];
components = { %for megtime redo subjects
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};   
    {4 6 10 11 17 22 24 25 30},{9 14 22 29},{21},{8 9 10 14 16 18 25};
    {12 13 19 24},{},{},{};
    {3 5 7 8 22},{3 5 6 8 19 22 24 26},{4 6 8 10 16 20 21 29},{2 3 4 9 22 23 26};
    {4 14},{},{},{};
    {},{},{7 10 13 19 24 30},{};   
    {},{},{},{4 5 23 24 30};
    {5 25 26},{19 21 30},{7 13 21},{8 10 15 19 28};
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};   
    {2 3 6 7 8 21 22 28},{2 5 6 19 20 22 26},{2 3 4 6 8 12 18 20 21 28},{2 3 4 8 18 20 25};
    {4 6 7 9 10 11},{4 5 6 8 9 12 13 14 17 19 25 26 27 30},{1 9 13 19 27 28 29 30},{3 9 12 14 21 22};  
    };

for s = allsubs 
    if s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    for b = bs 
        cp = components{s,b};
        if ~isempty(cp)    
        filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_megevt_epoch_pca.set');
        
        for c = 1:length(cp)
        EEG = pop_loadset(filename);             
        cn = cell2mat(cp(c));    
        EEG = pop_prop(EEG, 0, cn);
        eval(['saveas(gcf,''Sub' num2str(s) 'block' num2str(b) '_megevt_ICA_PCAcomponents' num2str(cn) '.tif'');']); %Example saved file: "grandavgchanA15best.ai"
        close(gcf); %Close the figure you just graphed, so you don't end up with a million figure windows all open at once
        end
        
        end
    end
end

%% Remove ICA components
components = { %components finally marked for removal for second ICA
    {},{},{},{7};
    {6 8},{},{},{};
    {25},{},{21},{7};
    {8},{},{8},{};
    {7},{14},{8 14},{7};
    {6 8 11 20},{6 16},{9 12},{9 14};
    {25},{29},{},{};
    {},{},{},{};
    {16},{18},{26},{};
    {6},{13},{19},{3 4 5 12};
    {20},{26},{3},{10 18};
    {},{24},{13 19},{20 26};
    {11},{21},{22},{};
    {7 10},{30},{19},{};  
    {27 30},{},{},{};
    {20 24},{5 9},{},{4 5 6};    
    };
%%
components = { % for second PCA after first ICA and epoching
    {1 7},{},{},{};% MARKED finally for removal
    {13},{},{},{};
    {},{},{},{};
    {8},{},{},{2};
    {17},{20},{16},{14};
    {12},{4},{9},{4};
    {5 7 9 15},{3 7 21},{4 5 8 13},{3 7 8 9 12 24};
    {21},{},{16},{};
    {24},{27},{30},{};
    {},{},{},{};
    {26},{20 22 26},{5 17 22 27 28},{7 12 29 30};
    {17},{27},{},{};
    {},{},{},{22};
    {},{},{},{};  
    {3 8 12 15 16 25},{2 4 5 6 8 10 30},{2 3 4 9 23},{2 3 22};
    {},{27},{4 9},{4 5 21};    
    };

%%

components = { % first ICA rej for 5 bad subjects
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};   
    {1 3 5 12},{1 3 4},{1 3 4 6},{1 4 5 6};
    {},{},{},{};
    {1 4 9 29},{1 5 12},{1 6 13},{1 6 18};
    {},{},{},{};
    {},{},{},{};   
    {},{},{},{};
    {1 2 6 9 13},{1 2 3 7 10 12 26},{1 2 3 6 10 14 19},{1 2 3 6 13 14 23};
    {},{},{},{};
    {},{},{},{};
    {1 2 3 10 13 19 26},{1 2 3 5 15 16 18 20},{1 2 3 4 15 18 27},{1 2 10 14 19 23};   
    {2 9 28},{2 12 30},{2 15 30},{2 21};
    {},{},{},{};  
    };

%%
components = { % after-epoch PCA for 5 bad subjects
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};   
    {},{},{},{2};
    {},{},{},{};
    {1 2 6},{1 2 6 7},{1 3 19 20},{1 2 5 7 13 23 26};
    {},{},{},{};
    {},{},{},{};   
    {},{},{},{};
    {1 6},{5},{9 13},{6};
    {},{},{},{};
    {},{},{},{};
    {7 8},{2 3 10},{2 3 25},{2 4 6};   
    {1},{3},{1 3 4 6},{1 28};
    {},{},{},{};  
    };

%%
components = { %for 4 bad subjects;ICA-epoched PCA components of suspicion 1-30hz
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};   
    {},{},{1},{2};
    {},{},{},{};
    {1 2 4 7},{1 2 5 6 16},{1 2 3 4 8},{1 2 4 6 21};
    {},{},{},{};
    {},{},{},{};   
    {},{},{},{};
    {},{},{5},{3};
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};   
    {1 2 3 24},{1 3 4 10 13 26},{1 2 3 5 13 24},{1 12 17 18 25};
    {},{},{},{};  
    };
%%
allsubs = [5:10 11 15 16];
components = { %for megtime redo subjects
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};   
    {17},{22},{21},{14};
    {},{},{},{};
    {3},{3},{4 6 29},{2};
    {14},{},{},{};
    {},{},{30},{};   
    {},{},{},{5};
    {25},{19},{7 21},{28};
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};   
    {2 6 28},{2 5 26},{2 4 28},{2 4};
    {},{30},{27 28 29 30},{};  
    };

%allsubs = 1:16;

for s = allsubs 
    if s == 6 || s == 8
        bs = 1;
    elseif s == 9
        bs = 3;
    elseif s == 10
        bs = 4;
    else
        bs = 1:4;
    end
    
    for b = bs        
    cp = components{s,b};    
    
    if ~isempty(cp)
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_megevt_epoch_pca.set');
    EEG = pop_loadset(filename);  
    EEG = pop_subcomp(EEG, cell2mat(cp) , 0);
    savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_megevt_epoch_pca_rm.set');
    EEG = pop_saveset( EEG,  'filename', savefile); %Save file in .set format   
    else
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_megevt_epoch_pca.set');
    EEG = pop_loadset(filename);  
    savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_megevt_epoch_pca_rm.set');
    EEG = pop_saveset( EEG,  'filename', savefile); %Save file in .set format          
    end
    
    end
end

%% Try PCA. First find out the No. of principle components needed
allsubs = 1:16;
PCAcomp = [];
for s = allsubs 
    if s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    for b = bs        
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_epoch.set');
    EEG = pop_loadset(filename);
    data = EEG.data;
    [pc,score,latent,tsquare] = princomp(data'); % concatenate your trials in time (suggested)
    r=find(cumsum(latent)./sum(latent) > 0.98);
    compNo = r(1); %is the total number of components need to capture more than 98 % of the variance of 
    %your initial data
    PCAcomp = [PCAcomp; s b compNo];
    clear EEG;
    end
end

%save MEG_PCAcomp_No PCAcomp

%% Run ICA with the PCA option

%allsubs = 7:16;

for s = allsubs 
    if s == 6 || s == 8
        bs = 1;
    elseif s == 9
        bs = 3;
    elseif s == 10
        bs = 4;
    else
        bs = 1:4;
    end
    
    for b = bs        
  %  compno = PCAcomp(counter,3); % use the No. of principle components specified in the last step   
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_megevt_epoch.set');
    EEG = pop_loadset(filename);  
    EEG = pop_runica(EEG, 'icatype', 'runica', 'options',{'pca' 30});
    savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_megevt_epoch_pca.set');
    EEG = pop_saveset( EEG,  'filename', savefile); %Save file in .set format    
    end
    
end

%% Plot ICA/PCA components
%load MEG_PCAcomp_No PCAcomp
%allsubs = 1:16;% problematic: s1b4, s2b1, s8b2, s10b4, s11b3/4, s16b3

for s = allsubs 
    if s == 6 || s == 8
        bs = 1;
    elseif s == 9
        bs = 3;
    elseif s == 10
        bs = 4;
    else
        bs = 1:4;
    end
    for b = bs        
    %compno = PCAcomp(counter,3); % use the No. of principle components specified in the last step         
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_megevt_epoch_pca.set');
    EEG = pop_loadset(filename);  
    EEG = pop_topoplot(EEG, 0, 1:30, 'PCA component maps');    
   % EEG = pop_topoplot(EEG, 0, 1:compno, 'PCA component maps');
    eval(['saveas(gcf,''Sub' num2str(s) 'block' num2str(b) '_megevt_ICA_PCAcomponents.tif'');']); %Example saved file: "grandavgchanA15best.ai"
    close(gcf) %Close the figure you just graphed, so you don't end up with a million figure windows all open at once
    clear EEG;
    end
end

%% Remove PCA components
components = { %potential components to reject (for first PCA)
    {6},{5 10},{9},{5 6};
    {3 4 5 6 9 15 16},{},{},{};
    {2 5},{2 4},{2 6},{2 5};
    {6 15},{5 17 27},{5 18 23},{5 16 20};
    {6 7 8 16},{7 16 35},{4 9 15},{4 12 46}; %single-dot source: 46
    {2 11 14},{2 5 8},{2 5 6 8 9},{2 5 6 9}; %single-dot source: 32
    {3 12 13 14 30},{2 15 19 31},{2 16 17 27},{2 14 19 29 33};
    {4 5 11},{2 6 7 32},{2 8 15},{2 8}; %single-dout source: 33
    {4 17 18 30},{3 14},{2},{4 11 28};
    {2 3 8 14},{1 2 9 21 22},{1 3 10 17},{1 3 9};
    {4 5 6 10},{4 7 31},{3 7 8},{3 4 5 37};%single-dot source: 31
    {3 5 6 9 22},{4 5 9},{3 5 6 7 29},{5 8 11 20 24}; %single-dot source: 41
    {2 5 9 20 27},{3 5 14 18},{2 6 13 28},{3 6 15};
    {2 4 5 6},{2 3},{1 5 7},{2 3 14};  
    {4 19 21},{4},{2},{2 20};
    {1 20 28},{1 24},{1},{1 27};    
    };

%%

components = { %for 5 bad subjects; remove ICA-epoched PCA components 1-30hz
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};   
    {1 2 4 10},{1 3 4},{1 3 5 7},{1 3 4};
    {},{},{},{};
    {1 4 6 30},{1 3 10},{1 5 13},{1 6 15};
    {},{},{},{};
    {},{},{},{};   
    {},{},{},{};
    {1 2 3 4 7 12},{1 2 3 4 9 24},{1 2 3 4 15},{1 2 3 4 7 18 23};
    {},{},{},{};
    {},{},{},{};
    {},{},{},{};   
    {2 8 23 29},{2 11},{2 15},{2 18};
    {},{},{},{};  
    };

for s = allsubs 
    if s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    for b = bs        
    cp = components{s,b};    
    
    if ~isempty(cp)
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds_chan_evt_fil_pca.set');
    EEG = pop_loadset(filename);  
    EEG = pop_subcomp(EEG, cell2mat(cp) , 0);
    savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_pca_rm.set');
    EEG = pop_saveset( EEG,  'filename', savefile); %Save file in .set format   
    else
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds_chan_evt_fil_pca.set');
    EEG = pop_loadset(filename);  
    savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_pca_rm.set');
    EEG = pop_saveset( EEG,  'filename', savefile); %Save file in .set format          
    end
    
    end
end

%% high-pass filter > 0.5hz for bad subjects
% try highpass 1hz, "_fil1"
% try lowpass 30hz on top of 1hz, "_fil30"

allsubs = [5 7 11 14 15];
for s = allsubs
    if s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    for b = bs        
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds_chan.set');
    EEG = pop_loadset(filename); %Load up EEG dataset
    
    EEG = pop_eegfilt( EEG, 1, 0, [], 0);
    %EEG, locutoff = 1, hicutoff = 0, [] = no notch filter, 0 = filter length
    EEG = eeg_checkset( EEG );
    EEG = pop_eegfilt( EEG, 0, 30, [], 0); %Filter in 2 steps to reduce chance of crashing
    EEG = eeg_checkset( EEG );
    savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_ds_chan_fil_30.set');
    EEG = pop_saveset(EEG, savefile);    
    end
end

%% Epoching
for s = allsubs
    if s == 6 || s == 8
        bs = 1;
    elseif s == 9
        bs = 3;
    elseif s == 10
        bs = 4;
    else
        bs = 1:4;
    end
    
    for b = bs        
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_ica_rm_megevt.set');
    EEG = pop_loadset(filename); %Load up EEG dataset
    epochname = strcat('MEGsub',num2str(s),'block',num2str(b),'_megevt_epoch.set'); 
    EEG = pop_epoch( EEG, {11 12 13 21 22 23}, [-0.2   0.3], 'newname', epochname, 'epochinfo', 'yes'); %1-18: all possible conditions (emotion*sf*response accuracy)
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset(EEG, epochname); %#ok<NASGU> %Save epochs
    end
end


%% Check again after epoching with ica

allsubs = 1:16;

for s = allsubs 
    if s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    for b = bs        
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_pca_fil_epoch.set');
    EEG = pop_loadset(filename);  
    EEG = pop_runica(EEG, 'icatype', 'runica');
    savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_pca_fil_epoch_ica.set');
    EEG = pop_saveset( EEG,  'filename', savefile); %Save file in .set format    
    end
    
end

%% Baseline correction

allsubs = [1:10 12:16]; 

for s = allsubs
    if s == 5 || s == 9
        bs = [1 2 4];
    elseif s == 6 || s==8 
        bs = 2:4;
    elseif s == 10 || s == 7
        bs = 1:3;
    elseif s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    
    for b = bs  
    filename = strcat('MEGsub',num2str(s),'block',num2str(b),'_epoch_pca_rm.set');
    EEG = pop_loadset(filename); %Load up EEG dataset
    
    EEG = pop_rmbase( EEG, [-200 0]); %-100ms to 0
    EEG = eeg_checkset( EEG );
    savefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_epoch_pca_rm_br.set');
    EEG = pop_saveset(EEG, savefile); %#ok<NASGU>
    end
end

%% Reject trials based on a predetermined threshold
thl = -5.00000000000000e-10;% final threshold for most subs; +-6 for sub 1,7,1
thh = 5.00000000000000e-10;

allsubs = [2]%[1:10 12:16]%[1:6 8:10 12:14]; 

for s = allsubs
    if s == 5 || s == 9
        bs = [1 2 4];
    elseif s == 6 || s==8 
        bs = 2:4;
    elseif s == 10 || s==7
        bs = 1:3;
    elseif s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    
    for b = bs  
    filename6 = strcat('MEGsub',num2str(s),'block',num2str(b),'_epoch_pca_rm_br.set'); 
    EEG = pop_loadset(filename6); %Load up baseline-corrected data
    allrejtrialtest = cell(160,3); %Col 1 = chan #, col 2 = # of rejected trials for that chan, col 3 = trial #s flagged for rejection for that chan
       for c = 1:160 %For each channel
       allrejtrialtest{c,1} = c; %Col 1 = chan #
       EEG = pop_eegthresh(EEG,1,c,thl,thh,-0.2,0.3,0,0);
       EEG = eeg_checkset( EEG );
       [EEG,com] = eeg_rejsuperpose( EEG, 1, 1, 1, 1, 1, 1, 1, 1); %#ok<NASGU> %Updates EEG.reject.rejglobal
       rejtr = find(EEG.reject.rejglobal); %"this channel's rej trials"; finds all trial #s that were rejected by pop_eegthresh
       allrejtrialtest{c,2} = length(rejtr); %Col 2 = # of rejected trials
       allrejtrialtest{c,3} = rejtr; %Col 3 = trial #s flagged for rejection for that chan
       end
   eval(['save MEGblock' num2str(b) '_sub' num2str(s) '_allrejtrialtest allrejtrialtest']);
   clear EEG
   end
end


%% Exclude channels, save corresponding info, and mark artifacts on just the included EEG channels.
%Extensive modifications made 11/15/10, patterned on
%Added chaninfo stuff (originally was in
%separate cell) and three-sections (back, middle, front) thresholding.
%allsubs = [1:6 8:10 12:14]; 

howmanysubs = length(allsubs); %1 row/subj
allsubs_feareegintrejtrials = cell(howmanysubs,5); %Col 1 = sub #, col 2 = EEG rej trials for block 1, col 3 = same for block 2, col 4 = for blk 3, col 5 = for blk 4
fintrow = 1; %Row counter

%Preallocation for giant-chaninfo-arrays
fearallchaninfo = cell(howmanysubs,9); %Cell array w/1 row per subj and 9 columns to store info
frow = 1; %Since included subjs are sometimes nonconsecutive, use "row" to fill in each row

for s = 2%allsubs
    if s == 5 || s == 9
        bs = [1 2 4];
    elseif s == 6 || s==8 
        bs = 2:4;
    elseif s == 10 ||s ==7
        bs = 1:3;
    elseif s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    
    for b = bs  
    fchanexc = []; %Matrix of excluded channels & # of rejected trials in each
    fchaninc = []; %Matrix of included channels
    eval(['load MEGblock' num2str(b) '_sub' num2str(s) '_allrejtrialtest allrejtrialtest']);
   
        for c = 1:160 %For each channel
        rejtr = allrejtrialtest{c,2}; %# of rejected face trials for that channel       
        z=38;        
            if rejtr > z %If # of rej face trials is >25% of total trials
            fchanexc = [fchanexc c]; %#ok<AGROW> %Add channel to "excluded channels" matrix
            else %Otherwise, add channel to "included channels" matrix
            fchaninc = [fchaninc c]; %#ok<AGROW> 
            end
        end       
     
        if ~isempty(fchanexc); %If any channels were excluded
        sprintf('%s','The following channels will be excluded:')
        sprintf('%d'' ',fchanexc) %Display onscreen which channels were excluded
        else %If no channels were excluded
        sprintf('%s','All channels will be included')
        end
        chaninfo.chanexc=fchanexc;
        chaninfo.chaninc=fchaninc;
        eval(['save MEGblock' num2str(b) '_sub' num2str(s) '_chaninfo chaninfo']); %Save excluded & included channels matrices
    
        fearallchaninfo{frow,1} = s; %col 1 = subj #
    
        switch b
            case (1) %For block 1
            fearallchaninfo{frow,2}=chaninfo.chanexc; %col 2 = excl. chans for block 1 for this subj
            fearallchaninfo{frow,3}=chaninfo.chaninc; %col 3 = incl. chans for block 1 for this subj
            case (2) %For block 2
            fearallchaninfo{frow,4}=chaninfo.chanexc; %col 4 = excl. for block 2
            fearallchaninfo{frow,5}=chaninfo.chaninc; %col 5 = incl. for block 2
            case (3) %For block 3
            fearallchaninfo{frow,6}=chaninfo.chanexc; %col 6 = excl. block 3
            fearallchaninfo{frow,7}=chaninfo.chaninc; %col 7 = incl. block 3
            case (4) %For block 4
            fearallchaninfo{frow,8}=chaninfo.chanexc; %col 8 = excl. block 4
            fearallchaninfo{frow,9}=chaninfo.chaninc; %col 9 = incl. block 4
        end
        
    chanint = chaninfo.chaninc;    
    %Mark artifacts on just the included channels of interest.  In 3
    %batches, one for each section of the head.
    filename4 = strcat('MEGsub',num2str(s),'block',num2str(b),'_epoch_pca_rm_br.set'); %Dataset free of previous thresholding
    EEG = pop_loadset(filename4); 
    EEG = pop_eegthresh(EEG,1,chanint,thl,thh,-0.2,0.3,0,0);
    EEG = eeg_checkset(EEG); %Check for errors
    [EEG,com] = eeg_rejsuperpose(EEG, 1, 1, 1, 1, 1, 1, 1, 1); %#ok<NASGU> %EEG.reject.rejglobal now has all marked trials for EEGchans
    
    intrejtriallocs = find(EEG.reject.rejglobal); %Obtain rejected trial #s
    eval(['save MEGsub',num2str(s),'block',num2str(b),'_intrejtriallocs intrejtriallocs']); %Save rejected trial locations
    allsubs_feareegintrejtrials{fintrow,1} =s;
        switch b %For each of the 4 blocks
            case(1)
            allsubs_feareegintrejtrials{fintrow,2} = intrejtriallocs; %Also save locations into big matrix
            case(2)
            allsubs_feareegintrejtrials{fintrow,3} = intrejtriallocs;
            case(3)
            allsubs_feareegintrejtrials{fintrow,4} = intrejtriallocs;
            case(4)
            allsubs_feareegintrejtrials{fintrow,5} = intrejtriallocs;
        end
        
    clear EEG %Keep memory from overloading
    end
    
fintrow = fintrow + 1; %Move to next row = next subject in each channels-of-interest EEG rejtriallocs cell array (fear)
frow = frow + 1; %Next row for fear allchaninfo matrix
end

save MEGsubs_eegintrejtrials.mat allsubs_feareegintrejtrials
save MEGChanInfo.mat fearallchaninfo

%% Actually Reject trials
allsubs = [1:10 12:16];
howmanysubs = length(allsubs);

for s = allsubs
    if s == 5 || s == 9
        bs = [1 2 4];
    elseif s == 6 || s==8 
        bs = 2:4;
    elseif s == 10 || s==7
        bs = 1:3;
    elseif s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    
    for b = bs  
    eval(['load MEGsub',num2str(s),'block',num2str(b),'_intrejtriallocs intrejtriallocs']); %Save rejected trial locations

        %Convert final marked trials matrix to logical; save
    if s == 2
        x = 600;
    else
        x = 150;
    end

        rejectbinary = zeros(1,x); %Preallocate zeros, 1 for each trials
            for p =1:length(intrejtriallocs) %For each trial flagged for rejection
            a = intrejtriallocs(p); %Assign that trial # to a variable
            rejectbinary(a) = 1; %That trial #'s spot in the zeros matrix becomes 1
            end
            
        rejectlogical = logical(rejectbinary); %#ok<NASGU> %Converts the zeros-and-ones matrix to a logical for use in EEG.reject.rejglobal
        
        filename6 = strcat('MEGsub',num2str(s),'block',num2str(b),'_epoch_pca_rm_br.set'); 
        EEG = pop_loadset(filename6); %Load up baseline-corrected data
        EEG.reject.rejglobal = rejectlogical; %Assign logical results of previous cell to EEG.reject.rejglobal
        EEG = pop_rejepoch(EEG, EEG.reject.rejglobal, 0); %#ok<NASGU> %Rejects marked trials
        savefilef = strcat('MEGsub',num2str(s),'block',num2str(b),'_epoch_pca_rm_br_trej.set');
        EEG = pop_saveset(EEG, savefilef); %Resave w/"arej" in title
        clear EEG
   end
end


%% Extract ERPs

%allsubs = [1:6 8:10 12:14]; 
allsubs = [1:10 12:16];

for s = allsubs 
    if s == 5 || s == 9
        bs = [1 2 4];
    elseif s == 6 || s==8 
        bs = 2:4;
    elseif s == 10 || s == 7
        bs = 1:3;
    elseif s == 2
        bs = 1;
    else
        bs = 1:4;
    end

    for b = bs %for each block
    %Preallocate cell arrays: 1 array for each condition
    %Condition labesl 1:LSF F, 2: LSF D, 3: LSF N, 4: HSF F, 5: HSF D, 6:
    %HSF N    
        fearL = cell(160,1);    
        disgustL = cell(160,1);
        neutralL = cell (160,1);
        fearH = cell(160,1);    
        disgustH = cell(160,1);
        neutralH = cell (160,1);

%         fear_allresp_all = cell(96,1);    
%         disgust_allresp_all = cell(96,1);
%         neutral_allresp_all = cell (96,1);   
        
            %load ica removed epoched files for each sub and each block
            thefile = strcat('MEGsub',num2str(s),'block',num2str(b),'_epoch_pca_rm_br_trej.set');
            EEG = pop_loadset(thefile); %Load up results from previous cell for this subj, block, head section
            cleandata = EEG.data; %return channel per frame*frames per epoch*number of epochs
            epochdur = EEG.pnts; %return frames per epoch
            cleanevents = [];
 
            %Create 1-row matrix of all event codes for clean epochs
            for i=1:length(EEG.epoch)%For each clean epoch
                n = EEG.epoch(i).eventtype;
                if iscell(n)
                    for ii=1:length(n)
                        if n{ii} <99
                        cleanevents = [cleanevents n(ii)];
                        end
                    end
                else
                    for ii=1:length(n)
                        if n(ii) <99
                        cleanevents = [cleanevents n(ii)];
                        end
                    end
                    
                end
            end
                        
            clear EEG %Got all the info we need, so let's clear it out to save memory
            howmanyevents = length(cleanevents);
            
            
            for m = 1:160 %For each channel in this section
                
        % All resp 3*2
               fearL_allresp = [];    
               disgustL_allresp = [];
               neutralL_allresp = [];
               fearH_allresp = [];    
               disgustH_allresp = [];
               neutralH_allresp = [];
      
                %For each clean event, add its epoch to the relevant condition matrix
                for j = 1:howmanyevents
                    
                cleanevent = cell2mat(cleanevents);
                
                    switch cleanevent(j)
                    case(11) %Event code 1: fear, low

                        fearL_allresp = [fearL_allresp; cleandata(m,(1+epochdur*(j-1): epochdur*j))] ; %#ok<AGROW>

                    case(12) %Event code 2: disgust,low

                        disgustL_allresp = [disgustL_allresp; cleandata(m,(1+epochdur*(j-1): epochdur*j))] ; %#ok<AGROW>

                    case(13) %Event code 3: neutral, low

                        neutralL_allresp = [neutralL_allresp; cleandata(m,(1+epochdur*(j-1): epochdur*j))] ; %#ok<AGROW>

                    case(21) %Event code 4: fear, high, correct

                        fearH_allresp = [fearH_allresp; cleandata(m,(1+epochdur*(j-1): epochdur*j))] ; %#ok<AGROW>

                    case(22) %Event code 5: disgust, high , correct

                        disgustH_allresp = [disgustH_allresp; cleandata(m,(1+epochdur*(j-1): epochdur*j))] ; %#ok<AGROW>

                    case(23) %Event code 6: neutral, high , correct

                        neutralH_allresp = [neutralH_allresp; cleandata(m,(1+epochdur*(j-1): epochdur*j))] ; %#ok<AGROW>
      
                    end %Of switch for coding events
                end %Of event loop
                
                %Average all epochs in each cell to get an average epoch for that channel in that condition.
                %Then assign that average epoch to the relevant cell in the large (96,1) array.
                        
        % All resp 3*2
               fearL{m} = fearL_allresp;    
               disgustL{m} = disgustL_allresp;
               neutralL{m} = neutralL_allresp;
               fearH{m} = fearH_allresp;    
               disgustH{m} = disgustH_allresp;
               neutralH{m} = neutralH_allresp;
                
            end %Of channel loop
        
        aaa=epochdur*1000/250; %Converts back from datapoint time into seconds
        horz=linspace(1, aaa, epochdur); %Vector from 1 to total # of seconds per epoch, w/as many points as are in an epoch
        %Time to save everything!
        %Creating save structure "results"
        results.horz = horz; %Will use later to graph
        results.cleandata = cleandata;
        results.epochdur=epochdur;

        results.fearL = fearL;
        results.disgustL = disgustL;
        results.neutralL = neutralL;
        results.fearH = fearH;
        results.disgustH = disgustH;
        results.neutralH = neutralH;

       
        eval(['save MEGsub' num2str(s) 'block' num2str(b) 'ERPs_ica_pca_nd.mat results';]); %Save it all for fear
        clear cleandata %To save memory
        clear results 
    end %Of block loop
end %Of subject loop 
    

%% Collapsing across blocks % change directory to "CollapseBlocksERP"

%cd 'C:\Users\User\Documents\MEG_all\MEG2EEG\CollapseBlocksERP'

allsubs = [5 6 8 9 10];

for s = 15%allsubs
    if s == 5 || s == 9
        bs = [1 2 4];
    elseif s == 6 || s==8 
        bs = 2:4;
    else
        bs = 1:4;
    end

%Preallocate cell arrays for each subject's averages.
        % All resp 3*2
        fearL = cell(160,1);    
        disgustL = cell(160,1);
        neutralL = cell (160,1);
        fearH = cell(160,1);    
        disgustH = cell(160,1);
        neutralH = cell (160,1);
        
       for c = 1:160 %For each channel
    %Preallocate condition matrices for this channel
        
        % All resp 3*2
               fearL_allresp = [];    
               disgustL_allresp = [];
               neutralL_allresp = [];
               fearH_allresp = [];    
               disgustH_allresp = [];
               neutralH_allresp = [];
        
            for g = 2:4%bs %For each of the 4 blocks

            eval(['load MEGsub' num2str(s) 'block' num2str(g) 'ERPs_ica_pca_nd8.mat results';]); %Load fear file
            eval(['load MEGblock' num2str(g) '_sub' num2str(s) '_chaninfo_ica_pca chaninfo']); %Load fear file channel info
          
             if c == 1 %Only have to do this part once for each subj & block (during channel 1)
            
                if g == 1 %Only have to do this part once for each subject (during block 1--> changed to 2 because sub1 doesn't have block1)
                horz = results.horz; %#ok<NASGU> %Will become the x-axis later, when graphing
                epochdur = results.epochdur; %Tells us how long the epoch is (in ms)
                else
                end
             else
             end

             if ~isempty(find(chaninfo.chaninc==c, 1)) %If this channel is in the included channels matrix
%             %Grab mean epoch for this channel for each condition &
%             %concatenate w/other 2 blocks        
                fearL_allresp = [fearL_allresp; results.fearL{c}];
                disgustL_allresp = [disgustL_allresp; results.disgustL{c}];
                neutralL_allresp = [neutralL_allresp; results.neutralL{c}];
                fearH_allresp = [fearH_allresp; results.fearH{c}];
                disgustH_allresp = [disgustH_allresp; results.disgustH{c}];
                neutralH_allresp = [neutralH_allresp; results.neutralH{c}];
             end
%            else %If the channel was excluded, don't add anything to the concatenated matrix
            end % end of the block loop
        % All resp 3*2
               fearL{c} = mean(fearL_allresp,1);    
               disgustL{c} = mean(disgustL_allresp,1);
               neutralL{c} = mean(neutralL_allresp,1);
               fearH{c} = mean(fearH_allresp,1);    
               disgustH{c} = mean(disgustH_allresp,1);
               neutralH{c} = mean(neutralH_allresp,1);  
               
        clear results %To save memory--these are big files!
        end %Of channel loop

    %Now that the ERPs for each block have been collected, average them
    %together & assign them to the correct cell in the overall matrix.

%Time to save everything!
%Creating save structure "results"
        results.horz = horz; %Will use later to graph
        results.epochdur=epochdur;

        results.fearL = fearL;
        results.disgustL = disgustL;
        results.neutralL = neutralL;
        results.fearH = fearH;
        results.disgustH = disgustH;
        results.neutralH = neutralH;
        
eval(['save MEGsub' num2str(s) 'cleanERPs_ica_pca_nd8_3b.mat results';]); %Save it all for each subject

end

%% Plot individual ERPs for specific channels

allsubs = [5:10 11 15 16];
allsubs = 1:16;
allchans = [114];%1:160;

for s = allsubs
%     if s == 6 || s == 8
%         bs = 1;
%     elseif s == 9
%         bs = 3;
%     elseif s == 10
%         bs = 4;
    if s ==2
        bs = 1;
    else
        bs = 1:4;
    end
    
for b = bs
    
eval(['load MEGsub' num2str(s) 'block' num2str(b) 'ERPs_noica.mat results';]); %Save it all for fear
%eval(['load MEGsub' num2str(s) 'cleanERPs_noica.mat results';]); %Save it all for fear

horz = results.horz - 200; %#ok<NASGU> %For use as x-axis.  Subtract 200 because DCR2 has 3-datapoint shift in Analyzer 1

for e = allchans
%     eval(['fearL_' num2str(e) ' = results.fearL{e}';]);     % blockwise
%     ERP
%     eval(['fearH_' num2str(e) ' = results.fearH{e}';]);
%     eval(['disgustL_' num2str(e) ' = results.disgustL{e}';]);
%     eval(['disgustH_' num2str(e) ' = results.disgustH{e}';]);
%     eval(['neutralL_' num2str(e) ' = results.neutralL{e}';]);
%     eval(['neutralH_' num2str(e) ' = results.neutralH{e}';]);
    
    eval(['fearL_' num2str(e) ' = mean(results.fearL{e},1);';]);% this is for subject-wise, blockwise ERPs
    eval(['fearH_' num2str(e) ' = mean(results.fearH{e},1);';]);
    eval(['disgustL_' num2str(e) ' = mean(results.disgustL{e},1);';]);
    eval(['disgustH_' num2str(e) ' = mean(results.disgustH{e},1);';]);
    eval(['neutralL_' num2str(e) ' = mean(results.neutralL{e},1);';]);
    eval(['neutralH_' num2str(e) ' = mean(results.neutralH{e},1);';]);
        
eval(['figure; plot(horz, fearH_' num2str(e) ', ''r'', ''LineWidth'',3); hold on; plot(horz, disgustH_' num2str(e) ', ''b'', ''LineWidth'',3); plot(horz, neutralH_' num2str(e) ', ''g'', ''LineWidth'',3); plot(horz, fearL_' num2str(e) ', ''r--'', ''LineWidth'',3); hold on; plot(horz, disgustL_' num2str(e) ', ''b--'', ''LineWidth'',3); plot(horz, neutralL_' num2str(e) ', ''g--'', ''LineWidth'',3);']); %Plot the figure  
% Note that two quote marks together are two single quotes, not a double quotation mark!
%legend('fearH','disgustH','neutralH','fearL','disgustL','neutralL');

eval(['saveas(gcf,''MEGsub' num2str(s) 'block' num2str(b) 'chan' num2str(e) 'ERPs_noica.tif'');']); %Example saved file: "grandavgchanA15best.ai"
close(gcf) %Close the figure you just graphed, so you don't end up with a million figure windows all open at once
end
end %Of for-loop for graphing each channel
end

%% grand average

clear all
%allsubs = [1 6 10 12 14 15 16];
allsubs = [1:10 12:13 16]; 
%allsubs = 1:25;
        fearL = cell(160,1);    
        disgustL = cell(160,1);
        neutralL = cell (160,1);
        fearH = cell(160,1);    
        disgustH = cell(160,1);
        neutralH = cell (160,1);

for d = 1:160 %For each channel
 %Preallocate condition matrices for this channel
             
        % All resp 3*2
               fearL_allresp = [];    
               disgustL_allresp = [];
               neutralL_allresp = [];
               fearH_allresp = [];    
               disgustH_allresp = [];
               neutralH_allresp = [];
    
    for m = allsubs
    eval(['load MEGsub' num2str(m) 'cleanERPs_ica_pca_mix.mat results';]); 
        if m == 1 && d == 1 %Only have to do this once
        horz = results.horz; 
        epochdur = results.epochdur; 
        else
        end

        fearL_allresp = [fearL_allresp; results.fearL{d}];
        disgustL_allresp = [disgustL_allresp; results.disgustL{d}];
        neutralL_allresp = [neutralL_allresp; results.neutralL{d}];
        fearH_allresp = [fearH_allresp; results.fearH{d}];
        disgustH_allresp = [disgustH_allresp; results.disgustH{d}];
        neutralH_allresp = [neutralH_allresp; results.neutralH{d}];
        
        
    clear results
    end %Of subject loop
%Averaging ERPs from each subject & assigning them to grand avg cells.    

        
        % All resp 
               fearL{d} = mean(fearL_allresp,1);    
               disgustL{d} = mean(disgustL_allresp,1);
               neutralL{d} = mean(neutralL_allresp,1);
               fearH{d} = mean(fearH_allresp,1);    
               disgustH{d} = mean(disgustH_allresp,1);
               neutralH{d} = mean(neutralH_allresp,1);

end %Of channel loop

results.horz = horz;
results.epochdur = epochdur;

        results.fearL = fearL;
        results.disgustL = disgustL;
        results.neutralL = neutralL;
        results.fearH = fearH;
        results.disgustH = disgustH;
        results.neutralH = neutralH;
        
 
save Meg_grand_13subno111415_ica_pca_mix.mat results

%% plot grand average

load Meg_grand_13subno111415_ica_pca_mix.mat results
allchans = [147];
horz = results.horz - 200; %#ok<NASGU> %For use as x-axis.  Subtract 200 because DCR2 has 3-datapoint shift in Analyzer 1

for e = allchans
    eval(['fearL_' num2str(e) ' = results.fearL{e}';]);
    eval(['fearH_' num2str(e) ' = results.fearH{e}';]);
    eval(['disgustL_' num2str(e) ' = results.disgustL{e}';]);
    eval(['disgustH_' num2str(e) ' = results.disgustH{e}';]);
    eval(['neutralL_' num2str(e) ' = results.neutralL{e}';]);
    eval(['neutralH_' num2str(e) ' = results.neutralH{e}';]);
    
eval(['figure; plot(horz, fearH_' num2str(e) ', ''r'', ''LineWidth'',3); hold on; plot(horz, disgustH_' num2str(e) ', ''b'', ''LineWidth'',3); plot(horz, neutralH_' num2str(e) ', ''g'', ''LineWidth'',3); plot(horz, fearL_' num2str(e) ', ''r--'', ''LineWidth'',3); hold on; plot(horz, disgustL_' num2str(e) ', ''b--'', ''LineWidth'',3); plot(horz, neutralL_' num2str(e) ', ''g--'', ''LineWidth'',3);']); %Plot the figure  
% Note that two quote marks together are two single quotes, not a double quotation mark!
legend('fearH','disgustH','neutralH','fearL','disgustL','neutralL');

eval(['saveas(gcf,''MEGgrand13no111415_chan' num2str(e) '_ERP_ica_pca_mix.tif'');']); %Example saved file: "grandavgchanA15best.ai"
close(gcf) %Close the figure you just graphed, so you don't end up with a million figure windows all open at once
end

%% Plot for a group of channels
load Meg_grand_12sub.mat results

allchans = [130];
horz = results.horz - 200; %#ok<NASGU> %For use as x-axis.  Subtract 200 because DCR2 has 3-datapoint shift in Analyzer 1
fearL = [];
fearH = [];
disgustL = [];
disgustH = [];
neutralL = [];
neutralH = [];

for e = allchans
    fearL = [fearL; results.fearL{e}];
    fearH = [fearH; results.fearH{e}];
    disgustL = [disgustL; results.disgustL{e}];
    disgustH = [disgustH; results.disgustH{e}];
    neutralL = [neutralL; results.neutralL{e}];
    neutralH = [neutralH; results.neutralH{e}]; 
end

fl = mean(fearL,1);
fh = mean(fearH,1);
dl = mean(disgustL,1);
dh = mean(disgustH,1);
nl = mean(neutralL,1);
nh = mean(neutralH,1);

eval(['figure; plot(horz, fh, ''r'', ''LineWidth'',3); hold on; plot(horz, dh, ''b'', ''LineWidth'',3); plot(horz, nh, ''g'', ''LineWidth'',3); plot(horz, fl, ''r--'', ''LineWidth'',3); hold on; plot(horz, dl, ''b--'', ''LineWidth'',3); plot(horz, nl, ''g--'', ''LineWidth'',3);']); %Plot the figure  
% Note that two quote marks together are two single quotes, not a double quotation mark!
legend('fearH','disgustH','neutralH','fearL','disgustL','neutralL');

eval(['saveas(gcf,''MEGgrand12_ERP.tif'');']); %Example saved file: "grandavgchanA15best.ai"
%close(gcf) %Close the figure you just graphed, so you don't end up with a million figure windows all open at once

%% Get values for a group of channels for each subject
allchans = [113 114 117 118 148 153]; %right6
%allchans = [52 54 129 130 133] %left5
allsubs = [7 15 11];%[1:4 6 8:10 12:14 16];
allERPs = [];

for s = allsubs 
    eval(['load MEGsub' num2str(s) 'cleanERPs_ica_pca_nd.mat results';]); %Save it all for each subject
    fearL = [];
    fearH = [];
    disgustL = [];
    disgustH = [];
    neutralL = [];
    neutralH = [];

    for e = allchans
    fearL = [fearL; results.fearL{e}];
    fearH = [fearH; results.fearH{e}];
    disgustL = [disgustL; results.disgustL{e}];
    disgustH = [disgustH; results.disgustH{e}];
    neutralL = [neutralL; results.neutralL{e}];
    neutralH = [neutralH; results.neutralH{e}]; 
    end

data.fl = mean(fearL,1);
data.fh = mean(fearH,1);
data.dl = mean(disgustL,1);
data.dh = mean(disgustH,1);
data.nl = mean(neutralL,1);
data.nh = mean(neutralH,1);

data.horz = results.horz;
allERPs = [data.fl; data.fh; data.dl; data.dh; data.nl; data.nh];
    eval(['save MEGsub' num2str(s) '_P1_Right6.mat data';]); %Save it all for each subject
end

grandygrand = mean(allERPs,1); %Make the grand-grand average
[thegmax, wheregmax] = max(grandygrand(60:90)); %Identify what and where the max is in a likely range for P1 (points 60-90 on the ERP)   

%max 77 for chan153, 76 for chan113, 148, 78 for chan 118
%max for all 4 chans: 77

%% Plot for each individual a group of channels

for s = [7 15 11]% 15]
    eval(['load MEGsub' num2str(s) '_P1_Right6.mat data';]); %Save it all for each subject
    eval(['figure; plot(data.horz, data.fh, ''r'', ''LineWidth'',3); hold on; plot(data.horz, data.dh, ''b'', ''LineWidth'',3); plot(data.horz, data.nh, ''g'', ''LineWidth'',3); plot(data.horz, data.fl, ''r--'', ''LineWidth'',3); hold on; plot(data.horz, data.dl, ''b--'', ''LineWidth'',3); plot(data.horz, data.nl, ''g--'', ''LineWidth'',3);']); %Plot the figure  
% Note that two quote marks together are two single quotes, not a double quotation mark!
    legend('fearH','disgustH','neutralH','fearL','disgustL','neutralL');

    eval(['saveas(gcf,''MEGsub' num2str(s) 'right6_ERP.tif'');']); %Example saved file: "grandavgchanA15best.ai"

end

%% calculate mean amplitude

meanp136ms = [];
meanp144ms = [];
line36 = [];
line44 = [];
e = 148;

for s = allsubs
    eval(['load MEGsub' num2str(s) '_P1_Chan' num2str(e) '.mat data';]); %Save it all for each subject
    fl = mean(data.fl(71:83));
    fh = mean(data.fh(71:83));
    dl = mean(data.dl(71:83));
    dh = mean(data.dh(71:83));    
    nl = mean(data.nl(71:83));
    nh = mean(data.nh(71:83));
    
    line44 = [s fl fh dl dh nl nh];
    meanp144ms = [meanp144ms; line44]; %#ok<AGROW>        
end


%% topomap
allP1s = zeros(1,160); %Preallocate space for final vector of P1s
allfearL = zeros(1,160);
alldisgustL = zeros(1,160);
load Meg_grand_14sub_ica_pca_rej.mat results

for a = 1:160
    disgustL = results.disgustL{a}; %#ok<NASGU> %Microfear L
    neutralL = results.neutralL{a}; %#ok<NASGU> %Neutral L
    fearL = results.fearL{a};
    disgustH = results.disgustH{a}; %#ok<NASGU> %Microfear L
    neutralH = results.neutralH{a}; %#ok<NASGU> %Neutral L
    fearH = results.fearH{a};
       
    eval(['disgustLchan' num2str(a) ' = mean(disgustL(73:81));']); %P1 mean peak amplitude for microfear L
    eval(['neutralLchan' num2str(a) ' = mean(neutralL(73:81));']); %Same for neutral L
    eval(['fearLchan' num2str(a) ' = mean(fearL(73:81));']); %P1 mean peak amplitude for microfear L
    eval(['neutralHchan' num2str(a) ' = mean(neutralH(73:81));']); %Same for neutral L
    eval(['disgustHchan' num2str(a) ' = mean(disgustH(73:81));']); %P1 mean peak amplitude for microfear L
    eval(['fearHchan' num2str(a) ' = mean(fearH(73:81));']); %Same for neutral L    
    
%    eval(['diffscore = fearHchan' num2str(a) ' - neutralHchan' num2str(a) ';']);
    eval(['diffscore = fearLchan' num2str(a) ';']);
%     eval(['allfearright.mfearp1A' num2str(a) ' = mfearp1A' num2str(a) ';']);
%     eval(['allneuright.neup1A' num2str(a) ' = neup1A' num2str(a) ';']);

     allP1s(a) = diffscore;
   
end

% save PSAfacevalRVF69to79Minus3.mat allfearright allneuright
save MEG_Allsub14_P1Toponl_d1.mat allP1s %Vector for topomapping

load MEG_Allsub14_P1Toponl_d1.mat allP1s

filename = strcat('MEGsub7block1_epoch_br.set'); %Dataset from a subject we're not using--just have to load up something
EEG = pop_loadset(filename);
%EEG.chanlocs = readlocs('ChanPos_sub7block1.xyz', 'filetype', '.xyz'); %Reads in accurate locations for all 96 EEG channels
figure; topoplot(allP1s, EEG.chanlocs, 'maplimits', 'maxmin', 'electrodes', 'on'); %Puts electrode points in the picture & changes colors to fit the range of the vector of values
%figure; topoplot(allP1s, EEG.chanlocs, 'maplimits', 'maxmin', 'electrodes', 'on', 'emarker',{'s','k',20,1}, 'emarker2', {44:47,'s','k',10});
%Can change 'maxmin' to values you specify.  Example: [-0.31 0.61] (no quotes)
%"emarker2" is to highlight certain channels (like my O2 cluster in this
%example).  Emarker2 & the {} after it can be deleted if you don't want to
%highlight particular channels.
colorbar

%% Convert back to spm
allsubs = 1:16;

sublist = {'2012_11_23_0892_ME051_B';
    '2012_11_26_0896_ME051_B';
    '2012_12_03_0904_ME051_B';
    '2012_12_03_0905_ME051_B';
    '2012_12_04_0906_ME051_B';
    '2012_12_04_0908_ME051_B';
    '2012_12_05_0909_ME051_B';
    '2012_12_05_0910_ME051_B';
    '2012_12_06_0914_ME051_B';
    '2012_12_10_0917_ME051_B';
    '2012_12_10_me051_0918_B';
    '2012_12_11_0919_ME051_B';
    '2012_12_12_0921_ME051_B';
    '2012_13_12_0924_ME051_B';
    '2012_12_17_0926_ME051_B';
    '2012_12_19_0931_ME051_B';};

for s = allsubs
    if s == 2
        bs = 1;
    else
        bs = 1:4;
    end
    for b = bs 

f_name = strcat('MEGsub',num2str(s),'block',num2str(b),'_epoch_br_nchan'); %can only read nchan EEGlab file for some reason without yielding an error

pendStr1='.set';
pendStr2='.mat';
pendStr3='spm8_';

S = [];
S.dataset = [f_name,pendStr1];
S.outfile = [pendStr3,f_name,pendStr2];
D = spm_eeg_convert(S);
clear D

name = sublist{s,1};          
f_name2 = strcat('effdspm8_',name,num2str(b),'.mat');
%f_name2 = 'effdspm8_2012_11_23_0892_ME051_B3.mat';
load (f_name2);
sensors=D.sensors; % retain sensor info in the epoched spm8 file
trials = D.trials; % retain trial info in the epoched spm8 file
channels = D.channels; % retain channel info in the epoched spm8 file

f_name3 = [pendStr3,f_name,pendStr2];
load (f_name3);
D.sensors = sensors;
D.trials = trials;
D.channels = channels;

save  (f_name3,'D');
clear D;

    end
end
