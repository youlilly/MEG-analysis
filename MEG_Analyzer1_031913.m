%% MEG_Analyzer
% Edited by Yuqi You
% Last commented: 06/04/13
% Note: this script calls additional customized functions; modification may
% be necessary to achieve the desired analysis
% Always remember to set path first, add to path "MEGTOOLS_updated" folder, and add "spm8" as subfolder

clear all
spm eeg 

%% Make a list of all subject file names for convenience of batch calling
% For these first steps to run properly, all subjects' raw data files
% should be collected in a same folder

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


%% find triggers for each block
% Generate "event.txt" files that codes trigger type and timing

for s = allsubs
    if s ==2
        bs = 1;
    else
        bs = 1:4;
    end
    
    for b = bs
    name = sublist{s,1};    
    filename = strcat(name,num2str(b),'-export.txt');
    findtriggers_easy;
    end

end

%% Convet .con files to SPM8 compatible formats
% Generate 'spm8.mat'file with trigger type and timing added

% Before doing this, ensure you have install the yokogawa toolbox into the
% $spm8\external\fileio\private
% spm_eeg_lgainmat was modified at line 142 to export Gxyz
% Insert your file names of native .raw in "cellStr"

for s = 7%allsubs
    if s ==2
        bs = 1;
    else
        bs = 1:4;
    end
    
    for b = bs

    name = sublist{s,1};    
    file_name = strcat(name,num2str(b));    
    megload_160_102010_easy; % this step import .con file into spm, generating 
                             % "spm8_" prefix data/log files; this step
                             % also imports into spm8 sensor info (inner & outer coils) from ".pos" files 
    addevents_yy; %this function uses cogent times as triggers, if meg time is desired, use
                  % addevents_yy_megtime.m
    %addevents_yy_0896; use this one for subject 0896 only, cogent times

    end 
end

%% Downsampling from 1000hz to 250hz
% creates the "d" prefix

%-Test for the presence of Signal Processing Matlab toolbox
flag_TBX = license('checkout','signal_toolbox');
if ~flag_TBX
    disp(['warning: using homemade resampling routine ' ...
          'as signal toolbox is not available.']);
end

for s = 7%allsubs
   if s == 2
       bs = 1;
   else
       bs = 1:4;
   end
   
   for b = bs
   name = sublist{i,1};
   filename_ds = strcat(name,num2str(b),'.mat');
   spm_eeg_downsample_easy; %downsample the data
   end
end


%% Highpass Filtering > .1hz
% creates the "f" prefix

for s = allsubs
   if s == 2
       bs = 1;
   else
       bs = 1:4;
   end
   
    for b = bs
    name = sublist{i,1};    
    filename_ft1 = strcat('d',name,num2str(b),'.mat');
    spm_eeg_hp_filter_easy; %filter the data-highpass 0.1Hz 
    end
end

%% Lowpass Filtering
% creates the "f" prefix

for i = 2%1:16
   if i == 2
       bk = 1;
   else
       bk = 1:4;
   end
   
    for b = bk
    name = sublist{i,1};
    filename_ft2 = strcat('fd',name,num2str(b),'.mat');
    block = bk;
    spm_eeg_lp_filter_easy; %filter the data-lowpass 40Hz secondly
    end
end

%% Epoching
% the following scripts should be in the "toolbox", epoch_yy.m, and
% select_events_yy.m
% creates the "e" prefix

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


for i = 16%1:16
   if i == 2
       block = 1;
   else
       block = 1:4;
   end
    name = sublist{i,1};   
    for b = block

    fe_name = strcat('spm8_CG_', name,num2str(b),'.mat');
    epoch_yy;
    end
end

%% Merging
% this step concatenate blocks into one
% create the "c" prefix
% click the "merge" button and select files/or change the numbers in the
% lines below and do it for each individual
%allsubs = [1:6 8:10 12:14 16];

%     if s == 2
%         bs = 1;
%     elseif s == 5 || s == 9
%         bs = [1 2 4];
%     elseif s == 6 || s==8 
%         bs = 2:4;
%     elseif s == 10
%         bs = 1:3;
%     else 
%         bs = 1:4;
%     end
    
spm('defaults', 'eeg');

S = [];
S.D = [
 %      'C:\Users\User\Documents\MEG_all\MEG2EEG\Changes to SPM8\spm8_MEGsub8block4_epoch_pca_rm_br_trej_nchan.mat'
       'C:\Users\User\Documents\MEG_all\MEG2EEG\Changes to SPM8\spm8_MEGsub10block3_epoch_pca_rm_br_trej_nchan.mat'       
       'C:\Users\User\Documents\MEG_all\MEG2EEG\Changes to SPM8\spm8_MEGsub10block2_epoch_pca_rm_br_trej_nchan.mat'
       'C:\Users\User\Documents\MEG_all\MEG2EEG\Changes to SPM8\spm8_MEGsub10block1_epoch_pca_rm_br_trej_nchan.mat'
       ];
S.recode = 'same';
D = spm_eeg_merge(S);
    

%% loading data and inspection (skip; debugging and checking purposes)
%file_name = input('please type the full filename\n','s');  %eg,name of 0892_RM_2012_11_23.hsp 
sublist = {'spm8_2012_11_23_0892_ME051_B';
    'spm8_2012_12_17_0926_ME051_B';
    'spm8_2012_12_03_0904_ME051_B';};
allep = [];

for i = 1%1:3
    b = 1;
    name = sublist{i,1};
    file_name = strcat('cbeffd',name,num2str(b),'.mat');    
    
    D   = spm_eeg_load(file_name);
   % S.D = fullfile(D.path, D.fname);
   for e = 1:600
        for c = [55 96 140]
        eval(['chan_' num2str(c) ' = D(c,:,e);']);
        eval(['mean_' num2str(c) ' = mean(chan_' num2str(c) ');']);        
        eval(['sort_a = sort(chan_' num2str(c) ');']);
        eval(['sort_d = sort(chan_' num2str(c) ', ''descend'');']);       
        %smalls = sort_a(1:20);
        %bigs = sort_d(1:20);
        eval(['chan_' num2str(c) '_s = sort_a(1);']);
        eval(['chan_' num2str(c) '_b = sort_d(1);']);        
        end
       % line = [e chan_33_s chan_33_b chan_103_s chan_103_b chan_140_s chan_140_b mean_33 mean_103 mean_140];
        line = [e chan_55_s chan_55_b chan_96_s chan_96_b];        
        allep = [allep; line];
        
    end
   
%         x = 1:600;
%         figure; scatter(x,allep(:,2));
%         figure; scatter(x,allep(:,4));
%         figure; scatter(x,allep(:,6));     
%         figure; scatter(x,allep(:,3));
%         figure; scatter(x,allep(:,5));
%         figure; scatter(x,allep(:,7));     

end

%% load files and inspect data (skip; debugging and checking purposes)
% spm
filename = 'spm8_2012_11_23_0892_ME051_B1.mat';
D = spm_eeg_load(filename);
a1 = D (1,1);
b1 = D (160,335000);
filename = 'dspm8_2012_11_23_0892_ME051_B1.mat';
D = spm_eeg_load(filename);
a2 = D (1,1); 
b2 = D (160,83750);

% eeg
filename = 'MEGsub1block1.set';
EEG = pop_loadset(filename);
a3 = EEG.data (1,1);
b3 = EEG.data (160,335000);
filename = 'MEGsub1block1_ds.set';
EEG = pop_loadset(filename);
a4 = EEG.data (1,1); 
b4 = EEG.data (160,83750);


%% Check data (skip; debugging and checking program)
%filename = 'effdspm8_2012_11_23_0892_ME051_B4.mat';
filename = 'MEGsub1block4_epoch_br_nchan.set';
EEG = pop_loadset(filename);
c = EEG.data(1,1,1);
%d = D (160,126,150);
e = EEG.data(160,125,150);

%% pick the 10 lagest max and 10 smallest min-associated epochs and plot them
        aaa=126*1000/250; %Converts back from datapoint time into seconds
        horz=linspace(1, aaa, 126)-200; %Vector from 1 to total # of seconds per epoch, w/as many points as are in an epoch
 
%  s33 = sortrows (allep, 2);
%  trials33 = s33(1:10,1);
%  for e = 1:10
%      en = trials33(e);
%      epdata = D(33,:,en);
%      figure; plot(horz,epdata);
%      eval(['saveas(gcf,''SFG_sub' num2str(i) '_chan33_epoch' num2str(en) '_s10.tif'');']); %Example saved file: "grandavgchanA15best.ai"
%      close(gcf) %Close the figure you just graphed, so you don't end up with a million figure windows all open at once
%  end
%  b33 = sortrows (allep, 3);
%  trialb33 = b33(591:600,1);
%   for e = 1:10
%      en = trialb33(e);
%      epdata = D(33,:,en);
%      figure; plot(horz,epdata);
%      eval(['saveas(gcf,''SFG_sub' num2str(i) '_chan33_epoch' num2str(en) '_b10.tif'');']); %Example saved file: "grandavgchanA15best.ai"
%      close(gcf) %Close the figure you just graphed, so you don't end up with a million figure windows all open at once
%   end
%   
 
 s55 = sortrows (allep, 2);
 trials55 = s55(1:10,1);
 for e = 1:10
     en = trials55(e);
     epdata = D(55,:,en);
     figure; plot(horz,epdata);
     eval(['saveas(gcf,''SFG_sub' num2str(i) '_chan55_epoch' num2str(en) '_s10.tif'');']); %Example saved file: "grandavgchanA15best.ai"
     close(gcf) %Close the figure you just graphed, so you don't end up with a million figure windows all open at once
 end
 
 b55 = sortrows (allep, 3);
 trialb55 = b55(591:600,1);
  for e = 1:10
     en = trialb55(e);
     epdata = D(55,:,en);
     figure; plot(horz,epdata);
     eval(['saveas(gcf,''SFG_sub' num2str(i) '_chan55_epoch' num2str(en) '_b10.tif'');']); %Example saved file: "grandavgchanA15best.ai"
     close(gcf) %Close the figure you just graphed, so you don't end up with a million figure windows all open at once
  end  
 %%
%  s103 = sortrows(allep, 4);
%  trials103 = s103(1:10,1);
%   for e = 1:10
%      en = trials103(e);
%      epdata = D(103,:,en);
%      figure; plot(horz,epdata);
%      eval(['saveas(gcf,''SFG_sub' num2str(i) '_chan103_epoch' num2str(en) '_s10.tif'');']); %Example saved file: "grandavgchanA15best.ai"
%      close(gcf) %Close the figure you just graphed, so you don't end up with a million figure windows all open at once
%   end
%  
%  b103 = sortrows(allep, 5);
%  trialb103 = b103(591:600,1);
%   for e = 1:10
%      en = trialb103(e);
%      epdata = D(103,:,en);
%      figure; plot(horz,epdata);
%      eval(['saveas(gcf,''SFG_sub' num2str(i) '_chan103_epoch' num2str(en) '_b10.tif'');']); %Example saved file: "grandavgchanA15best.ai"
%      close(gcf) %Close the figure you just graphed, so you don't end up with a million figure windows all open at once
%   end
  
 s96 = sortrows(allep, 4);
 trials96 = s96(1:10,1);
  for e = 1:10
     en = trials96(e);
     epdata = D(96,:,en);
     figure; plot(horz,epdata);
     eval(['saveas(gcf,''SFG_sub' num2str(i) '_chan96_epoch' num2str(en) '_s10.tif'');']); %Example saved file: "grandavgchanA15best.ai"
     close(gcf) %Close the figure you just graphed, so you don't end up with a million figure windows all open at once
  end
 
 b96 = sortrows(allep, 5);
 trialb96 = b96(591:600,1);
  for e = 1:10
     en = trialb96(e);
     epdata = D(96,:,en);
     figure; plot(horz,epdata);
     eval(['saveas(gcf,''SFG_sub' num2str(i) '_chan96_epoch' num2str(en) '_b10.tif'');']); %Example saved file: "grandavgchanA15best.ai"
     close(gcf) %Close the figure you just graphed, so you don't end up with a million figure windows all open at once
  end  

  for en = [1:4 7:9]
     epdata = D(96,:,en);
     figure; plot(horz,epdata);
     eval(['saveas(gcf,''SFG_sub' num2str(i) '_chan96_epoch' num2str(en) '_eyeblinks.tif'');']); %Example saved file: "grandavgchanA15best.ai"
     close(gcf) %Close the figure you just graphed, so you don't end up with a million figure windows all open at once
  end  
  
    
  
  %%
 s140 = sortrows(allep, 6);
 trials140 = s140(1:10,1);
   for e = 1:10
     en = trials140(e);
     epdata = D(140,:,en);
     figure; plot(horz,epdata);
     eval(['saveas(gcf,''SFG_sub' num2str(i) '_chan140_epoch' num2str(en) '_s10.tif'');']); %Example saved file: "grandavgchanA15best.ai"
     close(gcf) %Close the figure you just graphed, so you don't end up with a million figure windows all open at once
  end
 
 
 b140 = sortrows(allep, 7);
 trialb140 = b140(591:600,1);
  for e = 1:10
     en = trialb140(e);
     epdata = D(140,:,en);
     figure; plot(horz,epdata);
     eval(['saveas(gcf,''SFG_sub' num2str(i) '_chan140_epoch' num2str(en) '_b10.tif'');']); %Example saved file: "grandavgchanA15best.ai"
     close(gcf) %Close the figure you just graphed, so you don't end up with a million figure windows all open at once
  end
  

%% Debugging 07/08/13
% to check whether condition order in spm merged files by checking its
% labels and looking at ERP conditions from eeg lab


file = 'mcspm8_MEGsub8block4_epoch_pca_rm_br_trej_nchan.mat'
D   = spm_eeg_load(file);
b1 = D(1,1,1);
b2 = D(1,1,2);
b3 = D(1,1,3);
b4 = D(1,1,4);
b5 = D(1,1,5);
b6 = D(1,1,6);
line = [b1 b2 b3 b4 b5 b6]

load MEGsub8cleanERPs_ica_pca_nd.mat

%% Converting individual data from spm to matlab formats (this step is abandoned in favor of importing into eeglab and process sensor space data)

sublist = {'spm8_2012_11_23_0892_ME051_B';
    'spm8_2012_11_26_0896_ME051_B';
    'spm8_2012_12_03_0904_ME051_B';
    'spm8_2012_12_03_0905_ME051_B';
    'spm8_2012_12_04_0906_ME051_B';
    'spm8_2012_12_04_0908_ME051_B';
    'spm8_2012_12_05_0909_ME051_B';
    'spm8_2012_12_05_0910_ME051_B';
    'spm8_2012_12_06_0914_ME051_B';
    'spm8_2012_12_10_0917_ME051_B';
    'spm8_2012_12_10_me051_0918_B';
    'spm8_2012_12_11_0919_ME051_B';
    'spm8_2012_12_12_0921_ME051_B';
    'spm8_2012_13_12_0924_ME051_B';
    'spm8_2012_12_17_0926_ME051_B';
    'spm8_2012_12_19_0931_ME051_B';};

for i = 1:16
    
    b = 1;
    name = sublist{i,1};
    f_name = strcat('mcbeffd',name,num2str(b),'.mat');
    
    if i == 2
    f_name = strcat('mbeffd',name,num2str(b),'.mat');        
    end
    N = spm_eeg_load(f_name);
    
    %Condition labesl 1:LSF F, 2: LSF D, 3: LSF N, 4: HSF F, 5: HSF D, 6:
    %HSF N
    
        fearL = cell(160,1);    
        disgustL = cell(160,1);
        neutralL = cell (160,1);
        fearH = cell(160,1);    
        disgustH = cell(160,1);
        neutralH = cell (160,1);
        
        for c = 1:160 % for each channel
            
            fearL{c} = N(c,:,1);
            disgustL{c} = N(c,:,2);
            neutralL{c} = N(c,:,3);
            fearH{c} = N(c,:,4);
            disgustH{c} = N(c,:,5);
            neutralH{c} = N(c,:,6);
            
        end
        
        aaa=126*1000/250; %Converts back from datapoint time into seconds
        horz=linspace(1, aaa, 126); %Vector from 1 to total # of seconds per epoch, w/as many points as are in an epoch
        
     %   results.data = N;
        results.fearL = fearL;
        results.disgustL = disgustL;
        results.neutralL = neutralL;
        results.fearH = fearH;
        results.disgustH = disgustH;
        results.neutralH = neutralH;
        results.horz = horz;
        
        eval(['save SFG_sub' num2str(i) '_average_meg.mat results';]); %Save it all for fear
end

%% Converting grand average data from spm to matlab format (same as above)


    f_name = 'grand_mean_16.mat';
    

    N = spm_eeg_load(f_name);
    
    %Condition labesl 1:LSF F, 2: LSF D, 3: LSF N, 4: HSF F, 5: HSF D, 6:
    %HSF N
    
        fearL = cell(160,1);    
        disgustL = cell(160,1);
        neutralL = cell (160,1);
        fearH = cell(160,1);    
        disgustH = cell(160,1);
        neutralH = cell (160,1);
        
        for c = 1:160 % for each channel
            
            fearL{c} = N(c,:,1);
            disgustL{c} = N(c,:,2);
            neutralL{c} = N(c,:,3);
            fearH{c} = N(c,:,4);
            disgustH{c} = N(c,:,5);
            neutralH{c} = N(c,:,6);
            
        end
        
        aaa=126*1000/250; %Converts back from datapoint time into seconds
        horz=linspace(1, aaa, 126); %Vector from 1 to total # of seconds per epoch, w/as many points as are in an epoch
        
     %   results.data = N;
        results.fearL = fearL;
        results.disgustL = disgustL;
        results.neutralL = neutralL;
        results.fearH = fearH;
        results.disgustH = disgustH;
        results.neutralH = neutralH;
        results.horz = horz;
    
        
        save SFG_grand_average_meg.mat results
        
        
%% Back of head graphing with automated process! (save as above)
% for LPPs along central midline
% Last run: 04/23/11

allchans = [33 140 103];%1:160;

for i = 1%:16
    
    eval(['load SFG_sub' num2str(i) '_average_meg.mat results';]); %Save it all for fear

horz = results.horz - 200; %#ok<NASGU> %For use as x-axis.  Subtract 200 because DCR2 has 3-datapoint shift in Analyzer 1
end

for e = allchans
    eval(['fearL_' num2str(e) ' = results.fearL{e}';]);
    eval(['fearH_' num2str(e) ' = results.fearH{e}';]);
    eval(['disgustL_' num2str(e) ' = results.disgustL{e}';]);
    eval(['disgustH_' num2str(e) ' = results.disgustH{e}';]);
    eval(['neutralL_' num2str(e) ' = results.neutralL{e}';]);
    eval(['neutralH_' num2str(e) ' = results.neutralH{e}';]);
    
eval(['figure; plot(horz, fearH_' num2str(e) ', ''r'', ''LineWidth'',3); hold on; plot(horz, disgustH_' num2str(e) ', ''b'', ''LineWidth'',3); plot(horz, neutralH_' num2str(e) ', ''g'', ''LineWidth'',3); plot(horz, fearL_' num2str(e) ', ''r--'', ''LineWidth'',3); hold on; plot(horz, disgustL_' num2str(e) ', ''b--'', ''LineWidth'',3); plot(horz, neutralL_' num2str(e) ', ''g--'', ''LineWidth'',3);']); %Plot the figure  
% Note that two quote marks together are two single quotes, not a double quotation mark!
%legend('fearH','disgustH','neutralH','fearL','disgustL','neutralL');

eval(['saveas(gcf,''SFG_sub' num2str(i) 'avgchan' num2str(e) '.tif'');']); %Example saved file: "grandavgchanA15best.ai"
close(gcf) %Close the figure you just graphed, so you don't end up with a million figure windows all open at once

end %Of for-loop for graphing each channel



