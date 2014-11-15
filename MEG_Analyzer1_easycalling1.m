%%cd C:\......
clear all
spm eeg 
%always remember to set path first, add "toolbox" folder, and add "spm8" as subfolder
%subs No. = 16; 
%allsubs = [0892 0896 0904 0905 0906 0908 0909 0910 0914 0917 0918 0919 0921 0924 0926 0931]; 
%%%%%%%%%%the name of the MEG data were not saved systematically
%%%%%%%%%%the subject initial(also experiment date) is a big problem 
%%%%%%%%%%tried to change the name for .hsp .con...but caused other issues
%%%%%%%%%%so just just run this script for each subject
%% Creat .mat files for each subject.
%Select .hsp files
%Cell output: 'shape.mat'file
%%Tested on 25/2/13.

f_name = input('please type the filename without extension\n','s');  %eg,name of 0892_RM_2012_11_23.hsp with out extension
subno = f_name(1:4);  
%subinitial = f_name(6:7); % This is not needed
experimentdate = f_name(9:18);

%Do 'parsehsp_new' for only once
%parsehsp_new_easy;

%% find triggers for each block
% output='event.txt' file
% a = 1; % subject 0896
%for subject before 0918(including) allblock = 1:4   
for a = 3:4
    filename = strcat(num2str(experimentdate),'_',num2str(subno),'_ME051_B',num2str(a),'-export.txt');
    %filename = strcat('2012_12_10_me051_0918_B',num2str(a),'-export.txt'); %subject 0918 ~ 2012_12_10_me051_0918_B1-export
    %filename = strcat('2012_13_12_0924_ME051_B',num2str(a),'-export.txt'); %subject 0924 ~ 2012_13_12_0924_ME051_B1-export
    %filename = strcat('2012_12_19_0931_ME051_B',num2str(a),'-export.txt'); %subject 0931 ~ 2012_12_19_0931_ME051_B1-export
    block = a;
    findtriggers_easy;
end

%% Load 'megload_160_102010' 
% 'megload_160_102010'
% Load 'con'file
% output='spm8.mat'file
% %spm(latest version) has to start before megload_160_102010

% Before doing this, ensure you have install the yokogawa toolbox into the
% $spm8\external\fileio\private
% spm_eeg_lgainmat was modified at line 142 to export Gxyz
% Insert your file names of native .raw in "cellStr"

%file_name = input('please type the filename of the con file you wish to load\n**do not include file extension (.con)**\n','s');
%block = input('please type the block number\n','s');
%allblock = 1; % subject 0896
%for subject before 0918(including) allblock = 1:4   

for allblock = 1:4
    file_name = strcat(num2str(experimentdate),'_',num2str(subno),'_ME051_B',num2str(allblock));
    block = allblock;
    megload_160_102010_easy;
    
%%sub 0918
%     file_name = strcat('2012_13_12_0924_ME051_B',num2str(allblock));
%     block = allblock;
%     file_name_revised = strcat('2012_12_13_0924_ME051_B',num2str(allblock)); %subject 0918 (file name would be revised here)
%     megload_160_102010_easy_revised;

%%sub 0924
%     file_name = strcat('2012_13_12_0924_ME051_B',num2str(allblock));
%     block = allblock;
%     file_name_revised = strcat('2012_12_13_0924_ME051_B',num2str(allblock)); %subject 0924 (file name would be revised here)
%     megload_160_102010_easy_revised;
    
%%sub 0931
%     file_name = strcat('2012_12_19_0931_ME051_B',num2str(allblock));
%     block = allblock;
%     file_name_revised = strcat('2012_12_20_0931_ME051_B',num2str(allblock));
%     megload_160_102010_easy_revised;

    addevents_easy;
    
end 


%% Downsampling
f_name_ds = input('please type the filename without extension\n','s');  % If the upper script have been executed and the data has not been cleaned up 
subno = f_name_ds(1:4);                                                 %this step would not be needed. 
experimentdate = f_name_ds(9:18);

%-Test for the presence of Signal Processing Matlab toolbox
flag_TBX = license('checkout','signal_toolbox');
if ~flag_TBX
    disp(['warning: using homemade resampling routine ' ...
          'as signal toolbox is not available.']);
end

%-Get MEEG object
for b_ds = 1:4
    filename_ds = strcat('spm8_',num2str(experimentdate),'_',num2str(subno),'_ME051_B',num2str(b_ds),'.mat');
    block = b_ds;
    spm_eeg_downsample_easy; %downsample the data

end

%% Highpass Filtering
% f_name_ds = input('please type the filename without extension\n','s');
% subno = f_name_ds(1:4);  
% experimentdate = f_name_ds(9:18);

for b_ft1 = 1:4
    filename_ft1 = strcat('dspm8_',num2str(experimentdate),'_',num2str(subno),'_ME051_B',num2str(b_ft1),'.mat');
    block = b_ft1;
    spm_eeg_hp_filter_easy; %filter the data-highpass 0.1Hz firstly

end

%% Lowpass Filtering
for b_ft2 = 1:4
    filename_ft2 = strcat('fdspm8_',num2str(experimentdate),'_',num2str(subno),'_ME051_B',num2str(b_ft2),'.mat');
    block = b_ft2;
    spm_eeg_lp_filter_easy; %filter the data-lowpass 40Hz secondly

end


%% Add piconTimes/GreebonTimes and labels
%output could be found in "ffdspm8_XXXX_XX_XX_subX_ME051_BX.mat files"in picevents and greebevents,D.diftrials
%and "subX_blockX_picgrebtimeinfo.mat" 

% f_name_ds = input('please type the filename without extension\n','s');  % If the upper script have been executed and the data has not been cleaned up 
% subno = f_name_ds(1:4);                                                 %this step would not be needed. 
% experimentdate = f_name_ds(9:18);

allsubs = [];
megsubno = [0892 0896 0904 0905 0906 0908 0909 0910 0914 0917 0918 0919 0921 0924 0926 0931];
cogsubno = [1:16];
allsubno = [megsubno', cogsubno'];

%check resutls in [sub' num2str(subno) '_block' num2str(aeblock) '_picgrebtimeinfo] by checking picevent, greebevents, D.diftrials
for aeblock = 1:4 % not including control blocks 
    filename_apl = strcat('ffdspm8_',num2str(experimentdate),'_',num2str(subno),'_ME051_B',num2str(aeblock),'.mat');
    z = aeblock;
    
    for sn = 1:16   %find behavior data number
        
        if str2num(subno) == megsubno(sn) 
            bsub = 0;
            bsub = cogsubno(sn);
            break
        else
        end
        
    end
    
    add_labeltimeinfo; %add picontime/greebon and label to the meg triggers
    eval(['save sub' num2str(subno) '_block' num2str(aeblock) '_picgrebtimeinfo']);
      
end


%clear all

%% Epoching
%
% for ab = 1:8
%     fe_name = strcat('ffdspm8_',num2str(experimentdate),'_',num2str(subno),'_ME051_B',num2str(ab),'.mat');
%     block = ab;
%     bhuva_epoch;
% end
% clear all
