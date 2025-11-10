% From HFSS12 and so on, for Solution Type "Driven Terminal" we have the
% function autoidentifyPort (particularly used for Wave Port_ coaxial cable
% feed). It is needed to create a new function to this update

% Ho Manh Linh [17/11/2013]
% ho.linh@mail.polimi.it
% ----------------------------------------------------------------------------
function hfssAutoIdentifyPort(fid, Name, ObjName)
% Preamble.
fprintf(fid, '\n');
fprintf(fid, 'Set oModule = oDesign.GetModule("BoundarySetup") \n');
fprintf(fid, '\n');
fprintf(fid, 'oModule.AutoIdentifyPorts _\n');
fprintf(fid, 'Array( _\n');
fprintf(fid, '"NAME:%s", _\n', Name);
fprintf(fid, '\t"Objects:=", Array("%s")), true, _\n', ObjName);
fprintf(fid, '\tArray("NAME:ReferenceConductors"), "1" ,true');
end
