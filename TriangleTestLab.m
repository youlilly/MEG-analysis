clear all

% records subject's name first:
name_id=input('Enter initials (no spaces): ','s');
subnum=input('Enter subject number (1,2,3,...): ');

stimord = [1 1 2;
    3 4 3;
    5 6 5;
    7 7 8;
    4 3 3;
    7 8 7;
    3 3 4;
    6 5 5;
    8 7 7;
    1 2 1;
    6 5 5;
    2 1 1;
    8 7 7;
    2 1 1;
    5 5 6;
    3 4 3;
    1 2 1;
    1 1 2;
    5 5 6;
    4 3 3;
    7 8 7;
    8 7 7;
    6 5 5;
    4 3 3];
odd = [3 2 2 3 1 2 3 1 1 2 1 1 1 1 3 2 2 3 3 1 2 1 1 1];

resp_all = [];
resp_all2 = [];
responses = [];
accuracy = [];
confidence = [];
correct = 0;
incorrect = 0;
noresp = 0;

button_pressed = false;

usb2_config;

cgloadlib
cgopen(1,0,0,1)

gsd = cggetdata('gsd') ;
gpd = cggetdata('gpd') ;

ScrWid = gsd.ScreenWidth ;
ScrHgh = gsd.ScreenHeight ;

% Clear back page
cgrect(0, 0, ScrWid, ScrHgh, [1 1 1]) %changed background page of white 
cgfont('Arial',36)
cgpencol(0,0,0)%black text
cgtext('Sniff when you see',0, 2 * ScrHgh / 6 - 15);
cgtext('SNIFF NOW - BOTTLE #',0, 1.5 * ScrHgh / 6 - 15);
cgtext('Index',-160, 0.7 * ScrHgh / 6 - 15);
cgtext('Finger',-160, 0.2 * ScrHgh / 6 - 15);
cgtext('Middle',0, 0.7 * ScrHgh / 6 - 15);
cgtext('Finger',0, 0.2 * ScrHgh / 6 - 15);
cgtext('Ring',160, 0.7 * ScrHgh / 6 - 15);
cgtext('Finger',160, 0.2 * ScrHgh / 6 - 15);
cgtext('BOTTLE',0, -.4 * ScrHgh / 6 - 15);
cgtext('1',-160, -1 * ScrHgh / 6 - 15);
cgtext('2',0, -1 * ScrHgh / 6 - 15);
cgtext('3',160, -1 * ScrHgh / 6 - 15);
cgtext('CONFIDENCE',0, -1.6 * ScrHgh / 6 - 15);
cgtext('1',-160, -2.2 * ScrHgh / 6 - 15);
cgtext('2',0, -2.2 * ScrHgh / 6 - 15);
cgtext('3',160, -2.2 * ScrHgh / 6 - 15);

cgflip

pause on;
pause(10)



for i = 1:24
    odor1 = stimord(i,1);
    odor2 = stimord(i,2);
    odor3 = stimord(i,3);
    
    
    
    % Write out Sniff Text
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
    cgtext('+',0, 0 * ScrHgh / 6 - 15);
    cgflip
    
    
    pause(1)
    usb2_line_on(odor1,0);
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
    cgtext('SNIFF NOW - BOTTLE 1',0, 0 * ScrHgh / 6 - 15);
    cgflip
    
    
    pause(2)
    usb2_line_on(0,0);
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
    cgtext('++',0, 0 * ScrHgh / 6 - 15);
    cgflip
    
    
    pause(5)
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
    cgtext('+',0, 0 * ScrHgh / 6 - 15);
    cgflip
    
    
    pause(1)
    usb2_line_on(odor2,0);
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
    cgtext('SNIFF NOW - BOTTLE 2',0, 0 * ScrHgh / 6 - 15);
    cgflip
    
    
    pause(2)
    usb2_line_on(0,0);
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
    cgtext('++',0, 0 * ScrHgh / 6 - 15);
    cgflip
    
    
    pause(5)
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
    cgtext('+',0, 0 * ScrHgh / 6 - 15);
    cgflip
    
    
    pause(1)
    usb2_line_on(odor3,0);
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
    cgtext('SNIFF NOW - BOTTLE 3',0, 0 * ScrHgh / 6 - 15);
    cgflip
    pause(2)
    
    
    usb2_line_on(0,0);
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
    cgtext('WHICH BOTTLE?',0, 0 * ScrHgh / 6 - 15);
    cgflip
    time = (cogstd('sGetTime', -1) * 1000);
    
    resp = false;
    byte_in = 0;
    cgKeyMap;
    
    while ((cogstd('sGetTime', -1) * 1000) < (time + 6000))
        if (k_current(23) == 1) && resp == false %23 corresponds to the I key
            byte_in = 1;
            t_in = (cogstd('sGetTime', -1) * 1000) ;
            resp = true;
            resp_all = [resp_all; [byte_in t_in]];
        elseif (k_current(24) == 1) && resp == false %24 corresponds to the O key
            byte_in = 2;
            t_in = (cogstd('sGetTime', -1) * 1000) ;
            resp = true;
            resp_all = [resp_all; [byte_in t_in]];
        elseif (k_current(25) == 1) && resp == false %25 corresponds to the P key
            byte_in = 3;
            t_in = (cogstd('sGetTime', -1) * 1000) ;
            resp = true;
            resp_all = [resp_all; [byte_in t_in]];
        end
    end
    if byte_in > 0
        answer = byte_in;
        responses = [responses answer];
        if answer == odd(i)
            accuracy = [accuracy 1];
            correct = correct + 1;
        else
            accuracy = [accuracy 0];
            incorrect = incorrect + 1;
        end
    else
        answer = 0;
        responses = [responses answer];
        accuracy = [accuracy 0];
        noresp = noresp + 1;
    end
    
    
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
    cgtext('CONFIDENCE?',0, 0 * ScrHgh / 6 - 15);
    cgflip
    time = (cogstd('sGetTime', -1) * 1000);
    
    resp = false;
    byte_in = 0;
    cgKeyMap;
    while ((cogstd('sGetTime', -1) * 1000) < (time + 6000))
        if (k_current(23) == 1) && resp == false %23 corresponds to the I key
            byte_in = 1;
            t_in = (cogstd('sGetTime', -1) * 1000) ;
            resp = true;
            resp_all2 = [resp_all2; [byte_in t_in]];
        elseif (k_current(24) == 1) && resp == false %24 corresponds to the O key
            byte_in = 2;
            t_in = (cogstd('sGetTime', -1) * 1000) ;
            resp = true;
            resp_all2 = [resp_all2; [byte_in t_in]];
        elseif (k_current(25) == 1) && resp == false %25 corresponds to the P key
            byte_in = 3;
            t_in = (cogstd('sGetTime', -1) * 1000) ;
            resp = true;
            resp_all2 = [resp_all2; [byte_in t_in]];
        end
    end
    if byte_in > 0
        conf = byte_in;
        confidence = [confidence conf];
    else
        conf = 0;
        confidence = [confidence conf];
    end
    
    cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])
    cgtext('++',0, 0 * ScrHgh / 6 - 15);
    cgflip
    pause(4)
end

dm = 'C:\My Experiments\Wen_Li\SensInt_Greebles\m_scripts_SIG';
dmat = 'C:\My Experiments\Wen_Li\SensInt_Greebles\mat_files';

cd(dmat);
eval(['save TriangleTest_' deblank(name_id) '_sub' num2str(subnum)  ' stimord odd resp_all resp_all2 responses accuracy confidence correct incorrect noresp']);
cd(dm);


usb2_finish;

cgshut;