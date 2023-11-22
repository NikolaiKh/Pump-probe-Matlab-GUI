function xps_end(myxps, varargin)

%try   %Try is necessary because fclose will throw an error sometimes at startup
%    fclose(device); %close serial connections
%end

%=====device config==========================================
code = myxps.CloseInstrument();

end