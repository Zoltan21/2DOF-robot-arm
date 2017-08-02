function stringM = StringCutter( stringW, stringSection )
%cutting from stringW the stringsection
%assuming that this appear when the value is at square
position=findstr(stringW,stringSection);%finding the position of the stringSection in stringW
stringM=strcat(stringW(1:(position(1)-2)),stringW((position(1)+length(stringSection)):end)); %cutting out stringW
%the -1 subtracted from the position is because we also want to remove the
%* symbol
end

