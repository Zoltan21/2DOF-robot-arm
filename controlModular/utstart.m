function utstart(com)

% default port number
if nargin < 1, com = '5'; end;

global utip

disp('Starting session...');
%&& strcmp(utip.s.Status, 'open')
% close if open
if ~isempty(utip)
    if (isvalid(utip.s) && strcmp(utip.s.Status, 'open'))
        aux = instrfind;
        for i=1:length(aux)
            fclose(aux(i));
            delete(aux(i));
        end
        clear aux
    end
end;

% create
utip = struct;
utip.serialPort = ['COM' com];       % define COM port #
utip.offsetang1 = 785;               % offset for the first joint
utip.offsetang2 = 500;               % offset for the second joint
utip.resang = 0.00577;               % conversion rate from raw data to radian
utip.PWM_offset = 1000;              % the offset for the PWM control
utip.s = serial(utip.serialPort);
set(utip.s,'BaudRate',1000000);
fopen(utip.s);

%% INIT communication protocol dont change this part!
gotoConfig = hex2dec({'AA','03','FF','FE','06','F6'});
utip.s.RecordMode = 'index';
utip.s.RecordDetail = 'verbose';
utip.s.RecordName = 'serialLog.txt';
record(utip.s)
fwrite(utip.s,gotoConfig);
data = dec2hex(fread(utip.s,6));% it is not a mistake, here has to be 2 read
data = dec2hex(fread(utip.s,6));% it is not a mistake, here has to be 2 read
clear data
% INIT read command
utip.CycleRead = uint8(0);
utip.CycleRead(1:6) = utip.CycleRead;
utip.CycleRead(1:6) = [ 170 3 255 254 7 245]; % dont change this
% INIT write command
utip.writePWM = uint8(0);
utip.writePWM(1:14) = utip.writePWM;
utip.writePWM(1:13) = [170 11 255 254 131 16 2 1 0 0 2 0 0]; % dont change this

utread;

% sprintf('\8\8\8done.');