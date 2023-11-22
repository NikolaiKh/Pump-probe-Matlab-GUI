function ESP301_end(device, varargin)

%try   %Try is necessary because fclose will throw an error sometimes at startup
%    fclose(device); %close serial connections
%end

%=====device config==========================================
writeline(device,'1AC200'); %set acceleration
pause(0.02); % pause
writeline(device,'1AG200'); %set deceleration
pause(0.02); % pause

delete(device);

end