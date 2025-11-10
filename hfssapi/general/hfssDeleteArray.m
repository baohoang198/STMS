
function hfssDeleteArray(fid, ObjectName)

% create the necessary script.
fprintf(fid, '\n');
fprintf(fid, 'oEditor.Delete Array');
fprintf(fid, '("NAME:Selections", "Selections:=","%s")',ObjectName);
