function pos = XPS_goto(myxps, device_id, position, varargin)

code=myxps.GroupMoveAbsolute(device_id, position, 1);
if (code ~= 0)
 errormsg = (['Error ' num2str(code) ' occurred while XPS GroupMoveAbsolute !']) ;
 return;
end

pos = position;

end