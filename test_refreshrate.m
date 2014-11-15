picdiff = [];

for i = 1:50
    picdiff(i) = greebonTimes(i) - piconTimes(i);
end

jitter = [
13.33
39.99
93.31
146.63
199.95
239.94
293.26
346.58
13.33
39.99
93.31
146.63
199.95
239.94
293.26
346.58
13.33
39.99
93.31
146.63
199.95
239.94
293.26
346.58
13.33
39.99
93.31
146.63
199.95
239.94
293.26
346.58
13.33
39.99
93.31
146.63
199.95
239.94
293.26
346.58
13.33
39.99
93.31
146.63
199.95
239.94
293.26
346.58
13.33
39.99
];

x = ceil(jitter/(1000/62.27));
y = x*1000/62.27;

picdif = picdiff - y';

D = picdif/(1000/62.27);

%picondiffadj = picondiff - jit(1:49);
% hist(picondiffadj)
% 1789/257.6
% ans =
%     6.9449
%     
%     for n = 1:49
% picondiff(n) = piconTimes(n+1) - piconTimes(n);
% end
% picondiffadj = picondiff - jit;
% 
% jit=picdiff-257.6;
% jit_cyc=jit/16.1;
% picdiff_c=picdiff/16.1;
% 1/62.27
% 
% x = ceil(jitter/(1000/62.27));
% y = x*1000/62.27;
% picdif


