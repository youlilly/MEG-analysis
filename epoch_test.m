
% Epoching continuous M/EEG data
% FORMAT D = spm_eeg_epochs(S)
%
% S                     - input structure (optional)
% (optional) fields of S:
%   S.D                 - MEEG object or filename of M/EEG mat-file with
%                         continuous data
%   S.bc                - baseline-correct the data (1 - yes, 0 - no).
%
% Either (to use a ready-made trial definition):
%   S.epochinfo.trl             - Nx2 or Nx3 matrix (N - number of trials)
%                                 [start end offset]
%   S.epochinfo.conditionlabels - one label or cell array of N labels
%   S.epochinfo.padding         - the additional time period around each
%                                 trial for which the events are saved with
%                                 the trial (to let the user keep and use
%                                 for analysis events which are outside) [in ms]
%
% Or (to define trials using (spm_eeg_definetrial)):
%   S.pretrig           - pre-trigger time [in ms]
%   S.posttrig          - post-trigger time [in ms]
%   S.trialdef          - structure array for trial definition with fields
%     S.trialdef.conditionlabel - string label for the condition
%     S.trialdef.eventtype      - string
%     S.trialdef.eventvalue     - string, numeric or empty
%
%   S.reviewtrials      - review individual trials after selection
%   S.save              - save trial definition
%
% Output:
% D                     - MEEG object (also written on disk)
%__________________________________________________________________________
%
% spm_eeg_epochs extracts single trials from continuous EEG/MEG data. The
% length of an epoch is determined by the samples before and after stimulus
% presentation. One can limit the extracted trials to specific trial types.
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% % Stefan Kiebel
% % $Id: spm_eeg_epochs.m 3660 2010-01-04 19:11:24Z guillaume $
% 
% SVNrev = '$Rev: 3660 $';
% 
% %-Startup
% %--------------------------------------------------------------------------
% spm('FnBanner', mfilename, SVNrev);
% spm('FigName','M/EEG epoching'); spm('Pointer','Watch');
% 
% %-Get MEEG object
% %--------------------------------------------------------------------------
% try
%     D = S.D;
% catch
%     [D, sts] = spm_select(1, 'mat', 'Select M/EEG mat file');
%     if ~sts, D = []; return; end
%     S.D = D;
% end

D   = spm_eeg_load(fe_name);
S.D = fullfile(D.path, D.fname);

%-Check that the input file contains continuous data
%--------------------------------------------------------------------------
if ~strncmpi(D.type, 'cont', 4)
    error('The file must contain continuous data.');
end

S.fsample = 250;
S.timeonset = 0;
S.bc = 0;
S.inputformat = [];
S.pretrig = -200;
S.posttrig = 300;
S.trialdef(1).conditionlabel = 'LSFfear';
S.trialdef(1).eventtype = '11';
S.trialdef(1).eventvalue = 1;
S.trialdef(2).conditionlabel = 'LSFdisgust';
S.trialdef(2).eventtype = '12';
S.trialdef(2).eventvalue = 1;
S.trialdef(3).conditionlabel = 'LSFneutral';
S.trialdef(3).eventtype = '13';
S.trialdef(3).eventvalue = 1;
S.trialdef(4).conditionlabel = 'HSFfear';
S.trialdef(4).eventtype = '21';
S.trialdef(4).eventvalue = 1;
S.trialdef(5).conditionlabel = 'HSFdisgust';
S.trialdef(5).eventtype = '22';
S.trialdef(5).eventvalue = 1;
S.trialdef(6).conditionlabel = 'HSFneutral';
S.trialdef(6).eventtype = '23';
S.trialdef(6).eventvalue = 1;

% S.trialdef(7).conditionlabel = 'LSFfearS1';
% S.trialdef(7).eventtype = '111';
% S.trialdef(7).eventvalue = 1;
% S.trialdef(8).conditionlabel = 'LSFdisgustS1';
% S.trialdef(8).eventtype = '121';
% S.trialdef(8).eventvalue = 1;
% S.trialdef(9).conditionlabel = 'LSFneutralS1';
% S.trialdef(9).eventtype = '131';
% S.trialdef(9).eventvalue = 1;
% S.trialdef(10).conditionlabel = 'HSFfearS1';
% S.trialdef(10).eventtype = '211';
% S.trialdef(10).eventvalue = 1;
% S.trialdef(11).conditionlabel = 'HSFdisgustS1';
% S.trialdef(11).eventtype = '221';
% S.trialdef(11).eventvalue = 1;
% S.trialdef(12).conditionlabel = 'HSFneutralS1';
% S.trialdef(12).eventtype = '231';
% S.trialdef(12).eventvalue = 1;
% 
% S.trialdef(13).conditionlabel = 'LSFfearS2';
% S.trialdef(13).eventtype = '112';
% S.trialdef(13).eventvalue = 1;
% S.trialdef(14).conditionlabel = 'LSFdisgustS2';
% S.trialdef(14).eventtype = '122';
% S.trialdef(14).eventvalue = 1;
% S.trialdef(15).conditionlabel = 'LSFneutralS2';
% S.trialdef(15).eventtype = '132';
% S.trialdef(15).eventvalue = 1;
% S.trialdef(16).conditionlabel = 'HSFfearS2';
% S.trialdef(16).eventtype = '212';
% S.trialdef(16).eventvalue = 1;
% S.trialdef(17).conditionlabel = 'HSFdisgustS2';
% S.trialdef(17).eventtype = '222';
% S.trialdef(17).eventvalue = 1;
% S.trialdef(18).conditionlabel = 'HSFneutralS2';
% S.trialdef(18).eventtype = '232';
% S.trialdef(18).eventvalue = 1;
% 
% S.trialdef(19).conditionlabel = 'LSFfearS3';
% S.trialdef(19).eventtype = '113';
% S.trialdef(19).eventvalue = 1;
% S.trialdef(20).conditionlabel = 'LSFdisgustS3';
% S.trialdef(20).eventtype = '123';
% S.trialdef(20).eventvalue = 1;
% S.trialdef(21).conditionlabel = 'LSFneutralS3';
% S.trialdef(21).eventtype = '133';
% S.trialdef(21).eventvalue = 1;
% S.trialdef(22).conditionlabel = 'HSFfearS3';
% S.trialdef(22).eventtype = '213';
% S.trialdef(22).eventvalue = 1;
% S.trialdef(23).conditionlabel = 'HSFdisgustS3';
% S.trialdef(23).eventtype = '223';
% S.trialdef(23).eventvalue = 1;
% S.trialdef(24).conditionlabel = 'HSFneutralS3';
% S.trialdef(24).eventtype = '233';
% S.trialdef(24).eventvalue = 1;
% 
% S.trialdef(25).conditionlabel = 'LSFfearS4';
% S.trialdef(25).eventtype = '114';
% S.trialdef(25).eventvalue = 1;
% S.trialdef(26).conditionlabel = 'LSFdisgustS4';
% S.trialdef(26).eventtype = '124';
% S.trialdef(26).eventvalue = 1;
% S.trialdef(27).conditionlabel = 'LSFneutralS4';
% S.trialdef(27).eventtype = '134';
% S.trialdef(27).eventvalue = 1;
% S.trialdef(28).conditionlabel = 'HSFfearS4';
% S.trialdef(28).eventtype = '214';
% S.trialdef(28).eventvalue = 1;
% S.trialdef(29).conditionlabel = 'HSFdisgustS4';
% S.trialdef(29).eventtype = '224';
% S.trialdef(29).eventvalue = 1;
% S.trialdef(30).conditionlabel = 'HSFneutralS4';
% S.trialdef(30).eventtype = '234';
% S.trialdef(30).eventvalue = 1;

S.reviewtrials = 0;
S.save = 0;
S.epochinfo.padding = 0;

        S_definetrial.pretrig = S.pretrig;

        S_definetrial.posttrig = S.posttrig;

        S_definetrial.trialdef = S.trialdef;

        S_definetrial.reviewtrials = S.reviewtrials;
 
        S_definetrial.save = S.save;


    S_definetrial.D     = S.D;
    
    S_definetrial.event = D.events;

    S_definetrial.fsample = D.fsample;

    S_definetrial.timeonset = D.timeonset;

    S_definetrial.bc = S.bc;

    [epochinfo.trl, epochinfo.conditionlabels, S] = eeg_definetrial_test(S_definetrial);

    
    %-Second case: epochinfo (trlfile and trl)
    %--------------------------------------------------------------------------

trl = epochinfo.trl;
conditionlabels = epochinfo.conditionlabels;

try
    epochinfo.padding = S.epochinfo.padding;
catch
    epochinfo.padding = 0;
    % for history
    S.epochinfo.padding = epochinfo.padding;
end


% checks on input
if size(trl, 2) >= 3
    timeOnset = unique(trl(:, 3))./D.fsample;
    trl = trl(:, 1:2);
else
    timeOnset = 0;
end

if length(timeOnset) > 1
    error('All trials should have identical baseline');
end

nsampl = unique(round(diff(trl, [], 2)))+1;
if length(nsampl) > 1 || nsampl<1
    error('All trials should have identical and positive lengths');
end

inbounds = (trl(:,1)>=1 & trl(:, 2)<=D.nsamples);

rejected = find(~inbounds);
rejected = rejected(:)';

if ~isempty(rejected)
    trl = trl(find(inbounds), :);
    warning([D.fname ': Events ' num2str(rejected) ' not extracted - out of bounds']);
end

ntrial = size(trl, 1);

%-Generate new MEEG object with new filenames
%--------------------------------------------------------------------------
Dnew = clone(D, ['e' fnamedat(D)], [D.nchannels nsampl, ntrial]);

%-Epoch data
%--------------------------------------------------------------------------
spm_progress_bar('Init', ntrial, 'Events read');
if ntrial > 100, Ibar = floor(linspace(1, ntrial, 100));
else Ibar = [1:ntrial]; end

for i = 1:ntrial

    d = D(:, trl(i, 1):trl(i, 2), 1);

    Dnew(:, :, i) = d;

    Dnew = events(Dnew, i, select_events_yy(D.events, ...
        [trl(i, 1)/D.fsample-epochinfo.padding  trl(i, 2)/D.fsample+epochinfo.padding]));

    if ismember(i, Ibar), spm_progress_bar('Set', i); end
end

Dnew = conditions(Dnew, [], conditionlabels);

% The conditions will later be sorted in the original order they were defined.
if isfield(S, 'trialdef')
    Dnew = condlist(Dnew, {S.trialdef(:).conditionlabel});
end

Dnew = trialonset(Dnew, [], trl(:, 1)./D.fsample+D.trialonset);
Dnew = timeonset(Dnew, timeOnset);
Dnew = type(Dnew, 'single');

%-Perform baseline correction if there are negative time points
%--------------------------------------------------------------------------
if S.bc
    if time(Dnew, 1) < 0
        S1               = [];
        S1.D             = Dnew;
        S1.time          = [time(Dnew, 1, 'ms') 0];
        S1.save          = false;
        S1.updatehistory = false;
        Dnew             = spm_eeg_bc(S1);
    else
        warning('There was no baseline specified. The data is not baseline-corrected');
    end
end

%-Save new evoked M/EEG dataset
%--------------------------------------------------------------------------
D = Dnew;
% Remove some redundant stuff potentially put in by spm_eeg_definetrial
if isfield(S, 'event'), S = rmfield(S, 'event'); end
D = D.history(mfilename, S);
save(D);

%-Cleanup
%--------------------------------------------------------------------------
spm_progress_bar('Clear');
spm('FigName','M/EEG epoching: done'); spm('Pointer','Arrow');


