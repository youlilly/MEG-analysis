t1 = [];
t2 = [];

for z = 1:4
    for bsub = 2
eval(['load SFG_block' num2str(z) '_sub' num2str(bsub) '_timeinfo.mat;']); %load pic info
eval(['load SFG_block' num2str(z) '_sub' num2str(bsub) '_Greebtimeinfo.mat;']); %load greeble info
    t1 = [t1;trialarray_time];
    t2 = [t2;trialarray_Greebtime];
    end
end

trialarray_time = t1;
trialarray_Greebtime = t2;

 eval(['save sub0896_block1_picgrebtimeinfo']);

%%
sublist = {'spm8_2012_11_23_0892_ME051B';
  %  'spm8_2012_11_26_0896_ME051_B';
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