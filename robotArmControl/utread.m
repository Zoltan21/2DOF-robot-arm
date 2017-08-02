function data = utread

global utip

fwrite(utip.s,utip.CycleRead);
data1 = fread(utip.s,7);
data2 = fread(utip.s,7);
%convert angles into radian format
% the data is obtained at the 5th and 6th byte of the line, so we have to
% extract this:
% angle = (data(5)*256 + data(6)-offset)*resolution
if(~isempty(data1)) %Make sure Data Type is Correct       
    data = [(data1(5)*256 + data1(6)-utip.offsetang1)*utip.resang;(data2(5)*256 + data2(6)-utip.offsetang2)*utip.resang] ; %Extract 1st Data Element    
end
end