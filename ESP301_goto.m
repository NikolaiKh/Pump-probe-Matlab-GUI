function pos = ESP301_goto(device, position, varargin)

% This function moves the motor
% directly to a designated position relative to the current 0. This 
% function returns the final position of the motor after displacement as 
% a double, not a string.  A wait is built into this function to avoid
% overloading the controller buffer.
%
% The syntax is as follows:
%
% ESP301_goto(device, position)
%
% Where device is the declared device and position is the position from 
% the current zero position in millimeters.  
% Note that the final position value of this command has
% an error of +/- 0.050.
%
%
% Taken from https://github.com/UTAustinUltrasound/esp301/blob/master/moveto.m 

%try
%    fopen(device);
%end

% 1 is the No of motor
movecommand = strcat('1PA',num2str(position));
wait4stop = '1WS30';
%wait4jerk = '1WT20';
positionquery = '1TP?';

% Concantenate and send to the controller
command = strcat(movecommand, ';', wait4stop, ';', positionquery);
%fprintf(device, command);
writeline(device,command);
pause(0.02); % pause

%find the position
%pos = str2double(fscanf(device,'%s'));
pos = str2double(readline(device));
%pause(0.02); % pause

%fclose(device);

end