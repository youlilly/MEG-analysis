spm('defaults', 'eeg');

S = [];
S.D = 'C:\Users\User\Documents\MEG_all\Source_localization\spm8_MEGsub2block1_epoch_pca_rm_br_trej_nchan.mat';
S.robust = false;
D = spm_eeg_average(S);


S = [];
S.D = 'C:\Users\User\Documents\MEG_all\Source_localization\mspm8_MEGsub2block1_epoch_pca_rm_br_trej_nchan.mat';
S.task = 'headshape';
S.headshapefile = 'C:\Users\User\Documents\MEG_all\MEG_Preprocessing\0896-1block\shape.mat';
S.source = 'convert';
S.save = 1;
D = spm_eeg_prep(S);


S = [];
S.D = 'C:\Users\User\Documents\MEG_all\Source_localization\mspm8_MEGsub2block1_epoch_pca_rm_br_trej_nchan.mat';
S.task = 'coregister';
S.save = 1;
D = spm_eeg_prep(S);


