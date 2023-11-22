function [x, y, r] = SR830_getXYR(device, varargin)

%=====open the serial port=================================
%try
%    fopen(device);
%end
%=====Get Phase from Lock-in=================================
% writeline(device,'PHAS?');
% pause(0.02); % pause
% phase = str2double(readline(device));
%=====Get x, y, r from Lock-in=================================
writeline(device,'SNAP?1,2,3');
pause(0.02); % pause
dat = str2double(split(readline(device),','));
x = dat(1);
y = dat(2);
r = dat(3);
%pause(0.02); % pause
%=====close the serial port=================================
%fclose(device);

end