function [myxps, errormsg] = XPS_init(device_id, varargin)

try
    asmInfo = NET.addAssembly('Newport.XPS.CommandInterface');
catch 
    errormsg = '.NET is not connected'
    return;
end

try
    myxps=CommandInterfaceXPS.XPS();
catch 
    errormsg = 'CommandInterfaceXPS.XPS() is not connected';
    return;
end

code=myxps.OpenInstrument('192.168.50.2',5001,1000);
if (code ~= 0)
 errormsg = (['Error ' num2str(code) ' occurred while XPS OpenInstrument ! ']) ;
 return; 
end

code=myxps.Login('Administrator', 'Administrator');
if (code ~= 0)
 errormsg = (['Error ' num2str(code) ' occurred while XPS Login !']) ;
 return;
end

code=myxps.IsDeviceConnected();
if (code ~= 1)
 errormsg = (['Error ' num2str(code) ' occurred while XPS IsDeviceConnected !']) ;
 return;
end

code=myxps.GroupKill(device_id);
if (code ~= 0)
 errormsg = (['Error ' num2str(code) ' occurred while XPS GroupKill !']) ;
 return;
end

code=myxps.GroupInitialize(device_id);
if (code ~= 0)
 errormsg = (['Error ' num2str(code) ' occurred while XPS GroupInitialize !']) ;
 return;
end

code=myxps.GroupHomeSearch(device_id);
if (code ~= 0)
 errormsg = (['Error ' num2str(code) ' occurred while XPS GroupHomeSearch !']) ;
 return;
end

% pos = myxps.GroupPositionCurrentGet(device_id, 1);

errormsg = 'XPS initialized'

end