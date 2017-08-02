function utstop

global utip

% close if open
if ~isempty(utip) && isvalid(utip.s),
     if strcmp(utip.s.Status, 'open'), 
        % safety command before closing
        fprintf(utip.s, '0');
        % close
        fclose(utip.s); 
     end;
    delete(utip.s);
end;

clear utip;

disp('Session terminated.');