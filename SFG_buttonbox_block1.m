%Stimulus presentation script for Yuqi's LHE study + greeble distance
%judgment
%Experiment condition. Block 1 out of 4.
%Included measures to prevent saving on top of old files
%Changed to button box response coding
%Created Oct 23, 2012

clear all
cd E:\ExpPC_Files\MEGProjects_STIM2\ME051\Bhu\Greeble_study
%E:\Greeble_study % make sure you adapt this to your own stimulus-running computer; 
%in order for cd to work, there must be underscore between words composing the name of the folder

log_file_name = input('Log file name ?','s') ; 
%Start log file using low level functions.
date=input('6-digit date ?');%Using date instead of initials to identify file
block=5;
while block~=1
block=input('Block number');
end

initials = input('Subject Initials?');

%Valid subject number has to be less than 100
sub  = 150;
while sub>100
    sub = input('Subject number? ');
end

subinfo = sprintf('sub no. = %d, date=%d', sub, date);
% Pre-randomized stimulus matrix; same for each subject;
% Col 1 = picture id (1-50), 
% Col 2 = emotion condition(1=fear,2=disgust,3=neutral)
% Col 3 = spatial frequency (1=low,2=high)
% Col 4 = greeble id
% Col 5 = greeble size

StimR = [
9	1	1	247	1
48	3	2	249	3
1	1	1	214	4
41	3	2	233	3
29	1	2	179	1
25	2	1	157	3
29	1	2	242	4
19	3	1	220	2
1	1	1	169	3
35	1	2	174	4
50	2	2	200	2
49	2	2	208	2
25	2	1	175	1
33	2	2	169	3
38	1	2	185	3
10	2	1	243	1
45	3	2	228	2
19	3	1	211	1
46	3	2	157	3
25	2	1	247	1
52	2	2	184	2
12	1	1	213	3
43	3	2	217	3
8	1	1	210	4
49	2	2	190	4
23	2	1	200	2
17	3	1	191	1
30	1	2	198	4
14	3	1	242	4
42	3	2	180	2
49	2	2	163	1
12	1	1	249	3
45	3	2	210	4
15	3	1	153	3
12	1	1	159	1
49	2	2	217	3
3	1	1	225	3
41	3	2	179	1
53	2	2	203	1
30	1	2	243	1
11	1	1	167	1
4	1	1	154	4
41	3	2	152	2
53	2	2	194	4
53	2	2	185	3
34	2	2	170	4
28	1	2	160	2
27	2	1	231	1
36	1	2	193	3
22	2	1	208	2
37	2	2	216	2
41	3	2	224	2
29	1	2	188	2
12	1	1	186	4
31	1	2	163	1
36	1	2	220	2
23	2	1	173	3
6	2	1	241	3
31	1	2	235	1
49	2	2	172	2
16	3	1	172	2
43	3	2	163	1
9	1	1	193	3
12	1	1	231	1
41	3	2	188	2
12	1	1	195	1
16	3	1	208	2
33	2	2	187	1
44	3	2	155	1
52	2	2	211	1
5	1	1	245	3
20	3	1	203	1
28	1	2	241	3
54	2	2	204	2
1	1	1	205	3
40	3	2	160	2
43	3	2	154	4
14	3	1	188	2
39	1	2	204	2
6	2	1	169	3
35	1	2	156	2
22	2	1	172	2
26	2	1	167	1
8	1	1	201	3
31	1	2	190	4
3	1	1	162	4
13	3	1	187	1
9	1	1	175	1
8	1	1	237	3
35	1	2	219	1
15	3	1	234	4
2	1	1	215	1
33	2	2	232	2
43	3	2	190	4
15	3	1	243	1
37	2	2	180	2
45	3	2	237	3
9	1	1	166	4
28	1	2	214	4
6	2	1	214	4
27	2	1	213	3
47	3	2	248	2
22	2	1	217	3
2	1	1	188	2
11	1	1	203	1
27	2	1	249	3
34	2	2	188	2
18	3	1	246	4
17	3	1	218	4
52	2	2	193	3
6	2	1	223	1
27	2	1	240	2
7	2	1	170	4
20	3	1	167	1
8	1	1	165	3
39	1	2	213	3
39	1	2	168	2
22	2	1	235	1
14	3	1	197	3
34	2	2	197	3
15	3	1	216	2
13	3	1	232	2
6	2	1	232	2
51	2	2	165	3
41	3	2	197	3
10	2	1	162	4
5	1	1	155	1
47	3	2	194	4
47	3	2	203	1
21	3	1	177	3
4	1	1	208	2
23	2	1	164	2
7	2	1	188	2
39	1	2	240	2
33	2	2	241	3
20	3	1	230	4
42	3	2	153	3
32	1	2	227	1
48	3	2	222	4
33	2	2	151	1
16	3	1	244	2
18	3	1	210	4
13	3	1	196	2
50	2	2	227	1
24	2	1	210	4
19	3	1	247	1
53	2	2	221	3
5	1	1	173	3
43	3	2	172	2
17	3	1	227	1
];


%Create matrix of isijitter duration values, one for each trial.
%Times vary between 500 to 800 ms, same for each participant.
%r = 500 + (300).*rand(150,1)

%isijittervalues = [632.270237282671;762.728065243571;759.485492885851;606.545172568438;689.343934238989;759.364775006371;506.297520353012;523.046076494894;613.014328188316;544.758099063747;510.229068712156;734.674912250909;598.173522872261;745.242898909655;552.085715067534;702.835319789527;762.680144242673;727.146641711039;568.887714375747;607.683085785534;608.949228224450;580.232933384731;601.190828684087;526.088194670452;635.467895601385;636.399208322044;508.710652917063;691.130561797046;517.837636092361;550.758834211464;705.403922722178;666.370193770080;501.810750097001;586.425545787907;612.983469427806;543.947910009698;522.360084641325;638.222862868144;611.118313816299;747.367255523340;661.260696818908;745.254824884255;638.114247977926;504.210144314663;501.494961542975;549.868035163375;609.781651669206;715.463142934914;547.827091033331;583.631441216061;693.481534305954;586.161244751241;596.579267805117;546.625038493202;616.298942205694;768.719940205987;766.330060379522;618.083998321162;702.637322644697;575.664258378447;784.996312545522;687.404651989983;562.084382438862;532.896548330570;669.754883115306;582.300018862405;521.349578025405;547.534790060140;514.856088858651;704.265124397037;734.526743720475;742.209558876266;579.516077957964;768.769819138940;682.395826407247;504.320251591658;603.208624628023;660.099420594681;688.328773115463;634.021190186192;743.331693154037;543.448396799822;792.448812533419;750.128019786909;602.030348265033;684.871719760138;591.126850596523;526.765630242986;656.457741473586;747.587459875932;729.177986723125;784.291792370335;600.064181959948;616.921514734721;545.123863962662;600.111326197660;666.103648534597;665.088183464840;548.126313483884;535.126840872187;619.565130204876;749.414901406673;555.500361611920;650.235727253964;537.894343969809;759.388535917195;729.993706488574;669.306060666278;616.870811583267;647.041298994877;766.071228747327;771.514484473294;649.516686604522;658.768085072866;772.910215735982;673.579534096870;732.735531097033;698.418389163531;640.897171682264;565.930285953583;680.776921596779;555.277699034531;559.252914653300;758.597643945044;537.694775685809;693.674076717050;631.195463090699;683.781520249458;721.244724426927;590.983834148973;512.890313984578;750.652259192363;610.792453866257;698.401791930005;768.715975403462;582.229719772083;799.369543114935;750.306014416454;737.403106237494;696.983812449322;663.101905779956;616.004398890796;746.669626259026;678.600354178082;734.492396208387;796.302366873113;736.476140132702;755.876265996503;645.683848756743;762.126821752057];

%Time vary between 0 to 350 ms
isijittervalues2 = [146.63;
13.33;
39.99;
199.95;
93.31;
346.58;
293.26;
13.33;
39.99;%
93.31;
199.95;
146.63;
239.94;
346.58;
13.33;
293.26;
39.99;
239.94;
93.31;
146.63;%
239.94;
346.58;
199.95;
293.26;
13.33;
146.63;
39.99;
93.31;
239.94;%
199.95;
39.99;
293.26;
13.33;
93.31;
146.63;
346.58;
199.95;
239.94;
346.58;%
293.26;
39.99;
13.33;
93.31;
199.95;%
146.63;
239.94;
13.33;
39.99;
293.26;
93.31;
346.58;
13.33;
146.63;
293.26;
199.95;
239.94;
346.58;
146.63;
93.31;
239.94;
39.99;
199.95;
293.26;
13.33;
346.58;
39.99;
239.94;
93.31;
199.95;
293.26;
146.63;
346.58;
13.33;
199.95;
39.99;
146.63;
239.94;
93.31;
293.26;
39.99;
346.58;
13.33;
93.31;
346.58;
146.63;
293.26;
13.33;
199.95;
39.99;
239.94;
93.31;
146.63;
239.94;
293.26;
199.95;
346.58;
13.33;
146.63;
39.99;
239.94;
93.31;
199.95;
293.26;
346.58;
146.63;
13.33;
93.31;
199.95;
239.94;
39.99;
293.26;
346.58;
13.33;
199.95;
239.94;
39.99;
146.63;
293.26;
93.31;
346.58;
13.33;
199.95;
39.99;
146.63;
239.94;
93.31;
293.26;
13.33;
39.99;
346.58;
93.31;
239.94;
146.63;
199.95;
13.33;
293.26;
39.99;
93.31;
346.58;
146.63;
346.58;
199.95;
293.26;
13.33;
239.94;
39.99;
199.95;
93.31;
146.63;
239.94];

%Configure equipment 
parallel_config;

%Setting up variables for later use
piconTimes = []; %Matrix of IAPS  onset times (changed from faceonTimes)
picdurTimes = []; %Matrix of how long each face was presented--should all be 500 ms (changed from facedurTimes)
picoffTimes = []; %Matrix of fixation onset times
greebonTimes = []; %added this matrix of greeble onset times
greebdurTimes = []; % greeble duration times- should all be 400
fixonTimes = [];

SOAindex = [] ; %Each trial is  milliseconds long /means her ITI was jittered to make up for diffs in trial duration
picindex = []; %Matrix of which pic was used each trial--should match column 1 of StimR 
emoindex = []; %should match which emotion is in the trial--should match column 2 of StimR
sfindex = []; %should match what spatial frequency is in the trial - should match column 3 of StimR
greebsizeindex = []; %matrix of greeble sizes, should match column 5 of StimR

% all responses
allresp = [];
allRTs_greebsize = cell(1,4) ;
allRTs_greeb_emo_sf = cell(3,2); % sort RTs according to emo and sf associated with the greeble
corrRTs = [] ;
incorrRTs = [] ; 
acc = 0 ;
inacc = 0 ;
rtypes = [];

% correct responses
correct_trials = []; 
correct_RTs_greebsize = cell(1,4);
correct_RTs_greeb_emo_sf = cell(3,2); 

incorrect_trials = [];
incorrect_RTs_greebsize = cell(1,4);
incorrect_RTs_greeb_emo_sf = cell(3,2); 

% no response
noresp_trials = [] ;

% Load and configure Cogent
cgloadlib
cgopen(1,0,0,1)% starts Cogent

gsd = cggetdata('gsd') ; %requests the GScnd Data structure 
gpd = cggetdata('gpd') ; %requests the GPrim Data structure

ScrWid = gsd.ScreenWidth ;
ScrHgh = gsd.ScreenHeight ;

%Load 50 low and high spatial frequency pictures into Cogent.

picnames = {
    %Low spatial frequency pictures
    '0001a.tif';
    '0005a.tif';
    '0009a.tif';
    '0014a.tif';
    '0016a.tif';
    '1009a.tif';
    '1011a.tif';
    '1050a.tif';
    '1120a.tif';
    '1274a.tif';
    '6190a.tif';
    '6300a.tif';
    '7009a.tif';
    '7010a.tif';
    '7025a.tif';
    '7030a.tif';
    '7035a.tif';
    '7170a.tif';
    '7175a.tif';
    '7705a.tif';
    '7950a.tif';
    '9300a.tif';
    '9302a.tif';
    '9332a.tif';
    '9335a.tif';
    '9347a.tif';
    '9353a.tif';
    %High spatial frequency pictures
    '0001b.tif';
    '0005b.tif';
    '0009b.tif';
    '0014b.tif';
    '0016b.tif';
    '1009b.tif';
    '1011b.tif';
    '1050b.tif';
    '1120b.tif';
    '1274b.tif';
    '6190b.tif';
    '6300b.tif';
    '7009b.tif';
    '7010b.tif';
    '7025b.tif';
    '7030b.tif';
    '7035b.tif';
    '7170b.tif';
    '7175b.tif';
    '7705b.tif';
    '7950b.tif';
    '9300b.tif';
    '9302b.tif';
    '9332b.tif';
    '9335b.tif';
    '9347b.tif';
    '9353b.tif';};

%load greebles
cgloadbmp(151,'g1111_15picn.bmp');%need to edit pic names for VS greebles
cgloadbmp(152,'g1111_18picn.bmp');
cgloadbmp(153,'g1111_2picn.bmp');
cgloadbmp(154,'g1111_22picn.bmp');
cgloadbmp(155,'g1142_15picn.bmp');
cgloadbmp(156,'g1142_18picn.bmp');
cgloadbmp(157,'g1142_2picn.bmp');
cgloadbmp(158,'g1142_22picn.bmp');
cgloadbmp(159,'g1162_15picn.bmp');
cgloadbmp(160,'g1162_18picn.bmp');
cgloadbmp(161,'g1162_2picn.bmp');
cgloadbmp(162,'g1162_22picn.bmp');
cgloadbmp(163,'g2242_15picn.bmp');
cgloadbmp(164,'g2242_18picn.bmp');
cgloadbmp(165,'g2242_2picn.bmp');
cgloadbmp(166,'g2242_22picn.bmp');%
cgloadbmp(167,'g2251_15picn.bmp');
cgloadbmp(168,'g2251_18picn.bmp');
cgloadbmp(169,'g2251_2picn.bmp');
cgloadbmp(170,'g2251_22picn.bmp');%
cgloadbmp(171,'g2261_15picn.bmp');
cgloadbmp(172,'g2261_18picn.bmp');
cgloadbmp(173,'g2261_2picn.bmp');
cgloadbmp(174,'g2261_22picn.bmp');%
cgloadbmp(175,'g3322_15picn.bmp');
cgloadbmp(176,'g3322_18picn.bmp');
cgloadbmp(177,'g3322_2picn.bmp');
cgloadbmp(178,'g3322_22picn.bmp');%
cgloadbmp(179,'g3332_15picn.bmp');
cgloadbmp(180,'g3332_18picn.bmp');
cgloadbmp(181,'g3332_2picn.bmp');
cgloadbmp(182,'g3332_22picn.bmp');%
cgloadbmp(183,'g3391_15picn.bmp');
cgloadbmp(184,'g3391_18picn.bmp');
cgloadbmp(185,'g3391_2picn.bmp');
cgloadbmp(186,'g3391_22picn.bmp');%
cgloadbmp(187,'g4442_15picn.bmp');
cgloadbmp(188,'g4442_18picn.bmp');
cgloadbmp(189,'g4442_2picn.bmp');
cgloadbmp(190,'g4442_22picn.bmp');%
cgloadbmp(191,'g4452_15picn.bmp');
cgloadbmp(192,'g4452_18picn.bmp');
cgloadbmp(193,'g4452_2picn.bmp');
cgloadbmp(194,'g4452_22picn.bmp');%
cgloadbmp(195,'g4461_15picn.bmp');
cgloadbmp(196,'g4461_18picn.bmp');
cgloadbmp(197,'g4461_2picn.bmp');
cgloadbmp(198,'g4461_22picn.bmp');%
cgloadbmp(199,'g5521_15picn.bmp');
cgloadbmp(200,'g5521_18picn.bmp');
cgloadbmp(201,'g5521_2picn.bmp');
cgloadbmp(202,'g5521_22picn.bmp');%
cgloadbmp(203,'g5532_15picn.bmp');
cgloadbmp(204,'g5532_18picn.bmp');
cgloadbmp(205,'g5532_2picn.bmp');
cgloadbmp(206,'g5532_22picn.bmp');%
cgloadbmp(207,'g5551_15picn.bmp');
cgloadbmp(208,'g5551_18picn.bmp');
cgloadbmp(209,'g5551_2picn.bmp');
cgloadbmp(210,'g5551_22picn.bmp');%
cgloadbmp(211,'m1121_15picn.bmp');
cgloadbmp(212,'m1121_18picn.bmp');
cgloadbmp(213,'m1121_2picn.bmp');
cgloadbmp(214,'m1121_22picn.bmp');%
cgloadbmp(215,'m1141_15picn.bmp');
cgloadbmp(216,'m1141_18picn.bmp');
cgloadbmp(217,'m1141_2picn.bmp');
cgloadbmp(218,'m1141_22picn.bmp');%
cgloadbmp(219,'m1192_15picn.bmp');
cgloadbmp(220,'m1192_18picn.bmp');
cgloadbmp(221,'m1192_2picn.bmp');
cgloadbmp(222,'m1192_22picn.bmp');%
cgloadbmp(223,'m22102_15picn.bmp');
cgloadbmp(224,'m22102_18picn.bmp');
cgloadbmp(225,'m22102_2picn.bmp');
cgloadbmp(226,'m22102_22picn.bmp');%
cgloadbmp(227,'m2241_15picn.bmp');
cgloadbmp(228,'m2241_18picn.bmp');
cgloadbmp(229,'m2241_2picn.bmp');
cgloadbmp(230,'m2241_22picn.bmp');%
cgloadbmp(231,'m2272_15picn.bmp');
cgloadbmp(232,'m2272_18picn.bmp');
cgloadbmp(233,'m2272_2picn.bmp');
cgloadbmp(234,'m2272_22picn.bmp');%
cgloadbmp(235,'m3321_15picn.bmp');
cgloadbmp(236,'m3321_18picn.bmp');
cgloadbmp(237,'m3321_2picn.bmp');
cgloadbmp(238,'m3321_22picn.bmp');%
cgloadbmp(239,'m3342_15picn.bmp');
cgloadbmp(240,'m3342_18picn.bmp');
cgloadbmp(241,'m3342_2picn.bmp');
cgloadbmp(242,'m3342_22picn.bmp');%
cgloadbmp(243,'m3361_15picn.bmp');
cgloadbmp(244,'m3361_18picn.bmp');
cgloadbmp(245,'m3361_2picn.bmp');
cgloadbmp(246,'m3361_22picn.bmp');%
cgloadbmp(247,'m4431_15picn.bmp');
cgloadbmp(248,'m4431_18picn.bmp');
cgloadbmp(249,'m4431_2picn.bmp');
cgloadbmp(250,'m4431_22picn.bmp');%
cgloadbmp(251,'m4462_15picn.bmp');
cgloadbmp(252,'m4462_18picn.bmp');
cgloadbmp(253,'m4462_2picn.bmp');
cgloadbmp(254,'m4462_22picn.bmp');%
cgloadbmp(255,'m4491_15picn.bmp');
cgloadbmp(256,'m4491_18picn.bmp');
cgloadbmp(257,'m4491_2picn.bmp');
cgloadbmp(258,'m4491_22picn.bmp');%
cgloadbmp(259,'m5522_15picn.bmp');
cgloadbmp(260,'m5522_18picn.bmp');
cgloadbmp(261,'m5522_2picn.bmp');
cgloadbmp(262,'m5522_22picn.bmp');%
cgloadbmp(263,'m5552_15picn.bmp');
cgloadbmp(264,'m5552_18picn.bmp');
cgloadbmp(265,'m5552_2picn.bmp');
cgloadbmp(266,'m5552_22picn.bmp');%
cgloadbmp(267,'m5561_15picn.bmp');
cgloadbmp(268,'m5561_18picn.bmp');
cgloadbmp(269,'m5561_2picn.bmp');
cgloadbmp(270,'m5561_22picn.bmp');

cgloadbmp(301,'fixationtest.bmp') ;

config_display;

% Clear back page
cgrect(0, 0, ScrWid, ScrHgh, [0 0 0]) %changed background page of black 
 
%Experiment instructions 
cgfont('Arial',24)%changed from 36 pt to 28 pt
cgpencol(1,1,1) %white letters
cgtext('KEEP EYES FIXED At The CENTRE',0, 3.5 * ScrHgh / 9 - 15);
cgtext('OF The SCREEN',0, 3 * ScrHgh / 9 - 15);
cgpencol(1,1,1); % red changed to white letters
cgfont('Arial',24)
cgtext('PRESS A NUMBER TO ESTIMATE DISTANCE',0,0 * ScrHgh/9 - 6);
cgfont('Arial',22)
cgtext('Very Close(1)   Somewhat Close(2)   Somewhat Far(3)  Very Far(4)',5,-1 * ScrHgh/9 - 6);
cgflip 
 
pause on
pause(8); %display instructions for 8 seconds

% present crosshairs
cgrect(0, 0, ScrWid, ScrHgh, [0 0 0])  %draws filled rectangle that is black
cgdrawsprite(301,0,0) ;  
cgflip

pause on
pause (2); %display crosshairs for 2 seconds

%Set up more variables: counter, timecounter
timectr=[]; %Matrix of times for when each trial began
noresp = 0 ; 
presses = 0 ;  
count = 0; 

%Assing bottonbox presses for input
onekey = 2;  %Very close
twokey = 3;  %Somewhat close
threekey = 4;   %Somewhat far
fourkey = 5;   %Very far


%Trial loop for each of the 150 trials
for i = 1:150;
  
    count  = count + 1;
    picid=StimR(i,1) ; %Specifies which of the IAPS images in sequence
    emoid=StimR(i,2) ; %Specifies which of the emo conditions is presented (fear, disgust,neutral)
    sfid=StimR (i,3); %Specifies which spatial frequency is presented (low,high)
    greebid=StimR(i,4); %Specifies which greeble it is
    greebsize = StimR(i,5);%Specifies the size of that greeble
    
    
    emoindex = [emoindex emoid] ; 
    picindex = [picindex picid] ; 
    sfindex = [sfindex sfid];
    greebsizeindex = [greebsizeindex greebsize];
    
     
    trialtime = cogstd('sGetTime', -1) * 1000 ; %returns current time in milliseconds
    timectr=[timectr trialtime]; %#ok<AGROW> %Adds time this trial began to timectr matrix
    
cgkeymap 
    
    % Record time experiment began
    if (i == 1)  
        starttime  = trialtime;
    else
    end

    %Setting up response variables    
response_time = 0 ; %probably need to copy this to section before vas for new rt info
response_key = 0 ;  
    
    %Presentation of IAPS pic alone for 250 ms  
    cgrect(0, 0, ScrWid, ScrHgh, [0 0 0])  % Clear back screen to black
    cgrect(250, -200, 30, 30, [1 1 1]) % white box attempt  Photo diode 
    %drawpict(1)
    %loadpict(cell2mat(picnames(picid,1)),1);
    loadpict(cell2mat(picnames(picid,1)),1, 0, 0, 256, 300); % elongation modification
    cgflip(0,0,0)
    
    picon = cogstd('sGetTime', -1) * 1000 ; %Log pic onset time
    parallel_acquire;

    while ((cogstd('sGetTime', -1) * 1000) < (picon + 248)) 
    end %Presentation of IAPS pics for 250ms
    
    %Flip back to blankscreen for jitter time
    %fixation presentation ISI (jittered 0-150)
    
    %Conduct a photo diode test, to account for the refresh rates
    
    cgrect(0, 0, ScrWid, ScrHgh, [0 0 0])  
 %   cgdrawsprite(301,0,0) ; 
    cgflip
    picoff = cogstd('sGetTime', -1) * 1000 ; 
 
    isijittertime2 = isijittervalues2(i,:); 
    SOA = 250 + isijittertime2 + 400 + 1100; 
    SOAindex = [SOAindex; SOA]; %#ok<AGROW> 
    
    while ((cogstd('sGetTime', -1) * 1000) < (picoff + isijittertime2)) end %#ok<SEPEX>
 
    %Presentation of greebles (fixed 400 ms)
    cgrect(0, 0, ScrWid, ScrHgh, [0 0 0]) 
    cgdrawsprite(greebid,0,0) ; %Prepare greeble pic
    cgflip(0,0,0)
    greebon = cogstd('sGetTime', -1) * 1000 ; 
    parallel_acquire;
   
 while ((cogstd('sGetTime', -1) * 1000) < (greebon + 1500)) 
 
     if ((cogstd('sGetTime', -1) * 1000) == (greebon + 398))%#ok<SEPEX> 
     %Greeble offset
     cgrect(0, 0, ScrWid, ScrHgh, [1 1 1])  
     cgdrawsprite(301,0,0) ; 
     cgflip %Crosshairs on
     fixon = (cogstd('sGetTime', -1) * 1000) ;      
     end
      
             %Recording response and reaction time/
        rt_current = cogstd('sGetTime', -1) * 1000 ;

        if (response_time == 0)

            % Read the keyboard
            [k_current, k_previous] = cgkeymap ;

            % Get the current time.
            rt_old = rt_current ;
            rt_current = cogstd('sGetTime', -1) * 1000 ;


            % Check to see if onekey press has occured.
            if (k_previous(onekey) == 1)
                response_time = (rt_old + rt_current)/2 - greebon;
                response_key = onekey ;
            end

            if (k_current(onekey) == 1)
                response_time = rt_current - greebon;
                response_key = onekey ;
            end
            
            % Check to see if twokey press has occured.
            if (k_previous(twokey) == 1)
                response_time = (rt_old + rt_current)/2 - greebon;
                response_key = twokey ;
            end
            if (k_current(twokey) == 1)
                response_time = rt_current - greebon;
                response_key = twokey ;
            end

            % Check to see if threekey press has occured.
            if (k_previous(threekey) == 1)
                response_time = (rt_old + rt_current)/2 - greebon;
                response_key = threekey ;
            end
            if (k_current(threekey) == 1)
                response_time = rt_current - greebon;
                response_key = threekey ;
            end

            % Check to see if fourkey press has occured.
            if (k_previous(fourkey) == 1)
                response_time = (rt_old + rt_current)/2 - greebon;
                response_key = fourkey ;
            end

            if (k_current(fourkey) == 1)
                response_time = rt_current - greebon;
                response_key = fourkey ;
            end
      
        else
        end
        
 end
    
    
    %Collating pic onset and pic duration times
    piconTimes = [piconTimes picon];%#ok<AGROW>
    picdurTimes = [picdurTimes picoff-picon];%#ok<AGROW>
    greebonTimes = [greebonTimes greebon];%#ok<AGROW>
    fixonTimes = [fixonTimes fixon];%#ok<AGROW>
    greebdurTimes = [greebdurTimes fixon-greebon];%#ok<AGROW>

% %Setting up variables for later use
% piconTimes = []; %Matrix of IAPS  onset times (changed from faceonTimes)
% picdurTimes = []; %Matrix of how long each face was presented--should all be 500 ms (changed from facedurTimes)
% picoffTimes = []; %Matrix of fixation onset times
% greebonTimes = []; %added this matrix of greeble onset times
% greebdurTimes = []; % greeble duration times- should all be 400
% fixonTimes = [];
% 
% SOAindex = [] ; %Each trial is  milliseconds long /means her ITI was jittered to make up for diffs in trial duration
% picindex = []; %Matrix of which pic was used each trial--should match column 1 of StimR 
% emoindex = []; %should match which emotion is in the trial--should match column 2 of StimR
% sfindex = []; %should match what spatial frequency is in the trial - should match column 3 of StimR
% greebsizeindex = []; %matrix of greeble sizes, should match column 5 of StimR
% 
% % all responses
% allresp = [];
% allRTs_greebsize = cell(1,4) ;
% allRTs_greeb_emo_sf = cell(3,2); % sort RTs according to emo and sf associated with the greeble
% corrRTs = [] ;
% incorrRTs = [] ; 
% acc = 0 ;
% inacc = 0 ;
% rtypes = [];
% 
% % correct responses
% correct_trials = []; 
% correct_RTs_greebsize = cell(1,4);
% correct_RTs_greeb_emo_sf = cell(3,2); 
% 
% incorrect_trials = [];
% incorrect_RTs_greebsize = cell(1,4);
% incorrect_RTs_greeb_emo_sf = cell(3,2); 
% 
% % no response
% noresp_trials = [] ;

%     picid=StimR(i,1) ; %Specifies which of the IAPS images in sequence
%     emoid=StimR(i,2) ; %Specifies which of the emo conditions is presented (fear, disgust,neutral)
%     sfid=StimR (i,3); %Specifies which spatial frequency is presented (low,high)
%     greebid=StimR(i,4); %Specifies which greeble it is
%     greebsize = StimR(i,5);%Specifies the size of that greeble


%NEED TO INSERT BIG SECTION TO RECORD RESPONSES AND RT TO VAS HERE/EDIT
%THIS SECTION
%Collating times according to button response (correct, incorrect)

%Response type, or rtype is coded as such: 2:closest, 3:intermediate close,
%6: intermediate far, 5: farthest

    if response_time > 0 %if button press occurred
    presses = presses + 1;
    rt = response_time; % rt based on 1st button press, 
    allRTs_greebsize{greebsize} = [allRTs_greebsize{greebsize} rt];
    allRTs_greeb_emo_sf{emoid,sfid} = [allRTs_greeb_emo_sf{emoid,sfid} rt];
    allresp = [allresp rt] ; %#ok<AGROW> %collates all responses/ 
    
        if (response_key == onekey) % i.e. key 1 on the botton box is pressed
        corrRTs  = [corrRTs rt];   %These corrRTs variables might be a bit misleading. there is no accuracy in this task. The corrRTs variables just indicate that a button was pressed and it was not a no response
        correct_trials = [correct_trials i];
        buttstr = 'correct:  greeble is very close, response 1';
        acc = acc + 1; %#ok<AGROW>
        rtype = 1;
        correct_RTs_greebsize{greebsize} = [correct_RTs_greebsize{greebsize} rt];
        correct_RTs_greeb_emo_sf{emoid,sfid} = [correct_RTs_greeb_emo_sf{emoid,sfid} rt];
        
        elseif (response_key == twokey) % i.e. key 2 on the botton box is pressed
        corrRTs  = [corrRTs rt];  
        correct_trials = [correct_trials i];
        buttstr = 'correct:  greeble is somewhat close, response 2';
        acc = acc + 1; %#ok<AGROW>
        rtype = 2;
        correct_RTs_greebsize{greebsize} = [correct_RTs_greebsize{greebsize} rt];
        correct_RTs_greeb_emo_sf{emoid,sfid} = [correct_RTs_greeb_emo_sf{emoid,sfid} rt];
        
        
        elseif (response_key == threekey) % i.e. key 3 on the botton box is pressed
        corrRTs = [corrRTs rt];   
        correct_trials = [correct_trials i];
        buttstr = 'correct: greeble is somewhat far, response 3';
        acc = acc + 1; %#ok<AGROW>
        rtype = 3;
        correct_RTs_greebsize{greebsize} = [correct_RTs_greebsize{greebsize} rt];
        correct_RTs_greeb_emo_sf{emoid,sfid} = [correct_RTs_greeb_emo_sf{emoid,sfid} rt];
        
        
        elseif (response_key == fourkey) % key 4 on the botton box is pressed
        corrRTs  = [corrRTs rt];   %#ok<AGROW> % correct RTs
        correct_trials = [correct_trials i];
        buttstr = 'correct:  greeble is very far, response 4';
        acc = acc + 1; %#ok<AGROW>
        rtype = 4;%coded backwards for analysis
        correct_RTs_greebsize{greebsize} = [correct_RTs_greebsize{greebsize} rt];
        correct_RTs_greeb_emo_sf{emoid,sfid} = [correct_RTs_greeb_emo_sf{emoid,sfid} rt];
        
        else
        end
    else
        
    buttstr = 'NO BUTTON PRESS';
    response_key = NaN;
    allresp = [allresp response_key] ; %#ok<AGROW>
    noresp = noresp + 1;
    rtype = 10; %coded for null response
    noresp_trials = [noresp_trials i] ;  %#ok<AGROW>
    end 
    
rtypes = [rtypes rtype]; %#ok<AGROW>


%clearkeys;
cgkeymap;
    
end% of each trial

%Save variables/
%Setting up variables for later use
% piconTimes = []; %Matrix of IAPS  onset times (changed from faceonTimes)
% picdurTimes = []; %Matrix of how long each face was presented--should all be 500 ms (changed from facedurTimes)
% picoffTimes = []; %Matrix of fixation onset times
% greebonTimes = []; %added this matrix of greeble onset times
% greebdurTimes = []; % greeble duration times- should all be 400
% fixonTimes = [];

results.onsets.starttime    = starttime;
results.onsets.piconTimes       = piconTimes;
results.onsets.picdurTimes      = picdurTimes;
results.onsets.picoffTimes       = picoffTimes;
results.onsets.greebonTimes        =greebonTimes;
results.onsets.greebdurTimes       =greebdurTimes;
results.onsets.fixonTimes          =fixonTimes;

results.behav.allresp = allresp;
results.behav.allRTs_greebsize = allRTs_greebsize;
results.behav.allRTs_greeb_emo_sf = allRTs_greeb_emo_sf;

results.behav.accuracy = acc;
results.behav.corrRTs = corrRTs;
results.behav.correct_trials = correct_trials;
results.behav.correct_RTs_greebsize = correct_RTs_greebsize;
results.behav.correct_RTs_greeb_emo_sf = correct_RTs_greeb_emo_sf;

results.checks.subinfo         = subinfo;
results.checks.presses         = presses;
results.checks.rtypes          = rtypes';
results.checks.SOAindex             = SOAindex';
results.checks.emoid      = emoindex';
results.checks.picid       = picindex';
results.checks.sfid = sfindex';
results.checks.greebsizeindex = greebsizeindex';


% wait 5 sec. after last trial w/black screen
cgrect(0, 0, ScrWid, ScrHgh, [0 0 0]) ;
cgflip 
startwait = cogstd('sGetTime', -1) * 1000 ;
while ((cogstd('sGetTime', -1) * 1000) < startwait + 2000) end ; %#ok<SEPEX>

%Display "all done" message
cgrect(0, 0, ScrWid, ScrHgh, [0 0 0]) ;
cgpencol(1,1,1) ;
cgtext('You are finished with Block 1!',0,ScrHgh / 6 - 15);
cgflip 
startwait = cogstd('sGetTime', -1) * 1000 ;
while ((cogstd('sGetTime', -1) * 1000) < (startwait + 3000)) end %#ok<SEPEX>

%Save data in mat_files folder, then come back to run folder

eval(['save SFG_block1_sub' num2str(sub) '_' initials 'results']);

pause off
cgshut

parallel_finish;
