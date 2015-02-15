% Import .fif files into spm format

for s = 11:17
    for b = 1:8%:8
        eval(['WD = strcat(''/Users/bhu/Desktop/MEG_MCW/s0' num2str(s) '_s0' num2str(s) '/sss/'');']);
        cd(WD);
        
        
        eval(['file_name = ''s0' num2str(s) '_run' num2str(b) '_raw'';']);
        0
        pendStr1='.fif';
        pendStr2='.mat';
        pendStr3='spm8_';
        %pendStr4='.pos';
        
        S = [];
        S.dataset = [file_name,pendStr1];
        
        
        S.outfile = [pendStr3,file_name,pendStr2];
        D = spm_eeg_convert(S);
        clear D
    end
end


