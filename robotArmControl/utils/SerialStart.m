%0xAA  0x05  0x01  0x0FE  0x02 0x0B 0x02 0xZZ
gotoConfig = hex2dec({'AA','03','FF','FE','06','F6'});
s.RecordMode = 'index';
s.RecordDetail = 'verbose';
s.RecordName = 'serialLog.txt';
record(s)
fwrite(s,gotoConfig);
data = dec2hex(fread(s,6));
data = dec2hex(fread(s,6));


