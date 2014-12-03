%% Group inversion script without gui prompt
%last updated Nov19,2013; tested okay
%Normal operation requires the custom-made _yy scripts using the spm8(5236) in the dropbox 

% Select file names to be inverted
    [S, sts] = spm_select(Inf, 'mat','Select M/EEG mat files');
    if ~sts, return; end

Ns    = size(S,1);
swd   = pwd;

%% Load data and set method
%==========================================================================
for i = 1:Ns
    
    fprintf('checking for previous inversions: subject %i\n',i);
    D{i}                 = spm_eeg_load(deblank(S(i,:)));
    D{i}.val             = 1;
    D{i}.inv{1}.method   = 'Imaging';
    
    % clear redundant models
    %----------------------------------------------------------------------
    D{i}.inv = D{i}.inv(1);
    
    
    % clear previous inversions
    %----------------------------------------------------------------------
    try, D{i}.inv{1} = rmfield(D{i}.inv{1},'inverse' ); end
    try, D{i}.inv{1} = rmfield(D{i}.inv{1},'contrast'); end
    
    % save forward model parameters
    %----------------------------------------------------------------------
    save(D{i});
    
end

% Check for existing forward models and consistent Gain matrices
%--------------------------------------------------------------------------
Nd = zeros(1,Ns);
for i = 1:Ns
    fprintf('checking for forward models: subject %i\n',i);
    try
        [L, D{i}] = spm_eeg_lgainmat(D{i});
        Nd(i) = size(L,2);               % number of dipoles
    catch
        Nd(i) = 0;
    end
end
 
% use template head model where necessary
%==========================================================================
if max(Nd > 1024)
    NS = find(Nd ~= max(Nd));            % subjects requiring forward model
else
    NS = 1:Ns;
end

for i = NS
 
    cd(D{i}.path);
 
    % specify cortical mesh size (1 to 4; 1 = 5125, 2 = 8196 dipoles)
    %----------------------------------------------------------------------
    Msize  = 2;
 
    % use a template head model and associated meshes
    %======================================================================
    D{i} = spm_eeg_inv_mesh_ui(D{i}, 1, 1, Msize);
 
    % save forward model parameters
    %----------------------------------------------------------------------
    save(D{i});
 
end

%% Specify inversion parameters here
%     inverse.type   - 'GS' Greedy search on MSPs
%                      'ARD' ARD search on MSPs
%                      'LOR' LORETA-like model
%                      'IID' LORETA and minimum norm
%     inverse.woi    - time window of interest ([start stop] in ms)
%     inverse.Han    - switch for Hanning window
%     inverse.lpf    - band-pass filter - low frequency cut-off (Hz)
%     inverse.hpf    - band-pass filter - high frequency cut-off (Hz)
%     inverse.pQ     - any source priors (eg from fMRI) - cell array
%     inverse.xyz    - (n x 3) locations of spherical VOIs
%     inverse.rad    - radius (mm) of VOIs

inverse.type = 'LOR'; 
inverse.woi = [0,250];
inverse.Han = 0;
inverse.lpf = 0;
inverse.hpf = 48;
inverse.pQ = {};

[mod, list] = modality(D{1}, 1, 1);
inverse.modality = mod;%inverse.modality = 'MEG';in

% and save them (assume trials = types)
%--------------------------------------------------------------------------
for i = 1:Ns
    D{i}.inv{1}.inverse = inverse;
end
 
contrast = []; %% Time-Frequency contrast - No

%% Register and compute a forward model
%==========================================================================
for i = NS
 
fprintf('Registering and computing forward model (subject: %i)\n',i);
       
D{i} = spm_eeg_inv_datareg_yy(D{i}, 1); %this step adds fiducials (Nasion, LPA, RPA)

D{i}    = spm_eeg_inv_forward_yy(D{i}); %this step selects forward model ('Single Shell','Single Sphere', 'MEG Local Spheres')
voltype = D{i}.inv{1}.forward.voltype;

%----------------------------------------------------------------------
save(D{i}); 

end

%% Invert the forward model
%==========================================================================
D     = spm_eeg_invert(D);
if ~iscell(D), D = {D}; end
 
% Save
%==========================================================================
for i = 1:Ns
    save(D{i});
end
clear D
 
 
% Compute conditional expectation of contrast and produce image
%==========================================================================
if ~isempty(contrast)
 
    % evaluate contrast and write image
    %----------------------------------------------------------------------
    for i = 1:Ns
        D     = spm_eeg_load(deblank(S(i,:)));
        D.inv{1}.contrast = contrast;
        D     = spm_eeg_inv_results(D);
        D     = spm_eeg_inv_Mesh2Voxels(D);
        save(D);
    end
end
 