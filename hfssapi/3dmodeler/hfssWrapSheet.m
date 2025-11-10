function hfssWrapSheet(fid,Name)

fprintf(fid, 'oEditor.WrapSheet _\n');
fprintf(fid, '\tArray("NAME:Selections",  _\n');
fprintf(fid, 'Array("Selections:%s", _\n', Name);
fprintf(fid, '\tArray("NAME:WrapSheetParameters",  _\n');
fprintf(fid, '\t\t\t\tArray("NAME:Imprinted", "Value:=", False) _\n');
fprintf(fid, '\t\t\t\t) _\n');
fprintf(fid, '\t\t\t) _\n');
fprintf(fid, '\t\t) \n');
