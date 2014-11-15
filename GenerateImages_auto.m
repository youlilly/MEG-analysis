%% Automatically generate images according predetermined windows of interest
% after group inversion 
% Last updated: Nov19,2013; tested okay

% Select file names to generate images
    [S, sts] = spm_select(Inf, 'mat','Select M/EEG mat files');
    if ~sts, return; end

Ns    = size(S,1);
swd   = pwd;

for i = 1:Ns
    
    D                 = spm_eeg_load(deblank(S(i,:)));
    D.val             = 1;
    D.inv{1}.method   = 'Imaging';
    
    % clear redundant models
    %----------------------------------------------------------------------
    D.inv = D.inv(1);
    
% set time-frequency window
%--------------------------------------------------------------------------
    D.inv{1}.contrast.woi  = [100 132; 188 224];   % peristimulus time (ms)
    D.inv{1}.contrast.fboi = [];      % frequency window (Hz)
 
% and evaluate contrast
%--------------------------------------------------------------------------
    D = spm_eeg_inv_results(D);
 
% Convert mesh data into an image for further analysis
%==========================================================================
% Finally, write the smoothed contrast to an image in voxel space. The file 
% name will correspond to the data name and current inversion (i.e., D.val)
 
%--------------------------------------------------------------------------
    D.inv{D.val}.contrast.smooth  = 8; % FWHM (mm)
    D.inv{D.val}.contrast.display = 0;
    D = spm_eeg_inv_Mesh2Voxels(D);

    %----------------------------------------------------------------------
    save(D);
    
end
