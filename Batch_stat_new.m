%This script creates SPM batch stats files to run paired t-test on multiple
%windows and comparisons for 3D source localization

%Created by YY, last updated July 2013

%add 's' to use after-smoothing files
sublist = {'smcspm8_MEGsub10block3_epoch_pca_rm_br_trej_nchan_1';
    'smcspm8_MEGsub12block4_epoch_pca_rm_br_trej_nchan_1';
    'smcspm8_MEGsub13block4_epoch_pca_rm_br_trej_nchan_1';
    'smcspm8_MEGsub14block4_epoch_pca_rm_br_trej_nchan_1';
    'smcspm8_CE_MEGsub16block1_epoch_pca_rm_br_trej_nchan_1';
    'smcspm8_MEGsub1block4_epoch_pca_rm_br_trej_nchan_1';
    'smcspm8_MEGsub3block4_epoch_pca_rm_br_trej_nchan_1';
    'smcspm8_MEGsub4block4_epoch_pca_rm_br_trej_nchan_1';
    'smcspm8_MEGsub5block4_epoch_pca_rm_br_trej_nchan_1';
    'smcspm8_MEGsub6block4_epoch_pca_rm_br_trej_nchan_1';
    'smcspm8_CE_MEGsub7block2_epoch_pca_rm_br_trej_nchan_1';    
    'smcspm8_MEGsub8block4_epoch_pca_rm_br_trej_nchan_1';
    'smcspm8_MEGsub9block4_epoch_pca_rm_br_trej_nchan_1';
    'smspm8_MEGsub2block1_epoch_pca_rm_br_trej_nchan_1';
    };

allcond = {'fl';
    'dl';
    'nl';
    'fh';
    'dh';
    'nh';
    };

win = [100 132; 188 224]; % specify the window of interest
%win = [100 150];
con = [
%     1 3; % fl - nl
    1 2; % fl - dl
%     3 2; % nl - dl
%     4 6; % fh - nh
%     4 5; % fh - dh
%     6 5; % nh - dh    
    ];% put to-be-compaired condition numbers here

%starting from sub10, in the same order as in the variable sublist
c2n = [4	2	6	1	3	5 %sub10check
4	2	6	1	3	5 %sub12check
5	3	6	1	4	2 %sub13check
4	2	6	1	3	5 %sub14check
3	5   2	1	6	4 %sub16check
4	2	6	1	3	5 %sub1check
4	2	6	1	3	5 %sub3check
4	2	6	1	3	5 %sub4check
4	2	6	1	3	5 %sub5check
5	4	1	2	6	3 %sub6check
3   6   4   1   5   2 %sub7check
5	4	1	2	6	3 %sub8check
4	2	6	1	3	5 %sub9check
3	5	1	2	6	4];%sub2check

for n = 1:length(win)
    
window = win(n,:); 

for i = 1%:length(con)
conditions = con(i,:); 

cond1 = allcond{conditions(1),1};
cond2 = allcond{conditions(2),1};
% load a previously created batch stats file and will make modifications on
% that structure
load fh_dh_ttest_125_150_sub13.mat

% create the directory where stats will take place; it dictates directory
% names to be strictly lower cases following names in the variable "allcond"
dir = strcat('C:\Users\User\Documents\MEG_all\Source_localization\Group_inversion_COH_groupForward_11_20_13_noPST_14subs_auto\', cond1, '_', cond2, '_',  num2str(window(1)), '_', num2str(window(2)), '\' );
matlabbatch{1,1}.spm.stats.factorial_design.dir{1,1} = dir;

for s = 1:14
    ccode = c2n(s,:); % assign the condition-to-number code for each sub; this code will translate condition(1)/(2) to its actual corresponding condition in that particular sub
    name = sublist{s,1};    
%    filename1 = strcat('C:\Users\User\Documents\MEG_all\Source_localization\',cond1,'_',cond2,'_',num2str(window(1)),'_', num2str(window(2)),'\', name,'_t', num2str(window(1)),'_', num2str(window(2)), '_f_', num2str(conditions(1)),'.nii,1');
%    filename2 = strcat('C:\Users\User\Documents\MEG_all\Source_localization\',cond1,'_',cond2,'_',num2str(window(1)),'_', num2str(window(2)),'\', name,'_t', num2str(window(1)),'_', num2str(window(2)), '_f_', num2str(conditions(2)),'.nii,1');
    filename1 = strcat('C:\Users\User\Documents\MEG_all\Source_localization\Group_inversion_COH_groupForward_11_20_13_noPST_14subs_auto\', name,'_t', num2str(window(1)),'_', num2str(window(2)), '_f_', num2str(ccode(conditions(1))),'.nii,1');
    filename2 = strcat('C:\Users\User\Documents\MEG_all\Source_localization\Group_inversion_COH_groupForward_11_20_13_noPST_14subs_auto\', name,'_t', num2str(window(1)),'_', num2str(window(2)), '_f_', num2str(ccode(conditions(2))),'.nii,1');

    eval(['matlabbatch{1,1}.spm.stats.factorial_design.des.pt.pair(1,' num2str(s) ').scans{1,1} = filename1;']);
    eval(['matlabbatch{1,1}.spm.stats.factorial_design.des.pt.pair(1,' num2str(s) ').scans{2,1} = filename2;']);
    
end

filename_batch = strcat(cond1, '_', cond2, '_ttest_', num2str(window(1)), '_', num2str(window(2)),'_14subs' );

save(filename_batch, 'matlabbatch');
end
end