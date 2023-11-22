function [device, props] = SR830_init(device_id, varargin)
%=====create a serial connection===============================
%set its rate to 9600 baud
%SR830 terminator character is  (ACSII 13)
%use fprintf(s,['m' mode]) to write
%and fscanf(s) to read the SR830

device = visadevlist(device_id); 
% configureTerminator(device,13)
%=====open the serial port=================================
%try
%    fopen(device);
%end

%=====device name==========================================
writeline(device,'*IDN?');
pause(0.1); % pause
%props = fscanf(device,'%s');
props = readline(device);
%pause(0.1); % pause

%=====close the serial port=================================
%fclose(device);

end