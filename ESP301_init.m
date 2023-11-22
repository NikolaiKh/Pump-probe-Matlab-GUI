function [device, props] = ESP301_init(device_id, varargin)
%=====create a serial connection===============================
%set its rate to 921600 baud
%ESP301 terminator character is  (ACSII 13)
%use fprintf(s,[No_motor (1), 'command']) to write
%and fscanf(s) to read the ESP301

%device = serial(device_id,'baudrate',921600,'terminator',13);
device = serialport(device_id,921600,'Timeout',30); 
configureTerminator(device,13)
%=====open the serial port=================================
%try
%    fopen(device);
%end

%=====device name==========================================
%fprintf(device,'*IDN?');
writeline(device,'*IDN?');
pause(0.1); % pause
%props = fscanf(device,'%s');
props = readline(device);
%pause(0.1); % pause

%=====device config==========================================
writeline(device,'1AC50'); %set acceleration
pause(0.02); % pause
writeline(device,'1AG50'); %set deceleration
pause(0.02); % pause

%=====close the serial port=================================
%fclose(device);

end