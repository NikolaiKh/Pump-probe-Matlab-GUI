function SR830_end(device, varargin)

%try   %Try is necessary because fclose will throw an error sometimes at startup
%    fclose(device); %close serial connections
%end

delete(device);

end