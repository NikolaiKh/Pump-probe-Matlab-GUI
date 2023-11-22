function gui1_pumpprobe_SR830
% basic pump-probe GUI
global deviceDL delay folder filename measurement deviceLIA_AminusB measurementPrev f
delay = struct('start', 470,'stop', 440, 'step', 0.1, 'NofScans', 1, 'currScan', 1, 'AccCount', 1, 'WaitTime', 200);
btn_value = 'start'; % value of main START button start/stop
folder = 'f:\Data\Nikolai Kh\Test\';
filename = 'Rot_pump704.5nm_PWR8deg_L2_0deg_step0.5.dat';
measurement=[];
measurementPrev = [];

% Lock-in COM
Lock_in_ID = "GPIB0::8::INSTR";
% XPS
DL_ID = 'GROUP1';
%ThorLabs LTS300M
%DL_ID = 45853213;

lock_in_name = '--';
DL_msg = '--';
% Init Lock-in
try
    [deviceLIA_AminusB, lock_in_name] = Lock_in_init(Lock_in_ID);    
end
% Init DL
try
    [deviceDL, DL_msg] = DL_init(DL_ID);
end

x_space = 10; % horizontal space between gui elements
y_space = 10; % vertical space between gui elements
w_element = 100; % width of gui element
h_element = 20; % hight of gui element
fontsize = 11; % fontsize og gui elements

%%%% Create GUI figure
fpos    = get(0,'DefaultFigurePosition'); % figure default position
fpos(1) = 50; % figure position X
fpos(2) = 50; % figure position Y
fpos(3) = 1600; % figure window size;Width
fpos(4) = 900; % Height
f = figure('Position', fpos, 'Name','Pump-Probe GUI','CloseRequestFcn',@CloseReq);

%% Create and Initialize ActiveX Controller for Thorlabs Delay Line (MGMotor)
% MGMotor = actxcontrol('MGMOTOR.MGMotorCtrl.1',[20 20 300 200], f);
% % Initialize
% % Start Control
% MGMotor.StartCtrl;
% % Set the Serial Number
% SN = 94864141; % put in the serial number of the hardware
% set(MGMotor,'HWSerialNum', SN);
% % Indentify the device
% MGMotor.Identify;
% % set velocity parameters (like Daniel)
% MGMotor.SetVelParams(0, 0, 5, 100);
% % pause(5); % waiting for the GUI to load up;
% % Event Handling
% MGMotor.registerevent({'MoveComplete' 'MoveCompleteHandler'});

%%%%%%%%%%%%%%%%%%%

%%%%  Initialize and hide the GUI as it is being constructed.

% Hardware parameters
label_Lock_in_header = uicontrol('Style','text',...
    'Position',[x_space, fpos(4)-8*(h_element+y_space),w_element,h_element],...
    'String','Lock-in:', 'FontSize', fontsize);
label_Lock_in = uicontrol('Style','text',...
    'Position',[x_space, fpos(4)-9*(h_element+y_space),4*w_element,h_element],...
    'String',lock_in_name, 'FontSize', fontsize);
label_DL_header = uicontrol('Style','text',...
    'Position',[x_space, fpos(4)-10*(h_element+y_space),w_element,h_element],...
    'String','Delay Line:', 'FontSize', fontsize);
label_DL = uicontrol('Style','text',...
    'Position',[x_space, fpos(4)-11*(h_element+y_space),4*w_element,h_element],...
    'String',DL_msg, 'FontSize', fontsize);
label_DL_position = uicontrol('Style','text',...
    'Position',[x_space, fpos(4)-29*(h_element+y_space),w_element,h_element],...
    'String','- mm', 'FontSize', fontsize);

% Construct the components for Delay Line
label_StartPos = uicontrol('Style','text',...
    'Position',[x_space, fpos(4)-(h_element+y_space),w_element,h_element],...
    'String','Start Position', 'FontSize', fontsize);
label_StopPos = uicontrol('Style','text',...
    'Position',[x_space, fpos(4)-2*(h_element+y_space),w_element,h_element],...
    'String','Stop Position', 'FontSize', fontsize);
label_Step = uicontrol('Style','text',...
    'Position',[x_space, fpos(4)-3*(h_element+y_space),w_element,h_element],...
    'String','Step', 'FontSize', fontsize);

edit_StartPos = uicontrol('Style','edit',...
    'Position',[x_space+(w_element+x_space), fpos(4)-(h_element+y_space),w_element,h_element],...
    'String', delay.start, 'FontSize', fontsize);
edit_StopPos = uicontrol('Style','edit',...
    'Position',[x_space+(w_element+x_space), fpos(4)-2*(h_element+y_space),w_element,h_element],...
    'String', delay.stop, 'FontSize', fontsize);
edit_Step = uicontrol('Style','edit',...
    'Position',[x_space+(w_element+x_space), fpos(4)-3*(h_element+y_space),w_element,h_element],...
    'String', delay.step, 'FontSize', fontsize);

label_NofScans = uicontrol('Style','text',...
    'Position',[x_space+2*(w_element+x_space), fpos(4)-(h_element+y_space),w_element,h_element],...
    'String','Number of scans', 'FontSize', fontsize-2);
label_currScan = uicontrol('Style','text',...
    'Position',[x_space+2*(w_element+x_space), fpos(4)-2*(h_element+y_space),w_element,h_element],...
    'String','Current scan', 'FontSize', fontsize-2);
edit_NofScans = uicontrol('Style','edit',...
    'Position',[x_space+3*(w_element+x_space), fpos(4)-(h_element+y_space),w_element,h_element],...
    'String', delay.NofScans, 'FontSize', fontsize);
edit_currScan = uicontrol('Style','text',...
    'Position',[x_space+3*(w_element+x_space), fpos(4)-2*(h_element+y_space),w_element,h_element],...
    'String', delay.currScan, 'FontSize', fontsize);

label_AccCount = uicontrol('Style','text',...
    'Position',[x_space+2*(w_element+x_space), fpos(4)-3*(h_element+y_space),w_element,h_element],...
    'String','Acc Count', 'FontSize', fontsize);
edit_AccCount = uicontrol('Style','edit',...
    'Position',[x_space+3*(w_element+x_space), fpos(4)-3*(h_element+y_space),w_element,h_element],...
    'String', delay.AccCount, 'FontSize', fontsize);
label_WaitTime = uicontrol('Style','text',...
    'Position',[x_space+2*(w_element+x_space), fpos(4)-4*(h_element+y_space),w_element,h_element],...
    'String','Wait time', 'FontSize', fontsize);
edit_WaitTime = uicontrol('Style','edit',...
    'Position',[x_space+3*(w_element+x_space), fpos(4)-4*(h_element+y_space),w_element,h_element],...
    'String', delay.WaitTime, 'FontSize', fontsize);

button_Start = uicontrol('Style','pushbutton',...
    'Position',[x_space + 0.5*(w_element+x_space), fpos(4)-5*(h_element+y_space),w_element,2*h_element],...
    'String', 'START', 'FontSize', fontsize+2, 'BackgroundColor', [145,207,96]/256,...
    'Callback',{@button_Start_Push});

button_adjustment = uicontrol('Style','pushbutton',...
    'Position',[x_space + 2.5*(w_element+x_space), fpos(4)-7*(h_element+y_space),w_element,2*h_element],...
    'String', 'adjustment', 'FontSize', fontsize, 'BackgroundColor', [145,207,96]/256,...
    'Callback',{@button_adjustment_Push});

button_goto = uicontrol('Style','pushbutton',...
    'Position',[x_space + 0.5*(w_element+x_space), fpos(4)-28*(h_element+y_space),w_element,2*h_element],...
    'String', 'GoTo', 'FontSize', fontsize, 'BackgroundColor', [145,207,96]/256,...
    'Callback',{@button_goto_Push});
edit_DL_Pos = uicontrol('Style','edit',...
    'Position',[x_space+(w_element+x_space), fpos(4)-29*(h_element+y_space),w_element,h_element],...
    'String', delay.start, 'FontSize', fontsize);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  axes for plots
axes_MeanSignal = axes('Units','pixels', 'Box', 'On',...
    'Position',[x_space+4.5*(w_element+x_space), fpos(4)-9*(h_element+y_space),9*w_element,12*h_element]);
grid on;
axes_RealSignal = axes('Units','pixels', 'Box', 'On',...
    'Position',[x_space+4.5*(w_element+x_space), fpos(4)-18*(h_element+y_space),9*w_element,12*h_element]);
grid on;
axes_ImagSignal = axes('Units','pixels', 'Box', 'On',...
    'Position',[x_space+4.5*(w_element+x_space), fpos(4)-27*(h_element+y_space),9*w_element,12*h_element]);
grid on;
%%%
%%% saving file
button_Save = uicontrol('Style','pushbutton',...
    'Position',[x_space + 0.5*(w_element+x_space), fpos(4)-7*(h_element+y_space),w_element,2*h_element],...
    'String', 'Save', 'FontSize', fontsize+2, 'BackgroundColor', [255,255,191]/256,...
    'Callback',{@button_Save_Push});
check_AutoSave = uicontrol('Style','checkbox','String','AutoSave','FontSize', fontsize,...
    'Position',[x_space + 1.5*(w_element+x_space), fpos(4)-7*(h_element+y_space),w_element,1.5*h_element]);
button_ChooseFolder = uicontrol('Style','pushbutton',...
    'Position',[320 + 2*x_space, 20,w_element, 2*h_element],...
    'String', 'Select folder', 'FontSize', fontsize,...
    'Callback',{@button_Folder_Push});
label_ChooseFolder = uicontrol('Style','text',...
    'Position',[320+2*x_space+(w_element+x_space),20, 5*w_element, 1.5*h_element],...
    'String', folder, 'FontSize', fontsize);
edit_FileName = uicontrol('Style','edit',...
    'Position',[320+2*x_space+5*(w_element+x_space),20, 6*w_element, 1.5*h_element],...
    'String', filename, 'FontSize', fontsize-1, 'BackgroundColor', [255,255,255]/256);




%% ---- function for START/STOP button-----------------------------------
    function button_Start_Push(~,~)
        if strcmp(get(button_Start, 'String'), 'START')
            set(button_Start, 'BackgroundColor', [252,141,89]/256);
            set(button_Start, 'String', 'STOP');

            % read values
            delay.start=str2double(get(edit_StartPos,'String'));
            delay.stop=str2double(get(edit_StopPos,'String'));
            delay.step=str2double(get(edit_Step,'String'))*sign(delay.stop - delay.start);
            delay.NofScans=str2double(get(edit_NofScans,'String'));
            delay.AccCount=str2double(get(edit_AccCount,'String'));
            delay.WaitTime=str2double(get(edit_WaitTime,'String'));

            MarkSize = 5;
            measurement=[];         

            averagedMeasurement = 0;
            scansCounter = 0;

            % scan over time
            for k = 1:delay.NofScans % current scan index
                n=1; % point index for current scan
                set(edit_currScan, 'String',k);
                measurement=[];
                position = DL_goto(deviceDL, DL_ID, delay.start);

                for pos = delay.start+delay.step : delay.step : delay.stop
                    if strcmp(get(button_Start, 'String'), 'STOP')
                        
                        set(label_DL_position,'String',[num2str(position) 'mm']);
                    
                        x = 0;
                        y = 0;
                        r = 0;
                        
                        for iter=1:1:delay.AccCount   
                            if iter==1 
                                pause(delay.WaitTime*1e-3); % pause
                            else
                                pause(0.5*delay.WaitTime*1e-3); % pause
                            end
                            [xi, yi, ri] = Lock_in_getXYR(deviceLIA_AminusB); % get signal from Lock-in
                            x = x + xi;
                            y = y + yi;
                            r = r + ri*sign(x);
                        end
                        x = x/iter;
                        y = y/iter;
                        r = r/iter;

                        measurement(n,:)= [pos, x, y, r];
                        position = DL_goto(deviceDL, DL_ID, pos);

                        %visualization
                        if ~isempty(measurementPrev)
                            plot(axes_RealSignal,measurementPrev(:,1),measurementPrev(:,2),'--.r',...
                                'LineWidth',1,'MarkerSize',MarkSize);
                            hold(axes_RealSignal,'on')
                            plot(axes_RealSignal,measurement(:,1),measurement(:,2),'-o','LineWidth',2,...
                                'MarkerSize',MarkSize,'MarkerEdgeColor','b');
                            grid(axes_RealSignal,'on');
                            legend(axes_RealSignal, 'Xprev','X');
                            hold(axes_RealSignal,'off')
                            plot(axes_ImagSignal,measurementPrev(:,1),measurementPrev(:,3),'--.r',...
                                'LineWidth',1,'MarkerSize',MarkSize);
                            hold(axes_ImagSignal,'on')
                            plot(axes_ImagSignal,measurement(:,1),measurement(:,3),'-o','LineWidth',2,...
                                'MarkerSize',MarkSize,'MarkerEdgeColor','g');
                            grid(axes_ImagSignal,'on');
                            legend(axes_ImagSignal, 'Yprev','Y');
                            hold(axes_ImagSignal,'off')
                            plot(axes_MeanSignal,measurementPrev(:,1),measurementPrev(:,4),'--.r',...
                                'LineWidth',1,'MarkerSize',MarkSize);
                            hold(axes_MeanSignal,'on')
                            plot(axes_MeanSignal,measurement(:,1),measurement(:,4),'-o','LineWidth',2,...
                                'MarkerSize',MarkSize,'MarkerEdgeColor','k');
                            grid(axes_MeanSignal,'on');
                            legend(axes_MeanSignal, 'Rprev','R*sign(Y)');
                            hold(axes_MeanSignal,'off')
                        else
                            plot(axes_RealSignal,measurement(:,1),measurement(:,2),'-o','LineWidth',2,...
                                'MarkerSize',MarkSize,...
                                'MarkerEdgeColor','b');
                            grid(axes_RealSignal,'on');
                            legend(axes_RealSignal, 'X');
                            plot(axes_ImagSignal,measurement(:,1),measurement(:,3),'-o','LineWidth',2,...
                                'MarkerSize',MarkSize,...
                                'MarkerEdgeColor','g');
                            grid(axes_ImagSignal,'on');
                            legend(axes_ImagSignal, 'Y');
                            plot(axes_MeanSignal,measurement(:,1),measurement(:,4),'-o','LineWidth',2,...
                                'MarkerSize',MarkSize,...
                                'MarkerEdgeColor','k');
                            grid(axes_MeanSignal,'on');
                            legend(axes_MeanSignal, 'R*sign(Y)');
                        end                 

                        set(axes_RealSignal, 'xlim', [min(delay.start, delay.stop), max(delay.start, delay.stop)]);
                        set(axes_ImagSignal, 'xlim', [min(delay.start, delay.stop), max(delay.start, delay.stop)]);
                        set(axes_MeanSignal, 'xlim', [min(delay.start, delay.stop), max(delay.start, delay.stop)]);

                        n=n+1;
                    else
                        set(button_Start, 'BackgroundColor', [145,207,96]/256);
                        set(button_Start, 'String', 'START');
                    end
                end
                averagedMeasurement = averagedMeasurement + measurement;
                scansCounter = scansCounter + 1;
            end


            if delay.NofScans ~= 1 || scansCounter == 0
                measurement = averagedMeasurement ./ scansCounter;
            end

            %visualization
            if ~isempty(measurementPrev)
                plot(axes_RealSignal,measurementPrev(:,1),measurementPrev(:,2),'--.r',...
                    'LineWidth',1,'MarkerSize',MarkSize);
                hold(axes_RealSignal,'on')
                plot(axes_RealSignal,measurement(:,1),measurement(:,2),'-o','LineWidth',2,...
                    'MarkerSize',MarkSize,'MarkerEdgeColor','b');
                grid(axes_RealSignal,'on');
                legend(axes_RealSignal, 'Xprev','X');
                hold(axes_RealSignal,'off')
                plot(axes_ImagSignal,measurementPrev(:,1),measurementPrev(:,3),'--.r',...
                    'LineWidth',1,'MarkerSize',MarkSize);
                hold(axes_ImagSignal,'on')
                plot(axes_ImagSignal,measurement(:,1),measurement(:,3),'-o','LineWidth',2,...
                    'MarkerSize',MarkSize,'MarkerEdgeColor','g');
                grid(axes_ImagSignal,'on');
                legend(axes_ImagSignal, 'Yprev','Y');
                hold(axes_ImagSignal,'off')
                plot(axes_MeanSignal,measurementPrev(:,1),measurementPrev(:,4),'--.r',...
                    'LineWidth',1,'MarkerSize',MarkSize);
                hold(axes_MeanSignal,'on')
                plot(axes_MeanSignal,measurement(:,1),measurement(:,4),'-o','LineWidth',2,...
                    'MarkerSize',MarkSize,'MarkerEdgeColor','k');
                grid(axes_MeanSignal,'on');
                legend(axes_MeanSignal, 'Rprev','R');
                hold(axes_MeanSignal,'off')
            else
                plot(axes_RealSignal,measurement(:,1),measurement(:,2),'-o','LineWidth',2,...
                    'MarkerSize',MarkSize,'MarkerEdgeColor','b');
                grid(axes_RealSignal,'on');
                legend(axes_RealSignal, 'X');
                plot(axes_ImagSignal,measurement(:,1),measurement(:,3),'-o','LineWidth',2,...
                    'MarkerSize',MarkSize,'MarkerEdgeColor','g');
                grid(axes_ImagSignal,'on');
                legend(axes_ImagSignal, 'Y');
                plot(axes_MeanSignal,measurement(:,1),measurement(:,4),'-o','LineWidth',2,...
                    'MarkerSize',MarkSize,'MarkerEdgeColor','k');
                grid(axes_MeanSignal,'on');
                legend(axes_MeanSignal, 'R');
            end

            if ~isempty(measurement)
                measurementPrev = measurement;
            end

            set(button_Start, 'BackgroundColor', [145,207,96]/256);
            set(button_Start, 'String', 'START');

            if (get(check_AutoSave,'Value') == get(check_AutoSave,'Max'))
                button_Save_Push();
            end
        else
            set(button_Start, 'BackgroundColor', [145,207,96]/256);
            set(button_Start, 'String', 'START');
        end
    end
%%--------------------------------------------------------------------
%% ---- function for adjustment button-----------------------------------
    function button_adjustment_Push(~,~)

        if strcmp(get(button_adjustment, 'String'), 'adjustment')
            set(button_adjustment, 'BackgroundColor', [252,141,89]/256);
            set(button_adjustment, 'String', 'STOP');

            cla(axes_RealSignal);
            cla(axes_ImagSignal);
            cla(axes_MeanSignal);
            k = (1:400)';
            x = zeros(length(k),1);
            y = zeros(length(k),1);
            r = zeros(length(k),1);

            % start
            while strcmp(get(button_adjustment, 'String'), 'STOP')
                pause(0.1*1e-3); % pause
                x = circshift(x,-1);
                y = circshift(y,-1);
                r = circshift(r,-1);
                [x(400), y(400), r(400)] = Lock_in_getXYR(deviceLIA_AminusB); % get signal from Lock-in

                % X signal
                cla(axes_RealSignal);
                line(axes_RealSignal,k,[x y],'LineWidth',2)
                legend(axes_RealSignal, 'X','Y');

                % Y signal
                %cla(axes_ImagSignal);
                %line(axes_ImagSignal,k,y,'Color','r','LineWidth',2)
                %legend(axes_ImagSignal, 'Y');

                % R signal
                cla(axes_MeanSignal);
                line(axes_MeanSignal,k,r,'Color','k','LineWidth',2)
                legend(axes_MeanSignal, 'R');
            end

        else
            set(button_adjustment, 'BackgroundColor', [145,207,96]/256);
            set(button_adjustment, 'String', 'adjustment');
        end

    end
%%--------------------------------------------------------------------

%% ---- function for Folder button-----------------------------------
    function button_Folder_Push(~,~)
        temp = uigetdir(folder,'Save data folder');
        if temp~=0
            folder = temp;
        end
        set(label_ChooseFolder,'String',folder);
    end
%%-------------------------------------------------------------------

%% ---- function for Save button-----------------------------------
    function button_Save_Push(~,~)
        filename=get(edit_FileName,'String');

        fullname=fullfile(folder,filename);
        if exist(fullname, 'file') ~= 0
            if strcmp(questdlg('File already exists. Overwrite?'),'Yes')
                save(fullname,'measurement','-ascii');
            end
        else
            save(fullname,'measurement','-ascii');
        end
    end
%%-------------------------------------------------------------------

%% ---- function for GoTo button-----------------------------------
    function button_goto_Push(~,~)

        position = str2double(get(edit_DL_Pos,'String'));
        if position < 0
            position = 0;
        elseif position > 600
            position = 600;
        end
        position = DL_goto(deviceDL, DL_ID, position);
        set(label_DL_position,'String',[num2str(position) ' mm']);

    end
%%-------------------------------------------------------------------
end


function DelayLine_move(pos)
%% Sending Moving Commands to Delay Line
global MGMotor delay
timeout = 10; % timeout for waiting the move to be completed
t1 = clock; % current time
while(etime(clock,t1)<timeout)
    % wait while the motor is active; timeout to avoid dead loop
    s = MGMotor.GetStatusBits_Bits(0);
    if (IsMoving(s) == 0)
        % Move a absolute distance
        MGMotor.SetAbsMovePos(0,pos);
        MGMotor.MoveAbsolute(0,1==0);
        pause(delay.WaitTime*1e-3); % pause
        break;
    end
    pause(delay.WaitTime*1e-3); % pause
end
end

function [device, props] = Lock_in_init(device_id)
%% Sending Lock-in

% SR830
[device, props] = SR830_init(device_id);

end

function Lock_in_end(device)
%% End Lock-in

% SR830
SR830_end(device);

end

function [x, y, r] = Lock_in_getXYR(device)
%% Get X, Y values from Lock-in

% SR830
[x, y, r] = SR830_getXYR(device);

end

function [myxps, errormsg] = DL_init(device_id)
%% Sending DL
%ThorLabs LTS300M
%[device, props] = LTS300M_init(device_id);

% ESP301
% [device, props] = ESP301_init(device_id);
% XPS
[myxps, errormsg] = XPS_init(device_id);

end

function DL_end(device)
%% End DL

%ThorLabs LTS300M
%clear device;

% XPS
XPS_end(device);

end

function pos = DL_goto(device, id, position)
%% Move DL

%ThorLabs LTS300M
%pos = LTS300M_goto(device, position);

% ESP301
% pos = ESP301_goto(device, position);

% XPS
pos = XPS_goto(device, id, position);

end

function CloseReq(src,callbackdata)
% Close request function
global device deviceDL device_Power_supply
try
    Lock_in_end(device);
    delete(device);
end
try
    DL_end(deviceDL);
    delete(deviceDL);
end
% try
%     curr = Power_supply_set_curr(device_Power_supply, 0);
%     Power_supply_end(device_Power_supply);
%     delete(device_Power_supply);
% end
delete(gcf)

end
